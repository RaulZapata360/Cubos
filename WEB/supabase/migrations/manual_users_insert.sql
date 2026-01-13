-- ============================================
-- INSERCIÓN MANUAL DE USUARIOS
-- ============================================

-- 1. Insertar Supervisor
-- Email: marcel@demo.com
-- ID: 1c9ddce0-9633-4530-b00c-914d3cf3d9a7
INSERT INTO public.usuarios (id, email, nombre_completo, rol)
VALUES (
    '1c9ddce0-9633-4530-b00c-914d3cf3d9a7', 
    'marcel@demo.com', 
    'Marcel Supervisor', 
    'supervisor'
)
ON CONFLICT (id) DO UPDATE 
SET 
    email = EXCLUDED.email, 
    rol = EXCLUDED.rol,
    nombre_completo = EXCLUDED.nombre_completo;

-- 2. Insertar Ayudante (Contador)
-- Email: ayudante@demo.com
-- ID: 4c091cd9-7ea4-4767-9e1f-7ae06f7f225a
INSERT INTO public.usuarios (id, email, nombre_completo, rol)
VALUES (
    '4c091cd9-7ea4-4767-9e1f-7ae06f7f225a', 
    'ayudante@demo.com', 
    'Ayudante Contador', 
    'contador'
)
ON CONFLICT (id) DO UPDATE 
SET 
    email = EXCLUDED.email, 
    rol = EXCLUDED.rol,
    nombre_completo = EXCLUDED.nombre_completo;
