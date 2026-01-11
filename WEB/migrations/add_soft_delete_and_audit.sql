-- Migration: Add soft delete and audit functionality to movimientos table
-- Date: 2026-01-11
-- Description: Adds soft delete columns and audit trail for movement deletions

-- 1. Add soft delete columns to movimientos table
ALTER TABLE movimientos 
ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS deleted_by UUID REFERENCES usuarios(id);

-- 2. Create audit table for movement changes
CREATE TABLE IF NOT EXISTS movimientos_audit (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    movimiento_id UUID NOT NULL,
    action VARCHAR(50) NOT NULL, -- 'created', 'updated', 'deleted'
    changed_by UUID REFERENCES usuarios(id),
    changed_at TIMESTAMPTZ DEFAULT NOW(),
    old_data JSONB,
    new_data JSONB,
    reason TEXT
);

-- 3. Create index for better query performance
CREATE INDEX IF NOT EXISTS idx_movimientos_deleted_at ON movimientos(deleted_at);
CREATE INDEX IF NOT EXISTS idx_movimientos_audit_movimiento_id ON movimientos_audit(movimiento_id);
CREATE INDEX IF NOT EXISTS idx_movimientos_audit_changed_at ON movimientos_audit(changed_at);

-- 4. Create function to log deletions
CREATE OR REPLACE FUNCTION log_movimiento_deletion()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
        INSERT INTO movimientos_audit (
            movimiento_id,
            action,
            changed_by,
            old_data,
            new_data,
            reason
        ) VALUES (
            NEW.id,
            'deleted',
            NEW.deleted_by,
            row_to_json(OLD),
            row_to_json(NEW),
            'Movement soft deleted'
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 5. Create trigger for automatic audit logging
DROP TRIGGER IF EXISTS trigger_log_movimiento_deletion ON movimientos;
CREATE TRIGGER trigger_log_movimiento_deletion
    AFTER UPDATE ON movimientos
    FOR EACH ROW
    EXECUTE FUNCTION log_movimiento_deletion();

-- 6. Create function to log updates
CREATE OR REPLACE FUNCTION log_movimiento_update()
RETURNS TRIGGER AS $$
BEGIN
    -- Only log if it's not a deletion (deletion is handled by another trigger)
    IF NEW.deleted_at IS NULL AND OLD != NEW THEN
        INSERT INTO movimientos_audit (
            movimiento_id,
            action,
            changed_by,
            old_data,
            new_data,
            reason
        ) VALUES (
            NEW.id,
            'updated',
            auth.uid(), -- Current user
            row_to_json(OLD),
            row_to_json(NEW),
            'Movement updated'
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 7. Create trigger for update logging
DROP TRIGGER IF EXISTS trigger_log_movimiento_update ON movimientos;
CREATE TRIGGER trigger_log_movimiento_update
    AFTER UPDATE ON movimientos
    FOR EACH ROW
    EXECUTE FUNCTION log_movimiento_update();

-- 8. Add RLS policies for audit table
ALTER TABLE movimientos_audit ENABLE ROW LEVEL SECURITY;

-- Allow all authenticated users to read audit logs
CREATE POLICY "Allow authenticated users to read audit logs"
    ON movimientos_audit FOR SELECT
    TO authenticated
    USING (true);

-- Allow system to insert audit logs
CREATE POLICY "Allow system to insert audit logs"
    ON movimientos_audit FOR INSERT
    TO authenticated
    WITH CHECK (true);

-- 9. Update existing RLS policies for movimientos to exclude deleted records
-- Note: You may need to update your existing SELECT policies to add:
-- AND deleted_at IS NULL

COMMENT ON COLUMN movimientos.deleted_at IS 'Timestamp when the movement was soft deleted';
COMMENT ON COLUMN movimientos.deleted_by IS 'User ID who deleted the movement';
COMMENT ON TABLE movimientos_audit IS 'Audit trail for all changes to movements';
