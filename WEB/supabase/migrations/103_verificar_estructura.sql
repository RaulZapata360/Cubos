-- ============================================
-- VERIFICACIÓN DETALLADA DE DATOS
-- ============================================
-- Ejecuta esto para diagnosticar por qué los datos no se leen

-- 1. ¿Quién soy?
SELECT 
    auth.uid() as mi_id,
    (SELECT email FROM auth.users WHERE id = auth.uid()) as mi_email,
    (SELECT rol FROM usuarios WHERE id = auth.uid()) as mi_rol;

-- 2. ¿Qué obras puedo ver?
SELECT 
    id,
    nombre,
    ubicacion
FROM obras
ORDER BY nombre;

-- 3. ¿Cuántos movimientos hay en total (22-26 Dic)?
SELECT 
    COUNT(*) as total_movimientos,
    MIN(fecha) as fecha_min,
    MAX(fecha) as fecha_max
FROM movimientos
WHERE fecha BETWEEN '2024-12-22' AND '2024-12-26';

-- 4. Desglose por obra y fecha
SELECT 
    o.nombre as obra,
    m.fecha,
    COUNT(m.id) as movimientos,
    COUNT(DISTINCT m.camion_id) as camiones_distintos,
    SUM(CASE WHEN m.tipo = 'incoming' THEN m.capacidad ELSE 0 END) as vol_entrada,
    SUM(CASE WHEN m.tipo = 'outgoing' THEN m.capacidad ELSE 0 END) as vol_salida
FROM movimientos m
JOIN obras o ON m.obra_id = o.id
WHERE m.fecha BETWEEN '2024-12-22' AND '2024-12-26'
GROUP BY o.nombre, m.fecha
ORDER BY o.nombre, m.fecha;

-- 5. Verificar estructura de movimientos (primeros 5)
SELECT 
    m.id,
    o.nombre as obra,
    m.tipo,
    m.capacidad,
    m.material,
    m.ubicacion,  -- Debería ser NULL
    m.camion_nombre,  -- Debería ser NULL
    m.camion_patente,  -- Debería ser NULL
    m.fecha,
    m.timestamp
FROM movimientos m
JOIN obras o ON m.obra_id = o.id
WHERE m.fecha BETWEEN '2024-12-22' AND '2024-12-26'
ORDER BY m.timestamp
LIMIT 5;

-- 6. Verificar camiones
SELECT 
    o.nombre as obra,
    COUNT(c.id) as total_camiones,
    STRING_AGG(c.nombre, ', ' ORDER BY c.nombre) as camiones
FROM camiones c
JOIN obras o ON c.obra_id = o.id
WHERE o.nombre IN ('Aeroparque', 'VAIN', 'Azul')
GROUP BY o.nombre
ORDER BY o.nombre;

-- 7. Verificar que NO haya campos extras en movimientos
SELECT 
    COUNT(*) as movimientos_con_ubicacion,
    COUNT(CASE WHEN camion_nombre IS NOT NULL THEN 1 END) as movimientos_con_camion_nombre
FROM movimientos
WHERE fecha BETWEEN '2024-12-22' AND '2024-12-26';
