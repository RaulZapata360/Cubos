# 📱 Ejecutar App desde Android Studio - ACTUALIZADO

## ✅ Cambios Recientes Aplicados

**Fecha:** 31 de Diciembre 2025  
**Actualización:** Migración a nuevo proyecto Supabase activo

### Configuración Actualizada:
- ✅ **Proyecto Supabase:** `rvnxnwotpieemwhbpoit` (ACTIVO)
- ✅ **URL:** `https://rvnxnwotpieemwhbpoit.supabase.co`
- ✅ **Archivos sincronizados:** 57 archivos copiados a `APP/www`
- ✅ **Capacitor:** Sincronizado con Android

---

## 🚀 Pasos para Ejecutar desde Android Studio

### 1. Verificar Sincronización (YA COMPLETADO)

Los archivos web ya fueron copiados y sincronizados:

```bash
# ✅ Ejecutado automáticamente:
xcopy "WEB\*" "APP\www\" /E /I /Y
npx cap sync android
```

**Resultado:**
- ✅ 57 archivos copiados
- ✅ Assets web actualizados
- ✅ Plugins Android actualizados
- ✅ Sync completado en 0.282s

---

### 2. Abrir Proyecto en Android Studio

**Opción A - Desde línea de comandos:**
```bash
cd "c:\Users\raulz\OneDrive\Escritorio\IA\Conteo\Conteo Camiones\APP"
npx cap open android
```

**Opción B - Manualmente:**
1. Abre Android Studio
2. File → Open
3. Navega a: `c:\Users\raulz\OneDrive\Escritorio\IA\Conteo\Conteo Camiones\APP\android`
4. Clic en "OK"

---

### 3. Configurar Dispositivo

**Emulador:**
1. Tools → Device Manager
2. Crea o inicia un emulador Android (API 30+)
3. Espera a que inicie completamente

**Dispositivo Físico:**
1. Habilita "Opciones de Desarrollador" en tu Android
2. Activa "Depuración USB"
3. Conecta el dispositivo por USB
4. Autoriza la conexión en el dispositivo

---

### 4. Ejecutar la Aplicación

1. Espera a que Gradle termine de sincronizar
2. Selecciona el dispositivo/emulador en la barra superior
3. Clic en el botón **Run** (▶️) o presiona `Shift + F10`
4. Espera a que la app se compile e instale

---

## 🔑 Credenciales de Prueba

Una vez que la app se ejecute, usa estas credenciales:

### Jefe (Acceso Completo)
- **Email:** `jefe@demo.com`
- **Password:** `Demo123!`

### Contadores
- **Email:** `contador1@demo.com`, `contador2@demo.com`, `contador3@demo.com`
- **Password:** `Demo123!`

---

## 📁 Estructura del Proyecto

```
APP/
├── android/              # Proyecto Android nativo
│   ├── app/
│   │   └── src/
│   │       └── main/
│   │           └── assets/
│   │               └── public/   # ✅ Assets web actualizados
│   └── build.gradle
├── www/                  # ✅ Archivos web sincronizados (57 archivos)
│   ├── index.html
│   ├── login.html
│   ├── boss.html
│   ├── supabase-config.js  # ✅ Actualizado al proyecto activo
│   ├── auth-service.js
│   └── assets/
├── capacitor.config.json
└── package.json
```

---

## 🔧 Comandos Útiles

### Re-sincronizar Cambios Web

Si haces cambios en `WEB/`, ejecuta:

```bash
# Desde la raíz del proyecto
cd "c:\Users\raulz\OneDrive\Escritorio\IA\Conteo\Conteo Camiones"

# Copiar archivos web
xcopy "WEB\*" "APP\www\" /E /I /Y

# Sincronizar con Android
cd APP
npx cap sync android
```

### Limpiar y Reconstruir

Si tienes problemas de compilación:

```bash
cd "c:\Users\raulz\OneDrive\Escritorio\IA\Conteo\Conteo Camiones\APP\android"
.\gradlew clean
.\gradlew build
```

### Ver Logs en Tiempo Real

```bash
# Desde Android Studio
View → Tool Windows → Logcat

# O desde terminal
adb logcat | findstr "Capacitor"
```

---

## ⚠️ Solución de Problemas

### Error: "Gradle sync failed"

**Solución:**
1. File → Invalidate Caches → Invalidate and Restart
2. Espera a que Android Studio reinicie
3. Deja que Gradle sincronice automáticamente

### Error: "SDK not found"

**Solución:**
1. File → Project Structure → SDK Location
2. Verifica que Android SDK esté instalado
3. Ruta típica: `C:\Users\<usuario>\AppData\Local\Android\Sdk`

### Error: "Device offline" o "No devices found"

**Solución:**
1. Reinicia el servidor ADB:
   ```bash
   adb kill-server
   adb start-server
   ```
2. Reconecta el dispositivo o reinicia el emulador

### App se cierra al abrir

**Solución:**
1. Revisa Logcat para ver el error
2. Verifica que la configuración de Supabase sea correcta
3. Limpia caché de la app:
   ```bash
   adb shell pm clear com.conteo.camiones
   ```

---

## 📊 Verificación de Funcionamiento

### Checklist de Prueba

Después de ejecutar la app, verifica:

- [ ] La app abre sin crashes
- [ ] Aparece la pantalla de login
- [ ] Puedes hacer login con `jefe@demo.com` / `Demo123!`
- [ ] Se carga el dashboard correctamente
- [ ] Puedes ver las obras
- [ ] Puedes registrar un camión
- [ ] Los datos se guardan en Supabase

### Logs Esperados

En Logcat deberías ver:

```
✅ Supabase client initialized
✅ Auth service initialized
✅ Login successful
✅ User profile loaded
```

---

## 🔄 Workflow de Desarrollo

### Para Hacer Cambios en la App:

1. **Edita archivos en `WEB/`** (HTML, CSS, JS)
2. **Prueba en navegador:** `http://localhost:8080`
3. **Cuando esté listo, sincroniza:**
   ```bash
   xcopy "WEB\*" "APP\www\" /E /I /Y
   cd APP
   npx cap sync android
   ```
4. **Ejecuta en Android Studio:** Run ▶️

### Para Cambios Nativos:

1. Edita código Java/Kotlin en `APP/android/app/src/`
2. Gradle sincronizará automáticamente
3. Ejecuta directamente desde Android Studio

---

## 📱 Información de la App

**Nombre:** Conteo Camiones  
**Package:** `com.conteo.camiones`  
**Versión:** v3.1.3  
**Min SDK:** 22 (Android 5.1)  
**Target SDK:** 33 (Android 13)

---

## 🎯 Próximos Pasos

1. ✅ Ejecuta la app desde Android Studio
2. ✅ Verifica que el login funcione
3. ✅ Prueba todas las funcionalidades
4. 📦 Genera APK para distribución (opcional):
   ```bash
   cd APP/android
   .\gradlew assembleRelease
   ```

---

## 📞 Soporte

Si encuentras problemas:

1. **Revisa Logcat** para errores específicos
2. **Verifica la conexión** a Supabase en el dashboard
3. **Limpia y reconstruye** el proyecto
4. **Re-sincroniza** los assets web

**Dashboard Supabase:** https://supabase.com/dashboard/project/rvnxnwotpieemwhbpoit

---

## ✅ Resumen

- ✅ Archivos web sincronizados (57 archivos)
- ✅ Configuración Supabase actualizada
- ✅ Capacitor sincronizado con Android
- ✅ Listo para ejecutar desde Android Studio

**¡Todo está listo para ejecutar la app!** 🚀
