#!/usr/bin/env python3
"""
Generador de datos de prueba realistas para la semana 22-26 Dic 2025
"""
import datetime

# Configuración
START_DATE = datetime.date(2025, 12, 22)
DAYS = 5

# IDs de usuarios
CONTADOR1 = 'c2fcf75d-bb0b-467e-918a-4220154fca85'  # Ana Martínez
CONTADOR2 = '0acd45e7-0adb-4deb-9974-7b62624ec930'  # Pedro González
CONTADOR3 = '3a677477-7cfa-43f1-b755-00663eabc887'  # María López

# IDs de obras
AEROPARQUE = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
VAIN = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'
AZUL = 'cccccccc-cccc-cccc-cccc-cccccccccccc'

# Configuración de camiones
AERO_CAPACITIES = [15, 18, 15, 18, 15, 18, 15, 18, 15, 18]
VAIN_CAPACITIES = [20, 18, 20, 18, 20, 18]
AZUL_CAPACITIES = [12, 15, 12, 15, 18]

def generate_header():
    return """-- ============================================
-- DATOS REALISTAS SEMANA COMPLETA (22-26 DIC 2025)
-- ============================================
-- Generado automáticamente con datos realistas

"""

def generate_obras():
    return """-- ============================================
-- 1. CREAR OBRAS
-- ============================================

INSERT INTO obras (id, nombre, ubicacion, descripcion, fecha_inicio, estado) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Aeroparque', 'Torreones', 'Proyecto residencial', '2025-12-15', 'activa'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'VAIN', 'Chiguayante', 'Extracción de arena', '2025-12-10', 'activa'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Azul', 'Collao', 'Obra de infraestructura', '2025-12-18', 'activa')
ON CONFLICT (id) DO NOTHING;

"""

def generate_assignments():
    return f"""-- ============================================
-- 2. ASIGNAR CONTADORES
-- ============================================

INSERT INTO usuario_obra (usuario_id, obra_id) VALUES
  ('{CONTADOR1}', '{AEROPARQUE}'),
  ('{CONTADOR2}', '{VAIN}'),
  ('{CONTADOR3}', '{AZUL}')
ON CONFLICT (usuario_id, obra_id) DO NOTHING;

"""

def generate_materials():
    sql = """-- ============================================
-- 3. CREAR MATERIALES
-- ============================================

"""
    for obra_id, obra_name in [(AEROPARQUE, 'Aeroparque'), (VAIN, 'VAIN'), (AZUL, 'Azul')]:
        sql += f"-- {obra_name}\n"
        sql += f"INSERT INTO materiales (obra_id, nombre, tipo) VALUES\n"
        materials = [
            f"  ('{obra_id}', 'Arena', 'incoming'),\n",
            f"  ('{obra_id}', 'Ripio', 'incoming'),\n",
            f"  ('{obra_id}', 'Base estabilizada', 'incoming'),\n",
            f"  ('{obra_id}', 'Grava', 'incoming'),\n",
            f"  ('{obra_id}', 'Arena', 'outgoing'),\n",
            f"  ('{obra_id}', 'Arcilla', 'outgoing'),\n",
            f"  ('{obra_id}', 'Tierra', 'outgoing'),\n",
            f"  ('{obra_id}', 'Basura', 'outgoing')\n",
        ]
        sql += ''.join(materials)
        sql += "ON CONFLICT (obra_id, nombre, tipo) DO NOTHING;\n\n"
    
    return sql

def generate_destinos():
    return """-- ============================================
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

"""

def generate_camiones():
    sql = """-- ============================================
-- 5. CREAR CAMIONES CON IDs FIJOS
-- ============================================

-- Aeroparque: 10 camiones
INSERT INTO camiones (id, obra_id, nombre, patente, capacidad, tipo_registrado) VALUES\n"""
    
    hex_chars = '123456789a'  # 1-9, a (10 en hex)
    for i, cap in enumerate(AERO_CAPACITIES, 1):
        tipo = 'mixed' if i > 7 else 'outgoing'
        hex_id = hex_chars[i-1]
        sql += f"  ('ca00000{hex_id}-0000-0000-0000-00000000000{hex_id}', '{AEROPARQUE}', 'Camión {i}', 'AB{1230+i}', {cap}.0, '{tipo}'),\n"
    
    sql = sql.rstrip(',\n') + '\nON CONFLICT (id) DO NOTHING;\n\n'
    
    sql += "-- VAIN: 6 tolvas\nINSERT INTO camiones (id, obra_id, nombre, patente, capacidad, tipo_registrado) VALUES\n"
    for i, cap in enumerate(VAIN_CAPACITIES, 1):
        sql += f"  ('cb00000{i}-0000-0000-0000-00000000000{i}', '{VAIN}', 'Tolva {i}', 'UV{1230+i}', {cap}.0, 'outgoing'),\n"
    
    sql = sql.rstrip(',\n') + '\nON CONFLICT (id) DO NOTHING;\n\n'
    
    sql += "-- Azul: 5 camiones\nINSERT INTO camiones (id, obra_id, nombre, patente, capacidad, tipo_registrado) VALUES\n"
    for i, cap in enumerate(AZUL_CAPACITIES, 1):
        tipo = 'outgoing' if i == 5 else 'incoming'
        nombre = 'Tolva Basura' if i == 5 else f'Mixer {i}'
        sql += f"  ('cc00000{i}-0000-0000-0000-00000000000{i}', '{AZUL}', '{nombre}', 'DD{1230+i}', {cap}.0, '{tipo}'),\n"
    
    sql = sql.rstrip(',\n') + '\nON CONFLICT (id) DO NOTHING;\n\n'
    
    return sql

def generate_movements():
    sql = """-- ============================================
-- 6. GENERAR MOVIMIENTOS (22-26 DIC 2025)
-- ============================================

"""
    
    hex_chars = '123456789a'
    
    for day in range(DAYS):
        current_date = START_DATE + datetime.timedelta(days=day)
        date_str = current_date.strftime('%Y-%m-%d')
        day_name = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes'][day]
        
        sql += f"-- {day_name} {current_date.strftime('%d/%m/%Y')}\n"
        sql += f"INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, ubicacion, timestamp, fecha, destino) VALUES\n"
        
        movements = []
        
        # Aeroparque
        time_offset = 480  # 8:00 AM
        # 20 arcilla
        for i in range(20):
            truck_idx = i % 10
            hex_id = hex_chars[truck_idx]
            truck_id = f'ca00000{hex_id}-0000-0000-0000-00000000000{hex_id}'
            cap = AERO_CAPACITIES[truck_idx]
            hour = time_offset // 60
            minute = time_offset % 60
            movements.append(f"  ('{AEROPARQUE}', '{truck_id}', '{CONTADOR1}', 'outgoing', {cap}.0, 'Arcilla', '', '{date_str} {hour:02d}:{minute:02d}:00', '{date_str}', 'Botadero Rotonda')")
            time_offset += 40
        
        # 1 basura
        movements.append(f"  ('{AEROPARQUE}', 'ca000001-0000-0000-0000-000000000001', '{CONTADOR1}', 'outgoing', 15.0, 'Basura', '', '{date_str} {time_offset//60:02d}:{time_offset%60:02d}:00', '{date_str}', 'Jaime Repullo')")
        
        # Relleno días 4-5 (Jueves y Viernes)
        if day >= 3:  # Jueves y Viernes
            time_offset = 540  # 9:00 AM
            for i in range(12):  # ~200m³ / 16.5m³ promedio = 12 viajes
                truck_idx = 7 + (i % 3)  # Usar camiones mixed (8, 9, 10)
                hex_id = hex_chars[truck_idx]
                truck_id = f'ca00000{hex_id}-0000-0000-0000-00000000000{hex_id}'
                cap = AERO_CAPACITIES[truck_idx]
                hour = time_offset // 60
                minute = time_offset % 60
                movements.append(f"  ('{AEROPARQUE}', '{truck_id}', '{CONTADOR1}', 'incoming', {cap}.0, 'Base estabilizada', '', '{date_str} {hour:02d}:{minute:02d}:00', '{date_str}', 'Planta')")
                time_offset += 40
        
        # VAIN - 6 arena
        time_offset = 480
        for i in range(6):
            truck_id = f'cb00000{i+1}-0000-0000-0000-00000000000{i+1}'
            cap = VAIN_CAPACITIES[i]
            hour = time_offset // 60
            minute = time_offset % 60
            movements.append(f"  ('{VAIN}', '{truck_id}', '{CONTADOR2}', 'outgoing', {cap}.0, 'Arena', '', '{date_str} {hour:02d}:{minute:02d}:00', '{date_str}', 'Botadero Rotonda')")
            time_offset += 55
        
        # Azul - incoming (base + grava)
        time_offset = 480
        # Base estabilizada: 100m³ / 13.5 promedio = ~7 viajes
        for i in range(7):
            truck_idx = i % 4
            truck_id = f'cc00000{truck_idx+1}-0000-0000-0000-00000000000{truck_idx+1}'
            cap = AZUL_CAPACITIES[truck_idx]
            material = 'Base estabilizada' if i % 2 == 0 else 'Grava'
            destino = 'Sector Norte' if i % 2 == 0 else 'Sector Sur'
            hour = time_offset // 60
            minute = time_offset % 60
            movements.append(f"  ('{AZUL}', '{truck_id}', '{CONTADOR3}', 'incoming', {cap}.0, '{material}', '', '{date_str} {hour:02d}:{minute:02d}:00', '{date_str}', '{destino}')")
            time_offset += 75
        
        # Basura (Lun, Mar, Jue)
        if day in [0, 1, 3]:  # Lunes, Martes, Jueves
            time_offset = 600  # 10:00 AM
            for i in range(5):
                hour = time_offset // 60
                minute = time_offset % 60
                movements.append(f"  ('{AZUL}', 'cc000005-0000-0000-0000-000000000005', '{CONTADOR3}', 'outgoing', 18.0, 'Basura', '', '{date_str} {hour:02d}:{minute:02d}:00', '{date_str}', 'Jaime Repullo')")
                time_offset += 80
        
        sql += ',\n'.join(movements) + ';\n\n'
    
    return sql

def generate_verification():
    return """-- ============================================
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
"""

# Generar script completo
script = (
    generate_header() +
    generate_obras() +
    generate_assignments() +
    generate_materials() +
    generate_destinos() +
    generate_camiones() +
    generate_movements() +
    generate_verification()
)

# Guardar
output_file = 'WEB/supabase/migrations/114_datos_semana_completa.sql'
with open(output_file, 'w', encoding='utf-8') as f:
    f.write(script)

print(f'✅ Script generado: {output_file}')
print(f'📊 Total de líneas: {len(script.splitlines())}')
