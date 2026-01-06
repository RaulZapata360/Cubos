-- ============================================
-- ROLLBACK: Revertir cambios de viajes internos (122)
-- ============================================

-- 1. Eliminar columnas agregadas en historial_diario
ALTER TABLE historial_diario DROP COLUMN IF EXISTS vueltas_internas;
ALTER TABLE historial_diario DROP COLUMN IF EXISTS volumen_interno;

-- 2. Eliminar índice
DROP INDEX IF EXISTS idx_movimientos_tipo_viaje;

-- 3. Eliminar columna tipo_viaje de movimientos
ALTER TABLE movimientos DROP COLUMN IF EXISTS tipo_viaje;

-- 4. Verificar que se eliminaron correctamente
DO $$
DECLARE
    v_column_exists BOOLEAN;
BEGIN
    -- Verificar que tipo_viaje fue eliminado
    SELECT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'movimientos' AND column_name = 'tipo_viaje'
    ) INTO v_column_exists;
    
    IF NOT v_column_exists THEN
        RAISE NOTICE '✅ Columna tipo_viaje eliminada correctamente';
    ELSE
        RAISE EXCEPTION '❌ Error: Columna tipo_viaje aún existe';
    END IF;
    
    RAISE NOTICE '✅ Rollback completado exitosamente';
END $$;
