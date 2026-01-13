-- ============================================
-- ACTUALIZACIÓN DE USUARIOS EXISTENTES
-- ============================================

-- Como los usuarios ya existen en la base de datos (creados por el trigger),
-- usamos UPDATE para corregir sus roles y nombres.

-- 1. Actualizar Marcel a Supervisor
UPDATE public.usuarios
SET 
    nombre_completo = 'Marcel',
    rol = 'supervisor'
WHERE id = '1c9ddce0-9633-4530-b00c-914d3cf3d9a7';

-- 2. Actualizar Ayudante (mantiene rol contador)
UPDATE public.usuarios
SET 
    nombre_completo = 'Ayudante',
    rol = 'contador'
WHERE id = '4c091cd9-7ea4-4767-9e1f-7ae06f7f225a';

-- Verificación final
SELECT * FROM public.usuarios 
WHERE id IN ('1c9ddce0-9633-4530-b00c-914d3cf3d9a7', '4c091cd9-7ea4-4767-9e1f-7ae06f7f225a');
