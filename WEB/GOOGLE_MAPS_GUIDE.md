# Google Maps Integration - User Guide

## Para Administradores

### 1. Obtener API Key de Google Maps

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Crea un proyecto nuevo o selecciona uno existente
3. Habilita **Distance Matrix API**:
   - En el menú lateral, ve a "APIs & Services" → "Library"
   - Busca "Distance Matrix API"
   - Haz clic en "Enable"
4. Crea una API Key:
   - Ve a "APIs & Services" → "Credentials"
   - Haz clic en "Create Credentials" → "API Key"
   - Copia la API Key generada

### 2. Configurar API Key en el Proyecto

**Opción A: Para desarrollo local**
1. Abre `WEB/supabase-config.js`
2. Reemplaza `'YOUR_GOOGLE_MAPS_API_KEY_HERE'` con tu API Key
3. Cambia `enabled: false` a `enabled: true`

**Opción B: Para producción en Vercel (Recomendado)**
1. Ve al dashboard de Vercel
2. Selecciona tu proyecto
3. Ve a "Settings" → "Environment Variables"
4. Agrega una nueva variable:
   - Name: `GOOGLE_MAPS_API_KEY`
   - Value: Tu API Key
   - Environments: Production, Preview
5. Redeploy el proyecto

### 3. Agregar Direcciones a Orígenes y Destinos

Para que el sistema pueda calcular distancias y tiempos, necesitas agregar direcciones a tus orígenes y destinos:

1. Ve a la pestaña "Administración" en `index.html`
2. Para cada origen/destino:
   - Haz clic en el ícono de editar (lápiz)
   - Agrega la dirección completa en el campo "Dirección"
   - Ejemplo: `Av. Libertador Bernardo O'Higgins 1234, Santiago, Chile`
   - Guarda los cambios

**Nota**: Las direcciones deben ser lo más específicas posible para obtener resultados precisos.

### 4. Configurar Rendimiento de Camiones

1. Ve a la pestaña "Administración" → "Camiones"
2. Para cada camión:
   - Haz clic en editar
   - Ingresa el rendimiento en km/L (kilómetros por litro)
   - Si no conoces el valor exacto, usa 3.5 km/L como default
   - Guarda los cambios

## Para Usuarios (Jefes de Obra)

### Ver Rutas Activas

1. Abre `boss.html`
2. Ve a la pestaña "Reportes" → "Rutas"
3. Verás una tabla con:
   - Rutas utilizadas hoy
   - Número de camiones en cada ruta
   - Distancia en kilómetros
   - Tiempo estimado sin tráfico
   - Tiempo con tráfico actual
   - Indicador de tráfico (🟢 fluido, 🟡 moderado, 🔴 pesado)

### Actualizar Datos de Tráfico

- Los datos se actualizan automáticamente cada 30 minutos
- Para actualizar manualmente, haz clic en el botón "Refrescar Tráfico"

### Ver Consumo de Combustible

En la sección de "Rutas", también verás:
- Consumo total estimado del día
- Consumo por ruta
- Consumo por camión

## Solución de Problemas

### No aparecen datos de rutas

**Posible causa**: Falta configurar direcciones
- **Solución**: Agrega direcciones a orígenes y destinos (ver sección 3)

### Error "API Key not configured"

**Posible causa**: API Key no está configurada
- **Solución**: Configura la API Key (ver sección 2)

### Tiempos de viaje incorrectos

**Posible causa**: Direcciones incorrectas o incompletas
- **Solución**: Verifica que las direcciones sean correctas y específicas

### Consumo de combustible parece incorrecto

**Posible causa**: Rendimiento de camión no configurado o incorrecto
- **Solución**: Verifica y actualiza el rendimiento de cada camión (ver sección 4)

## Costos de Google Maps API

- **Crédito mensual gratuito**: $200 USD
- **Costo por consulta**: $5 USD por 1,000 consultas
- **Estimación**: Con el sistema de caché de 30 minutos, deberías mantenerte dentro del límite gratuito

**Monitorear uso**:
1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Selecciona tu proyecto
3. Ve a "APIs & Services" → "Dashboard"
4. Revisa el uso de "Distance Matrix API"
