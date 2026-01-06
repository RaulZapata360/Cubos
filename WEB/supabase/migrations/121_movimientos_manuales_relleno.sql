-- Migration: Registro de movimientos (Relleno) para camiones ingresados manualmente
-- Fecha: 2026-01-05
-- Obra: 8 Oriente (c4af1af6-d35d-4e70-96a3-0d6172dbf701)

INSERT INTO "public"."movimientos" 
("obra_id", "camion_id", "usuario_id", "tipo", "capacidad", "material", "origen", "fecha", "timestamp") 
VALUES 
-- Willy Altamirano
('c4af1af6-d35d-4e70-96a3-0d6172dbf701', 'a7203471-01ed-4899-bfd9-c580d55522b3', 'fc5c6a1e-f1e2-468a-95fe-3283a39b7334', 'incoming', 17.50, 'Trumao (Arena)', 'Camilo H', '2026-01-05', '2026-01-05 10:35:00+00'),
('c4af1af6-d35d-4e70-96a3-0d6172dbf701', 'a7203471-01ed-4899-bfd9-c580d55522b3', 'fc5c6a1e-f1e2-468a-95fe-3283a39b7334', 'incoming', 17.50, 'Trumao (Arena)', 'Camilo H', '2026-01-05', '2026-01-05 12:05:00+00'),

-- Fernando Torres
('c4af1af6-d35d-4e70-96a3-0d6172dbf701', '159ccb29-eb03-4d33-86b1-74f56bb9c1fd', 'fc5c6a1e-f1e2-468a-95fe-3283a39b7334', 'incoming', 17.50, 'Trumao (Arena)', 'Camilo H', '2026-01-05', '2026-01-05 10:43:00+00'),
('c4af1af6-d35d-4e70-96a3-0d6172dbf701', '159ccb29-eb03-4d33-86b1-74f56bb9c1fd', 'fc5c6a1e-f1e2-468a-95fe-3283a39b7334', 'incoming', 17.50, 'Trumao (Arena)', 'Camilo H', '2026-01-05', '2026-01-05 12:04:00+00'),

-- Jose Riffo
('c4af1af6-d35d-4e70-96a3-0d6172dbf701', '43b2b73b-cdaa-4e90-abee-f488a49b6f85', 'fc5c6a1e-f1e2-468a-95fe-3283a39b7334', 'incoming', 17.50, 'Trumao (Arena)', 'Camilo H', '2026-01-05', '2026-01-05 10:49:00+00'),
('c4af1af6-d35d-4e70-96a3-0d6172dbf701', '43b2b73b-cdaa-4e90-abee-f488a49b6f85', 'fc5c6a1e-f1e2-468a-95fe-3283a39b7334', 'incoming', 17.50, 'Trumao (Arena)', 'Camilo H', '2026-01-05', '2026-01-05 12:10:00+00'),

-- Luiz Toledo
('c4af1af6-d35d-4e70-96a3-0d6172dbf701', 'b6342b66-12c3-4a3c-b2a1-e408fc700348', 'fc5c6a1e-f1e2-468a-95fe-3283a39b7334', 'incoming', 17.50, 'Trumao (Arena)', 'Camilo H', '2026-01-05', '2026-01-05 10:50:00+00'),
('c4af1af6-d35d-4e70-96a3-0d6172dbf701', 'b6342b66-12c3-4a3c-b2a1-e408fc700348', 'fc5c6a1e-f1e2-468a-95fe-3283a39b7334', 'incoming', 17.50, 'Trumao (Arena)', 'Camilo H', '2026-01-05', '2026-01-05 12:08:00+00'),

-- Pedro Toledo
('c4af1af6-d35d-4e70-96a3-0d6172dbf701', 'a65fd013-4e39-4377-b7cf-70f033977940', 'fc5c6a1e-f1e2-468a-95fe-3283a39b7334', 'incoming', 17.50, 'Trumao (Arena)', 'Camilo H', '2026-01-05', '2026-01-05 10:51:00+00'),
('c4af1af6-d35d-4e70-96a3-0d6172dbf701', 'a65fd013-4e39-4377-b7cf-70f033977940', 'fc5c6a1e-f1e2-468a-95fe-3283a39b7334', 'incoming', 17.50, 'Trumao (Arena)', 'Camilo H', '2026-01-05', '2026-01-05 12:07:00+00');
