-- ============================================
-- MIGRATION: Add Routes and Fuel Tracking
-- Description: Add address fields, coordinates, fuel efficiency, and route caching
-- Date: 2026-01-11
-- ============================================

-- 1. Add address and coordinate fields to origenes
ALTER TABLE origenes 
ADD COLUMN IF NOT EXISTS direccion TEXT,
ADD COLUMN IF NOT EXISTS latitud DECIMAL(10, 8),
ADD COLUMN IF NOT EXISTS longitud DECIMAL(11, 8);

COMMENT ON COLUMN origenes.direccion IS 'Dirección completa para Google Maps API';
COMMENT ON COLUMN origenes.latitud IS 'Latitud GPS del origen';
COMMENT ON COLUMN origenes.longitud IS 'Longitud GPS del origen';

-- 2. Add address and coordinate fields to destinos
ALTER TABLE destinos 
ADD COLUMN IF NOT EXISTS direccion TEXT,
ADD COLUMN IF NOT EXISTS latitud DECIMAL(10, 8),
ADD COLUMN IF NOT EXISTS longitud DECIMAL(11, 8);

COMMENT ON COLUMN destinos.direccion IS 'Dirección completa para Google Maps API';
COMMENT ON COLUMN destinos.latitud IS 'Latitud GPS del destino';
COMMENT ON COLUMN destinos.longitud IS 'Longitud GPS del destino';

-- 3. Add fuel efficiency to camiones
ALTER TABLE camiones 
ADD COLUMN IF NOT EXISTS rendimiento_km_por_litro DECIMAL(4, 2) DEFAULT 3.5;

COMMENT ON COLUMN camiones.rendimiento_km_por_litro IS 'Rendimiento de combustible en km por litro';

-- 4. Create table for route data caching
CREATE TABLE IF NOT EXISTS datos_rutas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  obra_id UUID NOT NULL REFERENCES obras(id) ON DELETE CASCADE,
  origen_id UUID REFERENCES origenes(id) ON DELETE CASCADE,
  destino_id UUID REFERENCES destinos(id) ON DELETE CASCADE,
  distancia_km DECIMAL(6, 2) NOT NULL,
  tiempo_estimado_minutos INTEGER NOT NULL,
  tiempo_con_trafico_minutos INTEGER,
  consultado_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(origen_id, destino_id)
);

COMMENT ON TABLE datos_rutas IS 'Cache de datos de rutas obtenidos de Google Maps API';
COMMENT ON COLUMN datos_rutas.distancia_km IS 'Distancia en kilómetros entre origen y destino';
COMMENT ON COLUMN datos_rutas.tiempo_estimado_minutos IS 'Tiempo de viaje sin tráfico en minutos';
COMMENT ON COLUMN datos_rutas.tiempo_con_trafico_minutos IS 'Tiempo de viaje con tráfico actual en minutos';
COMMENT ON COLUMN datos_rutas.consultado_at IS 'Última vez que se consultó Google Maps API';

-- Create index for fast lookups
CREATE INDEX IF NOT EXISTS idx_datos_rutas_origen_destino 
ON datos_rutas(origen_id, destino_id);

CREATE INDEX IF NOT EXISTS idx_datos_rutas_obra 
ON datos_rutas(obra_id);

-- 5. Add calculated fields to movimientos
ALTER TABLE movimientos
ADD COLUMN IF NOT EXISTS distancia_km DECIMAL(6, 2),
ADD COLUMN IF NOT EXISTS combustible_estimado_litros DECIMAL(6, 2),
ADD COLUMN IF NOT EXISTS tiempo_estimado_minutos INTEGER;

COMMENT ON COLUMN movimientos.distancia_km IS 'Distancia calculada del viaje en km';
COMMENT ON COLUMN movimientos.combustible_estimado_litros IS 'Combustible estimado consumido en litros';
COMMENT ON COLUMN movimientos.tiempo_estimado_minutos IS 'Tiempo estimado del viaje en minutos';

-- ============================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================

-- Enable RLS on datos_rutas
ALTER TABLE datos_rutas ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view route data for their obra
CREATE POLICY "Users can view route data for their obra"
ON datos_rutas FOR SELECT
USING (
  obra_id IN (
    SELECT obra_id FROM usuarios_obras WHERE usuario_id = auth.uid()
  )
);

-- Policy: Users can insert route data for their obra
CREATE POLICY "Users can insert route data for their obra"
ON datos_rutas FOR INSERT
WITH CHECK (
  obra_id IN (
    SELECT obra_id FROM usuarios_obras WHERE usuario_id = auth.uid()
  )
);

-- Policy: Users can update route data for their obra
CREATE POLICY "Users can update route data for their obra"
ON datos_rutas FOR UPDATE
USING (
  obra_id IN (
    SELECT obra_id FROM usuarios_obras WHERE usuario_id = auth.uid()
  )
);

-- Policy: Users can delete route data for their obra
CREATE POLICY "Users can delete route data for their obra"
ON datos_rutas FOR DELETE
USING (
  obra_id IN (
    SELECT obra_id FROM usuarios_obras WHERE usuario_id = auth.uid()
  )
);

-- ============================================
-- MIGRATION COMPLETE
-- ============================================
