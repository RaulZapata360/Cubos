-- ============================================
-- RECUPERAR TABLA HISTORIAL_DIARIO
-- ============================================
-- Recrea la tabla historial_diario que fue eliminada por error

-- Crear tabla historial_diario
CREATE TABLE IF NOT EXISTS historial_diario (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  obra_id UUID REFERENCES obras(id) ON DELETE CASCADE,
  fecha DATE NOT NULL,
  total_camiones INTEGER,
  total_vueltas INTEGER,
  vueltas_entrantes INTEGER,
  vueltas_salientes INTEGER,
  volumen_relleno DECIMAL(10,2),
  volumen_excavacion DECIMAL(10,2),
  datos_completos JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(obra_id, fecha)
);

-- Crear índice
CREATE INDEX IF NOT EXISTS idx_historial_obra_fecha ON historial_diario(obra_id, fecha);

-- Verificar que se creó
SELECT 
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'historial_diario'
ORDER BY ordinal_position;
