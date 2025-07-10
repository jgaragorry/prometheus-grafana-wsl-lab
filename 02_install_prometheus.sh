#!/bin/bash

# Este script instala y configura Prometheus en tu sistema Ubuntu en WSL.
# Pasos realizados:
# 1. Define la versión de Prometheus a instalar.
# 2. Crea un usuario de sistema dedicado para Prometheus.
# 3. Crea los directorios necesarios para la configuración y los datos de Prometheus.
# 4. Descarga el binario de Prometheus desde GitHub.
# 5. Descomprime el archivo y mueve los ejecutables a /usr/local/bin/.
#    NOTA: Las versiones 3.x de Prometheus ya no incluyen 'consoles' y 'console_libraries'.
# 6. Limpia los archivos de descarga temporales.
# 7. Configura los permisos de archivos y directorios para el usuario 'prometheus'.
# 8. Crea el archivo de configuración 'prometheus.yml'.
# 9. Crea un servicio systemd para Prometheus para que se ejecute en segundo plano.
# 10. Recarga systemd, habilita e inicia el servicio de Prometheus.
# 11. Verifica el estado del servicio.

# Salir inmediatamente si un comando falla
set -e

echo "==================================================="
echo "======== Iniciando la instalación de Prometheus ========"
echo "==================================================="

# --- 1. Definir la versión de Prometheus ---
# Visita https://prometheus.io/download/ para obtener la última versión estable.
# A la fecha de esta guía, la versión 3.4.2 es la más reciente estable.
export PROMETHEUS_VERSION="3.4.2"
echo "Versión de Prometheus a instalar: v${PROMETHEUS_VERSION}"

echo ""
echo "--- 2. Creando usuario 'prometheus' ---"
# Crea un usuario del sistema sin directorio home y sin shell de inicio de sesión.
sudo useradd --no-create-home --shell /bin/false prometheus
echo "Usuario 'prometheus' creado."

echo ""
echo "--- 3. Creando directorios para Prometheus ---"
# Directorios para la configuración y los datos de Prometheus.
sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus
echo "Directorios /etc/prometheus y /var/lib/prometheus creados."

echo ""
echo "--- 4. Descargando Prometheus v${PROMETHEUS_VERSION} ---"
# Descarga el archivo comprimido del binario de Prometheus para Linux (amd64).
wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
echo "Descarga de Prometheus completada."

echo ""
echo "--- 5. Descomprimiendo y moviendo binarios de Prometheus ---"
# Descomprime el archivo tar.gz.
tar xvf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz

# Mueve los ejecutables 'prometheus' y 'promtool' a /usr/local/bin/.
sudo mv prometheus-${PROMETHEUS_VERSION}.linux-amd64/prometheus /usr/local/bin/
sudo mv prometheus-${PROMETHEUS_VERSION}.linux-amd64/promtool /usr/local/bin/
echo "Binarios 'prometheus' y 'promtool' movidos a /usr/local/bin/."

# NOTA IMPORTANTE: En Prometheus 3.x, los directorios 'consoles' y 'console_libraries'
# ya no se incluyen en el paquete de descarga. Por lo tanto, omitimos los comandos
# para moverlos, ya que darían error 'No such file or directory'.
echo "Omitiendo el movimiento de 'consoles' y 'console_libraries' (no incluidos en Prometheus 3.x)."

echo ""
echo "--- 6. Limpiando archivos de descarga temporales ---"
# Elimina el archivo comprimido y el directorio extraído.
rm -rf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz prometheus-${PROMETHEUS_VERSION}.linux-amd64
echo "Archivos temporales limpiados."

echo ""
echo "--- 7. Configurando permisos de archivos para Prometheus ---"
# Establece al usuario y grupo 'prometheus' como propietarios de los directorios y binarios.
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool
echo "Permisos de archivos configurados para Prometheus."

echo ""
echo "--- 8. Creando el archivo de configuración prometheus.yml ---"
# Crea el archivo de configuración principal para Prometheus.
# Este archivo le dice a Prometheus qué monitorear.
sudo bash -c 'cat <<EOF > /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s # Frecuencia con la que Prometheus recolectará métricas
  scrape_timeout: 10s

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"] # Prometheus se monitorea a sí mismo

  - job_name: "node_exporter" # Este job se usará para el Node Exporter (se instalará después)
    static_configs:
      - targets: ["localhost:9100"] # Puerto por defecto de Node Exporter
EOF'
echo "Archivo /etc/prometheus/prometheus.yml creado."

echo ""
echo "--- 9. Creando el servicio systemd para Prometheus ---"
# Crea un archivo de unidad de servicio para systemd para gestionar Prometheus.
# NOTA: Se omiten las opciones de 'consoles' y 'console_libraries' en ExecStart.
sudo bash -c 'cat <<EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \\
    --config.file /etc/prometheus/prometheus.yml \\
    --storage.tsdb.path /var/lib/prometheus/

[Install]
WantedBy=multi-user.target
EOF'
echo "Servicio systemd para Prometheus creado en /etc/systemd/system/prometheus.service."

echo ""
echo "--- 10. Recargando systemd, habilitando e iniciando Prometheus ---"
# Recarga la configuración de systemd para reconocer el nuevo servicio.
sudo systemctl daemon-reload
# Habilita el servicio para que se inicie automáticamente al arrancar el sistema.
sudo systemctl enable prometheus
# Inicia el servicio de Prometheus ahora mismo.
sudo systemctl start prometheus
echo "Servicio de Prometheus recargado, habilitado e iniciado."

echo ""
echo "--- 11. Verificando el estado del servicio Prometheus ---"
sudo systemctl status prometheus | grep "Active:"
if sudo systemctl is-active --quiet prometheus; then
    echo "Prometheus está activo (running). ¡Éxito!"
    echo "Puedes acceder a la interfaz web de Prometheus en: http://localhost:9090"
else
    echo "ERROR: Prometheus no está corriendo. Revisa los logs con 'sudo journalctl -xe -u prometheus.service'."
    exit 1
fi

echo ""
echo "==================================================="
echo "====== Instalación de Prometheus completada ======="
echo "==================================================="
echo "Ahora puedes ejecutar el script 03_install_node_exporter.sh"
echo ""
