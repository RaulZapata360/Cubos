-- ============================================
-- DIAGNÓSTICO: ¿Por qué no se ven los movimientos?
-- ============================================

-- 1. ¿Cuántos movimientos hay en total?
SELECT COUNT(*) as total_movimientos FROM movimientos;

-- 2. ¿Qué usuario de Carlos está en la tabla usuarios?
SELECT * FROM usuarios WHERE email = 'jefe@demo.com';

-- 3. Simular consulta del dashboard (como si fuera Carlos)
-- NOTA: Esta query solo funcionará si ejecutas como Carlos
SELECT 
    m.*,
    o.nombre as obra_nombre,
    c.nombre as camion_nombre,
    c.patente,
    c.capacidad
FROM movimientos m
LEFT JOIN obras o ON m.obra_id = o.id
LEFT JOIN camiones c ON m.camion_id = c.id
WHERE m.fecha = '2024-12-22'
ORDER BY m.timestamp DESC
LIMIT 10;

-- 4. Verificar si RLS está habilitado
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'movimientos';

-- 5. Ver políticas activas
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE tablename = 'movimientos';
