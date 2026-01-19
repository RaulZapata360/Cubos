-- Migración: Agregar material_id a movimientos
-- Fecha: 2026-01-19
-- Propósito: Permitir rastrear movimientos por ID de material para cálculo preciso de progreso de metas

-- Agregar columna para almacenar el ID del material
ALTER TABLE public.movimientos 
ADD COLUMN IF NOT EXISTS material_id uuid;

-- Agregar comentario para documentación
COMMENT ON COLUMN public.movimientos.material_id IS 'ID del material desde la tabla materiales. Permite tracking preciso de progreso de metas.';

-- Agregar índice para mejorar rendimiento en consultas de progreso de metas
CREATE INDEX IF NOT EXISTS movimientos_material_id_idx 
ON public.movimientos (material_id);

-- Agregar foreign key constraint (opcional, comentado por si la tabla materiales no tiene la estructura esperada)
-- ALTER TABLE public.movimientos 
-- ADD CONSTRAINT fk_movimiento_material 
-- FOREIGN KEY (material_id) 
-- REFERENCES public.materiales(id) 
-- ON DELETE SET NULL;
