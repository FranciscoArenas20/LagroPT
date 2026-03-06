# InventAgro Pro - Sistema de Gestión de Inventario

Aplicación móvil de alto rendimiento desarrollada en Flutter, diseñada para la visualización y búsqueda masiva de productos (+50,000 registros) con capacidades offline y sincronización eficiente.

## 🚀 Características Principales
- **Alto Rendimiento:** Renderizado fluido a 60 FPS incluso durante búsquedas intensivas.
- **Búsqueda Indexada:** Motor de búsqueda local (ObjectBox) que permite filtrar por Nombre y Categoría en milisegundos.
- **Arquitectura Robusta:** Implementación de Clean Architecture y gestión de estado con Riverpod.
- **Soporte Offline:** Persistencia de datos local que permite la consulta del catálogo sin conexión a internet.

## 🛠️ Stack Tecnológico
- **Lenguaje:** Dart / Flutter
- **Estado:** Riverpod (StateNotifier)
- **Base de Datos Local:** ObjectBox (NoSQL de alta velocidad)
- **Consumo API:** Dio con interceptores para manejo de errores
- **Backend:** Node.js (Railway)

## 📦 Generación de la APK
Para obtener la versión de lanzamiento optimizada:
```bash
flutter build apk --release --split-per-abi