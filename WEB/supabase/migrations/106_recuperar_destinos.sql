-- ============================================
-- RECUPERAR TABLA DESTINOS
-- ============================================
-- Recrea la tabla destinos que fue eliminada por error

-- Crear tabla destinos
CREATE TABLE IF NOT EXISTS destinos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  obra_id UUID REFERENCES obras(id) ON DELETE CASCADE,
  nombre TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(obra_id, nombre)
);

-- Crear índice
CREATE INDEX IF NOT EXISTS idx_destinos_obra ON destinos(obra_id);

-- Habilitar RLS
ALTER TABLE destinos ENABLE ROW LEVEL SECURITY;

-- Política: Usuarios ven destinos de sus obras asignadas
CREATE POLICY "usuarios_ver_destinos_obras_asignadas"
  ON destinos FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM usuario_obra
      WHERE usuario_obra.obra_id = destinos.obra_id
      AND usuario_obra.usuario_id = auth.uid()
    )
    OR
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  );

-- Política: Usuarios pueden crear destinos en sus obras
CREATE POLICY "usuarios_crear_destinos_obras_asignadas"
  ON destinos FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM usuario_obra
      WHERE usuario_obra.obra_id = destinos.obra_id
      AND usuario_obra.usuario_id = auth.uid()
    )
    OR
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  );

-- Política: Usuarios pueden actualizar destinos en sus obras
CREATE POLICY "usuarios_actualizar_destinos_obras_asignadas"
  ON destinos FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM usuario_obra
      WHERE usuario_obra.obra_id = destinos.obra_id
      AND usuario_obra.usuario_id = auth.uid()
    )
    OR
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  );

-- Política: Usuarios pueden eliminar destinos en sus obras
CREATE POLICY "usuarios_eliminar_destinos_obras_asignadas"
  ON destinos FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM usuario_obra
      WHERE usuario_obra.obra_id = destinos.obra_id
      AND usuario_obra.usuario_id = auth.uid()
    )
    OR
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE usuarios.id = auth.uid()
      AND usuarios.rol = 'jefe'
    )
  );

-- Verificar que se creó
SELECT 
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'destinos'
ORDER BY ordinal_position;
