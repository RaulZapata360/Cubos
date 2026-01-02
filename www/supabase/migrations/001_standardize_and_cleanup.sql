-- ==========================================
-- 001_ESTANDARIZAR_Y_LIMPIAR.sql
-- ==========================================
-- Este script estandariza los tipos de viaje a minúsculas,
-- limpia los datos de prueba y asegura que las políticas de RLS sean correctas.

-- 1. Estandarizar Restricciones de Tabla
ALTER TABLE movimientos DROP CONSTRAINT IF EXISTS movimientos_tipo_check;
ALTER TABLE movimientos ADD CONSTRAINT movimientos_tipo_check CHECK (tipo IN ('incoming', 'outgoing'));

-- 2. Limpiar Datos de Prueba (Opcional - borra todos los movimientos)
-- Si prefieres NO borrar todo, comenta estas líneas.
DELETE FROM movimientos;
-- DELETE FROM camiones; -- Descomentar si quieres resetear también los camiones

-- 3. Asegurar Políticas RLS (Row Level Security)
-- Esto asegura que los contadores puedan subir datos y el jefe verlos.

ALTER TABLE movimientos ENABLE ROW LEVEL SECURITY;

-- Borrar políticas existentes para evitar duplicados si se corre de nuevo
DROP POLICY IF EXISTS "Permitir inserción a contadores" ON movimientos;
DROP POLICY IF EXISTS "Permitir lectura a jefes" ON movimientos;
DROP POLICY IF EXISTS "Permitir lectura a contadores" ON movimientos;

-- Política: Los contadores pueden insertar movimientos
CREATE POLICY "Permitir inserción a contadores" ON movimientos
FOR INSERT TO authenticated
WITH CHECK (true); -- Simplificado para asegurar conexión, RLS se puede refinar luego

-- Política: Todos los usuarios autenticados pueden leer movimientos
CREATE POLICY "Permitir lectura a todos" ON movimientos
FOR SELECT TO authenticated
USING (true);

-- 4. Estandarizar Camiones
UPDATE camiones SET tipo_registrado = LOWER(tipo_registrado) WHERE tipo_registrado IS NOT NULL;
ALTER TABLE camiones DROP CONSTRAINT IF EXISTS camiones_tipo_registrado_check;
ALTER TABLE camiones ADD CONSTRAINT camiones_tipo_registrado_check CHECK (tipo_registrado IN ('incoming', 'outgoing', 'mixed'));

-- NOTA: Ejecuta este script en el SQL Editor de Supabase.
