# Datos de Prueba para la App - INSTRUCCIONES

## ⚠️ IMPORTANTE: Scripts Corregidos

Los scripts han sido actualizados para coincidir **EXACTAMENTE** con la lógica de la app.

### Campos que la app guarda en `movimientos`:
- `obra_id`, `camion_id`, `usuario_id`
- `tipo`, `capacidad`, `material`
- `timestamp`, `fecha`

### Campos que NO se incluyen:
- ❌ `ubicacion` (no se usa en la app)
- ❌ `camion_nombre` (desnormalizado, no se llena)
- ❌ `camion_patente` (desnormalizado, no se llena)

## Pasos para Insertar Datos

### 1. Limpiar Datos Anteriores
Ejecuta en Supabase SQL Editor:
```sql
-- Archivo: 099_limpiar_datos_prueba.sql
```

### 2. Insertar Nuevos Datos
Ejecuta en Supabase SQL Editor:
```sql
-- Archivo: 100_datos_prueba_app.sql
```

### 3. Verificar Inserción
La query de verificación al final del script 100 mostrará:

| obra | fecha | camiones_activos | total_movimientos | vol_entrada_m3 | vol_salida_m3 |
|------|-------|------------------|-------------------|----------------|---------------|
| Aeroparque | 2024-12-22 | 10 | 21 | ... | ... |
| VAIN | 2024-12-22 | 6 | 6 | 0 | ... |
| Azul | 2024-12-22 | 5 | 15 | ... | ... |

## Datos Generados

### 3 Obras
- **Aeroparque** (Torreones): 21 mov/día (Lun-Mie), 35 mov/día (Jue-Vie)
- **VAIN** (Chiguayante): 6 mov/día (extracción arena)
- **Azul** (Collao): 15-20 mov/día (relleno + basura)

### 21 Camiones
- Aeroparque: 10 camiones (7 excavación, 3 mixtos)
- VAIN: 6 tolvas (excavación)
- Azul: 5 camiones (4 relleno, 1 basura)

### ~215 Movimientos
- Semana: 22-26 Diciembre 2024 (Lun-Vie)
- Horario: 08:00 - 21:00
- Ciclos realistas: 40-75 min según distancia

## Verificación en la App

1. **Dashboard Boss**: Debería mostrar las 3 obras con datos
2. **Contador**: Cada contador ve solo su obra asignada
3. **Fechas**: Usa navegación de días para ver 22-26 Dic

## Troubleshooting

### "Solo veo una obra"
- Verifica que tu usuario tenga `rol='jefe'` en tabla `usuarios`
- Ejecuta `102_verificar_datos.sql` para diagnosticar

### "Datos en cero"
- Verifica que estás viendo las fechas correctas (22-26 Dic)
- Usa los botones ◀ ▶ para navegar entre días/semanas

### "Obras desconocidas"
- Problema de permisos RLS
- Tu usuario debe estar en tabla `usuarios`
