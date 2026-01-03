-- ============================================
-- SOLUCIÓN COMPLETA: Usuario jefe@demo.com
-- ============================================

-- PASO 1: Sincronizar usuario en tabla usuarios
DELETE FROM usuarios WHERE email = 'jefe@demo.com';

INSERT INTO usuarios (id, email, nombre_completo, rol, activo)
VALUES (
  '5e53572f-3217-4f02-a766-577e77ec0eeb',
  'jefe@demo.com',
  'Jack Price',
  'jefe',
  true
);

-- PASO 2: Verificar y limpiar asignaciones antiguas
DELETE FROM usuario_obra 
WHERE usuario_id NOT IN (SELECT id FROM usuarios);

-- PASO 3: Asignar todas las obras al jefe (si no están asignadas)
INSERT INTO usuario_obra (usuario_id, obra_id)
SELECT '5e53572f-3217-4f02-a766-577e77ec0eeb', id
FROM obras
WHERE id NOT IN (
  SELECT obra_id FROM usuario_obra 
  WHERE usuario_id = '5e53572f-3217-4f02-a766-577e77ec0eeb'
)
ON CONFLICT DO NOTHING;

-- VERIFICACIÓN
SELECT 
  u.id,
  u.email,
  u.nombre_completo,
  u.rol,
  COUNT(uo.obra_id) as obras_asignadas
FROM usuarios u
LEFT JOIN usuario_obra uo ON u.id = uo.usuario_id
WHERE u.email = 'jefe@demo.com'
GROUP BY u.id, u.email, u.nombre_completo, u.rol;
