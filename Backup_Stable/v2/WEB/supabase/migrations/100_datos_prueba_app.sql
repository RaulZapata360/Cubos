-- ============================================
-- DATOS DE PRUEBA BASADOS EN ESTRUCTURA REAL
-- ============================================
-- Generado a partir de datos reales capturados de la app
-- Fecha: 22-26 Diciembre 2024

-- ============================================
-- 1. CREAR OBRAS
-- ============================================

INSERT INTO obras (id, nombre, ubicacion, descripcion, fecha_inicio, estado) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Aeroparque', 'Torreones', 'Proyecto residencial', '2024-12-15', 'activa'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'VAIN', 'Chiguayante', 'Extracción de arena', '2024-12-10', 'activa'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Azul', 'Collao', 'Obra de infraestructura', '2024-12-18', 'activa')
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
-- 3. CREAR MATERIALES (8 por obra)
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
-- 5. CREAR CAMIONES
-- ============================================

-- Aeroparque: 10 camiones
INSERT INTO camiones (obra_id, nombre, patente, capacidad, tipo_registrado) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 1', 'AB1234', 15.0, 'outgoing'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 2', 'CD5678', 18.0, 'outgoing'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 3', 'EF9012', 15.0, 'outgoing'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 4', 'GH3456', 18.0, 'outgoing'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 5', 'IJ7890', 15.0, 'outgoing'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 6', 'KL1234', 18.0, 'outgoing'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 7', 'MN5678', 15.0, 'outgoing'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 8', 'OP9012', 18.0, 'mixed'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 9', 'QR3456', 15.0, 'mixed'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 10', 'ST7890', 18.0, 'mixed');

-- VAIN: 6 tolvas
INSERT INTO camiones (obra_id, nombre, patente, capacidad, tipo_registrado) VALUES
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 1', 'UV1234', 20.0, 'outgoing'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 2', 'WX5678', 18.0, 'outgoing'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 3', 'YZ9012', 20.0, 'outgoing'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 4', 'AA3456', 18.0, 'outgoing'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 5', 'BB7890', 20.0, 'outgoing'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 6', 'CC1234', 18.0, 'outgoing');

-- Azul: 5 camiones
INSERT INTO camiones (obra_id, nombre, patente, capacidad, tipo_registrado) VALUES
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Mixer 1', 'DD1234', 12.0, 'incoming'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Mixer 2', 'EE5678', 15.0, 'incoming'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Mixer 3', 'FF9012', 12.0, 'incoming'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Mixer 4', 'GG3456', 15.0, 'incoming'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Tolva Basura', 'HH7890', 18.0, 'outgoing');

-- ============================================
-- 6. GENERAR MOVIMIENTOS (22-26 Diciembre)
-- ============================================
-- IMPORTANTE: Campos que se guardan:
-- obra_id, camion_id, usuario_id, tipo, capacidad, material, timestamp, fecha, destino
-- ubicacion, camion_nombre, camion_patente quedan NULL

-- Lunes 22/12/2024 - Aeroparque (21 movimientos)
INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, timestamp, fecha, destino)
SELECT 
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  c.id,
  'c2fcf75d-bb0b-467e-918a-4220154fca85',
  'outgoing',
  c.capacidad,
  'Arcilla',
  '2024-12-22 08:00:00'::timestamp + (ROW_NUMBER() OVER () * interval '40 minutes'),
  '2024-12-22',
  'Botadero Rotonda'
FROM camiones c
WHERE c.obra_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' AND c.tipo_registrado IN ('outgoing', 'mixed')
LIMIT 20;

-- Último movimiento de Aeroparque es incoming
INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, timestamp, fecha, destino)
SELECT 
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  c.id,
  'c2fcf75d-bb0b-467e-918a-4220154fca85',
  'incoming',
  c.capacidad,
  'Base estabilizada',
  '2024-12-22 21:20:00',
  '2024-12-22',
  'Sector A'
FROM camiones c
WHERE c.obra_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' AND c.tipo_registrado = 'mixed'
LIMIT 1;

-- VAIN (6 movimientos)
INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, timestamp, fecha, destino)
SELECT 
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
  c.id,
  '0acd45e7-0adb-4deb-9974-7b62624ec930',
  'outgoing',
  c.capacidad,
  'Arena',
  '2024-12-22 08:00:00'::timestamp + (ROW_NUMBER() OVER () * interval '55 minutes'),
  '2024-12-22',
  'Botadero Rotonda'
FROM camiones c
WHERE c.obra_id = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'
LIMIT 6;

-- Azul (15 movimientos)
INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, timestamp, fecha, destino)
SELECT 
  'cccccccc-cccc-cccc-cccc-cccccccccccc',
  c.id,
  '3a677477-7cfa-43f1-b755-00663eabc887',
  'incoming',
  c.capacidad,
  CASE WHEN ROW_NUMBER() OVER () % 2 = 0 THEN 'Base estabilizada' ELSE 'Grava' END,
  '2024-12-22 08:00:00'::timestamp + (ROW_NUMBER() OVER () * interval '75 minutes'),
  '2024-12-22',
  CASE WHEN ROW_NUMBER() OVER () % 2 = 0 THEN 'Sector Norte' ELSE 'Sector Sur' END
FROM camiones c
WHERE c.obra_id = 'cccccccc-cccc-cccc-cccc-cccccccccccc' AND c.tipo_registrado = 'incoming'
LIMIT 10;

-- Azul - Basura (5 movimientos)
INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, timestamp, fecha, destino)
SELECT 
  'cccccccc-cccc-cccc-cccc-cccccccccccc',
  c.id,
  '3a677477-7cfa-43f1-b755-00663eabc887',
  'outgoing',
  c.capacidad,
  'Basura',
  '2024-12-22 10:00:00'::timestamp + (ROW_NUMBER() OVER () * interval '80 minutes'),
  '2024-12-22',
  'Jaime Repullo'
FROM camiones c
WHERE c.obra_id = 'cccccccc-cccc-cccc-cccc-cccccccccccc' AND c.tipo_registrado = 'outgoing'
LIMIT 5;

-- ============================================
-- VERIFICACIÓN
-- ============================================

SELECT 
  o.nombre as obra,
  COUNT(DISTINCT c.id) as camiones,
  COUNT(DISTINCT d.id) as destinos,
  COUNT(m.id) as movimientos,
  SUM(CASE WHEN m.tipo = 'incoming' THEN m.capacidad ELSE 0 END) as vol_entrada,
  SUM(CASE WHEN m.tipo = 'outgoing' THEN m.capacidad ELSE 0 END) as vol_salida
FROM obras o
LEFT JOIN camiones c ON c.obra_id = o.id
LEFT JOIN destinos d ON d.obra_id = o.id
LEFT JOIN movimientos m ON m.obra_id = o.id AND m.fecha = '2024-12-22'
WHERE o.id IN ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cccccccc-cccc-cccc-cccc-cccccccccccc')
GROUP BY o.nombre
ORDER BY o.nombre;
