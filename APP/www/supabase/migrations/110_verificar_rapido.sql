-- Verificar movimientos creados
SELECT 
  COUNT(*) as total_movimientos,
  MIN(fecha) as fecha_min,
  MAX(fecha) as fecha_max
FROM movimientos;

-- Ver movimientos por fecha
SELECT 
  fecha,
  COUNT(*) as movimientos
FROM movimientos
GROUP BY fecha
ORDER BY fecha;
