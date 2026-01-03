-- ============================================
-- AGREGAR USUARIO ACTUAL COMO JEFE
-- ============================================
-- Este script agrega el usuario actual a la tabla usuarios con rol='jefe'

-- Ver quién soy
SELECT 
    auth.uid() as mi_id,
    (SELECT email FROM auth.users WHERE id = auth.uid()) as mi_email;

-- Insertar/actualizar usuario actual como jefe
INSERT INTO usuarios (id, nombre_completo, rol, email)
SELECT 
    auth.uid(),
    COALESCE((SELECT raw_user_meta_data->>'full_name' FROM auth.users WHERE id = auth.uid()), 'Usuario Jefe'),
    'jefe',
    (SELECT email FROM auth.users WHERE id = auth.uid())
WHERE auth.uid() IS NOT NULL
ON CONFLICT (id) DO UPDATE
SET 
    rol = 'jefe',
    nombre_completo = COALESCE(EXCLUDED.nombre_completo, usuarios.nombre_completo);

-- Verificar
SELECT 
    id,
    nombre_completo,
    rol,
    email
FROM usuarios
WHERE id = auth.uid();
