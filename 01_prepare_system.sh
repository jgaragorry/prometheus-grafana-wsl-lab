#!/bin/bash

# Este script prepara el sistema Ubuntu en WSL para la instalación de Prometheus y Grafana.
# Realiza las siguientes tareas:
# 1. Actualiza la lista de paquetes disponibles.
# 2. Actualiza todos los paquetes instalados a sus últimas versiones.
# 3. Instala herramientas esenciales como 'wget' y 'curl' si no están presentes.

# Salir inmediatamente si un comando falla
set -e

echo "==================================================="
echo "=== Iniciando la preparación del sistema Ubuntu ==="
echo "==================================================="

echo ""
echo "--- 1. Actualizando la lista de paquetes (apt update) ---"
sudo apt update
echo "Lista de paquetes actualizada."

echo ""
echo "--- 2. Actualizando los paquetes instalados (apt upgrade) ---"
sudo apt upgrade -y
echo "Paquetes del sistema actualizados."

echo ""
echo "--- 3. Instalando herramientas esenciales (wget, curl) ---"
# 'apt-transport-https' y 'software-properties-common' son necesarios para añadir repositorios HTTPS
# 'gpg' es necesario para manejar claves GPG de repositorios
sudo apt install -y wget curl apt-transport-https software-properties-common gpg
echo "Herramientas esenciales instaladas."

echo ""
echo "==================================================="
echo "=== Preparación del sistema completada con éxito ==="
echo "==================================================="
echo "Ahora puedes ejecutar el script 02_install_prometheus.sh"
echo ""
