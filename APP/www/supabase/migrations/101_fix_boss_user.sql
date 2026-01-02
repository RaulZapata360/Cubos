-- ============================================
-- VERIFICAR Y CORREGIR ROL DE USUARIO JEFE
-- ============================================
-- Este script verifica que el usuario jefe esté correctamente
-- registrado en la tabla usuarios con rol='jefe'

-- 1. Verificar usuarios actuales
SELECT 
    u.id,
    u.nombre_completo,
    u.rol,
    u.email,
    au.email as auth_email
FROM usuarios u
LEFT JOIN auth.users au ON u.id = au.id
ORDER BY u.rol, u.nombre_completo;

-- 2. Verificar si existe algún usuario con rol 'jefe'
SELECT COUNT(*) as total_jefes
FROM usuarios
WHERE rol = 'jefe';

-- 3. Si no existe ningún jefe, crear uno con el usuario actual
-- IMPORTANTE: Ejecuta esto SOLO si estás logueado como el usuario que debe ser jefe
INSERT INTO usuarios (id, nombre_completo, rol, email)
SELECT 
    auth.uid(),
    'Usuario Boss',
    'jefe',
    (SELECT email FROM auth.users WHERE id = auth.uid())
WHERE NOT EXISTS (
    SELECT 1 FROM usuarios WHERE id = auth.uid()
)
ON CONFLICT (id) DO UPDATE
SET rol = 'jefe';

-- 4. Verificar que se creó correctamente
SELECT 
    id,
    nombre_completo,
    rol,
    email
FROM usuarios
WHERE id = auth.uid();

-- 5. Verificar que ahora puedes ver todas las obras
SELECT 
    o.id,
    o.nombre,
    o.ubicacion,
    COUNT(DISTINCT c.id) as total_camiones,
    COUNT(DISTINCT m.id) as total_movimientos
FROM obras o
LEFT JOIN camiones c ON c.obra_id = o.id
LEFT JOIN movimientos m ON m.obra_id = o.id
GROUP BY o.id, o.nombre, o.ubicacion
ORDER BY o.nombre;
