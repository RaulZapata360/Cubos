# Implementación de Edición y Eliminación de Movimientos

## Resumen
Sistema de edición y eliminación (soft delete) de movimientos con auditoría completa.

## Características

### 1. Edición de Movimientos
- ✅ Disponible en `boss.html` e `index.html`
- ✅ Modal de edición con todos los campos editables
- ✅ Validación de datos antes de guardar
- ✅ Registro de cambios en tabla de auditoría

### 2. Eliminación de Movimientos
- ✅ Disponible para todos los usuarios autenticados
- ✅ Confirmación obligatoria antes de eliminar
- ✅ **Soft Delete**: No se borra físicamente, se marca como eliminado
- ✅ Registro de quién y cuándo eliminó el movimiento
- ✅ Los movimientos eliminados no aparecen en consultas normales

### 3. Auditoría
- ✅ Tabla `movimientos_audit` registra todos los cambios
- ✅ Campos registrados:
  - Acción realizada (created, updated, deleted)
  - Usuario que realizó el cambio
  - Fecha y hora del cambio
  - Datos anteriores y nuevos (JSON)
  - Razón del cambio

## Pasos de Implementación

### Paso 1: Ejecutar Migración SQL
1. Abrir Supabase Dashboard
2. Ir a SQL Editor
3. Ejecutar el script: `migrations/add_soft_delete_and_audit.sql`
4. Verificar que las columnas y tablas se crearon correctamente

### Paso 2: Actualizar Consultas Existentes
Todas las consultas a `movimientos` deben filtrar registros eliminados:

```javascript
// ANTES
const { data, error } = await supabase
    .from('movimientos')
    .select('*');

// DESPUÉS
const { data, error } = await supabase
    .from('movimientos')
    .select('*')
    .is('deleted_at', null); // Solo movimientos activos
```

### Paso 3: Implementar UI de Edición
- Agregar botón "Editar" en cada tarjeta de movimiento
- Crear modal de edición con formulario
- Implementar función `editMovement(movementId)`

### Paso 4: Implementar UI de Eliminación
- Agregar botón "Eliminar" en cada tarjeta de movimiento
- Crear modal de confirmación
- Implementar función `deleteMovement(movementId)`

## Funciones JavaScript a Implementar

### 1. Función de Eliminación (Soft Delete)
```javascript
async function deleteMovement(movementId) {
    // Mostrar confirmación
    const confirmed = confirm('¿Estás seguro de que deseas eliminar este viaje?');
    if (!confirmed) return;

    try {
        const { data: { user } } = await supabase.auth.getUser();
        
        const { error } = await supabase
            .from('movimientos')
            .update({
                deleted_at: new Date().toISOString(),
                deleted_by: user.id
            })
            .eq('id', movementId);

        if (error) throw error;

        alert('Viaje eliminado exitosamente');
        // Recargar datos
        await loadDashboard();
    } catch (error) {
        console.error('Error al eliminar viaje:', error);
        alert('Error al eliminar el viaje');
    }
}
```

### 2. Función de Edición
```javascript
async function editMovement(movementId) {
    // 1. Obtener datos actuales del movimiento
    const { data: movement, error } = await supabase
        .from('movimientos')
        .select('*')
        .eq('id', movementId)
        .is('deleted_at', null)
        .single();

    if (error || !movement) {
        alert('No se pudo cargar el movimiento');
        return;
    }

    // 2. Mostrar modal con datos precargados
    showEditModal(movement);
}

async function saveMovementEdit(movementId, updatedData) {
    try {
        const { error } = await supabase
            .from('movimientos')
            .update(updatedData)
            .eq('id', movementId);

        if (error) throw error;

        alert('Viaje actualizado exitosamente');
        closeEditModal();
        await loadDashboard();
    } catch (error) {
        console.error('Error al actualizar viaje:', error);
        alert('Error al actualizar el viaje');
    }
}
```

### 3. Actualizar Consultas Existentes
Buscar y reemplazar en `boss-dashboard-service.js` e `index.html`:

```javascript
// En todas las funciones que consultan movimientos, agregar:
.is('deleted_at', null)

// Ejemplo en getMovementsByDate:
async getMovementsByDate(targetDate) {
    const { data, error } = await supabase
        .from('movimientos')
        .select(`
            *,
            camiones (nombre, patente, capacidad),
            usuarios (nombre_completo)
        `)
        .gte('timestamp', `${targetDate}T00:00:00`)
        .lte('timestamp', `${targetDate}T23:59:59`)
        .is('deleted_at', null) // ← AGREGAR ESTA LÍNEA
        .order('timestamp', { ascending: false });

    return data || [];
}
```

## Estructura del Modal de Edición

```html
<div id="editMovementModal" class="modal hidden">
    <div class="modal-content">
        <h2>Editar Viaje</h2>
        <form id="editMovementForm">
            <input type="hidden" id="edit_movement_id">
            
            <label>Camión:</label>
            <select id="edit_truck" required></select>
            
            <label>Material:</label>
            <select id="edit_material" required></select>
            
            <label>Origen:</label>
            <input type="text" id="edit_origin">
            
            <label>Destino:</label>
            <input type="text" id="edit_destination">
            
            <label>Capacidad (m³):</label>
            <input type="number" id="edit_capacity" step="0.1" required>
            
            <label>Fecha y Hora:</label>
            <input type="datetime-local" id="edit_timestamp" required>
            
            <div class="modal-buttons">
                <button type="submit">Guardar Cambios</button>
                <button type="button" onclick="closeEditModal()">Cancelar</button>
            </div>
        </form>
    </div>
</div>
```

## Verificación Post-Implementación

### Checklist
- [ ] Migración SQL ejecutada correctamente
- [ ] Columnas `deleted_at` y `deleted_by` existen en `movimientos`
- [ ] Tabla `movimientos_audit` creada
- [ ] Triggers funcionando correctamente
- [ ] Todas las consultas filtran `deleted_at IS NULL`
- [ ] Botones de editar y eliminar visibles en UI
- [ ] Modal de confirmación funciona
- [ ] Soft delete funciona correctamente
- [ ] Auditoría registra cambios
- [ ] UI se actualiza después de editar/eliminar

## Notas Importantes

1. **No se borran datos físicamente**: Los registros permanecen en la base de datos con `deleted_at` marcado
2. **Auditoría completa**: Todos los cambios quedan registrados en `movimientos_audit`
3. **Reversible**: Si es necesario, se puede "restaurar" un movimiento eliminado poniendo `deleted_at = NULL`
4. **Permisos**: Todos los usuarios autenticados pueden eliminar movimientos (con confirmación)
5. **Performance**: Los índices creados aseguran que las consultas sean rápidas

## Próximos Pasos

1. Ejecutar migración SQL en Supabase
2. Actualizar todas las consultas para filtrar eliminados
3. Implementar UI de edición en `boss.html`
4. Implementar UI de edición en `index.html`
5. Implementar UI de eliminación en ambos archivos
6. Probar exhaustivamente
7. Actualizar versión a v3.13.0
