-- ============================================
-- SETUP COMPLETO PARA NUEVO PROYECTO SUPABASE
-- ============================================

-- 1. HABILITAR EXTENSIONES
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. CREAR TABLAS
CREATE TABLE IF NOT EXISTS obras (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nombre TEXT NOT NULL,
  ubicacion TEXT,
  descripcion TEXT,
  fecha_inicio DATE,
  estado TEXT DEFAULT 'activa' CHECK (estado IN ('activa', 'pausada', 'finalizada')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS usuarios (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  nombre_completo TEXT NOT NULL,
  rol TEXT NOT NULL CHECK (rol IN ('jefe', 'contador')),
  email TEXT NOT NULL,
  telefono TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS usuario_obra (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  obra_id UUID REFERENCES obras(id) ON DELETE CASCADE,
  asignado_en TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(usuario_id, obra_id)
);

CREATE TABLE IF NOT EXISTS camiones (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  obra_id UUID REFERENCES obras(id) ON DELETE CASCADE,
  nombre TEXT NOT NULL,
  patente TEXT NOT NULL,
  capacidad DECIMAL(10,2) NOT NULL,
  tipo_registrado TEXT NOT NULL CHECK (tipo_registrado IN ('incoming', 'outgoing', 'mixed')),
  contador_entrante INTEGER DEFAULT 0,
  contador_saliente INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS destinos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  obra_id UUID REFERENCES obras(id) ON DELETE CASCADE,
  nombre TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(obra_id, nombre)
);

CREATE TABLE IF NOT EXISTS movimientos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  obra_id UUID REFERENCES obras(id) ON DELETE CASCADE,
  camion_id UUID REFERENCES camiones(id) ON DELETE SET NULL,
  usuario_id UUID REFERENCES usuarios(id) ON DELETE SET NULL,
  tipo TEXT NOT NULL CHECK (tipo IN ('incoming', 'outgoing')),
  capacidad DECIMAL(10,2) NOT NULL,
  material TEXT,
  ubicacion TEXT,
  destino TEXT,
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  fecha DATE DEFAULT CURRENT_DATE,
  camion_nombre TEXT,
  camion_patente TEXT
);

CREATE TABLE IF NOT EXISTS materiales (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  obra_id UUID REFERENCES obras(id) ON DELETE CASCADE,
  nombre TEXT NOT NULL,
  tipo TEXT NOT NULL CHECK (tipo IN ('incoming', 'outgoing')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(obra_id, nombre, tipo)
);

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

-- 3. HABILITAR RLS
ALTER TABLE obras ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuario_obra ENABLE ROW LEVEL SECURITY;
ALTER TABLE camiones ENABLE ROW LEVEL SECURITY;
ALTER TABLE movimientos ENABLE ROW LEVEL SECURITY;
ALTER TABLE materiales ENABLE ROW LEVEL SECURITY;
ALTER TABLE historial_diario ENABLE ROW LEVEL SECURITY;
ALTER TABLE destinos ENABLE ROW LEVEL SECURITY;

-- 4. POLÍTICAS BÁSICAS (Simplificadas para asegurar funcionamiento)
CREATE POLICY "Permitir lectura a autenticados" ON obras FOR SELECT TO authenticated USING (true);
CREATE POLICY "Permitir lectura a autenticados" ON usuarios FOR SELECT TO authenticated USING (true);
CREATE POLICY "Permitir lectura a autenticados" ON usuario_obra FOR SELECT TO authenticated USING (true);
CREATE POLICY "Permitir lectura a autenticados" ON camiones FOR SELECT TO authenticated USING (true);
CREATE POLICY "Permitir lectura a autenticados" ON movimientos FOR SELECT TO authenticated USING (true);
CREATE POLICY "Permitir lectura a autenticados" ON materiales FOR SELECT TO authenticated USING (true);
CREATE POLICY "Permitir lectura a autenticados" ON historial_diario FOR SELECT TO authenticated USING (true);
CREATE POLICY "Permitir lectura a autenticados" ON destinos FOR SELECT TO authenticated USING (true);

-- Políticas de Inserción/Update para Contadores y Jefes
CREATE POLICY "Permitir todo a autenticados" ON movimientos FOR ALL TO authenticated USING (true);
CREATE POLICY "Permitir todo a autenticados" ON camiones FOR ALL TO authenticated USING (true);
CREATE POLICY "Permitir todo a autenticados" ON materiales FOR ALL TO authenticated USING (true);
CREATE POLICY "Permitir todo a autenticados" ON destinos FOR ALL TO authenticated USING (true);
CREATE POLICY "Permitir todo a autenticados" ON historial_diario FOR ALL TO authenticated USING (true);

-- 5. DATOS INICIALES (IDs FIJOS)

-- Obras
INSERT INTO obras (id, nombre, ubicacion, fecha_inicio) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Aeroparque', 'Torreones', '2025-12-01'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'VAIN', 'Chiguayante', '2025-12-01'),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Azul', 'Collao', '2025-12-01')
ON CONFLICT (id) DO NOTHING;

-- Destinos
INSERT INTO destinos (obra_id, nombre) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Botadero Rotonda'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Jaime Repullo'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Botadero Rotonda'),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Jaime Repullo')
ON CONFLICT (obra_id, nombre) DO NOTHING;

-- Materiales
INSERT INTO materiales (obra_id, nombre, tipo) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Arena', 'incoming'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Arcilla', 'outgoing'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Ripio', 'incoming'),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Base', 'incoming')
ON CONFLICT DO NOTHING;

-- 6. ASIGNAR JEFE (Debes ejecutar esto DESPUÉS de registrarte en la app)
-- INSERT INTO usuarios (id, nombre_completo, rol, email)
-- VALUES ('TU_UUID_AQUI', 'Nombre Jefe', 'jefe', 'email@jefe.com');
