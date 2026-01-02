-- ============================================
-- AGREGAR POLÍTICAS FALTANTES PARA USUARIOS
-- ============================================

-- Primero, habilitar RLS en la tabla usuarios
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;

-- Política: Todos pueden ver su propio perfil
CREATE POLICY "usuarios_ver_propio_perfil"
ON usuarios
FOR SELECT
TO public
USING (auth.uid() = id);

-- Política: Jefes pueden ver todos los usuarios
CREATE POLICY "jefes_ver_todos_usuarios"
ON usuarios
FOR SELECT
TO public
USING (
  EXISTS (
    SELECT 1 FROM usuarios
    WHERE id = auth.uid() AND rol = 'jefe'
  )
);

-- Política: Usuarios pueden actualizar su propio perfil
CREATE POLICY "usuarios_actualizar_propio_perfil"
ON usuarios
FOR UPDATE
TO public
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- Política: Solo jefes pueden crear usuarios
CREATE POLICY "jefes_crear_usuarios"
ON usuarios
FOR INSERT
TO public
WITH CHECK (
  EXISTS (
    SELECT 1 FROM usuarios
    WHERE id = auth.uid() AND rol = 'jefe'
  )
);

-- Política: Solo jefes pueden eliminar usuarios
CREATE POLICY "jefes_eliminar_usuarios"
ON usuarios
FOR DELETE
TO public
USING (
  EXISTS (
    SELECT 1 FROM usuarios
    WHERE id = auth.uid() AND rol = 'jefe'
  )
);

-- Verificar que se crearon las políticas
SELECT 
  tablename,
  policyname,
  cmd
FROM pg_policies
WHERE schemaname = 'public' AND tablename = 'usuarios'
ORDER BY policyname;
