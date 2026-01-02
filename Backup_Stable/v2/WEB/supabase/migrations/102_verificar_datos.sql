-- ============================================
-- SCRIPT DE VERIFICACIÓN SIMPLE
-- Ejecuta esto en Supabase SQL Editor para ver qué está pasando
-- ============================================

-- 1. ¿Quién soy yo?
SELECT 
    auth.uid() as mi_user_id,
    (SELECT email FROM auth.users WHERE id = auth.uid()) as mi_email;

-- 2. ¿Estoy en la tabla usuarios?
SELECT * FROM usuarios WHERE id = auth.uid();

-- 3. ¿Cuántas obras existen en total?
SELECT COUNT(*) as total_obras FROM obras;

-- 4. ¿Cuántas obras PUEDO VER?
SELECT id, nombre, ubicacion FROM obras;

-- 5. ¿Cuántos movimientos existen en total (sin RLS)?
-- Esta query fallará si no eres superadmin, eso es normal
SELECT COUNT(*) as total_movimientos_db FROM movimientos;

-- 6. ¿Cuántos movimientos PUEDO VER?
SELECT COUNT(*) as movimientos_que_veo FROM movimientos;

-- 7. Desglose de movimientos por obra que PUEDO VER
SELECT 
    o.nombre as obra,
    COUNT(m.id) as total_movimientos
FROM obras o
LEFT JOIN movimientos m ON m.obra_id = o.id
GROUP BY o.id, o.nombre
ORDER BY o.nombre;

-- 8. ¿Hay datos en el rango 22-26 Dic?
SELECT 
    fecha,
    COUNT(*) as movimientos
FROM movimientos
WHERE fecha BETWEEN '2024-12-22' AND '2024-12-26'
GROUP BY fecha
ORDER BY fecha;
