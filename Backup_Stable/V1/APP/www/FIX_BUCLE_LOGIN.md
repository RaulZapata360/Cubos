# 🔧 Solución al Bucle de Login

## Problema
La página de login se recarga infinitamente porque hay una sesión activa de Supabase.

## Solución

### Opción 1: Limpiar desde la Consola del Navegador

1. Presiona **F12** para abrir DevTools
2. Ve a la pestaña **Console**
3. Pega este código y presiona Enter:

```javascript
// Limpiar sesión de Supabase
localStorage.clear();
sessionStorage.clear();
location.reload();
```

### Opción 2: Limpiar desde Application/Storage

1. Presiona **F12**
2. Ve a la pestaña **Application** (o **Almacenamiento**)
3. En el menú izquierdo:
   - **Local Storage** → `http://localhost:8000` → Click derecho → **Clear**
   - **Session Storage** → `http://localhost:8000` → Click derecho → **Clear**
4. Recarga la página (F5)

### Opción 3: Modo Incógnito

1. Abre una ventana de incógnito/privada
2. Ve a `http://localhost:8000/login.html`
3. Inicia sesión normalmente

---

## Después de Limpiar

Una vez limpiada la sesión, podrás:

1. Ver el formulario de login sin recargas
2. Ingresar `jefe@demo.com` / `Demo123!`
3. Iniciar sesión correctamente
4. Ser redirigido a `boss.html` sin bucles

---

## ¿Por qué pasó esto?

El sistema guardó una sesión de Supabase, pero `boss.html` aún no está completamente integrado con Supabase, causando que redirija de vuelta al login, creando un bucle infinito.

**Solución aplicada**: Desactivé el auto-redirect en `login.html` para evitar futuros bucles.
