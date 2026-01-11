-- ============================================
-- MIGRATION: Add location fields to obras table
-- Description: Add direccion, latitud, longitud to obras
-- Date: 2026-01-11
-- ============================================

-- Add address and coordinate fields to obras
ALTER TABLE obras 
ADD COLUMN IF NOT EXISTS direccion TEXT,
ADD COLUMN IF NOT EXISTS latitud DECIMAL(10, 8),
ADD COLUMN IF NOT EXISTS longitud DECIMAL(11, 8);

COMMENT ON COLUMN obras.direccion IS 'Dirección completa de la obra para Google Maps API';
COMMENT ON COLUMN obras.latitud IS 'Latitud GPS de la obra';
COMMENT ON COLUMN obras.longitud IS 'Longitud GPS de la obra';
