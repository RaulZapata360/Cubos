@echo off
echo ========================================
echo   CREANDO PROYECTO ANDROID
echo ========================================
echo.

REM Crear proyecto Android
echo Inicializando proyecto Android con Capacitor...
echo.
call npx cap add android

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Fallo la creacion del proyecto Android
    pause
    exit /b 1
)

echo.
echo Sincronizando archivos web con Android...
echo.
call npx cap sync android

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Fallo la sincronizacion
    pause
    exit /b 1
)

echo.
echo ========================================
echo   PROYECTO ANDROID CREADO
echo ========================================
echo.
echo Se ha creado la carpeta "android" con el proyecto
echo.
echo SIGUIENTE PASO:
echo 1. Instala Android Studio desde: https://developer.android.com/studio
echo 2. Ejecuta: 3_abrir_android_studio.bat
echo.
pause
