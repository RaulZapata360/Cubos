@echo off
echo ========================================
echo   SINCRONIZAR ARCHIVOS WEB A ANDROID
echo ========================================
echo.

cd /d "%~dp0"

echo [1/3] Copiando archivos de WEB a www...
xcopy /Y /E /I "..\WEB\*" "www\"

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] No se pudieron copiar los archivos
    pause
    exit /b 1
)

echo.
echo [2/3] Sincronizando con Android...
call npx cap sync android

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Fallo la sincronizacion
    pause
    exit /b 1
)

echo.
echo ========================================
echo   SINCRONIZACION COMPLETADA
echo ========================================
echo.
echo Archivos web actualizados en el proyecto Android
echo.
echo SIGUIENTE PASO:
echo 1. Abre Android Studio (ejecuta 3_abrir_android_studio.bat)
echo 2. Build ^> Rebuild Project
echo 3. Build ^> Build APK
echo.
pause
