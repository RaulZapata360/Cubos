-- ============================================
-- DATOS REALISTAS SEMANA COMPLETA (22-26 DIC 2025)
-- ============================================
-- Generado automáticamente con datos realistas

-- ============================================
-- 1. CREAR OBRAS
-- ============================================

INSERT INTO obras (id, nombre, ubicacion, descripcion, fecha_inicio, estado) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Aeroparque', 'Torreones', 'Proyecto residencial', '2025-12-15', 'activa'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'VAIN', 'Chiguayante', 'Extracción de arena', '2025-12-10', 'activa'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Azul', 'Collao', 'Obra de infraestructura', '2025-12-18', 'activa')
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- 2. ASIGNAR CONTADORES
-- ============================================

INSERT INTO usuario_obra (usuario_id, obra_id) VALUES
  ('c2fcf75d-bb0b-467e-918a-4220154fca85', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
  ('0acd45e7-0adb-4deb-9974-7b62624ec930', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'),
  ('3a677477-7cfa-43f1-b755-00663eabc887', 'cccccccc-cccc-cccc-cccc-cccccccccccc')
ON CONFLICT (usuario_id, obra_id) DO NOTHING;

-- ============================================
-- 3. CREAR MATERIALES
-- ============================================

-- Aeroparque
INSERT INTO materiales (obra_id, nombre, tipo) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Arena', 'incoming'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Ripio', 'incoming'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Base estabilizada', 'incoming'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Grava', 'incoming'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Arena', 'outgoing'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Arcilla', 'outgoing'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Tierra', 'outgoing'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Basura', 'outgoing')
ON CONFLICT (obra_id, nombre, tipo) DO NOTHING;

-- VAIN
INSERT INTO materiales (obra_id, nombre, tipo) VALUES
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Arena', 'incoming'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Ripio', 'incoming'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Base estabilizada', 'incoming'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Grava', 'incoming'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Arena', 'outgoing'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Arcilla', 'outgoing'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tierra', 'outgoing'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Basura', 'outgoing')
ON CONFLICT (obra_id, nombre, tipo) DO NOTHING;

-- Azul
INSERT INTO materiales (obra_id, nombre, tipo) VALUES
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Arena', 'incoming'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Ripio', 'incoming'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Base estabilizada', 'incoming'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Grava', 'incoming'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Arena', 'outgoing'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Arcilla', 'outgoing'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Tierra', 'outgoing'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Basura', 'outgoing')
ON CONFLICT (obra_id, nombre, tipo) DO NOTHING;

-- ============================================
-- 4. CREAR DESTINOS
-- ============================================

INSERT INTO destinos (obra_id, nombre) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Jaime Repullo'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Botadero Rotonda'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Jaime Repullo'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Sector Norte'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Sector Sur')
ON CONFLICT (obra_id, nombre) DO NOTHING;

-- ============================================
-- 5. CREAR CAMIONES CON IDs FIJOS
-- ============================================

-- Aeroparque: 10 camiones
INSERT INTO camiones (id, obra_id, nombre, patente, capacidad, tipo_registrado) VALUES
  ('ca000001-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 1', 'AB1231', 15.0, 'outgoing'),
  ('ca000002-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 2', 'AB1232', 18.0, 'outgoing'),
  ('ca000003-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 3', 'AB1233', 15.0, 'outgoing'),
  ('ca000004-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 4', 'AB1234', 18.0, 'outgoing'),
  ('ca000005-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 5', 'AB1235', 15.0, 'outgoing'),
  ('ca000006-0000-0000-0000-000000000006', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 6', 'AB1236', 18.0, 'outgoing'),
  ('ca000007-0000-0000-0000-000000000007', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 7', 'AB1237', 15.0, 'outgoing'),
  ('ca000008-0000-0000-0000-000000000008', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 8', 'AB1238', 18.0, 'mixed'),
  ('ca000009-0000-0000-0000-000000000009', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 9', 'AB1239', 15.0, 'mixed'),
  ('ca00000a-0000-0000-0000-00000000000a', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 10', 'AB1240', 18.0, 'mixed')
ON CONFLICT (id) DO NOTHING;

-- VAIN: 6 tolvas
INSERT INTO camiones (id, obra_id, nombre, patente, capacidad, tipo_registrado) VALUES
  ('cb000001-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 1', 'UV1231', 20.0, 'outgoing'),
  ('cb000002-0000-0000-0000-000000000002', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 2', 'UV1232', 18.0, 'outgoing'),
  ('cb000003-0000-0000-0000-000000000003', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 3', 'UV1233', 20.0, 'outgoing'),
  ('cb000004-0000-0000-0000-000000000004', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 4', 'UV1234', 18.0, 'outgoing'),
  ('cb000005-0000-0000-0000-000000000005', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 5', 'UV1235', 20.0, 'outgoing'),
  ('cb000006-0000-0000-0000-000000000006', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 6', 'UV1236', 18.0, 'outgoing')
ON CONFLICT (id) DO NOTHING;

-- Azul: 5 camiones
INSERT INTO camiones (id, obra_id, nombre, patente, capacidad, tipo_registrado) VALUES
  ('cc000001-0000-0000-0000-000000000001', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Mixer 1', 'DD1231', 12.0, 'incoming'),
  ('cc000002-0000-0000-0000-000000000002', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Mixer 2', 'DD1232', 15.0, 'incoming'),
  ('cc000003-0000-0000-0000-000000000003', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Mixer 3', 'DD1233', 12.0, 'incoming'),
  ('cc000004-0000-0000-0000-000000000004', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Mixer 4', 'DD1234', 15.0, 'incoming'),
  ('cc000005-0000-0000-0000-000000000005', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Tolva Basura', 'DD1235', 18.0, 'outgoing')
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- 6. GENERAR MOVIMIENTOS (22-26 DIC 2025)
-- ============================================

-- Lunes 22/12/2025
INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, ubicacion, timestamp, fecha, destino) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000001-0000-0000-0000-000000000001', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-22 08:00:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000002-0000-0000-0000-000000000002', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-22 08:40:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000003-0000-0000-0000-000000000003', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-22 09:20:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000004-0000-0000-0000-000000000004', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-22 10:00:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000005-0000-0000-0000-000000000005', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-22 10:40:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000006-0000-0000-0000-000000000006', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-22 11:20:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000007-0000-0000-0000-000000000007', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-22 12:00:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000008-0000-0000-0000-000000000008', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-22 12:40:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000009-0000-0000-0000-000000000009', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-22 13:20:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca00000a-0000-0000-0000-00000000000a', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-22 14:00:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000001-0000-0000-0000-000000000001', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-22 14:40:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000002-0000-0000-0000-000000000002', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-22 15:20:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000003-0000-0000-0000-000000000003', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-22 16:00:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000004-0000-0000-0000-000000000004', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-22 16:40:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000005-0000-0000-0000-000000000005', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-22 17:20:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000006-0000-0000-0000-000000000006', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-22 18:00:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000007-0000-0000-0000-000000000007', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-22 18:40:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000008-0000-0000-0000-000000000008', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-22 19:20:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000009-0000-0000-0000-000000000009', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-22 20:00:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca00000a-0000-0000-0000-00000000000a', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-22 20:40:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000001-0000-0000-0000-000000000001', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Basura', '', '2025-12-22 21:20:00', '2025-12-22', 'Jaime Repullo'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000001-0000-0000-0000-000000000001', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 20.0, 'Arena', '', '2025-12-22 08:00:00', '2025-12-22', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000002-0000-0000-0000-000000000002', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 18.0, 'Arena', '', '2025-12-22 08:55:00', '2025-12-22', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000003-0000-0000-0000-000000000003', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 20.0, 'Arena', '', '2025-12-22 09:50:00', '2025-12-22', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000004-0000-0000-0000-000000000004', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 18.0, 'Arena', '', '2025-12-22 10:45:00', '2025-12-22', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000005-0000-0000-0000-000000000005', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 20.0, 'Arena', '', '2025-12-22 11:40:00', '2025-12-22', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000006-0000-0000-0000-000000000006', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 18.0, 'Arena', '', '2025-12-22 12:35:00', '2025-12-22', 'Botadero Rotonda'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000001-0000-0000-0000-000000000001', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 12.0, 'Base estabilizada', '', '2025-12-22 08:00:00', '2025-12-22', 'Sector Norte'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000002-0000-0000-0000-000000000002', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 15.0, 'Grava', '', '2025-12-22 09:15:00', '2025-12-22', 'Sector Sur'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000003-0000-0000-0000-000000000003', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 12.0, 'Base estabilizada', '', '2025-12-22 10:30:00', '2025-12-22', 'Sector Norte'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000004-0000-0000-0000-000000000004', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 15.0, 'Grava', '', '2025-12-22 11:45:00', '2025-12-22', 'Sector Sur'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000001-0000-0000-0000-000000000001', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 12.0, 'Base estabilizada', '', '2025-12-22 13:00:00', '2025-12-22', 'Sector Norte'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000002-0000-0000-0000-000000000002', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 15.0, 'Grava', '', '2025-12-22 14:15:00', '2025-12-22', 'Sector Sur'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000003-0000-0000-0000-000000000003', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 12.0, 'Base estabilizada', '', '2025-12-22 15:30:00', '2025-12-22', 'Sector Norte'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000005-0000-0000-0000-000000000005', '3a677477-7cfa-43f1-b755-00663eabc887', 'outgoing', 18.0, 'Basura', '', '2025-12-22 10:00:00', '2025-12-22', 'Jaime Repullo'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000005-0000-0000-0000-000000000005', '3a677477-7cfa-43f1-b755-00663eabc887', 'outgoing', 18.0, 'Basura', '', '2025-12-22 11:20:00', '2025-12-22', 'Jaime Repullo'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000005-0000-0000-0000-000000000005', '3a677477-7cfa-43f1-b755-00663eabc887', 'outgoing', 18.0, 'Basura', '', '2025-12-22 12:40:00', '2025-12-22', 'Jaime Repullo'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000005-0000-0000-0000-000000000005', '3a677477-7cfa-43f1-b755-00663eabc887', 'outgoing', 18.0, 'Basura', '', '2025-12-22 14:00:00', '2025-12-22', 'Jaime Repullo'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000005-0000-0000-0000-000000000005', '3a677477-7cfa-43f1-b755-00663eabc887', 'outgoing', 18.0, 'Basura', '', '2025-12-22 15:20:00', '2025-12-22', 'Jaime Repullo');

-- Martes 23/12/2025
INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, ubicacion, timestamp, fecha, destino) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000001-0000-0000-0000-000000000001', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-23 08:00:00', '2025-12-23', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000002-0000-0000-0000-000000000002', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-23 08:40:00', '2025-12-23', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000003-0000-0000-0000-000000000003', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-23 09:20:00', '2025-12-23', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000004-0000-0000-0000-000000000004', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-23 10:00:00', '2025-12-23', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000005-0000-0000-0000-000000000005', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-23 10:40:00', '2025-12-23', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000006-0000-0000-0000-000000000006', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-23 11:20:00', '2025-12-23', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000007-0000-0000-0000-000000000007', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-23 12:00:00', '2025-12-23', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000008-0000-0000-0000-000000000008', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-23 12:40:00', '2025-12-23', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000009-0000-0000-0000-000000000009', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-23 13:20:00', '2025-12-23', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca00000a-0000-0000-0000-00000000000a', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-23 14:00:00', '2025-12-23', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000001-0000-0000-0000-000000000001', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-23 14:40:00', '2025-12-23', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000002-0000-0000-0000-000000000002', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-23 15:20:00', '2025-12-23', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000003-0000-0000-0000-000000000003', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-23 16:00:00', '2025-12-23', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000004-0000-0000-0000-000000000004', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-23 16:40:00', '2025-12-23', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000005-0000-0000-0000-000000000005', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-23 17:20:00', '2025-12-23', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000006-0000-0000-0000-000000000006', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-23 18:00:00', '2025-12-23', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000007-0000-0000-0000-000000000007', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-23 18:40:00', '2025-12-23', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000008-0000-0000-0000-000000000008', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-23 19:20:00', '2025-12-23', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000009-0000-0000-0000-000000000009', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-23 20:00:00', '2025-12-23', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca00000a-0000-0000-0000-00000000000a', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-23 20:40:00', '2025-12-23', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000001-0000-0000-0000-000000000001', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Basura', '', '2025-12-23 21:20:00', '2025-12-23', 'Jaime Repullo'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000001-0000-0000-0000-000000000001', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 20.0, 'Arena', '', '2025-12-23 08:00:00', '2025-12-23', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000002-0000-0000-0000-000000000002', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 18.0, 'Arena', '', '2025-12-23 08:55:00', '2025-12-23', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000003-0000-0000-0000-000000000003', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 20.0, 'Arena', '', '2025-12-23 09:50:00', '2025-12-23', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000004-0000-0000-0000-000000000004', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 18.0, 'Arena', '', '2025-12-23 10:45:00', '2025-12-23', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000005-0000-0000-0000-000000000005', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 20.0, 'Arena', '', '2025-12-23 11:40:00', '2025-12-23', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000006-0000-0000-0000-000000000006', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 18.0, 'Arena', '', '2025-12-23 12:35:00', '2025-12-23', 'Botadero Rotonda'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000001-0000-0000-0000-000000000001', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 12.0, 'Base estabilizada', '', '2025-12-23 08:00:00', '2025-12-23', 'Sector Norte'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000002-0000-0000-0000-000000000002', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 15.0, 'Grava', '', '2025-12-23 09:15:00', '2025-12-23', 'Sector Sur'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000003-0000-0000-0000-000000000003', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 12.0, 'Base estabilizada', '', '2025-12-23 10:30:00', '2025-12-23', 'Sector Norte'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000004-0000-0000-0000-000000000004', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 15.0, 'Grava', '', '2025-12-23 11:45:00', '2025-12-23', 'Sector Sur'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000001-0000-0000-0000-000000000001', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 12.0, 'Base estabilizada', '', '2025-12-23 13:00:00', '2025-12-23', 'Sector Norte'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000002-0000-0000-0000-000000000002', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 15.0, 'Grava', '', '2025-12-23 14:15:00', '2025-12-23', 'Sector Sur'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000003-0000-0000-0000-000000000003', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 12.0, 'Base estabilizada', '', '2025-12-23 15:30:00', '2025-12-23', 'Sector Norte'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000005-0000-0000-0000-000000000005', '3a677477-7cfa-43f1-b755-00663eabc887', 'outgoing', 18.0, 'Basura', '', '2025-12-23 10:00:00', '2025-12-23', 'Jaime Repullo'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000005-0000-0000-0000-000000000005', '3a677477-7cfa-43f1-b755-00663eabc887', 'outgoing', 18.0, 'Basura', '', '2025-12-23 11:20:00', '2025-12-23', 'Jaime Repullo'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000005-0000-0000-0000-000000000005', '3a677477-7cfa-43f1-b755-00663eabc887', 'outgoing', 18.0, 'Basura', '', '2025-12-23 12:40:00', '2025-12-23', 'Jaime Repullo'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000005-0000-0000-0000-000000000005', '3a677477-7cfa-43f1-b755-00663eabc887', 'outgoing', 18.0, 'Basura', '', '2025-12-23 14:00:00', '2025-12-23', 'Jaime Repullo'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000005-0000-0000-0000-000000000005', '3a677477-7cfa-43f1-b755-00663eabc887', 'outgoing', 18.0, 'Basura', '', '2025-12-23 15:20:00', '2025-12-23', 'Jaime Repullo');

-- Miércoles 24/12/2025
INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, ubicacion, timestamp, fecha, destino) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000001-0000-0000-0000-000000000001', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-24 08:00:00', '2025-12-24', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000002-0000-0000-0000-000000000002', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-24 08:40:00', '2025-12-24', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000003-0000-0000-0000-000000000003', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-24 09:20:00', '2025-12-24', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000004-0000-0000-0000-000000000004', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-24 10:00:00', '2025-12-24', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000005-0000-0000-0000-000000000005', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-24 10:40:00', '2025-12-24', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000006-0000-0000-0000-000000000006', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-24 11:20:00', '2025-12-24', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000007-0000-0000-0000-000000000007', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-24 12:00:00', '2025-12-24', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000008-0000-0000-0000-000000000008', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-24 12:40:00', '2025-12-24', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000009-0000-0000-0000-000000000009', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-24 13:20:00', '2025-12-24', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca00000a-0000-0000-0000-00000000000a', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-24 14:00:00', '2025-12-24', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000001-0000-0000-0000-000000000001', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-24 14:40:00', '2025-12-24', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000002-0000-0000-0000-000000000002', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-24 15:20:00', '2025-12-24', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000003-0000-0000-0000-000000000003', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-24 16:00:00', '2025-12-24', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000004-0000-0000-0000-000000000004', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-24 16:40:00', '2025-12-24', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000005-0000-0000-0000-000000000005', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-24 17:20:00', '2025-12-24', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000006-0000-0000-0000-000000000006', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-24 18:00:00', '2025-12-24', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000007-0000-0000-0000-000000000007', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-24 18:40:00', '2025-12-24', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000008-0000-0000-0000-000000000008', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-24 19:20:00', '2025-12-24', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000009-0000-0000-0000-000000000009', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-24 20:00:00', '2025-12-24', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca00000a-0000-0000-0000-00000000000a', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-24 20:40:00', '2025-12-24', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000001-0000-0000-0000-000000000001', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Basura', '', '2025-12-24 21:20:00', '2025-12-24', 'Jaime Repullo'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000001-0000-0000-0000-000000000001', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 20.0, 'Arena', '', '2025-12-24 08:00:00', '2025-12-24', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000002-0000-0000-0000-000000000002', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 18.0, 'Arena', '', '2025-12-24 08:55:00', '2025-12-24', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000003-0000-0000-0000-000000000003', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 20.0, 'Arena', '', '2025-12-24 09:50:00', '2025-12-24', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000004-0000-0000-0000-000000000004', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 18.0, 'Arena', '', '2025-12-24 10:45:00', '2025-12-24', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000005-0000-0000-0000-000000000005', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 20.0, 'Arena', '', '2025-12-24 11:40:00', '2025-12-24', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000006-0000-0000-0000-000000000006', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 18.0, 'Arena', '', '2025-12-24 12:35:00', '2025-12-24', 'Botadero Rotonda'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000001-0000-0000-0000-000000000001', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 12.0, 'Base estabilizada', '', '2025-12-24 08:00:00', '2025-12-24', 'Sector Norte'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000002-0000-0000-0000-000000000002', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 15.0, 'Grava', '', '2025-12-24 09:15:00', '2025-12-24', 'Sector Sur'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000003-0000-0000-0000-000000000003', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 12.0, 'Base estabilizada', '', '2025-12-24 10:30:00', '2025-12-24', 'Sector Norte'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000004-0000-0000-0000-000000000004', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 15.0, 'Grava', '', '2025-12-24 11:45:00', '2025-12-24', 'Sector Sur'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000001-0000-0000-0000-000000000001', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 12.0, 'Base estabilizada', '', '2025-12-24 13:00:00', '2025-12-24', 'Sector Norte'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000002-0000-0000-0000-000000000002', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 15.0, 'Grava', '', '2025-12-24 14:15:00', '2025-12-24', 'Sector Sur'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000003-0000-0000-0000-000000000003', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 12.0, 'Base estabilizada', '', '2025-12-24 15:30:00', '2025-12-24', 'Sector Norte');

-- Jueves 25/12/2025
INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, ubicacion, timestamp, fecha, destino) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000001-0000-0000-0000-000000000001', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-25 08:00:00', '2025-12-25', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000002-0000-0000-0000-000000000002', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-25 08:40:00', '2025-12-25', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000003-0000-0000-0000-000000000003', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-25 09:20:00', '2025-12-25', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000004-0000-0000-0000-000000000004', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-25 10:00:00', '2025-12-25', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000005-0000-0000-0000-000000000005', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-25 10:40:00', '2025-12-25', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000006-0000-0000-0000-000000000006', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-25 11:20:00', '2025-12-25', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000007-0000-0000-0000-000000000007', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-25 12:00:00', '2025-12-25', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000008-0000-0000-0000-000000000008', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-25 12:40:00', '2025-12-25', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000009-0000-0000-0000-000000000009', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-25 13:20:00', '2025-12-25', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca00000a-0000-0000-0000-00000000000a', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-25 14:00:00', '2025-12-25', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000001-0000-0000-0000-000000000001', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-25 14:40:00', '2025-12-25', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000002-0000-0000-0000-000000000002', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-25 15:20:00', '2025-12-25', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000003-0000-0000-0000-000000000003', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-25 16:00:00', '2025-12-25', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000004-0000-0000-0000-000000000004', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-25 16:40:00', '2025-12-25', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000005-0000-0000-0000-000000000005', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-25 17:20:00', '2025-12-25', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000006-0000-0000-0000-000000000006', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-25 18:00:00', '2025-12-25', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000007-0000-0000-0000-000000000007', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-25 18:40:00', '2025-12-25', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000008-0000-0000-0000-000000000008', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-25 19:20:00', '2025-12-25', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000009-0000-0000-0000-000000000009', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-25 20:00:00', '2025-12-25', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca00000a-0000-0000-0000-00000000000a', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-25 20:40:00', '2025-12-25', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000001-0000-0000-0000-000000000001', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Basura', '', '2025-12-25 21:20:00', '2025-12-25', 'Jaime Repullo'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000008-0000-0000-0000-000000000008', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 18.0, 'Base estabilizada', '', '2025-12-25 09:00:00', '2025-12-25', 'Planta'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000009-0000-0000-0000-000000000009', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 15.0, 'Base estabilizada', '', '2025-12-25 09:40:00', '2025-12-25', 'Planta'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca00000a-0000-0000-0000-00000000000a', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 18.0, 'Base estabilizada', '', '2025-12-25 10:20:00', '2025-12-25', 'Planta'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000008-0000-0000-0000-000000000008', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 18.0, 'Base estabilizada', '', '2025-12-25 11:00:00', '2025-12-25', 'Planta'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000009-0000-0000-0000-000000000009', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 15.0, 'Base estabilizada', '', '2025-12-25 11:40:00', '2025-12-25', 'Planta'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca00000a-0000-0000-0000-00000000000a', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 18.0, 'Base estabilizada', '', '2025-12-25 12:20:00', '2025-12-25', 'Planta'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000008-0000-0000-0000-000000000008', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 18.0, 'Base estabilizada', '', '2025-12-25 13:00:00', '2025-12-25', 'Planta'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000009-0000-0000-0000-000000000009', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 15.0, 'Base estabilizada', '', '2025-12-25 13:40:00', '2025-12-25', 'Planta'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca00000a-0000-0000-0000-00000000000a', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 18.0, 'Base estabilizada', '', '2025-12-25 14:20:00', '2025-12-25', 'Planta'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000008-0000-0000-0000-000000000008', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 18.0, 'Base estabilizada', '', '2025-12-25 15:00:00', '2025-12-25', 'Planta'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000009-0000-0000-0000-000000000009', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 15.0, 'Base estabilizada', '', '2025-12-25 15:40:00', '2025-12-25', 'Planta'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca00000a-0000-0000-0000-00000000000a', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 18.0, 'Base estabilizada', '', '2025-12-25 16:20:00', '2025-12-25', 'Planta'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000001-0000-0000-0000-000000000001', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 20.0, 'Arena', '', '2025-12-25 08:00:00', '2025-12-25', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000002-0000-0000-0000-000000000002', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 18.0, 'Arena', '', '2025-12-25 08:55:00', '2025-12-25', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000003-0000-0000-0000-000000000003', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 20.0, 'Arena', '', '2025-12-25 09:50:00', '2025-12-25', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000004-0000-0000-0000-000000000004', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 18.0, 'Arena', '', '2025-12-25 10:45:00', '2025-12-25', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000005-0000-0000-0000-000000000005', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 20.0, 'Arena', '', '2025-12-25 11:40:00', '2025-12-25', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000006-0000-0000-0000-000000000006', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 18.0, 'Arena', '', '2025-12-25 12:35:00', '2025-12-25', 'Botadero Rotonda'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000001-0000-0000-0000-000000000001', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 12.0, 'Base estabilizada', '', '2025-12-25 08:00:00', '2025-12-25', 'Sector Norte'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000002-0000-0000-0000-000000000002', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 15.0, 'Grava', '', '2025-12-25 09:15:00', '2025-12-25', 'Sector Sur'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000003-0000-0000-0000-000000000003', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 12.0, 'Base estabilizada', '', '2025-12-25 10:30:00', '2025-12-25', 'Sector Norte'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000004-0000-0000-0000-000000000004', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 15.0, 'Grava', '', '2025-12-25 11:45:00', '2025-12-25', 'Sector Sur'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000001-0000-0000-0000-000000000001', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 12.0, 'Base estabilizada', '', '2025-12-25 13:00:00', '2025-12-25', 'Sector Norte'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000002-0000-0000-0000-000000000002', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 15.0, 'Grava', '', '2025-12-25 14:15:00', '2025-12-25', 'Sector Sur'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000003-0000-0000-0000-000000000003', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 12.0, 'Base estabilizada', '', '2025-12-25 15:30:00', '2025-12-25', 'Sector Norte'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000005-0000-0000-0000-000000000005', '3a677477-7cfa-43f1-b755-00663eabc887', 'outgoing', 18.0, 'Basura', '', '2025-12-25 10:00:00', '2025-12-25', 'Jaime Repullo'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000005-0000-0000-0000-000000000005', '3a677477-7cfa-43f1-b755-00663eabc887', 'outgoing', 18.0, 'Basura', '', '2025-12-25 11:20:00', '2025-12-25', 'Jaime Repullo'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000005-0000-0000-0000-000000000005', '3a677477-7cfa-43f1-b755-00663eabc887', 'outgoing', 18.0, 'Basura', '', '2025-12-25 12:40:00', '2025-12-25', 'Jaime Repullo'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000005-0000-0000-0000-000000000005', '3a677477-7cfa-43f1-b755-00663eabc887', 'outgoing', 18.0, 'Basura', '', '2025-12-25 14:00:00', '2025-12-25', 'Jaime Repullo'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000005-0000-0000-0000-000000000005', '3a677477-7cfa-43f1-b755-00663eabc887', 'outgoing', 18.0, 'Basura', '', '2025-12-25 15:20:00', '2025-12-25', 'Jaime Repullo');

-- Viernes 26/12/2025
INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, ubicacion, timestamp, fecha, destino) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000001-0000-0000-0000-000000000001', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-26 08:00:00', '2025-12-26', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000002-0000-0000-0000-000000000002', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-26 08:40:00', '2025-12-26', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000003-0000-0000-0000-000000000003', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-26 09:20:00', '2025-12-26', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000004-0000-0000-0000-000000000004', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-26 10:00:00', '2025-12-26', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000005-0000-0000-0000-000000000005', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-26 10:40:00', '2025-12-26', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000006-0000-0000-0000-000000000006', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-26 11:20:00', '2025-12-26', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000007-0000-0000-0000-000000000007', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-26 12:00:00', '2025-12-26', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000008-0000-0000-0000-000000000008', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-26 12:40:00', '2025-12-26', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000009-0000-0000-0000-000000000009', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-26 13:20:00', '2025-12-26', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca00000a-0000-0000-0000-00000000000a', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-26 14:00:00', '2025-12-26', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000001-0000-0000-0000-000000000001', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-26 14:40:00', '2025-12-26', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000002-0000-0000-0000-000000000002', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-26 15:20:00', '2025-12-26', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000003-0000-0000-0000-000000000003', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-26 16:00:00', '2025-12-26', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000004-0000-0000-0000-000000000004', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-26 16:40:00', '2025-12-26', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000005-0000-0000-0000-000000000005', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-26 17:20:00', '2025-12-26', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000006-0000-0000-0000-000000000006', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-26 18:00:00', '2025-12-26', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000007-0000-0000-0000-000000000007', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-26 18:40:00', '2025-12-26', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000008-0000-0000-0000-000000000008', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-26 19:20:00', '2025-12-26', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000009-0000-0000-0000-000000000009', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-26 20:00:00', '2025-12-26', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca00000a-0000-0000-0000-00000000000a', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-26 20:40:00', '2025-12-26', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000001-0000-0000-0000-000000000001', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Basura', '', '2025-12-26 21:20:00', '2025-12-26', 'Jaime Repullo'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000008-0000-0000-0000-000000000008', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 18.0, 'Base estabilizada', '', '2025-12-26 09:00:00', '2025-12-26', 'Planta'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000009-0000-0000-0000-000000000009', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 15.0, 'Base estabilizada', '', '2025-12-26 09:40:00', '2025-12-26', 'Planta'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca00000a-0000-0000-0000-00000000000a', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 18.0, 'Base estabilizada', '', '2025-12-26 10:20:00', '2025-12-26', 'Planta'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000008-0000-0000-0000-000000000008', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 18.0, 'Base estabilizada', '', '2025-12-26 11:00:00', '2025-12-26', 'Planta'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000009-0000-0000-0000-000000000009', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 15.0, 'Base estabilizada', '', '2025-12-26 11:40:00', '2025-12-26', 'Planta'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca00000a-0000-0000-0000-00000000000a', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 18.0, 'Base estabilizada', '', '2025-12-26 12:20:00', '2025-12-26', 'Planta'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000008-0000-0000-0000-000000000008', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 18.0, 'Base estabilizada', '', '2025-12-26 13:00:00', '2025-12-26', 'Planta'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000009-0000-0000-0000-000000000009', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 15.0, 'Base estabilizada', '', '2025-12-26 13:40:00', '2025-12-26', 'Planta'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca00000a-0000-0000-0000-00000000000a', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 18.0, 'Base estabilizada', '', '2025-12-26 14:20:00', '2025-12-26', 'Planta'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000008-0000-0000-0000-000000000008', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 18.0, 'Base estabilizada', '', '2025-12-26 15:00:00', '2025-12-26', 'Planta'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000009-0000-0000-0000-000000000009', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 15.0, 'Base estabilizada', '', '2025-12-26 15:40:00', '2025-12-26', 'Planta'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca00000a-0000-0000-0000-00000000000a', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 18.0, 'Base estabilizada', '', '2025-12-26 16:20:00', '2025-12-26', 'Planta'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000001-0000-0000-0000-000000000001', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 20.0, 'Arena', '', '2025-12-26 08:00:00', '2025-12-26', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000002-0000-0000-0000-000000000002', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 18.0, 'Arena', '', '2025-12-26 08:55:00', '2025-12-26', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000003-0000-0000-0000-000000000003', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 20.0, 'Arena', '', '2025-12-26 09:50:00', '2025-12-26', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000004-0000-0000-0000-000000000004', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 18.0, 'Arena', '', '2025-12-26 10:45:00', '2025-12-26', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000005-0000-0000-0000-000000000005', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 20.0, 'Arena', '', '2025-12-26 11:40:00', '2025-12-26', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000006-0000-0000-0000-000000000006', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 18.0, 'Arena', '', '2025-12-26 12:35:00', '2025-12-26', 'Botadero Rotonda'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000001-0000-0000-0000-000000000001', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 12.0, 'Base estabilizada', '', '2025-12-26 08:00:00', '2025-12-26', 'Sector Norte'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000002-0000-0000-0000-000000000002', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 15.0, 'Grava', '', '2025-12-26 09:15:00', '2025-12-26', 'Sector Sur'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000003-0000-0000-0000-000000000003', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 12.0, 'Base estabilizada', '', '2025-12-26 10:30:00', '2025-12-26', 'Sector Norte'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000004-0000-0000-0000-000000000004', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 15.0, 'Grava', '', '2025-12-26 11:45:00', '2025-12-26', 'Sector Sur'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000001-0000-0000-0000-000000000001', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 12.0, 'Base estabilizada', '', '2025-12-26 13:00:00', '2025-12-26', 'Sector Norte'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000002-0000-0000-0000-000000000002', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 15.0, 'Grava', '', '2025-12-26 14:15:00', '2025-12-26', 'Sector Sur'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000003-0000-0000-0000-000000000003', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 12.0, 'Base estabilizada', '', '2025-12-26 15:30:00', '2025-12-26', 'Sector Norte');

-- ============================================
-- VERIFICACIÓN
-- ============================================

-- Resumen por día
SELECT 
  fecha,
  COUNT(*) as movimientos,
  SUM(CASE WHEN tipo = 'incoming' THEN capacidad ELSE 0 END) as vol_entrada,
  SUM(CASE WHEN tipo = 'outgoing' THEN capacidad ELSE 0 END) as vol_salida
FROM movimientos
WHERE fecha BETWEEN '2025-12-22' AND '2025-12-26'
GROUP BY fecha
ORDER BY fecha;

-- Resumen por obra
SELECT 
  o.nombre,
  COUNT(m.id) as total_movimientos,
  ROUND(SUM(CASE WHEN m.tipo = 'incoming' THEN m.capacidad ELSE 0 END), 2) as vol_entrada,
  ROUND(SUM(CASE WHEN m.tipo = 'outgoing' THEN m.capacidad ELSE 0 END), 2) as vol_salida
FROM obras o
LEFT JOIN movimientos m ON m.obra_id = o.id
WHERE m.fecha BETWEEN '2025-12-22' AND '2025-12-26'
GROUP BY o.nombre
ORDER BY o.nombre;
