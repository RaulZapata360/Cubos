-- Migración: Agregar material_objetivo_id a metas_obra
-- Fecha: 2026-01-19
-- Propósito: Permitir rastrear metas por ID de material en lugar de solo nombre

-- Agregar columna para almacenar el ID del material objetivo
ALTER TABLE public.metas_obra 
ADD COLUMN IF NOT EXISTS material_objetivo_id uuid;

-- Agregar comentario para documentación
COMMENT ON COLUMN public.metas_obra.material_objetivo_id IS 'ID del material objetivo desde la tabla materiales. Si es NULL, la meta acepta cualquier material del tipo especificado.';

-- Agregar índice para mejorar rendimiento en consultas de progreso
CREATE INDEX IF NOT EXISTS metas_obra_material_objetivo_id_idx 
ON public.metas_obra (material_objetivo_id);

-- Agregar foreign key constraint (opcional, comentado por si la tabla materiales no existe aún)
-- ALTER TABLE public.metas_obra 
-- ADD CONSTRAINT fk_material_objetivo 
-- FOREIGN KEY (material_objetivo_id) 
-- REFERENCES public.materiales(id) 
-- ON DELETE SET NULL;
