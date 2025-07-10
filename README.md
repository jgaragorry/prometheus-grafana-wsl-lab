# 🚀 Laboratorio Básico de Monitoreo con Prometheus y Grafana en WSL

Este laboratorio te guía paso a paso para montar un sistema de monitoreo básico en tu entorno **WSL (Ubuntu 24.04 LTS)**. Utiliza:

- **Prometheus** para recolección de métricas
- **Node Exporter** para exponer métricas del sistema
- **Grafana** para visualizar métricas
- **Tu navegador en Windows** para acceder a las interfaces web

---

## 🎯 ¿Qué aprenderás?

- Arquitectura y flujo de métricas con Prometheus y Grafana
- Instalación y configuración automatizada por scripts
- Verificación de funcionamiento y visualización en dashboards
- Observaciones importantes en cada fase del despliegue

---

## 🧱 Arquitectura del Laboratorio

```
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
+-------------------+     +---------------------+     +-----------------+
```

---

## 📋 Requisitos Previos

| Requisito                | Detalle                                                       |
|--------------------------|---------------------------------------------------------------|
| WSL                      | Ubuntu Server 24.04 LTS instalado y corriendo                 |
| Conexión a Internet      | Necesaria para descargar Prometheus, Node Exporter y Grafana |
| Acceso a terminal Linux  | Navegación por carpetas y ejecución de comandos               |

---

## 🚀 Instalación por Scripts

Ejecuta los siguientes pasos desde tu terminal en WSL Ubuntu:

### 1️⃣ Clonar el repositorio

```bash
git clone https://github.com/TU_USUARIO/prometheus-grafana-wsl-lab.git
cd prometheus-grafana-wsl-lab/scripts
```

> ✏️ Reemplaza `TU_USUARIO` por tu usuario real en GitHub

---

### 2️⃣ Dar permisos de ejecución

```bash
chmod +x *.sh
```

> 📌 Este paso es obligatorio para que los scripts puedan ejecutarse correctamente.

---

### 3️⃣ Ejecutar scripts en orden

#### 🛠️ 01 - Preparar el Sistema

```bash
./01_prepare_system.sh
```

📍 Este script:
- Actualiza el sistema (`apt update && upgrade`)
- Instala herramientas básicas (`wget`, `curl`)
- Verifica la conectividad

✅ Mensaje esperado al final:  
`🎉 Sistema preparado correctamente`

---

#### 📡 02 - Instalar Prometheus

```bash
./02_install_prometheus.sh
```

📍 Este script:
- Descarga binarios de Prometheus
- Crea carpetas `/etc/prometheus` y `/var/lib/prometheus`
- Configura servicio systemd
- Activa Prometheus en puerto **9090**

✅ Mensaje esperado:
- `✔ Prometheus instalado`
- Verifica con: `curl http://localhost:9090`

> ⚠️ Prometheus inicia como servicio y se autoconfigura para monitorear a sí mismo.

---

#### 🌐 03 - Instalar Node Exporter

```bash
./03_install_node_exporter.sh
```

📍 Este script:
- Descarga Node Exporter
- Lo configura como servicio en puerto **9100**
- Expone métricas del sistema: CPU, memoria, disco, red…

✅ Mensaje esperado:
- `✔ Node Exporter activo`
- Verifica con: `curl http://localhost:9100/metrics`

> ℹ️ Prometheus lo detectará automáticamente en `/targets` si la configuración fue correcta.

---

#### 📊 04 - Instalar Grafana

```bash
./04_install_grafana.sh
```

📍 Este script:
- Añade repositorio oficial de Grafana
- Instala y habilita servicio en puerto **3000**
- Abre acceso web

✅ Acceso en navegador:
- URL: [http://localhost:3000](http://localhost:3000)
- Usuario: `admin`
- Contraseña: `admin` (te pedirá cambiarla)

---

## 🌐 Interfaces Web

| Servicio      | URL                        | Detalles                       |
|---------------|----------------------------|--------------------------------|
| Prometheus    | http://localhost:9090      | Consulta estado y métricas     |
| Node Exporter | http://localhost:9100/metrics | Métricas del sistema en bruto |
| Grafana       | http://localhost:3000      | Visualización y dashboards     |

---

## 📊 Configuración en Grafana

### Añadir Fuente de Datos

1. Ir a **Connections → Data Sources → Add**
2. Elegir **Prometheus**
3. URL: `http://localhost:9090`
4. Save & Test → `Data source is working`

### Importar Dashboard Node Exporter Full

1. Ir a [https://grafana.com/grafana/dashboards/1860](https://grafana.com/grafana/dashboards/1860)
2. Descargar JSON → abrirlo con editor
3. En Grafana → Dashboard → Import
4. Pegar JSON → seleccionar Prometheus como fuente
5. Click en **Import**

✅ Verás paneles como uso de CPU, RAM, red, disco…

---

## ✅ Observaciones Clave por Fase

| Fase              | Observación Crítica                             |
|-------------------|--------------------------------------------------|
| Preparación       | Si faltan paquetes, los scripts no funcionarán  |
| Prometheus        | Requiere puertos libres y servicio activo       |
| Node Exporter     | Verifica que el puerto 9100 esté libre y abierto|
| Grafana           | Cambia la contraseña en el primer acceso        |
| Dashboard         | Si no ves métricas: revisa la fuente Prometheus |

---

## 🔒 Buenas Prácticas

- No uses credenciales por defecto en producción
- Protege los puertos (firewall, VPN, Nginx reverse proxy)
- Aprende PromQL para consultas avanzadas
- Crea tus propios dashboards personalizados
- Añade exporters para apps específicas (MySQL, Nginx, Redis)

---

## 🔔 Alertas y Notificaciones

Grafana permite:
- Enviar alertas por email, Teams, Slack…
- Definir umbrales en paneles
- Integrarse con Prometheus AlertManager

---

## 📚 Recursos Útiles

- [Prometheus Docs](https://prometheus.io/docs/)
- [Grafana Docs](https://grafana.com/docs/)
- [Node Exporter](https://github.com/prometheus/node_exporter)
- [Dashboard 1860](https://grafana.com/grafana/dashboards/1860-node-exporter-full/)
- [Instalación WSL](https://learn.microsoft.com/windows/wsl/install)

---

¿Listo para monitorizar como un pro? 🧠  
Este laboratorio te da una base sólida para explorar el mundo de observabilidad en Linux.

Si necesitas ayuda, abre un issue en GitHub o escribe en la comunidad oficial 🚀
