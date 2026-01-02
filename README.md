# 📱 Conteo de Camiones - Estructura del Proyecto

## 📂 Estructura de Carpetas

```
Conteo Camiones/
├── WEB/                    ← CÓDIGO FUENTE WEB (Edita aquí)
│   ├── index.html
│   ├── login.html
│   ├── boss.html
│   ├── history.html
│   ├── app.js
│   ├── boss-app.js
│   ├── history-app.js
│   ├── login-app.js
│   └── styles.css
│
└── APP/                    ← PROYECTO ANDROID
    ├── www/                ← Copia de archivos web (NO editar)
    ├── android/            ← Proyecto Android nativo
    ├── node_modules/       ← Dependencias
    ├── package.json
    ├── capacitor.config.json
    └── SINCRONIZAR_WEB.bat ← SCRIPT IMPORTANTE
```

---

## 🔄 Flujo de Trabajo

### **1. Editar la Aplicación Web**

Trabaja en la carpeta `WEB/`:
- ✅ Edita HTML, CSS, JS aquí
- ✅ Prueba en el navegador
- ✅ Haz todos tus cambios

### **2. Sincronizar con Android**

Cuando termines de editar:

1. Ve a la carpeta `APP/`
2. Ejecuta: `SINCRONIZAR_WEB.bat`
3. Espera a que termine

**¿Qué hace este script?**
- Copia archivos de `WEB/` a `APP/www/`
- Sincroniza con el proyecto Android
- Actualiza todo automáticamente

### **3. Compilar APK**

1. Ejecuta: `3_abrir_android_studio.bat`
2. En Android Studio:
   - **Build** → **Rebuild Project**
   - **Build** → **Build APK(s)**
3. Ejecuta: `6_copiar_apk_escritorio.bat`

---

## ⚠️ IMPORTANTE

### **✅ SÍ Editar:**
- `WEB/` - Todos los archivos HTML, CSS, JS

### **❌ NO Editar:**
- `APP/www/` - Se sobrescribe automáticamente
- `APP/android/` - Generado por Capacitor

---

## 🚀 Scripts Disponibles (en carpeta APP)

| Script | Función |
|--------|---------|
| `SINCRONIZAR_WEB.bat` | **Copia archivos de WEB/ a Android** |
| `1_instalar_dependencias.bat` | Instala Node.js y Capacitor |
| `2_crear_proyecto_android.bat` | Crea proyecto Android |
| `3_abrir_android_studio.bat` | Abre Android Studio |
| `4_actualizar_cambios.bat` | Sincroniza cambios (antiguo) |
| `5_fix_gradle.bat` | Arregla problemas de Gradle |
| `6_copiar_apk_escritorio.bat` | Copia APK al escritorio |

---

## 📝 Ejemplo de Uso Completo

### Escenario: Cambiar el color de un botón

1. **Editar**: Abre `WEB/styles.css`
2. **Cambiar**: Modifica el color del botón
3. **Probar**: Abre `WEB/index.html` en el navegador
4. **Sincronizar**: 
   - Ve a `APP/`
   - Ejecuta `SINCRONIZAR_WEB.bat`
5. **Compilar**:
   - Ejecuta `3_abrir_android_studio.bat`
   - Build → Rebuild Project
   - Build → Build APK
6. **Instalar**: Transfiere el APK a tu teléfono

---

## 🔧 Solución de Problemas

### La app Android no muestra los cambios

**Solución:**
1. Ejecuta `SINCRONIZAR_WEB.bat`
2. En Android Studio: **Build** → **Clean Project**
3. Luego: **Build** → **Rebuild Project**
4. Genera nuevo APK

### Los estilos no se ven en la app

**Causa:** Los archivos no se sincronizaron

**Solución:**
1. Verifica que `APP/www/` tenga todos los archivos
2. Ejecuta `SINCRONIZAR_WEB.bat` de nuevo
3. Recompila el APK

### Error al sincronizar

**Solución:**
1. Asegúrate de estar en la carpeta `APP/`
2. Verifica que `node_modules/` existe
3. Si no existe, ejecuta `1_instalar_dependencias.bat`

---

## ✅ Checklist Antes de Compilar APK

- [ ] Hice cambios en `WEB/`
- [ ] Probé en el navegador
- [ ] Ejecuté `SINCRONIZAR_WEB.bat`
- [ ] La sincronización terminó sin errores
- [ ] Abrí Android Studio
- [ ] Hice Rebuild Project
- [ ] Compilé el APK

---

## 📱 Resultado Final

Después de seguir estos pasos:
- ✅ APK con todos tus cambios
- ✅ Estilos funcionando correctamente
- ✅ JavaScript operativo
- ✅ Listo para instalar en Android

---

**Última actualización:** 20/12/2025
