# Guía: Limpiar Datos de Prueba

## Opción 1: Desde Supabase Dashboard (Recomendado)

1. Ve a [Supabase Dashboard](https://supabase.com/dashboard)
2. Selecciona tu proyecto
3. Ve a **SQL Editor** en el menú lateral
4. Click en **New Query**
5. Copia y pega el siguiente SQL:

```sql
-- Limpiar todos los datos de prueba
DELETE FROM movimientos;
DELETE FROM camiones;
DELETE FROM materiales;
DELETE FROM usuario_obra;
DELETE FROM usuarios;
DELETE FROM obras;
```

6. Click en **Run** (o presiona Ctrl+Enter)
7. Verifica que se eliminaron los datos:

```sql
SELECT 'obras' as tabla, COUNT(*) as registros FROM obras
UNION ALL
SELECT 'usuarios', COUNT(*) FROM usuarios
UNION ALL
SELECT 'usuario_obra', COUNT(*) FROM usuario_obra
UNION ALL
SELECT 'camiones', COUNT(*) FROM camiones
UNION ALL
SELECT 'movimientos', COUNT(*) FROM movimientos
UNION ALL
SELECT 'materiales', COUNT(*) FROM materiales;
```

Todos deberían mostrar `0` registros.

---

## Opción 2: Limpiar solo movimientos y camiones (mantener obras)

Si quieres mantener las obras y usuarios pero limpiar los datos operacionales:

```sql
-- Limpiar solo datos operacionales
DELETE FROM movimientos;
DELETE FROM camiones;
```

---

## Opción 3: Limpiar solo movimientos del día

Si solo quieres limpiar los movimientos de hoy:

```sql
DELETE FROM movimientos WHERE fecha = CURRENT_DATE;
```

---

## ⚠️ IMPORTANTE

**Los usuarios de autenticación NO se borran automáticamente.**

Los usuarios en `auth.users` (jefe@demo.com, contador1@demo.com, etc.) permanecerán en Supabase Auth incluso después de limpiar la tabla `usuarios`.

Si quieres eliminar también los usuarios de autenticación:

1. Ve a **Authentication** → **Users** en Supabase Dashboard
2. Elimina manualmente cada usuario que quieras borrar

---

## Después de Limpiar

Una vez limpiados los datos, puedes:

1. **Crear obras nuevas** desde el dashboard de jefe (botón "Nueva Obra")
2. **Crear usuarios nuevos** desde Authentication en Supabase
3. **Asignar contadores** a obras desde el dashboard de jefe (botón "Asignar Usuarios")

---

## Script Completo de Limpieza

El script completo está en:
`WEB/supabase/migrations/000_limpiar_datos.sql`

Puedes ejecutarlo completo desde el SQL Editor de Supabase.
