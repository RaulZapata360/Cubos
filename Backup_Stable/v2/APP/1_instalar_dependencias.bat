@echo off
echo ========================================
echo   INSTALACION DE DEPENDENCIAS ANDROID
echo ========================================
echo.

REM Verificar si Node.js está instalado
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Node.js no está instalado.
    echo.
    echo Por favor instala Node.js desde: https://nodejs.org/
    echo Descarga la version LTS (recomendada)
    pause
    exit /b 1
)

echo [OK] Node.js detectado
node --version
echo.

REM Instalar dependencias
echo Instalando dependencias de Capacitor...
echo.
call npm install

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Fallo la instalacion de dependencias
    pause
    exit /b 1
)

echo.
echo ========================================
echo   INSTALACION COMPLETADA
echo ========================================
echo.
echo Ahora ejecuta: 2_crear_proyecto_android.bat
echo.
pause
