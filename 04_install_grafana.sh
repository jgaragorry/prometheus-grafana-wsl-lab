#!/bin/bash

# Este script instala y configura Grafana en tu sistema Ubuntu en WSL.
# Grafana es una plataforma de código abierto para la visualización y el análisis de datos.

# Pasos realizados:
# 1. Instala dependencias necesarias para añadir repositorios HTTPS.
# 2. Añade la clave GPG oficial de Grafana.
# 3. Añade el repositorio APT de Grafana a las fuentes de paquetes del sistema.
# 4. Actualiza la lista de paquetes para incluir los de Grafana.
# 5. Instala el paquete de Grafana.
# 6. Habilita e inicia el servicio de Grafana.
# 7. Verifica el estado del servicio.
# 8. Proporciona instrucciones para acceder a la interfaz web de Grafana,
#    añadir Prometheus como fuente de datos e importar un dashboard.

# Salir inmediatamente si un comando falla
set -e

echo "==================================================="
echo "======== Iniciando la instalación de Grafana ========"
echo "==================================================="

echo ""
echo "--- 1. Instalando dependencias para el repositorio de Grafana ---"
# 'apt-transport-https' permite apt manejar repositorios HTTPS.
# 'software-properties-common' proporciona 'add-apt-repository'.
# 'gpg' es para manejar las claves de firma.
sudo apt install -y apt-transport-https software-properties-common gpg
echo "Dependencias instaladas."

echo ""
echo "--- 2. Añadiendo la clave GPG oficial de Grafana ---"
# Descarga la clave GPG de Grafana y la añade al directorio de claves del sistema.
# Esto asegura la autenticidad de los paquetes de Grafana.
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "Clave GPG de Grafana añadida."

echo ""
echo "--- 3. Añadiendo el repositorio APT de Grafana ---"
# Añade la línea del repositorio de Grafana a las fuentes de paquetes del sistema.
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
echo "Repositorio de Grafana añadido."

echo ""
echo "--- 4. Actualizando la lista de paquetes para incluir Grafana ---"
sudo apt update
echo "Lista de paquetes actualizada."

echo ""
echo "--- 5. Instalando Grafana ---"
sudo apt install -y grafana
echo "Grafana instalado."

echo ""
echo "--- 6. Habilitando e iniciando el servicio de Grafana ---"
# Recarga la configuración de systemd.
sudo systemctl daemon-reload
# Habilita el servicio para que se inicie automáticamente al arrancar el sistema.
sudo systemctl enable grafana-server
# Inicia el servicio de Grafana ahora mismo.
sudo systemctl start grafana-server
echo "Servicio de Grafana recargado, habilitado e iniciado."

echo ""
echo "--- 7. Verificando el estado del servicio Grafana ---"
sudo systemctl status grafana-server | grep "Active:"
if sudo systemctl is-active --quiet grafana-server; then
    echo "Grafana está activo (running). ¡Éxito!"
else
    echo "ERROR: Grafana no está corriendo. Revisa los logs con 'sudo journalctl -xe -u grafana-server.service'."
    exit 1
fi

echo ""
echo "==================================================="
echo "======== Instalación de Grafana completada ========"
echo "==================================================="

echo ""
echo "--- Pasos Siguientes en tu Navegador ---"
echo "1. Accede a la interfaz web de Grafana en: http://localhost:3000"
echo "   - Usuario por defecto: admin"
echo "   - Contraseña por defecto: admin"
echo "   - Se te pedirá cambiar la contraseña al primer inicio de sesión."
echo ""
echo "2. Añade Prometheus como fuente de datos en Grafana:"
echo "   - En el menú de la izquierda, haz clic en 'Connections' (Conexiones)."
echo "   - Luego, haz clic en 'Data sources' (Fuentes de datos)."
echo "   - Haz clic en 'Add data source' (Añadir fuente de datos) y selecciona 'Prometheus'."
echo "   - En el campo 'URL', introduce: http://localhost:9090"
echo "   - Haz clic en 'Save & Test'. Deberías ver 'Data source is working'."
echo ""
echo "3. Importa el Dashboard 'Node Exporter Full' (ID: 1860) en Grafana:"
echo "   - En el menú de la izquierda, haz clic en 'Dashboards'."
echo "   - Haz clic en 'New' o el icono '+' y selecciona 'Import'."
echo "   - En el campo 'Import via grafana.com dashboard ID', introduce '1860' y haz clic en 'Load'."
echo "     * SI FALLA la importación por ID (ej. 'Need a dashboard JSON model'):"
echo "       a. Abre tu navegador y ve a: https://grafana.com/grafana/dashboards/1860-node-exporter-full/"
echo "       b. Haz clic en 'Download JSON' y abre el archivo descargado con un editor de texto."
echo "       c. Copia TODO el contenido JSON."
echo "       d. Vuelve a la página de importación de Grafana y pega el JSON en el campo de texto grande."
echo "       e. Haz clic en 'Load'."
echo "   - En la siguiente pantalla, asegúrate de que tu fuente de datos 'Prometheus' esté seleccionada."
echo "   - Haz clic en 'Import'."
echo ""
echo "¡Tu laboratorio de monitoreo está listo! Explora el dashboard y tus métricas."
echo "==================================================="
