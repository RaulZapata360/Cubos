# Sistema de Soft Delete y Auditoría - Resumen de Implementación

Se ha implementado un sistema de "borrado suave" (soft delete) para los movimientos de camiones, asegurando que los registros eliminados no desaparezcan permanentemente de la base de datos, sino que se marquen como eliminados y se registren en un historial de auditoría.

## Cambios Realizados

### 1. Base de Datos (Supabase)
- **Tabla `movimientos`**: Se agregaron las columnas `deleted_at` (timestamp) y `deleted_by` (UUID del usuario).
- **Tabla `movimientos_audit`**: Nueva tabla para registrar cada creación, modificación o eliminación.
- **Triggers**: Se configuraron disparadores automáticos en PostgreSQL para que cada vez que se marque un viaje como eliminado, se guarde una copia del estado anterior en la tabla de auditoría.

### 2. Lógica de Negocio (`boss-dashboard-service.js`)
- Se agregó la función `deleteMovement(movementId)` que realiza el update del campo `deleted_at`.
- Se actualizaron **todas** las consultas de lectura (`getTodayMovements`, `getWeeklyVolumeData`, `getMaterialMixData`, etc.) para incluir el filtro `.is('deleted_at', null)`. Esto garantiza que los gráficos, reportes y totales reflejen únicamente los datos activos.

### 3. Interfaz de Usuario (UI)
- **Boss Dashboard (`boss.html`)**:
    - Se agregó un icono de basurero (rojo) en la esquina superior derecha de cada tarjeta en "Actividad Reciente". El botón aparece al pasar el cursor (o presionar la tarjeta en móviles).
    - Se implementó la confirmación nativa: `¿Estás seguro de que deseas eliminar este viaje?`.
- **Vista de Contador (`index.html`)**:
    - Se agregó el mismo icono de basurero en la pestaña de "Registros".
    - Se implementó la lógica de eliminación directamente en el archivo para asegurar independencia funcional.
    - Se actualizó el proceso de auto-archivado para que ignore los viajes borrados al generar el historial diario.

## Cómo Usar
1. En el panel de **Boss** o en la pestaña **Registros** del contador, busca el viaje que deseas eliminar.
2. Haz clic en el icono de basurero <span class="material-symbols-outlined" style="font-size: 14px; color: #ef4444;">delete</span>.
3. Confirma la acción.
4. El sistema actualizará automáticamente la vista y recalculará los volúmenes totales (m³), reflejando el cambio de inmediato en los gráficos y resúmenes.

---
*Implementado por Antigravity - Versión 3.13.0*
