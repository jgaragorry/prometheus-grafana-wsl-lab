#!/bin/bash

# Este script desinstala completamente Prometheus, Node Exporter y Grafana
# del sistema Ubuntu en WSL, revirtiendo los cambios realizados por los scripts de instalación.
# Realiza las siguientes tareas en el orden inverso a la instalación:
# 1. Detiene y deshabilita los servicios de Grafana, Node Exporter y Prometheus.
# 2. Elimina los archivos de servicio de systemd.
# 3. Desinstala el paquete de Grafana y LUEGO elimina su repositorio APT y clave GPG.
# 4. Elimina los binarios de Prometheus y Node Exporter.
# 5. Elimina los directorios de configuración y datos de Prometheus.
# 6. Elimina los usuarios de sistema creados para Prometheus y Node Exporter.
# 7. Limpia cualquier archivo de descarga temporal remanente.

# Salir inmediatamente si un comando falla
set -e

echo "========================================================"
echo "=== Iniciando la desinstalación de Prometheus, Node Exporter y Grafana ==="
echo "========================================================"

echo ""
echo "--- 1. Deteniendo y deshabilitando los servicios ---"
# Detener y deshabilitar Grafana
if systemctl is-active --quiet grafana-server; then
    echo "Deteniendo el servicio grafana-server..."
    sudo systemctl stop grafana-server
fi
if systemctl is-enabled --quiet grafana-server; then
    echo "Deshabilitando el servicio grafana-server..."
    sudo systemctl disable grafana-server
fi

# Detener y deshabilitar Node Exporter
if systemctl is-active --quiet node_exporter; then
    echo "Deteniendo el servicio node_exporter..."
    sudo systemctl stop node_exporter
fi
if systemctl is-enabled --quiet node_exporter; then
    echo "Deshabilitando el servicio node_exporter..."
    sudo systemctl disable node_exporter
fi

# Detener y deshabilitar Prometheus
if systemctl is-active --quiet prometheus; then
    echo "Deteniendo el servicio prometheus..."
    sudo systemctl stop prometheus
fi
if systemctl is-enabled --quiet prometheus; then
    echo "Deshabilitando el servicio prometheus..."
    sudo systemctl disable prometheus
fi

sudo systemctl daemon-reload # Recargar systemd después de deshabilitar
echo "Servicios detenidos y deshabilitados."

echo ""
echo "--- 2. Eliminando archivos de servicio de systemd ---"
sudo rm -f /etc/systemd/system/grafana-server.service
sudo rm -f /etc/systemd/system/node_exporter.service
sudo rm -f /etc/systemd/system/prometheus.service
echo "Archivos de servicio systemd eliminados."

echo ""
echo "--- 3. Desinstalando Grafana y limpiando su repositorio ---"
# Desinstalar el paquete de Grafana PRIMERO
echo "Desinstalando el paquete 'grafana'..."
# Usamos 'apt-get' en lugar de 'apt' para 'purge' por si hay alguna diferencia de comportamiento en versiones antiguas de apt.
# También usamos '|| true' para que el script no falle si el paquete no se encuentra
# (por ejemplo, si ya fue desinstalado manualmente o si la instalación previa falló).
sudo apt-get purge -y grafana || true
sudo apt autoremove -y
echo "Paquete Grafana desinstalado (si existía)."

# Eliminar el repositorio APT de Grafana
echo "Eliminando el repositorio APT de Grafana..."
sudo rm -f /etc/apt/sources.list.d/grafana.list
echo "Repositorio de Grafana eliminado."

# Eliminar la clave GPG de Grafana
echo "Eliminando la clave GPG de Grafana..."
sudo rm -f /etc/apt/keyrings/grafana.gpg
echo "Clave GPG de Grafana eliminada."

echo ""
echo "--- 4. Eliminando binarios de Prometheus y Node Exporter ---"
echo "Eliminando /usr/local/bin/prometheus..."
sudo rm -f /usr/local/bin/prometheus
echo "Eliminando /usr/local/bin/promtool..."
sudo rm -f /usr/local/bin/promtool
echo "Eliminando /usr/local/bin/node_exporter..."
sudo rm -f /usr/local/bin/node_exporter
echo "Binarios eliminados."

echo ""
echo "--- 5. Eliminando directorios de configuración y datos ---"
echo "Eliminando /etc/prometheus/..."
sudo rm -rf /etc/prometheus/
echo "Eliminando /var/lib/prometheus/..."
sudo rm -rf /var/lib/prometheus/
echo "Directorios de configuración y datos eliminados."

echo ""
echo "--- 6. Eliminando usuarios de sistema creados ---"
# Eliminar usuario 'prometheus'
if id "prometheus" &>/dev/null; then
    echo "Eliminando usuario 'prometheus'..."
    sudo userdel prometheus
else
    echo "Usuario 'prometheus' no existe, omitiendo eliminación."
fi

# Eliminar usuario 'node_exporter'
if id "node_exporter" &>/dev/null; then
    echo "Eliminando usuario 'node_exporter'..."
    sudo userdel node_exporter
else
    echo "Usuario 'node_exporter' no existe, omitiendo eliminación."
fi
echo "Usuarios de sistema eliminados (si existían)."

echo ""
echo "--- 7. Limpiando archivos de descarga temporales remanentes ---"
# Intentar limpiar cualquier archivo tar.gz o directorio extraído que pudiera quedar
# de intentos fallidos o si el usuario no los eliminó manualmente.
# Se usan las variables de versión para ser específicos, pero también un patrón genérico.
export PROMETHEUS_VERSION="3.4.2" # Ajustar si se usó otra versión
export NODE_EXPORTER_VERSION="1.9.1" # Ajustar si se usó otra versión

echo "Buscando y eliminando archivos tar.gz y directorios temporales..."
rm -rf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz prometheus-${PROMETHEUS_VERSION}.linux-amd64 || true
rm -rf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64 || true
rm -rf prometheus-*.linux-amd64.tar.gz prometheus-*.linux-amd64 || true
rm -rf node_exporter-*.linux-amd64.tar.gz node_exporter-*.linux-amd64 || true
echo "Archivos temporales limpiados (si existían)."

echo ""
echo "--- 8. Actualizando la lista de paquetes de apt después de la limpieza ---"
sudo apt update
echo "Lista de paquetes actualizada."

echo ""
echo "========================================================"
echo "=== Desinstalación completada. El sistema está limpio de Prometheus, Node Exporter y Grafana. ==="
echo "========================================================"
echo ""
