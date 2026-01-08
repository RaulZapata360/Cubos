# 🔧 GUÍA DE DIAGNÓSTICO - Datos no se cargan

## 📋 Pasos para diagnosticar el problema

### **Paso 1: Abrir la consola del navegador**
1. Abre `index.html` en tu navegador
2. Presiona `F12` para abrir las herramientas de desarrollador
3. Ve a la pestaña **"Console"**

### **Paso 2: Ejecutar el script de diagnóstico**
1. Abre el archivo `DIAGNOSTICO.js` (está en la misma carpeta que index.html)
2. **Copia TODO el contenido** del archivo
3. **Pégalo en la consola** del navegador
4. Presiona `Enter`

### **Paso 3: Leer los resultados**

El script te mostrará 6 verificaciones:

#### ✅ **Si todo está OK:**
```
✅ Supabase library cargada
✅ supabaseClient existe
✅ Usuario autenticado
✅ Obra seleccionada
✅ Conexión a Supabase OK
```

#### ❌ **Si hay errores, aquí están las soluciones:**

**Error 1: "❌ Usuario NO autenticado"**
- **Solución**: Necesitas hacer login primero
- Ve a `login.html` e inicia sesión

**Error 2: "❌ NO hay obra seleccionada"**
- **Solución**: Necesitas seleccionar una obra
- Ve a `site-selector.html` y selecciona una obra

**Error 3: "❌ Error conectando a Supabase"**
- **Solución**: Problema de conexión a internet o Supabase caído
- Verifica tu conexión a internet
- Intenta más tarde

**Error 4: "❌ Supabase library NO cargada"**
- **Solución**: El CDN de Supabase no se cargó
- Verifica tu conexión a internet
- Refresca la página (`Ctrl + Shift + R`)

---

## 🚀 Solución Rápida (si no quieres usar el script)

### **Opción A: Verificar manualmente**
1. Abre `index.html`
2. Presiona `F12` → pestaña "Console"
3. Busca mensajes de error en rojo
4. Toma una captura de pantalla y envíamela

### **Opción B: Reiniciar desde cero**
1. Cierra el navegador completamente
2. Abre el navegador de nuevo
3. Ve a `login.html`
4. Inicia sesión
5. Selecciona una obra
6. Ve a `index.html`

---

## 📸 Si nada funciona

Toma capturas de pantalla de:
1. La consola del navegador (pestaña "Console")
2. La pestaña "Network" (para ver qué requests fallan)
3. La página completa

Y envíamelas para ayudarte mejor.
