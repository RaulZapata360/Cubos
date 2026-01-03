-- ============================================
-- DATOS REALISTAS PERÍODO 15-30 DIC 2025
-- ============================================
-- Generado con variabilidad y casos extraordinarios
-- 3 obras: Aeroparque, VAIN, Azul
-- Horario: Lunes a Viernes, 8am-6pm

-- ============================================
-- CONFIGURACIÓN INICIAL
-- ============================================

-- Limpiar datos existentes del período
DELETE FROM movimientos WHERE fecha BETWEEN '2025-12-15' AND '2025-12-30';

-- ============================================
-- OBRAS Y CONFIGURACIÓN
-- ============================================

INSERT INTO obras (id, nombre, ubicacion, descripcion, fecha_inicio, estado) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Aeroparque', 'Torreones', 'Proyecto residencial', '2025-12-01', 'activa'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'VAIN', 'Chiguayante', 'Extracción de arena', '2025-12-01', 'activa'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Azul', 'Collao', 'Obra de infraestructura', '2025-12-01', 'activa')
ON CONFLICT (id) DO UPDATE SET
  nombre = EXCLUDED.nombre,
  ubicacion = EXCLUDED.ubicacion,
  estado = EXCLUDED.estado;

-- Asignar contadores
INSERT INTO usuario_obra (usuario_id, obra_id) VALUES
  ('c2fcf75d-bb0b-467e-918a-4220154fca85', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
  ('0acd45e7-0adb-4deb-9974-7b62624ec930', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'),
  ('3a677477-7cfa-43f1-b755-00663eabc887', 'cccccccc-cccc-cccc-cccc-cccccccccccc')
ON CONFLICT DO NOTHING;

-- Materiales
INSERT INTO materiales (obra_id, nombre, tipo) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Arcilla', 'outgoing'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Tierra', 'outgoing'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Basura', 'outgoing'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Base estabilizada', 'incoming'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Ripio', 'incoming'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Arena', 'outgoing'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Grava', 'outgoing'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Base estabilizada', 'incoming'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Grava', 'incoming'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Basura', 'outgoing')
ON CONFLICT DO NOTHING;

-- Destinos
INSERT INTO destinos (obra_id, nombre) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Botadero Rotonda'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Jaime Repullo'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Botadero Rotonda'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Sector Norte'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Sector Sur')
ON CONFLICT DO NOTHING;

-- Camiones Aeroparque (10 camiones)
INSERT INTO camiones (id, obra_id, nombre, patente, capacidad, tipo_registrado) VALUES
  ('ca000001-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 1', 'AB1231', 15.0, 'outgoing'),
  ('ca000002-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 2', 'AB1232', 18.0, 'outgoing'),
  ('ca000003-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 3', 'AB1233', 15.0, 'outgoing'),
  ('ca000004-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 4', 'AB1234', 18.0, 'outgoing'),
  ('ca000005-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 5', 'AB1235', 15.0, 'outgoing'),
  ('ca000006-0000-0000-0000-000000000006', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 6', 'AB1236', 18.0, 'mixed'),
  ('ca000007-0000-0000-0000-000000000007', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 7', 'AB1237', 15.0, 'mixed'),
  ('ca000008-0000-0000-0000-000000000008', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 8', 'AB1238', 18.0, 'mixed'),
  ('ca000009-0000-0000-0000-000000000009', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 9', 'AB1239', 15.0, 'outgoing'),
  ('ca00000a-0000-0000-0000-00000000000a', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Camión 10', 'AB1240', 18.0, 'outgoing')
ON CONFLICT (id) DO NOTHING;

-- Camiones VAIN (6 tolvas)
INSERT INTO camiones (id, obra_id, nombre, patente, capacidad, tipo_registrado) VALUES
  ('cb000001-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 1', 'UV1231', 20.0, 'outgoing'),
  ('cb000002-0000-0000-0000-000000000002', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 2', 'UV1232', 18.0, 'outgoing'),
  ('cb000003-0000-0000-0000-000000000003', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 3', 'UV1233', 20.0, 'outgoing'),
  ('cb000004-0000-0000-0000-000000000004', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 4', 'UV1234', 18.0, 'outgoing'),
  ('cb000005-0000-0000-0000-000000000005', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 5', 'UV1235', 20.0, 'outgoing'),
  ('cb000006-0000-0000-0000-000000000006', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tolva 6', 'UV1236', 18.0, 'outgoing')
ON CONFLICT (id) DO NOTHING;

-- Camiones Azul (5 mixers)
INSERT INTO camiones (id, obra_id, nombre, patente, capacidad, tipo_registrado) VALUES
  ('cc000001-0000-0000-0000-000000000001', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Mixer 1', 'DD1231', 12.0, 'incoming'),
  ('cc000002-0000-0000-0000-000000000002', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Mixer 2', 'DD1232', 15.0, 'incoming'),
  ('cc000003-0000-0000-0000-000000000003', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Mixer 3', 'DD1233', 12.0, 'incoming'),
  ('cc000004-0000-0000-0000-000000000004', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Mixer 4', 'DD1234', 15.0, 'incoming'),
  ('cc000005-0000-0000-0000-000000000005', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Tolva Basura', 'DD1235', 18.0, 'outgoing')
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- DATOS DINÁMICOS CON PYTHON
-- ============================================
-- NOTA: Este archivo debe ser ejecutado junto con el script Python
-- que genera los datos de manera dinámica y realista.
-- Ver: generate_realistic_data.py

-- Verificación de datos insertados
SELECT 
  fecha,
  COUNT(*) as movimientos,
  SUM(CASE WHEN tipo = 'incoming' THEN capacidad ELSE 0 END) as vol_entrada,
  SUM(CASE WHEN tipo = 'outgoing' THEN capacidad ELSE 0 END) as vol_salida
FROM movimientos
WHERE fecha BETWEEN '2025-12-15' AND '2025-12-30'
GROUP BY fecha
ORDER BY fecha;
