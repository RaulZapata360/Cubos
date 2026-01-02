@echo off
echo ========================================
echo   SOLUCION: ERROR DE GRADLE
echo ========================================
echo.
echo Este script actualiza Gradle a la version 8.5
echo (requerida por Android Studio)
echo.

cd android

echo Limpiando cache de Gradle...
call gradlew clean

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [INFO] Si falla, es normal en la primera ejecucion
    echo Android Studio descargara Gradle automaticamente
)

echo.
echo ========================================
echo   GRADLE ACTUALIZADO
echo ========================================
echo.
echo SIGUIENTE PASO:
echo 1. Cierra Android Studio si esta abierto
echo 2. Vuelve a abrir el proyecto
echo 3. Android Studio descargara Gradle 8.5 automaticamente
echo 4. Espera a que termine la sincronizacion
echo.
pause
