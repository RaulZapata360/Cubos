-- ==========================================
-- 003_LIMPIEZA_TOTAL_DEMO.sql
-- ==========================================
-- Este script elimina TODOS los datos relacionados con las obras de demo 
-- (IDs: 1111..., 2222..., 3333...) en todas las tablas.

BEGIN;

-- 1. Eliminar movimientos de demo
DELETE FROM movimientos 
WHERE obra_id::text LIKE '11111111-%' 
   OR obra_id::text LIKE '22222222-%' 
   OR obra_id::text LIKE '33333333-%';

-- 2. Eliminar camiones de demo
DELETE FROM camiones 
WHERE obra_id::text LIKE '11111111-%' 
   OR obra_id::text LIKE '22222222-%' 
   OR obra_id::text LIKE '33333333-%';

-- 3. Eliminar materiales de demo
DELETE FROM materiales 
WHERE obra_id::text LIKE '11111111-%' 
   OR obra_id::text LIKE '22222222-%' 
   OR obra_id::text LIKE '33333333-%';

-- 4. Eliminar historial diario de demo
DELETE FROM historial_diario 
WHERE obra_id::text LIKE '11111111-%' 
   OR obra_id::text LIKE '22222222-%' 
   OR obra_id::text LIKE '33333333-%';

-- 5. Eliminar asignaciones usuario_obra de demo
DELETE FROM usuario_obra 
WHERE obra_id::text LIKE '11111111-%' 
   OR obra_id::text LIKE '22222222-%' 
   OR obra_id::text LIKE '33333333-%';

-- 6. Finalmente, eliminar las obras de demo
DELETE FROM obras 
WHERE id::text LIKE '11111111-%' 
   OR id::text LIKE '22222222-%' 
   OR id::text LIKE '33333333-%';

COMMIT;

-- NOTA: Los usuarios de demo (Emails: jefe@demo.com, contadorX@demo.com) 
-- pueden ser eliminados manualmente desde la pestaña Authentication si así lo deseas.
