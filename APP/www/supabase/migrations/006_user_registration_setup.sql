-- ============================================
-- MIGRACIÓN: REGISTRO DE USUARIOS Y NUEVOS ROLES
-- ============================================

-- 1. Actualizar los roles permitidos en la tabla usuarios
ALTER TABLE public.usuarios 
DROP CONSTRAINT IF EXISTS usuarios_rol_check;

ALTER TABLE public.usuarios 
ADD CONSTRAINT usuarios_rol_check 
CHECK (rol IN ('jefe', 'contador', 'supervisor', 'secretaria'));

-- 2. Función para crear el perfil automáticamente al registrarse
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.usuarios (id, nombre_completo, email, rol)
  VALUES (
    new.id, 
    COALESCE(new.raw_user_meta_data->>'nombre', 'Nuevo Usuario'), 
    new.email, 
    COALESCE(new.raw_user_meta_data->>'rol', 'contador')
  );
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Trigger para ejecutar la función después de un insert en auth.users
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 4. Ajustar políticas RLS para permitir el registro
-- Permitir inserción inicial (el trigger lo hace como SECURITY DEFINER, así que no es estrictamente necesario, pero ayuda)
CREATE POLICY "Permitir registro individual" 
ON public.usuarios 
FOR INSERT 
WITH CHECK (auth.uid() = id);

-- Permitir a usuarios actualizar sus propios metadatos
CREATE POLICY "Permitir actualizar propio perfil"
ON public.usuarios
FOR UPDATE
USING (auth.uid() = id);
