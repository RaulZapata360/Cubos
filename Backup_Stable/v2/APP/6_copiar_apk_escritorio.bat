@echo off
echo ========================================
echo   COPIAR APK A ESCRITORIO
echo ========================================
echo.

set APK_SOURCE=android\app\build\outputs\apk\debug\app-debug.apk
set APK_DEST=%USERPROFILE%\Desktop\Conteo-Camiones.apk

if not exist "%APK_SOURCE%" (
    echo [ERROR] No se encontro el APK
    echo.
    echo Asegurate de haber compilado el APK en Android Studio:
    echo Build ^> Build Bundle^(s^) / APK^(s^) ^> Build APK^(s^)
    echo.
    pause
    exit /b 1
)

echo Copiando APK al escritorio...
copy "%APK_SOURCE%" "%APK_DEST%"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo   APK COPIADO EXITOSAMENTE
    echo ========================================
    echo.
    echo Ubicacion: %APK_DEST%
    echo Tamano: 
    for %%A in ("%APK_DEST%") do echo %%~zA bytes
    echo.
    echo Ahora puedes:
    echo 1. Transferir el APK a tu telefono
    echo 2. Instalarlo directamente
    echo 3. Compartirlo con otros
    echo.
    echo Abriendo carpeta del escritorio...
    explorer %USERPROFILE%\Desktop
) else (
    echo.
    echo [ERROR] No se pudo copiar el APK
)

echo.
pause
