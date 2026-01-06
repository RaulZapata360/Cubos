-- ============================================
-- SCRIPT DE DIAGNÓSTICO: ESTRUCTURA COMPLETA
-- Ejecutar en el PROYECTO ORIGINAL
-- ============================================

-- Este script te dará la estructura exacta de todas las tablas
-- para poder replicarla en el sandbox

-- 1. LISTAR TODAS LAS TABLAS
-- ============================================
SELECT 
    table_name,
    table_type
FROM information_schema.tables
WHERE table_schema = 'public'
    AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- 2. ESTRUCTURA DETALLADA DE CADA TABLA
-- ============================================

-- Tabla: usuarios
SELECT 
    'usuarios' as tabla,
    ordinal_position as orden,
    column_name as columna,
    data_type as tipo,
    character_maximum_length as longitud_max,
    column_default as valor_default,
    is_nullable as permite_null
FROM information_schema.columns
WHERE table_schema = 'public' 
    AND table_name = 'usuarios'
ORDER BY ordinal_position;

-- Tabla: obras
SELECT 
    'obras' as tabla,
    ordinal_position as orden,
    column_name as columna,
    data_type as tipo,
    character_maximum_length as longitud_max,
    column_default as valor_default,
    is_nullable as permite_null
FROM information_schema.columns
WHERE table_schema = 'public' 
    AND table_name = 'obras'
ORDER BY ordinal_position;

-- Tabla: obras_usuarios (o usuario_obra)
SELECT 
    'obras_usuarios' as tabla,
    ordinal_position as orden,
    column_name as columna,
    data_type as tipo,
    character_maximum_length as longitud_max,
    column_default as valor_default,
    is_nullable as permite_null
FROM information_schema.columns
WHERE table_schema = 'public' 
    AND table_name IN ('obras_usuarios', 'usuario_obra')
ORDER BY ordinal_position;

-- Tabla: camiones
SELECT 
    'camiones' as tabla,
    ordinal_position as orden,
    column_name as columna,
    data_type as tipo,
    character_maximum_length as longitud_max,
    column_default as valor_default,
    is_nullable as permite_null
FROM information_schema.columns
WHERE table_schema = 'public' 
    AND table_name = 'camiones'
ORDER BY ordinal_position;

-- Tabla: materiales
SELECT 
    'materiales' as tabla,
    ordinal_position as orden,
    column_name as columna,
    data_type as tipo,
    character_maximum_length as longitud_max,
    column_default as valor_default,
    is_nullable as permite_null
FROM information_schema.columns
WHERE table_schema = 'public' 
    AND table_name = 'materiales'
ORDER BY ordinal_position;

-- Tabla: movimientos
SELECT 
    'movimientos' as tabla,
    ordinal_position as orden,
    column_name as columna,
    data_type as tipo,
    character_maximum_length as longitud_max,
    column_default as valor_default,
    is_nullable as permite_null
FROM information_schema.columns
WHERE table_schema = 'public' 
    AND table_name = 'movimientos'
ORDER BY ordinal_position;

-- Tabla: destinos
SELECT 
    'destinos' as tabla,
    ordinal_position as orden,
    column_name as columna,
    data_type as tipo,
    character_maximum_length as longitud_max,
    column_default as valor_default,
    is_nullable as permite_null
FROM information_schema.columns
WHERE table_schema = 'public' 
    AND table_name = 'destinos'
ORDER BY ordinal_position;

-- Tabla: origenes
SELECT 
    'origenes' as tabla,
    ordinal_position as orden,
    column_name as columna,
    data_type as tipo,
    character_maximum_length as longitud_max,
    column_default as valor_default,
    is_nullable as permite_null
FROM information_schema.columns
WHERE table_schema = 'public' 
    AND table_name = 'origenes'
ORDER BY ordinal_position;

-- Tabla: historial_diario
SELECT 
    'historial_diario' as tabla,
    ordinal_position as orden,
    column_name as columna,
    data_type as tipo,
    character_maximum_length as longitud_max,
    column_default as valor_default,
    is_nullable as permite_null
FROM information_schema.columns
WHERE table_schema = 'public' 
    AND table_name = 'historial_diario'
ORDER BY ordinal_position;

-- 3. CONSTRAINTS Y FOREIGN KEYS
-- ============================================

SELECT
    tc.table_name as tabla,
    tc.constraint_name as constraint,
    tc.constraint_type as tipo,
    kcu.column_name as columna,
    ccu.table_name AS tabla_referenciada,
    ccu.column_name AS columna_referenciada
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
LEFT JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.table_schema = 'public'
    AND tc.table_name IN ('usuarios', 'obras', 'obras_usuarios', 'usuario_obra', 'camiones', 'materiales', 'movimientos', 'destinos', 'origenes', 'historial_diario')
ORDER BY tc.table_name, tc.constraint_type;

-- 4. ÍNDICES
-- ============================================

SELECT
    tablename as tabla,
    indexname as indice,
    indexdef as definicion
FROM pg_indexes
WHERE schemaname = 'public'
    AND tablename IN ('usuarios', 'obras', 'obras_usuarios', 'usuario_obra', 'camiones', 'materiales', 'movimientos', 'destinos', 'origenes', 'historial_diario')
ORDER BY tablename, indexname;

-- ============================================
-- INSTRUCCIONES
-- ============================================

-- 1. Ejecuta este script en tu PROYECTO ORIGINAL (Cubos producción)
-- 2. Copia TODOS los resultados (todas las tablas que aparecen)
-- 3. Pégamelos aquí
-- 4. Con esa información crearé el script exacto para replicar
--    la estructura en el sandbox

-- ============================================
-- BONUS: GENERAR SCRIPT DE CREACIÓN
-- ============================================

-- Este query genera el DDL completo de cada tabla
-- (Solo funciona si tienes permisos de superusuario)

SELECT 
    'CREATE TABLE ' || table_name || ' (' || 
    string_agg(
        column_name || ' ' || 
        data_type || 
        CASE 
            WHEN character_maximum_length IS NOT NULL 
            THEN '(' || character_maximum_length || ')'
            ELSE ''
        END ||
        CASE 
            WHEN column_default IS NOT NULL 
            THEN ' DEFAULT ' || column_default
            ELSE ''
        END ||
        CASE 
            WHEN is_nullable = 'NO' 
            THEN ' NOT NULL'
            ELSE ''
        END,
        ', '
        ORDER BY ordinal_position
    ) || ');' as create_statement
FROM information_schema.columns
WHERE table_schema = 'public'
    AND table_name IN ('usuarios', 'obras', 'obras_usuarios', 'usuario_obra', 'camiones', 'materiales', 'movimientos', 'destinos', 'origenes', 'historial_diario')
GROUP BY table_name
ORDER BY table_name;
