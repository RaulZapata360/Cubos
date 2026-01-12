-- ============================================
-- MIGRATION: Update datos_rutas to support obra locations
-- Description: Allow caching routes that include obra as origin or destination
-- Date: 2026-01-12
-- ============================================

-- 1. Drop existing foreign key constraints
ALTER TABLE datos_rutas 
DROP CONSTRAINT IF EXISTS datos_rutas_origen_id_fkey,
DROP CONSTRAINT IF EXISTS datos_rutas_destino_id_fkey;

-- 2. Make origen_id and destino_id nullable
ALTER TABLE datos_rutas 
ALTER COLUMN origen_id DROP NOT NULL,
ALTER COLUMN destino_id DROP NOT NULL;

-- 3. Add new columns to identify location types
ALTER TABLE datos_rutas
ADD COLUMN IF NOT EXISTS origen_tipo VARCHAR(10) CHECK (origen_tipo IN ('origen', 'obra')),
ADD COLUMN IF NOT EXISTS destino_tipo VARCHAR(10) CHECK (destino_tipo IN ('destino', 'obra'));

-- 4. Add flexible foreign keys (will be validated in application logic)
-- We can't use traditional FKs since IDs can point to different tables
-- Instead, we'll add comments to document the structure

COMMENT ON COLUMN datos_rutas.origen_id IS 'UUID of origen (from origenes table) or obra (from obras table). Check origen_tipo to determine which table.';
COMMENT ON COLUMN datos_rutas.destino_id IS 'UUID of destino (from destinos table) or obra (from obras table). Check destino_tipo to determine which table.';
COMMENT ON COLUMN datos_rutas.origen_tipo IS 'Type of origin: "origen" (from origenes table) or "obra" (from obras table)';
COMMENT ON COLUMN datos_rutas.destino_tipo IS 'Type of destination: "destino" (from destinos table) or "obra" (from obras table)';

-- 5. Update unique constraint to include type columns
ALTER TABLE datos_rutas 
DROP CONSTRAINT IF EXISTS datos_rutas_origen_id_destino_id_key;

ALTER TABLE datos_rutas
ADD CONSTRAINT datos_rutas_unique_route 
UNIQUE (origen_id, destino_id, origen_tipo, destino_tipo);

-- 6. Update indexes
DROP INDEX IF EXISTS idx_datos_rutas_origen_destino;

CREATE INDEX IF NOT EXISTS idx_datos_rutas_route_lookup 
ON datos_rutas(origen_id, destino_id, origen_tipo, destino_tipo);

-- 7. Add validation check to ensure at least one ID is present
ALTER TABLE datos_rutas
ADD CONSTRAINT datos_rutas_check_ids
CHECK (origen_id IS NOT NULL OR destino_id IS NOT NULL);

-- Confirmation
SELECT 'Migration completed: datos_rutas now supports obra locations' as status;
