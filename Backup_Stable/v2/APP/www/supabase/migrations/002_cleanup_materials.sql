-- ==========================================
-- 002_LIMPIEZA_MATERIALES.sql
-- ==========================================

-- 1. Limpiar materiales de demo (con IDs falsos)
DELETE FROM materiales 
WHERE obra_id::text LIKE '11111111-%' 
   OR obra_id::text LIKE '22222222-%' 
   OR obra_id::text LIKE '33333333-%';

-- 2. Asegurarse de que existan materiales básicos si no hay ninguno
-- Nota: Esto asume que tienes al menos una obra real creada.
-- Si quieres agregar materiales a una obra específica, reemplaza el UUID.

/*
INSERT INTO materiales (obra_id, nombre, tipo)
SELECT id, 'Arena', 'incoming' FROM obras WHERE estado = 'activa'
ON CONFLICT DO NOTHING;

INSERT INTO materiales (obra_id, nombre, tipo)
SELECT id, 'Grava', 'incoming' FROM obras WHERE estado = 'activa'
ON CONFLICT DO NOTHING;

INSERT INTO materiales (obra_id, nombre, tipo)
SELECT id, 'Tierra Vegetal', 'outgoing' FROM obras WHERE estado = 'activa'
ON CONFLICT DO NOTHING;

INSERT INTO materiales (obra_id, nombre, tipo)
SELECT id, 'Escombros', 'outgoing' FROM obras WHERE estado = 'activa'
ON CONFLICT DO NOTHING;
*/

-- El usuario prefiere gestionar sus propios materiales, 
-- pero este script limpia la "basura" de la demo.
