-- ============================================
-- CONTEO DE CAMIONES - SCHEMA MULTI-OBRA
-- ============================================

-- Habilitar extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- TABLA: obras
-- Almacena información de cada obra/proyecto
-- ============================================
CREATE TABLE obras (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nombre TEXT NOT NULL,
  ubicacion TEXT,
  descripcion TEXT,
  fecha_inicio DATE,
  estado TEXT DEFAULT 'activa' CHECK (estado IN ('activa', 'pausada', 'finalizada')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- TABLA: usuarios
-- Extiende auth.users de Supabase
-- ============================================
CREATE TABLE usuarios (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  nombre_completo TEXT NOT NULL,
  rol TEXT NOT NULL CHECK (rol IN ('jefe', 'contador')),
  email TEXT NOT NULL,
  telefono TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- TABLA: usuario_obra
-- Relación muchos a muchos entre usuarios y obras
-- ============================================
CREATE TABLE usuario_obra (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  obra_id UUID REFERENCES obras(id) ON DELETE CASCADE,
  asignado_en TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(usuario_id, obra_id)
);

-- ============================================
-- TABLA: camiones
-- Camiones registrados por obra
-- ============================================
CREATE TABLE camiones (
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

-- ============================================
-- TABLA: movimientos
-- Registro de vueltas de camiones
-- ============================================
CREATE TABLE movimientos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  obra_id UUID REFERENCES obras(id) ON DELETE CASCADE,
  camion_id UUID REFERENCES camiones(id) ON DELETE SET NULL,
  usuario_id UUID REFERENCES usuarios(id) ON DELETE SET NULL,
  tipo TEXT NOT NULL CHECK (tipo IN ('incoming', 'outgoing')),
  capacidad DECIMAL(10,2) NOT NULL,
  material TEXT,
  ubicacion TEXT,
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  fecha DATE DEFAULT CURRENT_DATE,
  -- Datos desnormalizados para mantener historial
  camion_nombre TEXT,
  camion_patente TEXT
);

-- ============================================
-- TABLA: materiales
-- Materiales disponibles por obra y tipo
-- ============================================
CREATE TABLE materiales (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  obra_id UUID REFERENCES obras(id) ON DELETE CASCADE,
  nombre TEXT NOT NULL,
  tipo TEXT NOT NULL CHECK (tipo IN ('incoming', 'outgoing')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(obra_id, nombre, tipo)
);

-- ============================================
-- TABLA: historial_diario
-- Archivo de resumen diario por obra
-- ============================================
CREATE TABLE historial_diario (
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

-- ============================================
-- ÍNDICES PARA MEJORAR RENDIMIENTO
-- ============================================
CREATE INDEX idx_camiones_obra ON camiones(obra_id);
CREATE INDEX idx_camiones_patente ON camiones(patente);
CREATE INDEX idx_movimientos_obra ON movimientos(obra_id);
CREATE INDEX idx_movimientos_fecha ON movimientos(fecha);
CREATE INDEX idx_movimientos_camion ON movimientos(camion_id);
CREATE INDEX idx_materiales_obra ON materiales(obra_id);
CREATE INDEX idx_usuario_obra_usuario ON usuario_obra(usuario_id);
CREATE INDEX idx_usuario_obra_obra ON usuario_obra(obra_id);
CREATE INDEX idx_historial_obra_fecha ON historial_diario(obra_id, fecha);

-- ============================================
-- FUNCIÓN: Actualizar timestamp automáticamente
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger para obras
CREATE TRIGGER update_obras_updated_at BEFORE UPDATE ON obras
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Trigger para camiones
CREATE TRIGGER update_camiones_updated_at BEFORE UPDATE ON camiones
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
