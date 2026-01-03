-- ============================================
-- FIX RLS FOR HISTORIAL_DIARIO (UPSERT SUPPORT)
-- ============================================

-- First, drop existing policies to ensure clean state and avoid conflicts
DROP POLICY IF EXISTS "usuarios_crear_historial_obras_asignadas" ON historial_diario;
DROP POLICY IF EXISTS "usuarios_ver_historial_obras_asignadas" ON historial_diario;
DROP POLICY IF EXISTS "ver_historial_diario_policy" ON historial_diario;
DROP POLICY IF EXISTS "insertar_historial_diario_policy" ON historial_diario;
DROP POLICY IF EXISTS "actualizar_historial_diario_policy" ON historial_diario;

-- Ensure RLS is enabled
ALTER TABLE historial_diario ENABLE ROW LEVEL SECURITY;

-- 1. SELECT: Allow viewing history for assigned works (or if Role is Jefe)
CREATE POLICY "ver_historial_diario_policy"
  ON historial_diario FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM usuario_obra
      WHERE usuario_obra.obra_id = historial_diario.obra_id
      AND usuario_obra.usuario_id = auth.uid()
    )
    OR
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  );

-- 2. INSERT: Allow inserting new history records
CREATE POLICY "insertar_historial_diario_policy"
  ON historial_diario FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM usuario_obra
      WHERE usuario_obra.obra_id = historial_diario.obra_id
      AND usuario_obra.usuario_id = auth.uid()
    )
    OR
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  );

-- 3. UPDATE: Allow updating history records (REQUIRED FOR UPSERT)
CREATE POLICY "actualizar_historial_diario_policy"
  ON historial_diario FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM usuario_obra
      WHERE usuario_obra.obra_id = historial_diario.obra_id
      AND usuario_obra.usuario_id = auth.uid()
    )
    OR
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM usuario_obra
      WHERE usuario_obra.obra_id = historial_diario.obra_id
      AND usuario_obra.usuario_id = auth.uid()
    )
    OR
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  );

-- Verification
SELECT schemaname, tablename, policyname, cmd 
FROM pg_policies 
WHERE tablename = 'historial_diario';
