-- ============================================
-- LIMPIEZA TOTAL DE DATOS (Manual + Script)
-- ============================================
-- Este script elimina TODOS los datos de TODAS las obras
-- ⚠️ CUIDADO: Esto borrará TODO, no solo datos de prueba

-- 1. Eliminar TODOS los movimientos
DELETE FROM movimientos;

-- 2. Eliminar TODO el historial diario
DELETE FROM historial_diario;

-- 3. Eliminar TODOS los destinos
DELETE FROM destinos;

-- 4. Eliminar TODOS los camiones
DELETE FROM camiones;

-- 5. Eliminar TODOS los materiales
DELETE FROM materiales;

-- 6. Eliminar TODAS las asignaciones usuario-obra
DELETE FROM usuario_obra;

-- 7. Eliminar TODAS las obras
DELETE FROM obras;

-- ============================================
-- VERIFICACIÓN DE LIMPIEZA
-- ============================================

SELECT 
  'obras' as tabla,
  COUNT(*) as registros_restantes
FROM obras
UNION ALL
SELECT 'camiones', COUNT(*) FROM camiones
UNION ALL
SELECT 'materiales', COUNT(*) FROM materiales
UNION ALL
SELECT 'destinos', COUNT(*) FROM destinos
UNION ALL
SELECT 'movimientos', COUNT(*) FROM movimientos
UNION ALL
SELECT 'usuario_obra', COUNT(*) FROM usuario_obra
UNION ALL
SELECT 'historial_diario', COUNT(*) FROM historial_diario;

-- Todos los valores deben ser 0
