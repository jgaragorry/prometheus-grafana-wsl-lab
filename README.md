# 🚀 Laboratorio Básico de Monitoreo con Prometheus y Grafana en WSL

¡Bienvenido a tu primer laboratorio de monitoreo! Este repositorio te guiará paso a paso para configurar un sistema de monitoreo básico utilizando **Prometheus** (recolección de métricas), **Node Exporter** (exposición de métricas del sistema) y **Grafana** (visualización de datos) en tu entorno **WSL con Ubuntu Server 24.04 LTS**.

Este laboratorio está diseñado para principiantes, con explicaciones claras y scripts automatizados.

---

## 🎯 ¿Qué aprenderás?

- Arquitectura básica de monitoreo con Prometheus y Grafana
- Instalación y configuración de Prometheus
- Instalación de Node Exporter
- Instalación de Grafana
- Importación de dashboard preconfigurado

---

## 🧱 Arquitectura del Laboratorio

```
+-------------------+     +---------------------+     +-----------------+
|   Tu PC (Windows) |     |   WSL (Ubuntu)      |     |   Tu Navegador  |
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

- WSL con Ubuntu Server 24.04 LTS
- Conexión a Internet
- Conocimientos básicos de terminal Linux

---

## 🚀 Guía de Instalación Rápida

```bash
# 1. Clonar el repositorio
git clone https://github.com/TU_USUARIO/prometheus-grafana-wsl-lab.git
cd prometheus-grafana-wsl-lab/scripts

# 2. Dar permisos
chmod +x *.sh

# 3. Ejecutar scripts
./01_prepare_system.sh
./02_install_prometheus.sh
./03_install_node_exporter.sh
./04_install_grafana.sh
```

---

## 🌐 Acceso a Interfaces Web

- **Prometheus UI**: http://localhost:9090  
- **Node Exporter Metrics**: http://localhost:9100/metrics  
- **Grafana UI**: http://localhost:3000  
  - Usuario: `admin`  
  - Contraseña: `admin` (se solicita cambiar en primer login)

---

## 📊 Configurar Grafana

### Añadir Fuente de Datos

1. Conexiones → Data Sources → Add data source  
2. Selecciona **Prometheus**  
3. URL: `http://localhost:9090`  
4. Guardar y probar

### Importar Dashboard Node Exporter Full

1. Ir a [https://grafana.com/grafana/dashboards/1860](https://grafana.com/grafana/dashboards/1860)
2. Descargar JSON
3. En Grafana → Dashboards → Import
4. Pegar contenido JSON y seleccionar Prometheus como fuente de datos

---

## ✨ Buenas Prácticas y Siguientes Pasos

- **Seguridad**: Cambia contraseñas por defecto y protege puertos expuestos
- **Explora PromQL**: Aprende el lenguaje de consulta para métricas avanzadas
- **Crea tus propios dashboards**
- **Investiga otros exporters**
- **Configura alertas**

---

## ❓ Soporte

¿Dudas? Abre un "issue" en el repositorio o consulta la documentación oficial:

- [Prometheus Docs](https://prometheus.io/docs/)
- [Grafana Docs](https://grafana.com/docs/)

¡Feliz monitoreo! 🚀
