# 🚀 Cómo Ejecutar la Aplicación

## ⚠️ IMPORTANTE: No abrir archivos HTML directamente

Los navegadores modernos bloquean módulos ES6 cuando se abren archivos HTML directamente (`file://`). 

**Debes usar un servidor local.**

---

## ✅ Opción 1: Usar el Script Automático (Recomendado)

1. **Doble click** en `INICIAR_SERVIDOR.bat`
2. Se abrirá una ventana negra (NO la cierres)
3. Abre tu navegador en: **http://localhost:8000/login.html**
4. ¡Listo! Ya puedes usar la aplicación

**Para detener el servidor:**
- Cierra la ventana negra, o
- Presiona `Ctrl + C` en la ventana

---

## ✅ Opción 2: Usar Python Manualmente

Si el script no funciona, ejecuta manualmente:

1. Abre **PowerShell** o **CMD**
2. Navega a la carpeta WEB:
   ```bash
   cd "C:\Users\raulz\OneDrive\Escritorio\IA\Conteo\Conteo Camiones\WEB"
   ```
3. Inicia el servidor:
   ```bash
   python -m http.server 8000
   ```
4. Abre tu navegador en: **http://localhost:8000/login.html**

---

## ✅ Opción 3: Usar Node.js (si tienes instalado)

1. Instala `http-server` (solo una vez):
   ```bash
   npm install -g http-server
   ```
2. En la carpeta WEB, ejecuta:
   ```bash
   http-server -p 8000
   ```
3. Abre: **http://localhost:8000/login.html**

---

## ✅ Opción 4: Usar Live Server (VS Code)

Si usas Visual Studio Code:

1. Instala la extensión **"Live Server"**
2. Click derecho en `login.html`
3. Selecciona **"Open with Live Server"**

---

## 🔐 Credenciales de Demo

Una vez que el servidor esté corriendo:

| Email | Password | Rol |
|-------|----------|-----|
| jefe@demo.com | Demo123! | Jefe |
| contador1@demo.com | Demo123! | Contador |
| contador2@demo.com | Demo123! | Contador |
| contador3@demo.com | Demo123! | Contador |

---

## 🆘 Solución de Problemas

### Error: "python no se reconoce como comando"

**Solución:** Instala Python desde [python.org](https://www.python.org/downloads/)

Durante la instalación, marca la opción **"Add Python to PATH"**

### El servidor inicia pero no carga la página

1. Verifica que estés en: `http://localhost:8000/login.html`
2. Revisa la consola del navegador (F12) para ver errores
3. Asegúrate de haber configurado `supabase-config.js` correctamente

### Error de CORS aún con servidor

Verifica que:
1. Estés usando `http://localhost:8000` (NO `file://`)
2. El `anon key` en `supabase-config.js` esté correcto
3. Las credenciales de Supabase sean válidas

---

## 📱 Para Android

Una vez que todo funcione en el navegador:

1. Ve a la carpeta `APP/`
2. Ejecuta `SINCRONIZAR_WEB.bat`
3. Compila el APK desde Android Studio

---

**¡Listo! Ahora puedes usar la aplicación sin problemas de CORS.**
