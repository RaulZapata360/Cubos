# Plan de Migración a Android Studio (Capacitor) 🚀

Este documento detalla los pasos para llevar la aplicación web actual a un entorno nativo de Android utilizando **Capacitor**.

## 1. Requisitos Previos
*   **Node.js**: Instalado en el sistema.
*   **Android Studio**: Instalado y configurado con el SDK de Android (API 30 o superior recomendada).
*   **Java JDK 17**: Requerido para las versiones modernas de Gradle.

## 2. Preparación de Archivos Web
Antes de sincronizar con el proyecto Android, asegúrate de que los archivos en la carpeta `WEB/` estén listos. Capacitor toma los archivos de la carpeta `APP/www/`.

## 3. Flujo de Trabajo de Sincronización
Cada vez que realices cambios en la carpeta `WEB`, debes seguir estos pasos para verlos en Android Studio:

1.  **Limpiar la carpeta de destino**:
    Borra el contenido de `APP/www/` para evitar archivos residuales.
2.  **Copiar archivos actuales**:
    Copia todo el contenido de `WEB/` a `APP/www/`.
3.  **Sincronizar Capacitor**:
    Abre una terminal en la carpeta `APP/` y ejecuta:
    ```bash
    npx cap sync android
    ```
    *Este comando copia el código web a la carpeta nativa de Android y actualiza los plugins.*

## 4. Ejecución en Android Studio
Para abrir el proyecto en Android Studio:
1.  En la carpeta `APP/`, ejecuta:
    ```bash
    npx cap open android
    ```
2.  Una vez abierto Android Studio:
    *   Espera a que **Gradle** termine de sincronizar (barra de progreso abajo a la derecha).
    *   Conecta un celular físico o inicia un Emulador.
    *   Presiona el botón **Run (Play verde)**.

## 5. Scripts de Ayuda (Automatización)
En la carpeta `APP/` ya existen archivos `.bat` que automatizan estos procesos:
*   `SINCRONIZAR_WEB.bat`: Realiza la copia de archivos y ejecuta `cap sync`.
*   `3_abrir_android_studio.bat`: Abre el proyecto directamente en el IDE.
*   `6_copiar_apk_escritorio.bat`: Extrae el archivo APK generado por Android Studio al escritorio.

## 6. Configuración de Supabase
Recuerda que para que la app funcione en un dispositivo móvil:
*   La URL de Supabase debe ser la URL pública (`https://xyz.supabase.co`).
*   Asegúrate de que las RLS (Políticas de Seguridad) permitan el acceso desde el `origin` que usa Capacitor (generalmente `http://localhost`).

---
**Estado del Respaldo**: Se ha creado una copia estable de esta versión en:
`C:\Users\raulz\OneDrive\Escritorio\IA\Conteo\Conteo Camiones\Backup_Stable\v2`
