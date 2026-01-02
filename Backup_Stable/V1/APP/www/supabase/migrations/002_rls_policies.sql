-- ============================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================

-- Habilitar RLS en todas las tablas
ALTER TABLE obras ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuario_obra ENABLE ROW LEVEL SECURITY;
ALTER TABLE camiones ENABLE ROW LEVEL SECURITY;
ALTER TABLE movimientos ENABLE ROW LEVEL SECURITY;
ALTER TABLE materiales ENABLE ROW LEVEL SECURITY;
ALTER TABLE historial_diario ENABLE ROW LEVEL SECURITY;

-- ============================================
-- POLÍTICAS PARA: obras
-- ============================================

-- Jefes pueden ver todas las obras
CREATE POLICY "jefes_ver_todas_obras"
  ON obras FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  );

-- Contadores solo ven obras asignadas
CREATE POLICY "contadores_ver_obras_asignadas"
  ON obras FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM usuario_obra
      WHERE usuario_obra.obra_id = obras.id
      AND usuario_obra.usuario_id = auth.uid()
    )
  );

-- Solo jefes pueden insertar obras
CREATE POLICY "jefes_insertar_obras"
  ON obras FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  );

-- Solo jefes pueden actualizar obras
CREATE POLICY "jefes_actualizar_obras"
  ON obras FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  );

-- Solo jefes pueden eliminar obras
CREATE POLICY "jefes_eliminar_obras"
  ON obras FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  );

-- ============================================
-- POLÍTICAS PARA: usuarios
-- ============================================

-- Usuarios pueden ver su propio perfil
CREATE POLICY "usuarios_ver_propio_perfil"
  ON usuarios FOR SELECT
  USING (id = auth.uid());

-- Jefes pueden ver todos los usuarios
CREATE POLICY "jefes_ver_todos_usuarios"
  ON usuarios FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM usuarios u
      WHERE u.id = auth.uid()
      AND u.rol = 'jefe'
    )
  );

-- Solo jefes pueden crear usuarios
CREATE POLICY "jefes_crear_usuarios"
  ON usuarios FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  );

-- ============================================
-- POLÍTICAS PARA: usuario_obra
-- ============================================

-- Usuarios pueden ver sus propias asignaciones
CREATE POLICY "usuarios_ver_propias_asignaciones"
  ON usuario_obra FOR SELECT
  USING (usuario_id = auth.uid());

-- Jefes pueden ver todas las asignaciones
CREATE POLICY "jefes_ver_todas_asignaciones"
  ON usuario_obra FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  );

-- Solo jefes pueden gestionar asignaciones
CREATE POLICY "jefes_gestionar_asignaciones"
  ON usuario_obra FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  );

-- ============================================
-- POLÍTICAS PARA: camiones
-- ============================================

-- Usuarios ven camiones de sus obras asignadas
CREATE POLICY "usuarios_ver_camiones_obras_asignadas"
  ON camiones FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM usuario_obra
      WHERE usuario_obra.obra_id = camiones.obra_id
      AND usuario_obra.usuario_id = auth.uid()
    )
    OR
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  );

-- Usuarios pueden crear camiones en sus obras
CREATE POLICY "usuarios_crear_camiones_obras_asignadas"
  ON camiones FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM usuario_obra
      WHERE usuario_obra.obra_id = camiones.obra_id
      AND usuario_obra.usuario_id = auth.uid()
    )
    OR
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  );

-- Usuarios pueden actualizar camiones en sus obras
CREATE POLICY "usuarios_actualizar_camiones_obras_asignadas"
  ON camiones FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM usuario_obra
      WHERE usuario_obra.obra_id = camiones.obra_id
      AND usuario_obra.usuario_id = auth.uid()
    )
    OR
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  );

-- Usuarios pueden eliminar camiones en sus obras
CREATE POLICY "usuarios_eliminar_camiones_obras_asignadas"
  ON camiones FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM usuario_obra
      WHERE usuario_obra.obra_id = camiones.obra_id
      AND usuario_obra.usuario_id = auth.uid()
    )
    OR
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  );

-- ============================================
-- POLÍTICAS PARA: movimientos
-- ============================================

-- Usuarios ven movimientos de sus obras
CREATE POLICY "usuarios_ver_movimientos_obras_asignadas"
  ON movimientos FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM usuario_obra
      WHERE usuario_obra.obra_id = movimientos.obra_id
      AND usuario_obra.usuario_id = auth.uid()
    )
    OR
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  );

-- Usuarios pueden crear movimientos en sus obras
CREATE POLICY "usuarios_crear_movimientos_obras_asignadas"
  ON movimientos FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM usuario_obra
      WHERE usuario_obra.obra_id = movimientos.obra_id
      AND usuario_obra.usuario_id = auth.uid()
    )
    OR
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  );

-- Usuarios pueden eliminar movimientos en sus obras
CREATE POLICY "usuarios_eliminar_movimientos_obras_asignadas"
  ON movimientos FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM usuario_obra
      WHERE usuario_obra.obra_id = movimientos.obra_id
      AND usuario_obra.usuario_id = auth.uid()
    )
    OR
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  );

-- ============================================
-- POLÍTICAS PARA: materiales
-- ============================================

-- Usuarios ven materiales de sus obras
CREATE POLICY "usuarios_ver_materiales_obras_asignadas"
  ON materiales FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM usuario_obra
      WHERE usuario_obra.obra_id = materiales.obra_id
      AND usuario_obra.usuario_id = auth.uid()
    )
    OR
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  );

-- Usuarios pueden gestionar materiales en sus obras
CREATE POLICY "usuarios_gestionar_materiales_obras_asignadas"
  ON materiales FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM usuario_obra
      WHERE usuario_obra.obra_id = materiales.obra_id
      AND usuario_obra.usuario_id = auth.uid()
    )
    OR
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  );

-- ============================================
-- POLÍTICAS PARA: historial_diario
-- ============================================

-- Usuarios ven historial de sus obras
CREATE POLICY "usuarios_ver_historial_obras_asignadas"
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

-- Usuarios pueden crear/actualizar historial en sus obras
CREATE POLICY "usuarios_gestionar_historial_obras_asignadas"
  ON historial_diario FOR ALL
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
