#!/bin/bash

# Este script instala y configura Node Exporter en tu sistema Ubuntu en WSL.
# Node Exporter es una herramienta que expone métricas del sistema operativo
# (CPU, memoria, disco, red, etc.) para que Prometheus pueda recolectarlas.

# Pasos realizados:
# 1. Define la versión de Node Exporter a instalar.
# 2. Crea un usuario de sistema dedicado para Node Exporter.
# 3. Descarga el binario de Node Exporter desde GitHub.
# 4. Descomprime el archivo y mueve el ejecutable a /usr/local/bin/.
# 5. Limpia los archivos de descarga temporales.
# 6. Configura los permisos del binario para el usuario 'node_exporter'.
# 7. Crea un servicio systemd para Node Exporter.
# 8. Recarga systemd, habilita e inicia el servicio de Node Exporter.
# 9. Verifica el estado del servicio.
# 10. Indica cómo verificar las métricas directamente y en Prometheus.

# Salir inmediatamente si un comando falla
set -e

echo "==================================================="
echo "===== Iniciando la instalación de Node Exporter ====="
echo "==================================================="

# --- 1. Definir la versión de Node Exporter ---
# Visita https://github.com/prometheus/node_exporter/releases para obtener la última versión estable.
# A la fecha de esta guía, la versión 1.9.1 es la más reciente estable.
export NODE_EXPORTER_VERSION="1.9.1"
echo "Versión de Node Exporter a instalar: v${NODE_EXPORTER_VERSION}"

echo ""
echo "--- 2. Creando usuario 'node_exporter' ---"
# Crea un usuario del sistema sin directorio home y sin shell de inicio de sesión.
sudo useradd --no-create-home --shell /bin/false node_exporter
echo "Usuario 'node_exporter' creado."

echo ""
echo "--- 3. Descargando Node Exporter v${NODE_EXPORTER_VERSION} ---"
# Descarga el archivo comprimido del binario de Node Exporter para Linux (amd64).
wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
echo "Descarga de Node Exporter completada."

echo ""
echo "--- 4. Descomprimiendo y moviendo el binario de Node Exporter ---"
# Descomprime el archivo tar.gz.
tar xvf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz

# Mueve el ejecutable 'node_exporter' a /usr/local/bin/.
sudo mv node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin/
echo "Binario 'node_exporter' movido a /usr/local/bin/."

echo ""
echo "--- 5. Limpiando archivos de descarga temporales ---"
# Elimina el archivo comprimido y el directorio extraído.
rm -rf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64
echo "Archivos temporales limpiados."

echo ""
echo "--- 6. Configurando permisos de archivos para Node Exporter ---"
# Establece al usuario y grupo 'node_exporter' como propietario del binario.
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
echo "Permisos de archivos configurados para Node Exporter."

echo ""
echo "--- 7. Creando el servicio systemd para Node Exporter ---"
# Crea un archivo de unidad de servicio para systemd para gestionar Node Exporter.
sudo bash -c 'cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF'
echo "Servicio systemd para Node Exporter creado en /etc/systemd/system/node_exporter.service."

echo ""
echo "--- 8. Recargando systemd, habilitando e iniciando Node Exporter ---"
# Recarga la configuración de systemd para reconocer el nuevo servicio.
sudo systemctl daemon-reload
# Habilita el servicio para que se inicie automáticamente al arrancar el sistema.
sudo systemctl enable node_exporter
# Inicia el servicio de Node Exporter ahora mismo.
sudo systemctl start node_exporter
echo "Servicio de Node Exporter recargado, habilitado e iniciado."

echo ""
echo "--- 9. Verificando el estado del servicio Node Exporter ---"
sudo systemctl status node_exporter | grep "Active:"
if sudo systemctl is-active --quiet node_exporter; then
    echo "Node Exporter está activo (running). ¡Éxito!"
    echo "Puedes ver las métricas de Node Exporter en tu navegador en: http://localhost:9100/metrics"
else
    echo "ERROR: Node Exporter no está corriendo. Revisa los logs con 'sudo journalctl -xe -u node_exporter.service'."
    exit 1
fi

echo ""
echo "--- 10. Verificando que Prometheus está scrapeando Node Exporter ---"
echo "Abre la interfaz web de Prometheus en http://localhost:9090."
echo "Ve a 'Status' -> 'Targets'. Deberías ver 'node_exporter' listado como 'UP'."

echo ""
echo "==================================================="
echo "==== Instalación de Node Exporter completada ====="
echo "==================================================="
echo "Ahora puedes ejecutar el script 04_install_grafana.sh"
echo ""
