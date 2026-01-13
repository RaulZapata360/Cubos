-- ============================================
-- CREAR OBRA 'TORREONES' Y ASIGNAR AYUDANTE
-- ============================================

DO $$
DECLARE
    new_obra_id UUID;
    ayudante_id UUID := '4c091cd9-7ea4-4767-9e1f-7ae06f7f225a';
BEGIN
    -- 1. Crear la nueva obra
    INSERT INTO public.obras (nombre, ubicacion, estado, fecha_inicio)
    VALUES ('Torreones', 'Ubicación General', 'activa', CURRENT_DATE)
    RETURNING id INTO new_obra_id;

    -- 2. Asignar el usuario ayudante a la nueva obra
    INSERT INTO public.usuario_obra (usuario_id, obra_id)
    VALUES (ayudante_id, new_obra_id);

    -- 3. (Opcional) Asignar al Supervisor también si se requiere, 
    -- pero la solicitud solo pidió al ayudante.
    
    RAISE NOTICE 'Obra Torreones creada exitosamente (ID: %) y Ayudante asignado.', new_obra_id;
END $$;
