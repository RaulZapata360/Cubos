-- ============================================
-- OPCIONAL: MIGRACIÓN DE DATOS EXISTENTES
-- Reclasifica movimientos que tienen origen Y destino como internos
-- ============================================

-- 1. Mostrar estadísticas ANTES de la migración
SELECT 
    'ANTES DE MIGRACIÓN' as momento,
    tipo_viaje,
    COUNT(*) as total_movimientos,
    COUNT(DISTINCT camion_id) as camiones_unicos,
    SUM(capacidad) as volumen_total
FROM movimientos
GROUP BY tipo_viaje
ORDER BY tipo_viaje;

-- 2. Identificar movimientos que deberían ser internos
-- (tienen origen Y destino, pero están marcados como externos)
SELECT 
    COUNT(*) as movimientos_a_migrar,
    MIN(fecha) as fecha_mas_antigua,
    MAX(fecha) as fecha_mas_reciente
FROM movimientos
WHERE origen IS NOT NULL 
  AND destino IS NOT NULL
  AND tipo_viaje = 'externo';

-- 3. Realizar la migración
UPDATE movimientos 
SET tipo_viaje = 'interno'
WHERE origen IS NOT NULL 
  AND destino IS NOT NULL
  AND tipo_viaje = 'externo';

-- 4. Mostrar estadísticas DESPUÉS de la migración
SELECT 
    'DESPUÉS DE MIGRACIÓN' as momento,
    tipo_viaje,
    COUNT(*) as total_movimientos,
    COUNT(DISTINCT camion_id) as camiones_unicos,
    SUM(capacidad) as volumen_total
FROM movimientos
GROUP BY tipo_viaje
ORDER BY tipo_viaje;

-- 5. Verificar que no hay inconsistencias
-- (movimientos marcados como internos sin origen o destino)
SELECT 
    COUNT(*) as inconsistencias
FROM movimientos
WHERE tipo_viaje = 'interno'
  AND (origen IS NULL OR destino IS NULL);

-- 6. Mostrar ejemplos de viajes internos migrados
SELECT 
    fecha,
    tipo,
    material,
    origen,
    destino,
    capacidad,
    tipo_viaje
FROM movimientos
WHERE tipo_viaje = 'interno'
ORDER BY fecha DESC, timestamp DESC
LIMIT 10;

RAISE NOTICE '✅ Migración de datos completada. Revisa los resultados arriba.';
