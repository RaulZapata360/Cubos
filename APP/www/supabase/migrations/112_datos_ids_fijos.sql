-- ============================================
-- DATOS DE PRUEBA CON IDs FIJOS
-- ============================================
-- Los camiones ahora tienen IDs fijos para que los movimientos puedan referenciarlos

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
  ('ca000001-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 1', 'AB1234', 15.0, 'outgoing'),
  ('ca000002-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 2', 'CD5678', 18.0, 'outgoing'),
  ('ca000003-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 3', 'EF9012', 15.0, 'outgoing'),
  ('ca000004-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 4', 'GH3456', 18.0, 'outgoing'),
  ('ca000005-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 5', 'IJ7890', 15.0, 'outgoing'),
  ('ca000006-0000-0000-0000-000000000006', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 6', 'KL1234', 18.0, 'outgoing'),
  ('ca000007-0000-0000-0000-000000000007', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 7', 'MN5678', 15.0, 'outgoing'),
  ('ca000008-0000-0000-0000-000000000008', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 8', 'OP9012', 18.0, 'mixed'),
  ('ca000009-0000-0000-0000-000000000009', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 9', 'QR3456', 15.0, 'mixed'),
  ('ca00000a-0000-0000-0000-00000000000a', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 10', 'ST7890', 18.0, 'mixed')
ON CONFLICT (id) DO NOTHING;

-- VAIN: 6 tolvas
INSERT INTO camiones (id, obra_id, nombre, patente, capacidad, tipo_registrado) VALUES
  ('cb000001-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 1', 'UV1234', 20.0, 'outgoing'),
  ('cb000002-0000-0000-0000-000000000002', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 2', 'WX5678', 18.0, 'outgoing'),
  ('cb000003-0000-0000-0000-000000000003', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 3', 'YZ9012', 20.0, 'outgoing'),
  ('cb000004-0000-0000-0000-000000000004', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 4', 'AA3456', 18.0, 'outgoing'),
  ('cb000005-0000-0000-0000-000000000005', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 5', 'BB7890', 20.0, 'outgoing'),
  ('cb000006-0000-0000-0000-000000000006', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 6', 'CC1234', 18.0, 'outgoing')
ON CONFLICT (id) DO NOTHING;

-- Azul: 5 camiones
INSERT INTO camiones (id, obra_id, nombre, patente, capacidad, tipo_registrado) VALUES
  ('cc000001-0000-0000-0000-000000000001', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Mixer 1', 'DD1234', 12.0, 'incoming'),
  ('cc000002-0000-0000-0000-000000000002', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Mixer 2', 'EE5678', 15.0, 'incoming'),
  ('cc000003-0000-0000-0000-000000000003', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Mixer 3', 'FF9012', 12.0, 'incoming'),
  ('cc000004-0000-0000-0000-000000000004', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Mixer 4', 'GG3456', 15.0, 'incoming'),
  ('cc000005-0000-0000-0000-000000000005', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Tolva Basura', 'HH7890', 18.0, 'outgoing')
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- 6. CREAR MOVIMIENTOS (22 Dic 2024)
-- ============================================

-- Aeroparque (20 outgoing + 1 incoming)
INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, ubicacion, timestamp, fecha, destino) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000001-0000-0000-0000-000000000001', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-22 08:00:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000002-0000-0000-0000-000000000002', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-22 08:40:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000003-0000-0000-0000-000000000003', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-22 09:20:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000004-0000-0000-0000-000000000004', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-22 10:00:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000005-0000-0000-0000-000000000005', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-22 10:40:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000006-0000-0000-0000-000000000006', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-22 11:20:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000007-0000-0000-0000-000000000007', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-22 12:00:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000001-0000-0000-0000-000000000001', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-22 12:40:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000002-0000-0000-0000-000000000002', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-22 13:20:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000003-0000-0000-0000-000000000003', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 15.0, 'Arcilla', '', '2025-12-22 14:00:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000004-0000-0000-0000-000000000004', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'outgoing', 18.0, 'Arcilla', '', '2025-12-22 14:40:00', '2025-12-22', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ca000008-0000-0000-0000-000000000008', 'c2fcf75d-bb0b-467e-918a-4220154fca85', 'incoming', 18.0, 'Base estabilizada', '', '2025-12-22 21:20:00', '2025-12-22', 'Sector A');

-- VAIN (6 movimientos)
INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, ubicacion, timestamp, fecha, destino) VALUES
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000001-0000-0000-0000-000000000001', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 20.0, 'Arena', '', '2025-12-22 08:00:00', '2025-12-22', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000002-0000-0000-0000-000000000002', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 18.0, 'Arena', '', '2025-12-22 08:55:00', '2025-12-22', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000003-0000-0000-0000-000000000003', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 20.0, 'Arena', '', '2025-12-22 09:50:00', '2025-12-22', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000004-0000-0000-0000-000000000004', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 18.0, 'Arena', '', '2025-12-22 10:45:00', '2025-12-22', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000005-0000-0000-0000-000000000005', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 20.0, 'Arena', '', '2025-12-22 11:40:00', '2025-12-22', 'Botadero Rotonda'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cb000006-0000-0000-0000-000000000006', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', 18.0, 'Arena', '', '2025-12-22 12:35:00', '2025-12-22', 'Botadero Rotonda');

-- Azul (10 incoming + 5 outgoing)
INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, ubicacion, timestamp, fecha, destino) VALUES
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000001-0000-0000-0000-000000000001', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 12.0, 'Grava', '', '2025-12-22 08:00:00', '2025-12-22', 'Sector Sur'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000002-0000-0000-0000-000000000002', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 15.0, 'Base estabilizada', '', '2025-12-22 09:15:00', '2025-12-22', 'Sector Norte'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000003-0000-0000-0000-000000000003', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 12.0, 'Grava', '', '2025-12-22 10:30:00', '2025-12-22', 'Sector Sur'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000004-0000-0000-0000-000000000004', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 15.0, 'Base estabilizada', '', '2025-12-22 11:45:00', '2025-12-22', 'Sector Norte'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000001-0000-0000-0000-000000000001', '3a677477-7cfa-43f1-b755-00663eabc887', 'incoming', 12.0, 'Grava', '', '2025-12-22 13:00:00', '2025-12-22', 'Sector Sur'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000005-0000-0000-0000-000000000005', '3a677477-7cfa-43f1-b755-00663eabc887', 'outgoing', 18.0, 'Basura', '', '2025-12-22 10:00:00', '2025-12-22', 'Jaime Repullo'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000005-0000-0000-0000-000000000005', '3a677477-7cfa-43f1-b755-00663eabc887', 'outgoing', 18.0, 'Basura', '', '2025-12-22 11:20:00', '2025-12-22', 'Jaime Repullo'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'cc000005-0000-0000-0000-000000000005', '3a677477-7cfa-43f1-b755-00663eabc887', 'outgoing', 18.0, 'Basura', '', '2025-12-22 12:40:00', '2025-12-22', 'Jaime Repullo');

-- ============================================
-- VERIFICACIÓN
-- ============================================

SELECT 
  o.nombre as obra,
  COUNT(DISTINCT c.id) as camiones,
  COUNT(m.id) as movimientos,
  ROUND(SUM(CASE WHEN m.tipo = 'incoming' THEN m.capacidad ELSE 0 END), 2) as vol_entrada,
  ROUND(SUM(CASE WHEN m.tipo = 'outgoing' THEN m.capacidad ELSE 0 END), 2) as vol_salida
FROM obras o
LEFT JOIN camiones c ON c.obra_id = o.id
LEFT JOIN movimientos m ON m.obra_id = o.id AND m.fecha = '2025-12-22'
WHERE o.id IN ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cccccccc-cccc-cccc-cccc-cccccccccccc')
GROUP BY o.nombre
ORDER BY o.nombre;
