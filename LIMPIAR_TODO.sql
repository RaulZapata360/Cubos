-- ============================================
-- SQL DE LIMPIEZA TOTAL (USUARIOS Y DATOS)
-- ============================================

-- 1. BORRAR ASIGNACIONES Y PERFILES DE USUARIOS
-- Primero las tablas que dependen de otras (FK)
DELETE FROM public.usuario_obra;
DELETE FROM public.usuarios;

-- 2. BORRAR REGISTROS DE AUTENTICACIÓN (SISTEMA)
-- Borramos identidades vinculadas primero
DELETE FROM auth.identities;
-- Borramos los usuarios del sistema de autenticación
DELETE FROM auth.users;

-- 3. BORRAR DATOS DE NEGOCIO (OPCIONAL - SOLO SI QUIERES RESETEAR TODO)
-- DELETE FROM public.movimientos;
-- DELETE FROM public.camiones;
-- DELETE FROM public.materiales;
-- DELETE FROM public.destinos;
-- DELETE FROM public.obras;

-- NOTA: Al ejecutar esto, el proyecto quedará como nuevo,
-- listo para ejecutar el script de USUARIOS_DEMO de nuevo.
