@echo off
echo ========================================
echo   ACTUALIZAR APP ANDROID
echo ========================================
echo.
echo Este script sincroniza los cambios de tu app web
echo con el proyecto Android.
echo.
echo Ejecuta esto cada vez que hagas cambios en:
echo - HTML
echo - CSS  
echo - JavaScript
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
echo   SINCRONIZACION COMPLETADA
echo ========================================
echo.
echo Los cambios han sido copiados al proyecto Android
echo.
echo OPCIONES:
echo 1. Ejecuta 3_abrir_android_studio.bat para probar
echo 2. O simplemente reconstruye en Android Studio
echo.
pause
