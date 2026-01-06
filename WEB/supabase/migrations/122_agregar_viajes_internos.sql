-- ============================================
-- FEATURE: VIAJES INTERNOS
-- Agrega la capacidad de diferenciar viajes internos (dentro de la obra)
-- de viajes externos (entrada/salida de la obra)
-- ============================================

-- 1. Agregar columna tipo_viaje a la tabla movimientos
ALTER TABLE movimientos ADD COLUMN IF NOT EXISTS tipo_viaje TEXT DEFAULT 'externo' 
  CHECK (tipo_viaje IN ('externo', 'interno'));

-- 2. Crear índice para mejorar consultas filtradas por tipo de viaje
CREATE INDEX IF NOT EXISTS idx_movimientos_tipo_viaje ON movimientos(tipo_viaje);

-- 3. Agregar comentario para documentación
COMMENT ON COLUMN movimientos.tipo_viaje IS 'Tipo de viaje: externo (entrada/salida obra) o interno (movimiento dentro de obra)';

-- 4. Actualizar tabla historial_diario para incluir métricas de viajes internos
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='historial_diario' AND column_name='vueltas_internas') THEN
        ALTER TABLE historial_diario ADD COLUMN vueltas_internas INTEGER DEFAULT 0;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='historial_diario' AND column_name='volumen_interno') THEN
        ALTER TABLE historial_diario ADD COLUMN volumen_interno DECIMAL(10,2) DEFAULT 0;
    END IF;
END $$;

-- 5. Agregar comentarios a las nuevas columnas
COMMENT ON COLUMN historial_diario.vueltas_internas IS 'Total de vueltas internas (movimientos dentro de la obra)';
COMMENT ON COLUMN historial_diario.volumen_interno IS 'Volumen total movido internamente en m³';

-- 6. Verificar que la migración fue exitosa
DO $$
DECLARE
    v_column_exists BOOLEAN;
    v_index_exists BOOLEAN;
BEGIN
    -- Verificar columna tipo_viaje
    SELECT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'movimientos' AND column_name = 'tipo_viaje'
    ) INTO v_column_exists;
    
    IF v_column_exists THEN
        RAISE NOTICE '✅ Columna tipo_viaje agregada correctamente';
    ELSE
        RAISE EXCEPTION '❌ Error: Columna tipo_viaje no fue creada';
    END IF;
    
    -- Verificar índice
    SELECT EXISTS (
        SELECT 1 FROM pg_indexes 
        WHERE tablename = 'movimientos' AND indexname = 'idx_movimientos_tipo_viaje'
    ) INTO v_index_exists;
    
    IF v_index_exists THEN
        RAISE NOTICE '✅ Índice idx_movimientos_tipo_viaje creado correctamente';
    ELSE
        RAISE EXCEPTION '❌ Error: Índice no fue creado';
    END IF;
    
    RAISE NOTICE '✅ Migración 122_agregar_viajes_internos completada exitosamente';
END $$;

-- 7. Mostrar estadísticas actuales
SELECT 
    tipo_viaje,
    COUNT(*) as total_movimientos,
    COUNT(DISTINCT camion_id) as camiones_unicos,
    SUM(capacidad) as volumen_total
FROM movimientos
GROUP BY tipo_viaje
ORDER BY tipo_viaje;
