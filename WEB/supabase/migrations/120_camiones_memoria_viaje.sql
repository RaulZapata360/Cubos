-- Migration: Add last trip memory to camiones table
-- This allows the system to remember the last material and destination/origin for each truck

ALTER TABLE camiones ADD COLUMN IF NOT EXISTS ultimo_material TEXT;
ALTER TABLE camiones ADD COLUMN IF NOT EXISTS ultimo_destino TEXT;
ALTER TABLE camiones ADD COLUMN IF NOT EXISTS ultimo_origen TEXT;
ALTER TABLE camiones ADD COLUMN IF NOT EXISTS ultima_ubicacion TEXT;

-- Update existing comments
COMMENT ON COLUMN camiones.ultimo_material IS 'Último material transportado por el camión';
COMMENT ON COLUMN camiones.ultimo_destino IS 'Último destino (para movimientos salientes)';
COMMENT ON COLUMN camiones.ultimo_origen IS 'Último origen (para movimientos entrantes)';
