-- ============================================
-- REFIX: ESTRUCTURA FALTANTE (Origenes y Nómina)
-- ============================================

-- 1. Crear tabla de orígenes (que faltaba en las migraciones previas)
CREATE TABLE IF NOT EXISTS origenes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  obra_id UUID REFERENCES obras(id) ON DELETE CASCADE,
  nombre TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(obra_id, nombre)
);

-- 2. Asegurar que la tabla camiones tenga la columna nomina_fecha
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='camiones' AND column_name='nomina_fecha') THEN
        ALTER TABLE camiones ADD COLUMN nomina_fecha DATE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='movimientos' AND column_name='origen') THEN
        ALTER TABLE movimientos ADD COLUMN origen TEXT;
    END IF;
END $$;

-- 3. Habilitar RLS para la nueva tabla de origenes
ALTER TABLE origenes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Permitir lectura a todos" ON origenes;
CREATE POLICY "Permitir lectura a todos" ON origenes FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "Permitir inserción a todos" ON origenes;
CREATE POLICY "Permitir inserción a todos" ON origenes FOR INSERT TO authenticated WITH CHECK (true);

-- 4. Datos de prueba para orígenes (opcional, para que no esté vacío)
INSERT INTO origenes (obra_id, nombre) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Cantera Norte'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Suministro Central'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Cantera Norte'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Punto de Extracción A'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Punto de Extracción B')
ON CONFLICT (obra_id, nombre) DO NOTHING;
