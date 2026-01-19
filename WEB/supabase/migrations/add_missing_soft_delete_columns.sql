-- Add missing deleted_at columns for soft delete functionality
-- Addressing error: "column origenes.deleted_at does not exist"

-- 1. Add deleted_at to Origenes
ALTER TABLE origenes 
ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ DEFAULT NULL;

-- 2. Add deleted_at to Destinos
ALTER TABLE destinos 
ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ DEFAULT NULL;

-- 3. Add deleted_at to Obras (prevent future errors)
ALTER TABLE obras 
ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ DEFAULT NULL;

-- 4. Add deleted_at to Camiones (prevent future errors)
ALTER TABLE camiones 
ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ DEFAULT NULL;

-- 5. Add deleted_at to Usuarios (prevent future errors)
ALTER TABLE usuarios 
ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ DEFAULT NULL;

-- 6. Reload schema cache
NOTIFY pgrst, 'reload schema';
