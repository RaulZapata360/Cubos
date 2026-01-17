-- Migration: Add 'internal' type to materiales table
-- Date: 2026-01-17
-- Description: Allow materials to be classified as 'internal' for internal trips
-- This eliminates the need for frontend mapping logic

BEGIN;

-- Drop existing constraint
ALTER TABLE materiales 
DROP CONSTRAINT IF EXISTS materiales_tipo_check;

-- Add new constraint with 'internal' type
ALTER TABLE materiales 
ADD CONSTRAINT materiales_tipo_check 
CHECK (tipo IN ('incoming', 'outgoing', 'internal'));

COMMIT;
