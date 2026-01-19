-- Agregar columna 'nombre' a la tabla metas_obra
ALTER TABLE public.metas_obra 
ADD COLUMN IF NOT EXISTS nombre text;

-- Opcional: Agregar columna material_objetivo si no estaba explicita en el diseño previo 
-- (aunque en JS la enviaba, es mejor asegurar que exista en la tabla si se usa para filtrar)
ALTER TABLE public.metas_obra 
ADD COLUMN IF NOT EXISTS material_objetivo text;
