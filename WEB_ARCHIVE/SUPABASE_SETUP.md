# 🚀 Guía de Configuración de Supabase

## Paso 1: Crear Proyecto en Supabase

1. Ve a [https://supabase.com](https://supabase.com)
2. Crea una cuenta o inicia sesión
3. Click en "New Project"
4. Completa los datos:
   - **Name**: Conteo Camiones
   - **Database Password**: (guarda esta contraseña de forma segura)
   - **Region**: Selecciona la más cercana a tu ubicación
   - **Pricing Plan**: Free (suficiente para empezar)
5. Click en "Create new project"
6. Espera 2-3 minutos mientras se crea el proyecto

---

## Paso 2: Obtener Credenciales

1. En tu proyecto de Supabase, ve a **Settings** (⚙️) → **API**
2. Copia y guarda estos valores:

   - **Project URL**: `https://xxxxx.supabase.co`
   - **anon/public key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

3. Abre el archivo `WEB/supabase-config.js` y reemplaza los valores

---

## Paso 3: Ejecutar Migraciones SQL

### 3.1 Schema Inicial

1. En Supabase, ve a **SQL Editor** (icono de base de datos)
2. Click en "New query"
3. Copia y pega el contenido de `supabase/migrations/001_initial_schema.sql`
4. Click en "Run" (▶️)
5. Verifica que aparezca "Success. No rows returned"

### 3.2 Políticas RLS

1. Nueva query
2. Copia y pega el contenido de `supabase/migrations/002_rls_policies.sql`
3. Click en "Run" (▶️)
4. Verifica que aparezca "Success"

---

## Paso 4: Crear Usuarios de Demo

1. En Supabase, ve a **Authentication** → **Users**
2. Click en "Add user" → "Create new user"
3. Crea los siguientes usuarios:

### Usuario 1: Jefe
- **Email**: `jefe@demo.com`
- **Password**: `Demo123!`
- **Confirm Password**: `Demo123!`
- Click "Create user"
- **IMPORTANTE**: Copia el UUID del usuario creado

### Usuario 2: Contador 1
- **Email**: `contador1@demo.com`
- **Password**: `Demo123!`
- Copia el UUID

### Usuario 3: Contador 2
- **Email**: `contador2@demo.com`
- **Password**: `Demo123!`
- Copia el UUID

### Usuario 4: Contador 3
- **Email**: `contador3@demo.com`
- **Password**: `Demo123!`
- Copia el UUID

---

## Paso 5: Actualizar Script de Demo con UUIDs

1. Abre `supabase/migrations/003_demo_data.sql`
2. Reemplaza los UUIDs de ejemplo con los UUIDs reales:

```sql
-- Reemplaza estos valores:
'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'  -- UUID del jefe
'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'  -- UUID del contador1
'cccccccc-cccc-cccc-cccc-cccccccccccc'  -- UUID del contador2
'dddddddd-dddd-dddd-dddd-dddddddddddd'  -- UUID del contador3
```

3. Guarda el archivo

---

## Paso 6: Cargar Datos de Demo

1. En **SQL Editor**, nueva query
2. Copia y pega el contenido de `supabase/migrations/003_demo_data.sql` (ya actualizado con UUIDs)
3. Click en "Run" (▶️)
4. Verifica que aparezca "Success"

---

## Paso 7: Verificar Instalación

### Verificar Tablas

1. Ve a **Table Editor**
2. Deberías ver estas tablas:
   - ✅ obras (3 registros)
   - ✅ usuarios (4 registros)
   - ✅ usuario_obra (3 registros)
   - ✅ camiones (17 registros)
   - ✅ movimientos (~70 registros)
   - ✅ materiales (~16 registros)

### Verificar RLS

1. Ve a **Authentication** → **Policies**
2. Deberías ver políticas para cada tabla
3. Verifica que RLS esté habilitado (🔒 verde)

---

## Paso 8: Probar la Aplicación

1. Abre `WEB/login.html` en tu navegador
2. Prueba iniciar sesión con:

### Como Jefe:
- **Email**: `jefe@demo.com`
- **Password**: `Demo123!`
- Deberías ver el dashboard con las 3 obras

### Como Contador:
- **Email**: `contador1@demo.com`
- **Password**: `Demo123!`
- Deberías ver solo la "Obra Norte"

---

## 🎉 ¡Listo!

Tu sistema multi-obra está configurado y funcionando.

### Próximos Pasos:

- Crear obras reales (eliminar las de demo)
- Invitar usuarios reales por email
- Personalizar materiales por obra
- Comenzar a registrar camiones y vueltas

---

## 🆘 Solución de Problemas

### Error: "relation does not exist"
- Verifica que ejecutaste el script `001_initial_schema.sql`
- Revisa que no haya errores en la consola SQL

### Error: "new row violates row-level security policy"
- Verifica que ejecutaste el script `002_rls_policies.sql`
- Asegúrate de que los UUIDs de usuarios coincidan

### No puedo iniciar sesión
- Verifica que creaste los usuarios en Authentication
- Confirma que el email y password son correctos
- Revisa la consola del navegador (F12) para ver errores

### Los datos no se cargan
- Verifica tu conexión a internet
- Revisa que las credenciales en `supabase-config.js` sean correctas
- Abre la consola del navegador para ver errores de red
