# 📱 Guía Completa: Migración a Android

Esta guía te llevará paso a paso para convertir tu aplicación web "Conteo de Camiones" en una app Android nativa.

---

## 📋 Requisitos Previos

### 1. **Node.js** (Obligatorio)
- **Descargar**: https://nodejs.org/
- **Versión**: LTS (Long Term Support) - Recomendada
- **Verificar instalación**: Abre CMD y ejecuta:
  ```bash
  node --version
  npm --version
  ```

### 2. **Android Studio** (Obligatorio para generar APK)
- **Descargar**: https://developer.android.com/studio
- **Tamaño**: ~1GB de descarga
- **Instalación**: Sigue el asistente, instala todos los componentes recomendados

### 3. **Java JDK** (Se instala con Android Studio)
- Android Studio incluye el JDK necesario
- No necesitas instalarlo por separado

---

## 🚀 Proceso de Migración

### **PASO 1: Instalar Dependencias**

1. Abre la carpeta del proyecto
2. Ejecuta: `1_instalar_dependencias.bat`
3. Espera a que termine (puede tardar 2-5 minutos)

**¿Qué hace este paso?**
- Instala Capacitor (framework para convertir web a móvil)
- Descarga las dependencias necesarias
- Crea la carpeta `node_modules`

---

### **PASO 2: Crear Proyecto Android**

1. Ejecuta: `2_crear_proyecto_android.bat`
2. Espera a que termine (1-3 minutos)

**¿Qué hace este paso?**
- Crea la carpeta `android` con el proyecto nativo
- Copia todos tus archivos HTML, CSS y JS
- Configura el proyecto para Android

**Resultado**: Verás una nueva carpeta llamada `android` en tu proyecto

---

### **PASO 3: Abrir en Android Studio**

1. **Si no tienes Android Studio instalado**:
   - Descárgalo desde: https://developer.android.com/studio
   - Instálalo (acepta todas las opciones por defecto)
   - Espera a que descargue componentes adicionales

2. **Ejecuta**: `3_abrir_android_studio.bat`

3. **Primera vez en Android Studio**:
   - Espera a que "Gradle" termine de sincronizar (barra inferior)
   - Puede tardar 5-10 minutos la primera vez
   - Descargará dependencias de Android

---

### **PASO 4: Generar APK**

#### **Opción A: APK de Prueba (Debug)**

1. En Android Studio, ve a: **Build > Build Bundle(s) / APK(s) > Build APK(s)**
2. Espera a que compile (2-5 minutos)
3. Cuando termine, click en "locate" en la notificación
4. El APK estará en: `android\app\build\outputs\apk\debug\app-debug.apk`

**Este APK**:
- ✅ Se puede instalar en cualquier teléfono
- ✅ No necesita Google Play Store
- ✅ Perfecto para pruebas
- ⚠️ Tamaño más grande (~10-20 MB)

#### **Opción B: APK de Producción (Release)**

1. En Android Studio, ve a: **Build > Generate Signed Bundle / APK**
2. Selecciona: **APK**
3. Click en **Create new...** para crear un keystore
4. Llena los datos:
   - **Key store path**: Elige dónde guardar (ej: `C:\keystore\conteo-camiones.jks`)
   - **Password**: Crea una contraseña (¡GUÁRDALA!)
   - **Alias**: `conteo-camiones`
   - **Validity**: 25 años
   - **First and Last Name**: Tu nombre
   - **Organization**: Tu empresa
5. Click **OK** y luego **Next**
6. Selecciona **release**
7. Click **Finish**

**Este APK**:
- ✅ Optimizado y más pequeño
- ✅ Listo para publicar en Google Play
- ⚠️ Necesitas el keystore para futuras actualizaciones

---

## 📱 Probar en Dispositivo Real

### **Preparar tu Teléfono Android**

1. **Habilitar Modo Desarrollador**:
   - Ve a: Ajustes > Acerca del teléfono
   - Toca 7 veces en "Número de compilación"
   - Verás un mensaje: "Ahora eres desarrollador"

2. **Habilitar Depuración USB**:
   - Ve a: Ajustes > Opciones de desarrollador
   - Activa: "Depuración USB"

3. **Conectar por USB**:
   - Conecta tu teléfono a la PC
   - Acepta el mensaje de "Permitir depuración USB"

4. **En Android Studio**:
   - Click en el botón verde ▶️ (Run)
   - Selecciona tu dispositivo
   - La app se instalará y abrirá automáticamente

---

## 🔄 Actualizar la App Después de Cambios

Cada vez que modifiques HTML, CSS o JavaScript:

1. Ejecuta: `4_actualizar_cambios.bat`
2. En Android Studio: **Build > Rebuild Project**
3. Vuelve a ejecutar la app

---

## 📦 Estructura del Proyecto

```
Conteo Camiones/
├── android/                    # ← Proyecto Android (generado)
├── node_modules/              # ← Dependencias (generado)
├── index.html                 # Tu app web
├── app.js
├── styles.css
├── boss.html
├── history.html
├── login.html
├── package.json              # ← Configuración de dependencias
├── capacitor.config.json     # ← Configuración de Capacitor
├── 1_instalar_dependencias.bat
├── 2_crear_proyecto_android.bat
├── 3_abrir_android_studio.bat
└── 4_actualizar_cambios.bat
```

---

## 🎨 Personalizar el Ícono de la App

### **Crear Ícono**

1. Crea una imagen PNG de **1024x1024 px**
2. Usa una herramienta online: https://icon.kitchen/
3. Sube tu imagen
4. Descarga el paquete de íconos

### **Reemplazar Íconos**

1. Ve a: `android\app\src\main\res\`
2. Verás carpetas: `mipmap-hdpi`, `mipmap-mdpi`, etc.
3. Reemplaza los archivos `ic_launcher.png` en cada carpeta
4. Ejecuta: `4_actualizar_cambios.bat`

---

## 🚨 Solución de Problemas

### **Error: "Node.js no está instalado"**
- Instala Node.js desde: https://nodejs.org/
- Reinicia CMD después de instalar

### **Error: "Gradle sync failed"**
- Espera a que termine completamente
- Si persiste: File > Invalidate Caches > Invalidate and Restart

### **Error: "SDK not found"**
- En Android Studio: Tools > SDK Manager
- Instala: Android SDK Platform 33 (o superior)

### **La app no se instala en el teléfono**
- Verifica que "Depuración USB" esté activada
- Desconecta y vuelve a conectar el cable USB
- Acepta todos los permisos en el teléfono

### **El APK no se instala**
- Ve a: Ajustes > Seguridad
- Activa: "Orígenes desconocidos" o "Instalar apps desconocidas"

---

## 📊 Características de la App Android

✅ **Funciona sin internet** (todos los datos en localStorage)
✅ **Pantalla completa** (sin barra de navegador)
✅ **Ícono en el escritorio** del teléfono
✅ **Notificaciones** (si las implementas)
✅ **Acceso a cámara** (si lo necesitas)
✅ **Rendimiento nativo**

---

## 🔐 Publicar en Google Play Store (Opcional)

1. **Crear cuenta de desarrollador**:
   - https://play.google.com/console
   - Costo único: $25 USD

2. **Generar APK de producción** (ver Opción B arriba)

3. **Subir a Play Console**:
   - Crea una nueva aplicación
   - Completa la información
   - Sube el APK
   - Envía para revisión

4. **Tiempo de revisión**: 1-7 días

---

## 📞 Soporte

Si encuentras algún problema:

1. Revisa la sección "Solución de Problemas"
2. Verifica que todos los requisitos estén instalados
3. Asegúrate de seguir los pasos en orden

---

## 🎉 ¡Listo!

Tu aplicación web ahora es una app Android nativa. Puedes:
- Instalarla en cualquier teléfono Android
- Compartir el APK con otros
- Publicarla en Google Play Store
- Actualizarla fácilmente

**¡Disfruta tu nueva app móvil!** 🚀
