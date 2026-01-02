-- ============================================
-- USUARIOS DE PRUEBA Y ASIGNACIONES (CORREGIDO)
-- ============================================

-- 1. CREAR USUARIOS EN AUTH (SISTEMA)
-- Nota: La contraseña para todos es 'Demo123!'
-- Aseguramos que pgcrypto esté habilitado
CREATE EXTENSION IF NOT EXISTS pgcrypto;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, confirmation_token)
VALUES
  ('c2fcf75d-bb0b-467e-918a-4220154fca85', 'contador1@demo.com', crypt('Demo123!', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"nombre":"Contador 1"}', now(), now(), 'authenticated', 'authenticated', ''),
  ('0acd45e7-0adb-4deb-9974-7b62624ec930', 'contador2@demo.com', crypt('Demo123!', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"nombre":"Contador 2"}', now(), now(), 'authenticated', 'authenticated', ''),
  ('3a677477-7cfa-43f1-b755-00663eabc887', 'contador3@demo.com', crypt('Demo123!', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"nombre":"Contador 3"}', now(), now(), 'authenticated', 'authenticated', ''),
  ('d2fcf75d-bb0b-467e-918a-4220154fca99', 'jefe@demo.com', crypt('Demo123!', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"nombre":"Jefe Demo"}', now(), now(), 'authenticated', 'authenticated', '')
ON CONFLICT (id) DO NOTHING;

-- Corregido: Insertar en auth.identities incluyendo provider_id
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at)
SELECT 
    id, 
    id, 
    format('{"sub":"%s","email":"%s"}', id, email)::jsonb, 
    'email', 
    id::text, -- El provider_id suele ser el ID del usuario en formato texto para el proveedor email
    now(), 
    now(), 
    now()
FROM auth.users
WHERE email LIKE '%@demo.com'
ON CONFLICT (provider, provider_id) DO NOTHING;


-- 2. CREAR PERFILES EN TABLA USUARIOS (PÚBLICA)
INSERT INTO public.usuarios (id, nombre_completo, rol, email) VALUES
  ('c2fcf75d-bb0b-467e-918a-4220154fca85', 'Contador Demo 1', 'contador', 'contador1@demo.com'),
  ('0acd45e7-0adb-4deb-9974-7b62624ec930', 'Contador Demo 2', 'contador', 'contador2@demo.com'),
  ('3a677477-7cfa-43f1-b755-00663eabc887', 'Contador Demo 3', 'contador', 'contador3@demo.com'),
  ('d2fcf75d-bb0b-467e-918a-4220154fca99', 'Jefe de Obra Principal', 'jefe', 'jefe@demo.com')
ON CONFLICT (id) DO NOTHING;


-- 3. ASIGNAR CONTADORES A SUS RESPECTIVAS OBRAS
-- Aeroparque (Contador 1)
INSERT INTO public.usuario_obra (usuario_id, obra_id) VALUES
  ('c2fcf75d-bb0b-467e-918a-4220154fca85', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa')
ON CONFLICT DO NOTHING;

-- VAIN (Contador 2)
INSERT INTO public.usuario_obra (usuario_id, obra_id) VALUES
  ('0acd45e7-0adb-4deb-9974-7b62624ec930', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb')
ON CONFLICT DO NOTHING;

-- Azul (Contador 3)
INSERT INTO public.usuario_obra (usuario_id, obra_id) VALUES
  ('3a677477-7cfa-43f1-b755-00663eabc887', 'cccccccc-cccc-cccc-cccc-cccccccccccc')
ON CONFLICT DO NOTHING;


-- 4. AGREGAR CAMIONES DE PRUEBA
INSERT INTO public.camiones (obra_id, nombre, patente, capacidad, tipo_registrado) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 1', 'AB-CD-11', 15.0, 'outgoing'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 2', 'BC-DE-22', 15.0, 'outgoing'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Tolva 1', 'XY-ZZ-99', 18.0, 'mixed')
ON CONFLICT DO NOTHING;
