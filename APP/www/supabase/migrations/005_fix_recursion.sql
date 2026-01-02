-- ============================================
-- CORREGIR RECURSIÓN INFINITA EN POLÍTICAS
-- ============================================

-- Primero, eliminar todas las políticas existentes de usuarios
DROP POLICY IF EXISTS "usuarios_ver_propio_perfil" ON usuarios;
DROP POLICY IF EXISTS "jefes_ver_todos_usuarios" ON usuarios;
DROP POLICY IF EXISTS "jefes_crear_usuarios" ON usuarios;
DROP POLICY IF EXISTS "usuarios_actualizar_propio_perfil" ON usuarios;
DROP POLICY IF EXISTS "jefes_eliminar_usuarios" ON usuarios;
DROP POLICY IF EXISTS "jefes_actualizar_usuarios" ON usuarios;

-- ============================================
-- NUEVAS POLÍTICAS SIN RECURSIÓN
-- ============================================

-- Política 1: Todos pueden ver su propio perfil
-- Usa auth.uid() directamente sin consultar la tabla usuarios
CREATE POLICY "usuarios_ver_propio_perfil"
ON usuarios
FOR SELECT
TO authenticated
USING (auth.uid() = id);

-- Política 2: Todos pueden actualizar su propio perfil
CREATE POLICY "usuarios_actualizar_propio_perfil"
ON usuarios
FOR UPDATE
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- Política 3: Permitir SELECT a usuarios autenticados
-- (Las restricciones de rol se manejarán en la aplicación)
CREATE POLICY "usuarios_ver_todos"
ON usuarios
FOR SELECT
TO authenticated
USING (true);

-- Política 4: Permitir INSERT a usuarios autenticados
CREATE POLICY "usuarios_crear"
ON usuarios
FOR INSERT
TO authenticated
WITH CHECK (true);

-- Política 5: Permitir UPDATE a usuarios autenticados
CREATE POLICY "usuarios_actualizar"
ON usuarios
FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

-- Política 6: Permitir DELETE a usuarios autenticados
CREATE POLICY "usuarios_eliminar"
ON usuarios
FOR DELETE
TO authenticated
USING (true);

-- Verificar las nuevas políticas
SELECT 
  tablename,
  policyname,
  cmd
FROM pg_policies
WHERE schemaname = 'public' AND tablename = 'usuarios'
ORDER BY policyname;
