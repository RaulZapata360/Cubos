-- ============================================
-- MIGRACIÓN 007 (CORREGIDA): PERMISOS PARA NUEVOS ROLES (ESPECTADOR)
-- SIN RECURSIÓN INFINITA
-- ============================================

-- A. Función auxiliar para verificar roles sin causar recursión (SECURITY DEFINER bypasses RLS)
CREATE OR REPLACE FUNCTION public.check_user_is_staff()
RETURNS boolean SECURITY DEFINER AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.usuarios
    WHERE id = auth.uid()
    AND rol IN ('jefe', 'supervisor', 'secretaria')
  );
END;
$$ LANGUAGE plpgsql;

-- 1. Actualizar políticas de OBRAS
DROP POLICY IF EXISTS "jefes_ver_todas_obras" ON public.obras;
DROP POLICY IF EXISTS "jefes_y_espectadores_ver_todas_obras" ON public.obras;
CREATE POLICY "jefes_y_espectadores_ver_todas_obras"
  ON public.obras FOR SELECT
  USING ( public.check_user_is_staff() );

-- 2. Actualizar políticas de CAMIONES
DROP POLICY IF EXISTS "usuarios_ver_camiones_obras_asignadas" ON public.camiones;
DROP POLICY IF EXISTS "usuarios_ver_camiones_acceso_total" ON public.camiones;
CREATE POLICY "usuarios_ver_camiones_acceso_total"
  ON public.camiones FOR SELECT
  USING (
    public.check_user_is_staff()
    OR 
    EXISTS (
      SELECT 1 FROM public.usuario_obra
      WHERE usuario_obra.obra_id = camiones.obra_id
      AND usuario_obra.usuario_id = auth.uid()
    )
  );

-- 3. Actualizar políticas de MOVIMIENTOS
DROP POLICY IF EXISTS "usuarios_ver_movimientos_obras_asignadas" ON public.movimientos;
DROP POLICY IF EXISTS "usuarios_ver_movimientos_acceso_total" ON public.movimientos;
CREATE POLICY "usuarios_ver_movimientos_acceso_total"
  ON public.movimientos FOR SELECT
  USING (
    public.check_user_is_staff()
    OR 
    EXISTS (
      SELECT 1 FROM public.usuario_obra
      WHERE usuario_obra.obra_id = movimientos.obra_id
      AND usuario_obra.usuario_id = auth.uid()
    )
  );

-- 4. Actualizar políticas de MATERIALES
DROP POLICY IF EXISTS "usuarios_ver_materiales_obras_asignadas" ON public.materiales;
DROP POLICY IF EXISTS "usuarios_ver_materiales_acceso_total" ON public.materiales;
CREATE POLICY "usuarios_ver_materiales_acceso_total"
  ON public.materiales FOR SELECT
  USING (
    public.check_user_is_staff()
    OR 
    EXISTS (
      SELECT 1 FROM public.usuario_obra
      WHERE usuario_obra.obra_id = materiales.obra_id
      AND usuario_obra.usuario_id = auth.uid()
    )
  );

-- 5. Actualizar políticas de HISTORIAL_DIARIO
DROP POLICY IF EXISTS "usuarios_ver_historial_obras_asignadas" ON public.historial_diario;
DROP POLICY IF EXISTS "usuarios_ver_historial_acceso_total" ON public.historial_diario;
CREATE POLICY "usuarios_ver_historial_acceso_total"
  ON public.historial_diario FOR SELECT
  USING (
    public.check_user_is_staff()
    OR 
    EXISTS (
      SELECT 1 FROM public.usuario_obra
      WHERE usuario_obra.obra_id = historial_diario.obra_id
      AND usuario_obra.usuario_id = auth.uid()
    )
  );

-- 6. Arreglar recursión en USUARIOS SELECT
DROP POLICY IF EXISTS "jefes_ver_todos_usuarios" ON public.usuarios;
DROP POLICY IF EXISTS "staff_ver_todos_usuarios" ON public.usuarios;
CREATE POLICY "staff_ver_todos_usuarios"
  ON public.usuarios FOR SELECT
  USING (
    auth.uid() = id -- Siempre puede ver su propio perfil
    OR
    public.check_user_is_staff() -- Jefes/Supervisores/Secretarias pueden ver a todos
  );
