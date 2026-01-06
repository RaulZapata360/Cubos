-- Migration: Carga Masiva de Movimientos Pendientes (2026-01-05)
-- Obra: 8 Oriente (c4af1af6-d35d-4e70-96a3-0d6172dbf701)
-- Origen: Camilo H (Camilo H)
-- Material: Trumao (Arena)

DO $$ 
DECLARE
    v_obra_id UUID := 'c4af1af6-d35d-4e70-96a3-0d6172dbf701';
    v_user_id UUID := 'fc5c6a1e-f1e2-468a-95fe-3283a39b7334'; -- Tomado del ejemplo
    v_fecha DATE := '2026-01-05';
    v_material TEXT := 'Trumao (Arena)';
    v_origen TEXT := 'Camilo H';
    
    -- IDs de Camiones (los creamos para asegurar consistencia)
    v_id_riffo UUID := gen_random_uuid();
    v_id_luis UUID := gen_random_uuid();
    v_id_pedro UUID := gen_random_uuid();
    v_id_willy UUID := gen_random_uuid();
    v_id_fernando UUID := gen_random_uuid();
BEGIN
    -- 1. Insertar camiones en la nómina de hoy si no existen
    -- Nota: Usamos ON CONFLICT por patente para no duplicar si se ejecutan dos veces
    INSERT INTO camiones (id, obra_id, nombre, patente, capacidad, tipo_registrado, nomina_fecha)
    VALUES 
        (v_id_riffo, v_obra_id, 'Jose Riffo', 'LRHD62', 17.5, 'incoming', v_fecha),
        (v_id_luis, v_obra_id, 'Luiz Toledo', 'LLGX10', 17.5, 'incoming', v_fecha),
        (v_id_pedro, v_obra_id, 'Pedro Toledo', 'LLGV98', 17.5, 'incoming', v_fecha),
        (v_id_willy, v_obra_id, 'Willy Altamirano', 'LLGV99', 17.5, 'incoming', v_fecha),
        (v_id_fernando, v_obra_id, 'Fernando Torres', 'LLGV97', 17.5, 'incoming', v_fecha)
    ON CONFLICT (patente) DO UPDATE SET nomina_fecha = v_fecha 
    RETURNING id INTO v_id_riffo; -- Esto es un simplismo, en realidad necesitaríamos manejar los 5

    -- Re-obtener IDs reales por si hubo conflicto (para asegurar que el movimiento apunte al camión correcto)
    SELECT id INTO v_id_riffo FROM camiones WHERE patente = 'LRHD62' LIMIT 1;
    SELECT id INTO v_id_luis FROM camiones WHERE patente = 'LLGX10' LIMIT 1;
    SELECT id INTO v_id_pedro FROM camiones WHERE patente = 'LLGV98' LIMIT 1;
    SELECT id INTO v_id_willy FROM camiones WHERE patente = 'LLGV99' LIMIT 1;
    SELECT id INTO v_id_fernando FROM camiones WHERE patente = 'LLGV97' LIMIT 1;

    -- 2. Insertar Movimientos
    INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, origen, fecha, timestamp)
    VALUES
        -- Bloque 10:00 AM
        (v_obra_id, v_id_willy, v_user_id, 'incoming', 17.5, v_material, v_origen, v_fecha, v_fecha + time '10:35'),
        (v_obra_id, v_id_fernando, v_user_id, 'incoming', 17.5, v_material, v_origen, v_fecha, v_fecha + time '10:43'),
        (v_obra_id, v_id_riffo, v_user_id, 'incoming', 17.5, v_material, v_origen, v_fecha, v_fecha + time '10:49'),
        (v_obra_id, v_id_luis, v_user_id, 'incoming', 17.5, v_material, v_origen, v_fecha, v_fecha + time '10:50'),
        (v_obra_id, v_id_pedro, v_user_id, 'incoming', 17.5, v_material, v_origen, v_fecha, v_fecha + time '10:51'),
        
        -- Bloque 12:00 PM
        (v_obra_id, v_id_fernando, v_user_id, 'incoming', 17.5, v_material, v_origen, v_fecha, v_fecha + time '12:04'),
        (v_obra_id, v_id_willy, v_user_id, 'incoming', 17.5, v_material, v_origen, v_fecha, v_fecha + time '12:05'),
        (v_obra_id, v_id_pedro, v_user_id, 'incoming', 17.5, v_material, v_origen, v_fecha, v_fecha + time '12:07'),
        (v_obra_id, v_id_luis, v_user_id, 'incoming', 17.5, v_material, v_origen, v_fecha, v_fecha + time '12:08'),
        (v_obra_id, v_id_riffo, v_user_id, 'incoming', 17.5, v_material, v_origen, v_fecha, v_fecha + time '12:10');

    RAISE NOTICE 'Carga masiva completada exitosamente.';
END $$;
