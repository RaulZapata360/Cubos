-- ============================================
-- RECUPERACIÓN COMPLETA: JORGE Y EDUARDO SALAMANCA
-- Fecha: 2026-01-17
-- Descripción: Recrea Jorge Salamanca y completa movimientos faltantes de Eduardo
-- ============================================

DO $$
DECLARE
    jorge_id UUID;
    eduardo_id UUID := '51627dc9-3b32-4fb9-9a7b-c443bff18822';
BEGIN
    RAISE NOTICE '============================================';
    RAISE NOTICE 'INICIANDO RECUPERACIÓN DE MOVIMIENTOS';
    RAISE NOTICE '============================================';
    
    -- ============================================
    -- PARTE 1: JORGE SALAMANCA
    -- ============================================
    
    -- 1. Crear Jorge Salamanca
    INSERT INTO camiones (
        id,
        obra_id,
        nombre,
        patente,
        capacidad,
        tipo_registrado,
        contador_entrante,
        contador_saliente,
        created_at,
        updated_at,
        nomina_fecha,
        rendimiento_km_por_litro
    )
    VALUES (
        gen_random_uuid(),
        'c4af1af6-d35d-4e70-96a3-0d6172dbf701',
        'Jorge Salamanca',
        'AX8507',
        14.00,
        'internal',
        0,
        0,
        NOW(),
        NOW(),
        '2026-01-17',
        '3.50'
    )
    RETURNING id INTO jorge_id;
    
    RAISE NOTICE 'Jorge Salamanca creado con ID: %', jorge_id;
    
    -- 2. Insertar movimientos de Jorge - 12/01/2026 (7 vueltas)
    INSERT INTO movimientos (id, obra_id, camion_id, usuario_id, tipo, capacidad, material, destino, timestamp, fecha)
    SELECT 
        gen_random_uuid(), 
        'c4af1af6-d35d-4e70-96a3-0d6172dbf701', 
        jorge_id, 
        'fc5c6a1e-f1e2-468a-95fe-3283a39b7334', 
        'outgoing', 
        14.00, 
        'Tierra', 
        'Interno', 
        '2026-01-12 08:00:00+00'::timestamp + (n || ' hours')::interval, 
        '2026-01-12'
    FROM generate_series(1, 7) as n;
    RAISE NOTICE 'Jorge - 12/01: 7 vueltas';
    
    -- 3. Jorge - 13/01/2026 (7 vueltas)
    INSERT INTO movimientos (id, obra_id, camion_id, usuario_id, tipo, capacidad, material, destino, timestamp, fecha)
    SELECT gen_random_uuid(), 'c4af1af6-d35d-4e70-96a3-0d6172dbf701', jorge_id, 'fc5c6a1e-f1e2-468a-95fe-3283a39b7334', 'outgoing', 14.00, 'Tierra', 'Interno', '2026-01-13 08:00:00+00'::timestamp + (n || ' hours')::interval, '2026-01-13'
    FROM generate_series(1, 7) as n;
    RAISE NOTICE 'Jorge - 13/01: 7 vueltas';
    
    -- 4. Jorge - 14/01/2026 (13 vueltas)
    INSERT INTO movimientos (id, obra_id, camion_id, usuario_id, tipo, capacidad, material, destino, timestamp, fecha)
    SELECT gen_random_uuid(), 'c4af1af6-d35d-4e70-96a3-0d6172dbf701', jorge_id, 'fc5c6a1e-f1e2-468a-95fe-3283a39b7334', 'outgoing', 14.00, 'Tierra', 'Interno', '2026-01-14 08:00:00+00'::timestamp + (n || ' hours')::interval, '2026-01-14'
    FROM generate_series(1, 13) as n;
    RAISE NOTICE 'Jorge - 14/01: 13 vueltas';
    
    -- 5. Jorge - 15/01/2026 (15 vueltas)
    INSERT INTO movimientos (id, obra_id, camion_id, usuario_id, tipo, capacidad, material, destino, timestamp, fecha)
    SELECT gen_random_uuid(), 'c4af1af6-d35d-4e70-96a3-0d6172dbf701', jorge_id, 'fc5c6a1e-f1e2-468a-95fe-3283a39b7334', 'outgoing', 14.00, 'Tierra', 'Interno', '2026-01-15 08:00:00+00'::timestamp + (n || ' hours')::interval, '2026-01-15'
    FROM generate_series(1, 15) as n;
    RAISE NOTICE 'Jorge - 15/01: 15 vueltas';
    
    -- 6. Jorge - 16/01/2026 (6 vueltas)
    INSERT INTO movimientos (id, obra_id, camion_id, usuario_id, tipo, capacidad, material, destino, timestamp, fecha)
    SELECT gen_random_uuid(), 'c4af1af6-d35d-4e70-96a3-0d6172dbf701', jorge_id, 'fc5c6a1e-f1e2-468a-95fe-3283a39b7334', 'outgoing', 14.00, 'Tierra', 'Interno', '2026-01-16 08:00:00+00'::timestamp + (n || ' hours')::interval, '2026-01-16'
    FROM generate_series(1, 6) as n;
    RAISE NOTICE 'Jorge - 16/01: 6 vueltas';
    
    -- 7. Jorge - 17/01/2026 (9 vueltas)
    INSERT INTO movimientos (id, obra_id, camion_id, usuario_id, tipo, capacidad, material, destino, timestamp, fecha)
    SELECT gen_random_uuid(), 'c4af1af6-d35d-4e70-96a3-0d6172dbf701', jorge_id, 'fc5c6a1e-f1e2-468a-95fe-3283a39b7334', 'outgoing', 14.00, 'Tierra', 'Interno', '2026-01-17 08:00:00+00'::timestamp + (n || ' hours')::interval, '2026-01-17'
    FROM generate_series(1, 9) as n;
    RAISE NOTICE 'Jorge - 17/01: 9 vueltas';
    
    RAISE NOTICE 'Jorge TOTAL: 57 vueltas = 798 m³';
    
    -- ============================================
    -- PARTE 2: EDUARDO SALAMANCA (MOVIMIENTOS FALTANTES)
    -- ============================================
    
    RAISE NOTICE '--------------------------------------------';
    RAISE NOTICE 'Completando movimientos de Eduardo...';
    
    -- Eduardo - 12/01: Faltan 2 vueltas (tiene 5, necesita 7)
    INSERT INTO movimientos (id, obra_id, camion_id, usuario_id, tipo, capacidad, material, destino, timestamp, fecha)
    SELECT gen_random_uuid(), 'c4af1af6-d35d-4e70-96a3-0d6172dbf701', eduardo_id, 'fc5c6a1e-f1e2-468a-95fe-3283a39b7334', 'outgoing', 17.00, 'Tierra', 'Interno', '2026-01-12 15:00:00+00'::timestamp + (n || ' hours')::interval, '2026-01-12'
    FROM generate_series(1, 2) as n;
    RAISE NOTICE 'Eduardo - 12/01: +2 vueltas (ahora 7)';
    
    -- Eduardo - 13/01: Faltan 3 vueltas (tiene 4, necesita 7)
    INSERT INTO movimientos (id, obra_id, camion_id, usuario_id, tipo, capacidad, material, destino, timestamp, fecha)
    SELECT gen_random_uuid(), 'c4af1af6-d35d-4e70-96a3-0d6172dbf701', eduardo_id, 'fc5c6a1e-f1e2-468a-95fe-3283a39b7334', 'outgoing', 17.00, 'Tierra', 'Interno', '2026-01-13 15:00:00+00'::timestamp + (n || ' hours')::interval, '2026-01-13'
    FROM generate_series(1, 3) as n;
    RAISE NOTICE 'Eduardo - 13/01: +3 vueltas (ahora 7)';
    
    -- Eduardo - 14/01: Faltan 4 vueltas (tiene 9, necesita 13)
    INSERT INTO movimientos (id, obra_id, camion_id, usuario_id, tipo, capacidad, material, destino, timestamp, fecha)
    SELECT gen_random_uuid(), 'c4af1af6-d35d-4e70-96a3-0d6172dbf701', eduardo_id, 'fc5c6a1e-f1e2-468a-95fe-3283a39b7334', 'outgoing', 17.00, 'Tierra', 'Interno', '2026-01-14 15:00:00+00'::timestamp + (n || ' hours')::interval, '2026-01-14'
    FROM generate_series(1, 4) as n;
    RAISE NOTICE 'Eduardo - 14/01: +4 vueltas (ahora 13)';
    
    -- Eduardo - 15/01: Faltan 7 vueltas (tiene 7, necesita 14)
    INSERT INTO movimientos (id, obra_id, camion_id, usuario_id, tipo, capacidad, material, destino, timestamp, fecha)
    SELECT gen_random_uuid(), 'c4af1af6-d35d-4e70-96a3-0d6172dbf701', eduardo_id, 'fc5c6a1e-f1e2-468a-95fe-3283a39b7334', 'outgoing', 17.00, 'Tierra', 'Interno', '2026-01-15 15:00:00+00'::timestamp + (n || ' hours')::interval, '2026-01-15'
    FROM generate_series(1, 7) as n;
    RAISE NOTICE 'Eduardo - 15/01: +7 vueltas (ahora 14)';
    
    -- Eduardo - 16/01: Faltan 7 vueltas (tiene 7, necesita 14)
    INSERT INTO movimientos (id, obra_id, camion_id, usuario_id, tipo, capacidad, material, destino, timestamp, fecha)
    SELECT gen_random_uuid(), 'c4af1af6-d35d-4e70-96a3-0d6172dbf701', eduardo_id, 'fc5c6a1e-f1e2-468a-95fe-3283a39b7334', 'outgoing', 17.00, 'Tierra', 'Interno', '2026-01-16 15:00:00+00'::timestamp + (n || ' hours')::interval, '2026-01-16'
    FROM generate_series(1, 7) as n;
    RAISE NOTICE 'Eduardo - 16/01: +7 vueltas (ahora 14)';
    
    -- Eduardo - 17/01: Ya tiene 8, está correcto ✓
    RAISE NOTICE 'Eduardo - 17/01: ✓ Ya tiene 8 vueltas';
    
    RAISE NOTICE 'Eduardo TOTAL: +23 vueltas = +391 m³ (ahora 63 vueltas = 1071 m³)';
    
    -- ============================================
    -- RESUMEN FINAL
    -- ============================================
    
    RAISE NOTICE '============================================';
    RAISE NOTICE 'RECUPERACIÓN COMPLETADA';
    RAISE NOTICE '--------------------------------------------';
    RAISE NOTICE 'Jorge Salamanca:';
    RAISE NOTICE '  - Camión recreado';
    RAISE NOTICE '  - 57 vueltas insertadas (798 m³)';
    RAISE NOTICE '--------------------------------------------';
    RAISE NOTICE 'Eduardo Salamanca:';
    RAISE NOTICE '  - 23 vueltas agregadas (391 m³)';
    RAISE NOTICE '  - Total ahora: 63 vueltas (1071 m³)';
    RAISE NOTICE '============================================';
    RAISE NOTICE 'TOTAL RECUPERADO: 80 movimientos';
    RAISE NOTICE '============================================';
    
END $$;

-- ============================================
-- VERIFICACIÓN DE RESULTADOS
-- ============================================

-- Verificar Jorge Salamanca
SELECT 
    'Jorge Salamanca' as camion,
    fecha, 
    COUNT(*) as vueltas, 
    SUM(m.capacidad) as total_m3
FROM movimientos m
JOIN camiones c ON m.camion_id = c.id
WHERE c.nombre = 'Jorge Salamanca'
  AND m.destino = 'Interno'
  AND m.fecha BETWEEN '2026-01-12' AND '2026-01-17'
GROUP BY fecha
ORDER BY fecha;

-- Verificar Eduardo Salamanca
SELECT 
    'Eduardo Salamanca' as camion,
    fecha, 
    COUNT(*) as vueltas, 
    SUM(m.capacidad) as total_m3
FROM movimientos m
WHERE m.camion_id = '51627dc9-3b32-4fb9-9a7b-c443bff18822'
  AND m.destino = 'Interno'
  AND m.fecha BETWEEN '2026-01-12' AND '2026-01-17'
GROUP BY fecha
ORDER BY fecha;

-- Total general
SELECT 
    c.nombre as camion,
    COUNT(*) as total_vueltas, 
    SUM(m.capacidad) as total_m3
FROM movimientos m
JOIN camiones c ON m.camion_id = c.id
WHERE c.nombre IN ('Jorge Salamanca', 'Eduardo Salamanca')
  AND m.destino = 'Interno'
  AND m.fecha BETWEEN '2026-01-12' AND '2026-01-17'
GROUP BY c.nombre
ORDER BY c.nombre;
