-- ============================================
-- AGREGAR POLÍTICA RLS PARA HISTORIAL_DIARIO
-- ============================================

-- Permitir INSERT en historial_diario
CREATE POLICY "usuarios_crear_historial_obras_asignadas"
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

-- Verificar políticas
SELECT schemaname, tablename, policyname, permissive, cmd
FROM pg_policies
WHERE tablename = 'historial_diario';
