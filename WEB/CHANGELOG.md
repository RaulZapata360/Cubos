# Changelog - Sistema de Conteo de Camiones

## [v3.9.6] - 2026-01-09

### 🐛 Fix: Menú de Navegación Inferior en iOS Safari
- **CORREGIDO**: El menú de navegación inferior (accesos directos) se desplazaba al hacer scroll en dispositivos iOS
- **Problema**: En iOS Safari, el menú con `position: fixed` se movía junto con el contenido al hacer scroll, tapando información de la interfaz
- **Solución**: 
  - Agregadas propiedades CSS específicas para iOS: `transform: translateZ(0)`, `-webkit-transform`, `will-change: transform`
  - Forzada aceleración por hardware con `backface-visibility: hidden`
  - Aplicado en ambos archivos: `index.html` (contador) y `boss.html` (supervisor)

### 🔄 Mejora: Unificación de Versiones
- **UNIFICADO**: Ahora `index.html` y `boss.html` muestran la misma versión (v3.9.6)
- **AGREGADO**: Comentarios críticos en el código recordando actualizar ambas versiones simultáneamente
- **Ubicaciones**: 
  - `index.html` línea ~255
  - `boss.html` línea ~476
- **Nota para desarrolladores**: ⚠️ **SIEMPRE** actualizar la versión en AMBOS archivos cuando se haga cualquier cambio

### 📁 Archivos Modificados
- `styles.css` - Actualizada clase `.bottom-nav`
- `index.html` - Agregado estilo inline + versión actualizada a v3.9.6 + comentarios
- `boss.html` - Agregado estilo inline + versión actualizada a v3.9.6 + comentarios
- `CHANGELOG.md` - Documentado el fix y la unificación
- `BUG_FIX_iOS_Navigation.md` - Documentación técnica completa del fix de iOS

---

## [v3.9.4] - 2026-01-08

### 🐛 Fix: Filtrado en Modo Manual
- **CORREGIDO**: Los camiones marcados como `internal` (Jorge Salamanca, etc.) ya aparecen correctamente al seleccionar "Interno" en el Agregado Manual.
- Se actualizó la lógica de filtrado para permitir tipos `internal`, `outgoing` y `mixed` en viajes internos.

---

## [v3.9.3] - 2026-01-08

### 🔧 Mejoras Técnicas: Carga de Datos y Diagnóstico

- **MEJORADO**: Consulta de movimientos ahora trae información completa del camión
  - Agregados campos: `capacidad` y `tipo_registrado` al JOIN con tabla camiones
  - Asegura que toda la información necesaria esté disponible para filtros y visualización
  - Soluciona problemas de datos faltantes en la sección de análisis

- **NUEVO**: Herramientas de diagnóstico integradas
  - Script `DIAGNOSTICO.js` con funciones de debugging
  - Funciones disponibles en consola del navegador:
    - `checkMovements()` - Verifica movimientos cargados
    - `checkTrucks()` - Verifica camiones cargados  
    - `checkPerformance()` - Analiza rendimiento y patentes
    - `testMovementsQuery()` - Prueba consulta a Supabase
    - `runFullDiagnostic()` - Diagnóstico completo
  - Facilita identificación de problemas de carga de datos

---

## [v3.9.2] - 2026-01-08

### ✨ Mejora: Visualización de Patentes en Análisis

- **NUEVO**: Ahora se muestra la **patente del camión** en la sección "Rendimiento por Camión"
  - Ubicado en la pestaña **Análisis**
  - La patente aparece debajo del nombre del camión con estilo discreto
  - Facilita la identificación rápida de cada vehículo en el listado de rendimiento
  
- **Detalles de Visualización**:
  - Nombre del camión (texto principal en blanco)
  - Patente (texto pequeño en gris, debajo del nombre)
  - Etiquetas de tipo de movimiento (Relleno/Excavación/Interno)
  - Estadísticas de vueltas y m³

---

## [v3.8.6] - 2026-01-08

### ✨ Nueva Funcionalidad: Agregado Manual de Vueltas

- **NUEVO**: Botón "Agregado Manual" para registrar vueltas retroactivamente
  - Ubicado debajo del contador de "Viajes Internos" en el tab Resumen
  - Diseño morado distintivo para fácil identificación
  
- **Flujo Paso a Paso**: Interfaz secuencial que coincide con la estética de los contadores regulares
  1. **Tipo de Viaje**: Selección entre Relleno, Excavación o Interno
  2. **Camión**: Lista filtrada según tipo de movimiento
  3. **Material**: Lista filtrada según tipo de movimiento
  4. **Origen/Destino**: Según corresponda (se omite para viajes internos)
  5. **Fecha y Hora**: Con resumen visual antes de confirmar

- **Filtrado Inteligente**:
  - Camiones filtrados por tipo (incoming/outgoing/mixed)
  - Materiales filtrados por tipo (incoming/outgoing)
  - Solo muestra opciones relevantes para cada tipo de viaje
  - Previene errores de usuario mostrando solo opciones válidas

- **Agregar Nuevos Elementos**: Botones "+" en cada paso para crear:
  - Nuevos camiones (con validación de tipo)
  - Nuevos materiales
  - Nuevos orígenes/destinos
  - Auto-selección del elemento recién creado

- **Validación y UX**:
  - Navegación con botones "Volver" en cada paso
  - Validación de fecha (no permite fechas futuras)
  - Resumen completo antes de confirmar
  - Mensajes claros cuando no hay opciones disponibles

---

## [v3.7.4] - 2026-01-06

### 🚀 Mejoras de Carga de Datos
- **Fijado**: Los datos de Supabase no se mostraban en la interfaz (quedaban en 0) a pesar de estar en la base.
- Se forzó la recarga de datos (`loadTrucks(true)` y `loadMovements(true)`) al iniciar la app para evitar que el caché muestre ceros.
- Optimizado el sistema de caché para respetar el parámetro `forceRefresh`.

### 🐛 Fixes de Interfaz
- **CORRECCIÓN DEFINITIVA**: El historial de movimientos ya no aparece en todos los tabs.
  - Se eliminó el `</div>` extra que causaba que el panel de movimientos se "saliera" de su pestaña.
  - Se verificó el balance de etiquetas en el archivo `index.html`.

---

## [v3.7.1] - [v3.7.3] - Versiones de Transición
- Intentos de corregir el historial y la visibilidad de datos.

---

## [v3.7.0] - 2026-01-06
- Versión base con bug de historial y estructura desbalanceada.
