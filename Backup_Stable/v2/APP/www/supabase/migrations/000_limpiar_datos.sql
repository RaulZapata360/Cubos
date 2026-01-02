-- ============================================
-- LIMPIAR DATOS DE DEMO
-- Ejecuta este script para borrar todos los datos
-- ============================================

-- Borrar en orden inverso por las foreign keys

-- 1. Borrar movimientos
DELETE FROM movimientos;

-- 2. Borrar camiones
DELETE FROM camiones;

-- 3. Borrar materiales
DELETE FROM materiales;

-- 4. Borrar asignaciones usuario-obra
DELETE FROM usuario_obra;

-- 5. Borrar usuarios (perfiles)
DELETE FROM usuarios;

-- 6. Borrar obras
DELETE FROM obras;

-- Verificar que todo está vacío
SELECT 'obras' as tabla, COUNT(*) as registros FROM obras
UNION ALL
SELECT 'usuarios', COUNT(*) FROM usuarios
UNION ALL
SELECT 'usuario_obra', COUNT(*) FROM usuario_obra
UNION ALL
SELECT 'camiones', COUNT(*) FROM camiones
UNION ALL
SELECT 'movimientos', COUNT(*) FROM movimientos
UNION ALL
SELECT 'materiales', COUNT(*) FROM materiales;

-- Si todos muestran 0, entonces está limpio y listo para ejecutar 003_demo_data.sql de nuevo
