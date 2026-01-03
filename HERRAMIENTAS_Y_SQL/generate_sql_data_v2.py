"""
Generador de datos de prueba SQL v2
Genera datos que coinciden EXACTAMENTE con lo que la app guarda
"""

from datetime import datetime, timedelta
import uuid

def generate_sql():
    sql_parts = []
    
    # Header
    sql_parts.append("""-- ============================================
-- DATOS DE PRUEBA CORREGIDOS (22-26 Diciembre 2024)
-- ============================================
-- Generados para coincidir con la lógica real de la app
-- Solo incluye campos que la app REALMENTE guarda

-- ============================================
-- 1. CREAR OBRAS
-- ============================================
""")
    
    # Obras con IDs fijos
    obras = {
        'Aeroparque': 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        'VAIN': 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
        'Azul': 'cccccccc-cccc-cccc-cccc-cccccccccccc'
    }
    
    sql_parts.append("INSERT INTO obras (id, nombre, ubicacion, descripcion, fecha_inicio, estado) VALUES")
    sql_parts.append(f"  ('{obras['Aeroparque']}', 'Aeroparque', 'Torreones', 'Proyecto residencial con excavación y relleno', '2024-12-15', 'activa'),")
    sql_parts.append(f"  ('{obras['VAIN']}', 'VAIN', 'Chiguayante', 'Extracción de arena para proyecto vial', '2024-12-10', 'activa'),")
    sql_parts.append(f"  ('{obras['Azul']}', 'Azul', 'Collao', 'Obra de infraestructura con relleno', '2024-12-18', 'activa')")
    sql_parts.append("ON CONFLICT (id) DO NOTHING;\n")
    
    # Usuarios (usar los IDs reales de la imagen)
    sql_parts.append("""-- ============================================
-- 2. ASIGNAR CONTADORES A OBRAS
-- ============================================
-- IMPORTANTE: Estos UUIDs deben coincidir con usuarios reales en tu base de datos
-- Verifica los IDs en la tabla usuarios antes de ejecutar

INSERT INTO usuario_obra (usuario_id, obra_id) VALUES
  ('c2fcf75d-bb0b-467e-918a-4220154fca85', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),  -- Contador 1 -> Aeroparque
  ('0acd45e7-0adb-4deb-9974-7b62624ec930', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'),  -- Contador 2 -> VAIN
  ('3a677477-7cfa-43f1-b755-00663eabc887', 'cccccccc-cccc-cccc-cccc-cccccccccccc')   -- Contador 3 -> Azul
ON CONFLICT (usuario_id, obra_id) DO NOTHING;

""")
    
    # Materiales
    sql_parts.append("""-- ============================================
-- 3. CREAR MATERIALES
-- ============================================

INSERT INTO materiales (obra_id, nombre, tipo) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Arcilla', 'outgoing'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Basura', 'outgoing'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Base estabilizada', 'incoming'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Arena', 'outgoing'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Base estabilizada', 'incoming'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Grava', 'incoming'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Basura', 'outgoing')
ON CONFLICT (obra_id, nombre, tipo) DO NOTHING;

""")
    
    # Camiones
    sql_parts.append("""-- ============================================
-- 4. CREAR CAMIONES
-- ============================================

""")
    
    # Aeroparque: 10 camiones
    camiones_aero = []
    patentes = ['AB12', 'CD34', 'EF56', 'GH78', 'IJ90', 'KL12', 'MN34', 'OP56', 'QR78', 'ST90']
    capacidades = [15.0, 18.0, 15.0, 18.0, 15.0, 18.0, 15.0, 18.0, 15.0, 18.0]
    tipos = ['outgoing']*7 + ['mixed']*3
    
    for i in range(10):
        camion_id = str(uuid.uuid4())
        camiones_aero.append(camion_id)
        sql_parts.append(f"INSERT INTO camiones (id, obra_id, nombre, patente, capacidad, tipo_registrado) VALUES ('{camion_id}', '{obras['Aeroparque']}', 'Camión {i+1}', '{patentes[i]}', {capacidades[i]}, '{tipos[i]}');")
    
    # VAIN: 6 tolvas
    camiones_vain = []
    patentes_vain = ['UV12', 'WX34', 'YZ56', 'AA78', 'BB90', 'CC12']
    capacidades_vain = [20.0, 18.0, 20.0, 18.0, 20.0, 18.0]
    
    for i in range(6):
        camion_id = str(uuid.uuid4())
        camiones_vain.append(camion_id)
        sql_parts.append(f"INSERT INTO camiones (id, obra_id, nombre, patente, capacidad, tipo_registrado) VALUES ('{camion_id}', '{obras['VAIN']}', 'Tolva {i+1}', '{patentes_vain[i]}', {capacidades_vain[i]}, 'outgoing');")
    
    # Azul: 5 camiones (4 mixers + 1 tolva basura)
    camiones_azul = []
    patentes_azul = ['DD12', 'EE34', 'FF56', 'GG78', 'HH90']
    capacidades_azul = [12.0, 15.0, 12.0, 15.0, 18.0]
    tipos_azul = ['incoming', 'incoming', 'incoming', 'incoming', 'outgoing']
    
    for i in range(5):
        camion_id = str(uuid.uuid4())
        camiones_azul.append(camion_id)
        nombre = f'Mixer {i+1}' if i < 4 else 'Tolva Basura'
        sql_parts.append(f"INSERT INTO camiones (id, obra_id, nombre, patente, capacidad, tipo_registrado) VALUES ('{camion_id}', '{obras['Azul']}', '{nombre}', '{patentes_azul[i]}', {capacidades_azul[i]}, '{tipos_azul[i]}');")
    
    sql_parts.append("\n-- ============================================")
    sql_parts.append("-- 5. GENERAR MOVIMIENTOS (22-26 Diciembre)")
    sql_parts.append("-- ============================================")
    sql_parts.append("-- IMPORTANTE: Solo campos que la app guarda:")
    sql_parts.append("-- obra_id, camion_id, usuario_id, tipo, capacidad, material, timestamp, fecha")
    sql_parts.append("-- SIN: ubicacion, camion_nombre, camion_patente\n")
    
    # Generar movimientos para cada día
    start_date = datetime(2024, 12, 22)  # Lunes
    
    for day_offset in range(5):  # Lun-Vie
        current_date = start_date + timedelta(days=day_offset)
        date_str = current_date.strftime('%Y-%m-%d')
        day_name = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes'][day_offset]
        
        sql_parts.append(f"\n-- {day_name} {current_date.strftime('%d/%m/%Y')}")
        
        # Aeroparque: 21 movimientos/día (Lun-Mie), 35 (Jue-Vie)
        movs_aero = 21 if day_offset < 3 else 35
        current_time = datetime(2024, 12, 22 + day_offset, 8, 0)
        
        for i in range(movs_aero):
            camion_idx = i % 10
            camion_id = camiones_aero[camion_idx]
            capacidad = capacidades[camion_idx]
            
            # Determinar tipo y material
            if i < movs_aero - 1:  # Excavación
                tipo = 'outgoing'
                material = 'Arcilla' if i % 3 != 0 else 'Basura'
            else:  # Último es relleno
                tipo = 'incoming'
                material = 'Base estabilizada'
            
            timestamp = current_time.strftime('%Y-%m-%d %H:%M:%S')
            sql_parts.append(f"INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, timestamp, fecha) VALUES ('{obras['Aeroparque']}', '{camion_id}', 'c2fcf75d-bb0b-467e-918a-4220154fca85', '{tipo}', {capacidad}, '{material}', '{timestamp}', '{date_str}');")
            
            current_time += timedelta(minutes=40)
        
        # VAIN: 6 movimientos/día
        current_time = datetime(2024, 12, 22 + day_offset, 8, 0)
        for i in range(6):
            camion_id = camiones_vain[i]
            capacidad = capacidades_vain[i]
            timestamp = current_time.strftime('%Y-%m-%d %H:%M:%S')
            
            sql_parts.append(f"INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, timestamp, fecha) VALUES ('{obras['VAIN']}', '{camion_id}', '0acd45e7-0adb-4deb-9974-7b62624ec930', 'outgoing', {capacidad}, 'Arena', '{timestamp}', '{date_str}');")
            
            current_time += timedelta(minutes=55)
        
        # Azul: Variable por día
        movs_azul = [15, 15, 10, 20, 20][day_offset]
        current_time = datetime(2024, 12, 22 + day_offset, 8, 0)
        
        for i in range(movs_azul):
            if i < movs_azul - 5:  # Relleno
                camion_idx = i % 4
                camion_id = camiones_azul[camion_idx]
                capacidad = capacidades_azul[camion_idx]
                tipo = 'incoming'
                material = 'Base estabilizada' if i % 2 == 0 else 'Grava'
            else:  # Últimos 5 son basura
                camion_id = camiones_azul[4]
                capacidad = 18.0
                tipo = 'outgoing'
                material = 'Basura'
            
            timestamp = current_time.strftime('%Y-%m-%d %H:%M:%S')
            sql_parts.append(f"INSERT INTO movimientos (obra_id, camion_id, usuario_id, tipo, capacidad, material, timestamp, fecha) VALUES ('{obras['Azul']}', '{camion_id}', '3a677477-7cfa-43f1-b755-00663eabc887', '{tipo}', {capacidad}, '{material}', '{timestamp}', '{date_str}');")
            
            current_time += timedelta(minutes=75)
    
    # Verificación
    sql_parts.append("""\n-- ============================================
-- VERIFICACIÓN
-- ============================================

SELECT 
  o.nombre as obra,
  m.fecha,
  COUNT(DISTINCT m.camion_id) as camiones_activos,
  COUNT(m.id) as total_movimientos,
  ROUND(SUM(CASE WHEN m.tipo = 'incoming' THEN m.capacidad ELSE 0 END), 2) as vol_entrada_m3,
  ROUND(SUM(CASE WHEN m.tipo = 'outgoing' THEN m.capacidad ELSE 0 END), 2) as vol_salida_m3
FROM movimientos m
JOIN obras o ON m.obra_id = o.id
WHERE m.fecha BETWEEN '2024-12-22' AND '2024-12-26'
GROUP BY o.nombre, m.fecha
ORDER BY o.nombre, m.fecha;
""")
    
    return '\n'.join(sql_parts)

if __name__ == '__main__':
    sql_content = generate_sql()
    output_file = 'WEB/supabase/migrations/100_datos_prueba_app.sql'
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(sql_content)
    
    print(f"✅ Script SQL generado: {output_file}")
    print(f"📊 Total de líneas: {len(sql_content.splitlines())}")
