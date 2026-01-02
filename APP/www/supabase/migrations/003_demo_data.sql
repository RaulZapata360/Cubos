-- ============================================
-- DATOS DE DEMO - 3 OBRAS
-- ============================================

-- NOTA: Este script debe ejecutarse DESPUÉS de crear los usuarios en Supabase Auth
-- Los UUIDs de usuarios deben coincidir con los creados en auth.users

-- ============================================
-- OBRAS DE DEMO
-- ============================================

INSERT INTO obras (id, nombre, ubicacion, descripcion, fecha_inicio, estado) VALUES
  ('11111111-1111-1111-1111-111111111111', 'Obra Norte - Urbanización Las Colinas', 'Sector Norte, Km 15', 'Proyecto residencial de 50 lotes', '2025-01-15', 'activa'),
  ('22222222-2222-2222-2222-222222222222', 'Obra Sur - Complejo Industrial', 'Parque Industrial Sur', 'Construcción de naves industriales', '2025-01-10', 'activa'),
  ('33333333-3333-3333-3333-333333333333', 'Obra Centro - Edificio Corporativo', 'Av. Principal 1234', 'Torre de oficinas 15 pisos', '2025-02-01', 'activa');

-- ============================================
-- USUARIOS DE DEMO
-- IMPORTANTE: Estos usuarios deben crearse primero en Supabase Auth
-- Luego ejecutar este script con los UUIDs correctos
-- ============================================

-- Jefe (acceso a todas las obras)
-- Email: jefe@demo.com | Password: Demo123!
INSERT INTO usuarios (id, nombre_completo, rol, email, telefono) VALUES
  ('420087d5-383a-41e0-8387-e974efc8d6d6', 'Carlos Rodríguez', 'jefe', 'jefe@demo.com', '+56912345678');

-- Contador 1 - Obra Norte
-- Email: contador1@demo.com | Password: Demo123!
INSERT INTO usuarios (id, nombre_completo, rol, email, telefono) VALUES
  ('c2fcf75d-bb0b-467e-918a-4220154fca85', 'Ana Martínez', 'contador', 'contador1@demo.com', '+56912345679');

-- Contador 2 - Obra Sur
-- Email: contador2@demo.com | Password: Demo123!
INSERT INTO usuarios (id, nombre_completo, rol, email, telefono) VALUES
  ('0acd45e7-0adb-4deb-9974-7b62624ec930', 'Pedro González', 'contador', 'contador2@demo.com', '+56912345680');

-- Contador 3 - Obra Centro
-- Email: contador3@demo.com | Password: Demo123!
INSERT INTO usuarios (id, nombre_completo, rol, email, telefono) VALUES
  ('3a677477-7cfa-43f1-b755-00663eabc887', 'María López', 'contador', 'contador3@demo.com', '+56912345681');

-- ============================================
-- ASIGNACIONES USUARIO-OBRA
-- ============================================

INSERT INTO usuario_obra (usuario_id, obra_id) VALUES
  -- Contador 1 → Obra Norte
  ('c2fcf75d-bb0b-467e-918a-4220154fca85', '11111111-1111-1111-1111-111111111111'),
  -- Contador 2 → Obra Sur
  ('0acd45e7-0adb-4deb-9974-7b62624ec930', '22222222-2222-2222-2222-222222222222'),
  -- Contador 3 → Obra Centro
  ('3a677477-7cfa-43f1-b755-00663eabc887', '33333333-3333-3333-3333-333333333333');

-- ============================================
-- MATERIALES POR OBRA
-- ============================================

-- Obra Norte - Materiales
INSERT INTO materiales (obra_id, nombre, tipo) VALUES
  ('11111111-1111-1111-1111-111111111111', 'Base estabilizada', 'incoming'),
  ('11111111-1111-1111-1111-111111111111', 'Grava', 'incoming'),
  ('11111111-1111-1111-1111-111111111111', 'Ripio', 'incoming'),
  ('11111111-1111-1111-1111-111111111111', 'Arena', 'incoming'),
  ('11111111-1111-1111-1111-111111111111', 'Arcilla', 'outgoing'),
  ('11111111-1111-1111-1111-111111111111', 'Tierra', 'outgoing');

-- Obra Sur - Materiales
INSERT INTO materiales (obra_id, nombre, tipo) VALUES
  ('22222222-2222-2222-2222-222222222222', 'Hormigón', 'incoming'),
  ('22222222-2222-2222-2222-222222222222', 'Grava', 'incoming'),
  ('22222222-2222-2222-2222-222222222222', 'Arena gruesa', 'incoming'),
  ('22222222-2222-2222-2222-222222222222', 'Escombros', 'outgoing'),
  ('22222222-2222-2222-2222-222222222222', 'Tierra', 'outgoing');

-- Obra Centro - Materiales
INSERT INTO materiales (obra_id, nombre, tipo) VALUES
  ('33333333-3333-3333-3333-333333333333', 'Hormigón premezclado', 'incoming'),
  ('33333333-3333-3333-3333-333333333333', 'Arena fina', 'incoming'),
  ('33333333-3333-3333-3333-333333333333', 'Ripio', 'incoming'),
  ('33333333-3333-3333-3333-333333333333', 'Escombros', 'outgoing'),
  ('33333333-3333-3333-3333-333333333333', 'Basura', 'outgoing');

-- ============================================
-- CAMIONES DE DEMO
-- ============================================

-- Obra Norte - 5 camiones
INSERT INTO camiones (obra_id, nombre, patente, capacidad, tipo_registrado, contador_entrante, contador_saliente) VALUES
  ('11111111-1111-1111-1111-111111111111', 'Camión 1', 'ABC123', 15.0, 'incoming', 8, 0),
  ('11111111-1111-1111-1111-111111111111', 'Camión 2', 'DEF456', 12.0, 'incoming', 6, 0),
  ('11111111-1111-1111-1111-111111111111', 'Camión 3', 'GHI789', 18.0, 'outgoing', 0, 4),
  ('11111111-1111-1111-1111-111111111111', 'Volvo A40', 'JKL012', 20.0, 'mixed', 3, 2),
  ('11111111-1111-1111-1111-111111111111', 'Mercedes 2628', 'MNO345', 14.0, 'incoming', 5, 0);

-- Obra Sur - 8 camiones
INSERT INTO camiones (obra_id, nombre, patente, capacidad, tipo_registrado, contador_entrante, contador_saliente) VALUES
  ('22222222-2222-2222-2222-222222222222', 'Tolva 1', 'PQR678', 16.0, 'incoming', 12, 0),
  ('22222222-2222-2222-2222-222222222222', 'Tolva 2', 'STU901', 16.0, 'incoming', 10, 0),
  ('22222222-2222-2222-2222-222222222222', 'Tolva 3', 'VWX234', 16.0, 'incoming', 8, 0),
  ('22222222-2222-2222-2222-222222222222', 'Mixer 1', 'YZA567', 8.0, 'incoming', 15, 0),
  ('22222222-2222-2222-2222-222222222222', 'Mixer 2', 'BCD890', 8.0, 'incoming', 12, 0),
  ('22222222-2222-2222-2222-222222222222', 'Excavadora 1', 'EFG123', 22.0, 'outgoing', 0, 9),
  ('22222222-2222-2222-2222-222222222222', 'Excavadora 2', 'HIJ456', 22.0, 'outgoing', 0, 7),
  ('22222222-2222-2222-2222-222222222222', 'Camión Mixto', 'KLM789', 18.0, 'mixed', 5, 4);

-- Obra Centro - 4 camiones
INSERT INTO camiones (obra_id, nombre, patente, capacidad, tipo_registrado, contador_entrante, contador_saliente) VALUES
  ('33333333-3333-3333-3333-333333333333', 'Hormigonera 1', 'NOP012', 10.0, 'incoming', 9, 0),
  ('33333333-3333-3333-3333-333333333333', 'Hormigonera 2', 'QRS345', 10.0, 'incoming', 7, 0),
  ('33333333-3333-3333-3333-333333333333', 'Camión Carga', 'TUV678', 15.0, 'mixed', 4, 3),
  ('33333333-3333-3333-3333-333333333333', 'Retiro Escombros', 'WXY901', 20.0, 'outgoing', 0, 5);

-- ============================================
-- MOVIMIENTOS DE DEMO (Hoy)
-- ============================================

-- Obra Norte - 20 movimientos
INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, ubicacion, timestamp, fecha, camion_nombre, camion_patente) 
SELECT 
  '11111111-1111-1111-1111-111111111111',
  c.id,
  'c2fcf75d-bb0b-467e-918a-4220154fca85',
  'incoming',
  c.capacidad,
  'Base estabilizada',
  'Sector A',
  NOW() - (random() * interval '8 hours'),
  CURRENT_DATE,
  c.nombre,
  c.patente
FROM camiones c
WHERE c.obra_id = '11111111-1111-1111-1111-111111111111' AND c.tipo_registrado IN ('incoming', 'mixed')
LIMIT 15;

INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, ubicacion, timestamp, fecha, camion_nombre, camion_patente) 
SELECT 
  '11111111-1111-1111-1111-111111111111',
  c.id,
  'c2fcf75d-bb0b-467e-918a-4220154fca85',
  'outgoing',
  c.capacidad,
  'Arcilla',
  'Sector B',
  NOW() - (random() * interval '8 hours'),
  CURRENT_DATE,
  c.nombre,
  c.patente
FROM camiones c
WHERE c.obra_id = '11111111-1111-1111-1111-111111111111' AND c.tipo_registrado IN ('outgoing', 'mixed')
LIMIT 5;

-- Obra Sur - 35 movimientos
INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, ubicacion, timestamp, fecha, camion_nombre, camion_patente) 
SELECT 
  '22222222-2222-2222-2222-222222222222',
  c.id,
  '0acd45e7-0adb-4deb-9974-7b62624ec930',
  'incoming',
  c.capacidad,
  'Hormigón',
  'Nave 1',
  NOW() - (random() * interval '10 hours'),
  CURRENT_DATE,
  c.nombre,
  c.patente
FROM camiones c
WHERE c.obra_id = '22222222-2222-2222-2222-222222222222' AND c.tipo_registrado IN ('incoming', 'mixed')
LIMIT 25;

INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, ubicacion, timestamp, fecha, camion_nombre, camion_patente) 
SELECT 
  '22222222-2222-2222-2222-222222222222',
  c.id,
  '0acd45e7-0adb-4deb-9974-7b62624ec930',
  'outgoing',
  c.capacidad,
  'Escombros',
  'Nave 2',
  NOW() - (random() * interval '10 hours'),
  CURRENT_DATE,
  c.nombre,
  c.patente
FROM camiones c
WHERE c.obra_id = '22222222-2222-2222-2222-222222222222' AND c.tipo_registrado IN ('outgoing', 'mixed')
LIMIT 10;

-- Obra Centro - 15 movimientos
INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, ubicacion, timestamp, fecha, camion_nombre, camion_patente) 
SELECT 
  '33333333-3333-3333-3333-333333333333',
  c.id,
  '3a677477-7cfa-43f1-b755-00663eabc887',
  'incoming',
  c.capacidad,
  'Hormigón premezclado',
  'Piso 3',
  NOW() - (random() * interval '6 hours'),
  CURRENT_DATE,
  c.nombre,
  c.patente
FROM camiones c
WHERE c.obra_id = '33333333-3333-3333-3333-333333333333' AND c.tipo_registrado IN ('incoming', 'mixed')
LIMIT 10;

INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, ubicacion, timestamp, fecha, camion_nombre, camion_patente) 
SELECT 
  '33333333-3333-3333-3333-333333333333',
  c.id,
  '3a677477-7cfa-43f1-b755-00663eabc887',
  'outgoing',
  c.capacidad,
  'Escombros',
  'Sótano',
  NOW() - (random() * interval '6 hours'),
  CURRENT_DATE,
  c.nombre,
  c.patente
FROM camiones c
WHERE c.obra_id = '33333333-3333-3333-3333-333333333333' AND c.tipo_registrado IN ('outgoing', 'mixed')
LIMIT 5;
