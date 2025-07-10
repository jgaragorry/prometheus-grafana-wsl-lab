🚀 Laboratorio Básico de Monitoreo con Prometheus y Grafana en WSL 🚀
¡Bienvenido a tu primer laboratorio de monitoreo! Este repositorio te guiará paso a paso para configurar un sistema de monitoreo básico utilizando Prometheus (para la recolección de métricas), Node Exporter (para exponer métricas de tu sistema) y Grafana (para la visualización de datos) en tu entorno WSL (Windows Subsystem for Linux) con Ubuntu Server 24.04 LTS.

Este laboratorio está diseñado para principiantes, con explicaciones claras y scripts automatizados para facilitar el proceso.

🎯 ¿Qué aprenderás?
Comprender la arquitectura básica de monitoreo con Prometheus y Grafana.

Instalar y configurar Prometheus para recolectar métricas.

Instalar Node Exporter para exponer métricas de tu sistema operativo.

Instalar Grafana y conectarlo a Prometheus.

Importar un dashboard preconfigurado en Grafana para visualizar tus métricas.

🧱 Arquitectura del Laboratorio
Este laboratorio implementará la siguiente arquitectura de monitoreo:

+-------------------+     +---------------------+     +-----------------+
|   Tu PC (Windows) |     |   WSL (Ubuntu)      |     |   Tu Navegador  |
|                   |     |                     |     |                 |
|                   |     |  +--------------+   |     |  +-----------+  |
|                   |     |  | Node Exporter|   |     |  |  Grafana  |  |
|                   |     |  | (Puerto 9100)|<----+-----|  | Dashboard |  |
|                   |     |  +--------------+   |     |  +-----------+  |
|                   |     |         ^           |     |        ^        |
|                   |     |         |           |     |        |        |
|                   |     |  +--------------+   |     |  +-----------+  |
|                   |     |  |   Prometheus |<--------+--|  Grafana  |  |
|                   |     |  | (Puerto 9090)|   |     |  | (Puerto 3000) |
|                   |     |  +--------------+   |     |  +-----------+  |
|                   |     |                     |     |                 |
+-------------------+     +---------------------+     +-----------------+

Node Exporter: Se ejecuta en tu WSL y expone métricas de tu sistema (CPU, memoria, disco, red, etc.) en el puerto 9100.

Prometheus: Se ejecuta en tu WSL, "raspa" (scrapea) las métricas de Node Exporter (y de sí mismo) en el puerto 9100 (y 9090 respectivamente) y las almacena en su base de datos de series de tiempo.

Grafana: Se ejecuta en tu WSL, se conecta a Prometheus como fuente de datos y te permite crear y visualizar dashboards interactivos con las métricas recolectadas.

Tu Navegador: Accederás a las interfaces web de Prometheus y Grafana desde tu navegador en Windows, usando localhost y sus respectivos puertos.

📋 Requisitos Previos
Antes de comenzar, asegúrate de tener lo siguiente:

Windows Subsystem for Linux (WSL): Con una distribución Ubuntu Server 24.04 LTS instalada y funcionando.

Si no lo tienes, puedes seguir las guías oficiales de Microsoft para instalar WSL y Ubuntu.

Conexión a Internet: Tu instancia de WSL debe tener acceso a Internet para descargar los paquetes y binarios necesarios.

Conocimientos básicos de terminal Linux: Saber cómo ejecutar comandos y navegar por directorios.

🚀 Guía de Instalación Rápida (Usando los Scripts)
Sigue estos pasos en el orden indicado. Cada script imprimirá mensajes para guiarte.

1. Clonar el Repositorio
Abre tu terminal de WSL (Ubuntu) y clona este repositorio:

git clone https://github.com/TU_USUARIO/prometheus-grafana-wsl-lab.git # Reemplaza TU_USUARIO con tu nombre de usuario de GitHub
cd prometheus-grafana-wsl-lab/scripts

2. Dar Permisos de Ejecución a los Scripts
chmod +x *.sh

3. Ejecutar los Scripts en Orden
Ejecuta cada script uno por uno. Presta atención a los mensajes en la terminal.

3.1. Preparar el Sistema
Este script actualizará tu sistema e instalará herramientas básicas como wget y curl.

./01_prepare_system.sh

3.2. Instalar Prometheus
Este script se encargará de toda la instalación y configuración de Prometheus.

./02_install_prometheus.sh

3.3. Instalar Node Exporter
Este script instalará y configurará Node Exporter para recolectar métricas de tu sistema.

./03_install_node_exporter.sh

3.4. Instalar Grafana
Este script instalará y configurará Grafana.

./04_install_grafana.sh

🌐 Accediendo a las Interfaces Web
Una vez que todos los scripts se hayan ejecutado con éxito, podrás acceder a las interfaces web desde tu navegador en Windows:

Prometheus UI: http://localhost:9090

Aquí puedes ver el estado de tus "targets" (Node Exporter y Prometheus mismo) en Status -> Targets. Deberían aparecer como UP.

También puedes usar la pestaña Graph para ejecutar consultas PromQL básicas (ej. up, node_cpu_seconds_total).

Node Exporter Metrics: http://localhost:9100/metrics

Esta página muestra las métricas en formato plano que Prometheus "raspa". Es útil para verificar que Node Exporter está funcionando.

Grafana UI: http://localhost:3000

Usuario por defecto: admin

Contraseña por defecto: admin

Te pedirá que cambies la contraseña la primera vez que inicies sesión.

📊 Configurar Grafana y Visualizar Métricas
Después de iniciar sesión en Grafana, sigue estos pasos para conectar Prometheus y visualizar tus métricas:

1. Añadir Prometheus como Fuente de Datos
En el menú de la izquierda de Grafana, haz clic en el icono de "Connections" (Conexiones).

Dentro de "Connections", haz clic en "Data sources" (Fuentes de datos).

Haz clic en el botón "Add data source" (Añadir fuente de datos).

Busca y selecciona "Prometheus" de la lista.

En el campo "URL", introduce http://localhost:9090.

Haz clic en "Save & Test" (Guardar y probar). Deberías ver un mensaje de "Data source is working".

2. Importar el Dashboard de Node Exporter
Para visualizar tus métricas del sistema de forma atractiva, importaremos un dashboard preconfigurado:

En el menú de la izquierda de Grafana, haz clic en el icono de "Dashboards" (parece un cuadrado con otros cuadrados dentro).

Haz clic en el botón "New" (Nuevo) o en el icono "+" y selecciona "Import" (Importar).

Método recomendado (si falla la importación por ID):

Abre tu navegador web y ve a la página del dashboard Node Exporter Full: https://grafana.com/grafana/dashboards/1860-node-exporter-full/

Haz clic en el botón "Download JSON".

Abre el archivo JSON descargado con un editor de texto y copia todo su contenido.

En la página de importación de Grafana, pega el contenido JSON en el campo de texto grande bajo "Import via dashboard JSON model".

Haz clic en "Load".

Configuración final del Dashboard:

En la siguiente pantalla, asegúrate de que en el desplegable "Prometheus" (o el nombre que le diste a tu fuente de datos) esté seleccionada la fuente de datos de Prometheus que acabas de configurar.

Haz clic en "Import".

¡Listo! Ahora deberías ver el dashboard "Node Exporter Full" mostrando las métricas de tu sistema WSL en tiempo real.

✨ Mejores Prácticas y Próximos Pasos
Seguridad: Para entornos de producción, nunca uses las contraseñas por defecto de Grafana. Configura autenticación más robusta y asegúrate de que tus servicios no estén expuestos públicamente sin la debida protección (firewalls, VPNs).

Explora PromQL: Dedica tiempo a aprender el lenguaje de consulta de Prometheus (PromQL). Es muy potente para extraer y transformar tus métricas.

Crea tus Propios Dashboards: Una vez que te sientas cómodo, intenta crear tus propios dashboards y paneles en Grafana para visualizar métricas específicas que te interesen.

Otros Exporters: Explora la gran cantidad de exporters disponibles para monitorear otras aplicaciones y servicios (bases de datos, servidores web, etc.).

Alertas: Configura reglas de alerta en Prometheus y notificaciones en Grafana para ser avisado cuando algo no funcione como esperas.

¡Esperamos que este laboratorio te sea de gran utilidad en tu viaje por el mundo del monitoreo! Si tienes alguna pregunta, no dudes en abrir un "issue" en este repositorio o buscar en la documentación oficial de Prometheus y Grafana.
