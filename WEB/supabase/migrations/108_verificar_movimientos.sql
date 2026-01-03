-- ============================================
-- VERIFICAR MOVIMIENTOS CREADOS
-- ============================================

-- 1. ¿Cuántos movimientos hay en total?
SELECT COUNT(*) as total_movimientos FROM movimientos;

-- 2. ¿Cuántos movimientos por obra?
SELECT 
  o.nombre as obra,
  COUNT(m.id) as movimientos
FROM obras o
LEFT JOIN movimientos m ON m.obra_id = o.id
GROUP BY o.nombre
ORDER BY o.nombre;

-- 3. ¿Qué fechas tienen movimientos?
SELECT 
  fecha,
  COUNT(*) as movimientos
FROM movimientos
GROUP BY fecha
ORDER BY fecha;

-- 4. Ver primeros 5 movimientos
SELECT 
  o.nombre as obra,
  c.nombre as camion,
  m.tipo,
  m.capacidad,
  m.material,
  m.destino,
  m.fecha,
  m.timestamp
FROM movimientos m
JOIN obras o ON m.obra_id = o.id
LEFT JOIN camiones c ON c.id = m.camion_id
ORDER BY m.timestamp DESC
LIMIT 5;
