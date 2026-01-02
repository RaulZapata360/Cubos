@echo off
echo Iniciando Sistema de Conteo de Camiones...
echo.
echo Abriendo navegador en http://localhost:8000/login.html
echo.

REM Check if server is already running
tasklist /FI "IMAGENAME eq python.exe" 2>NUL | find /I /N "python.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo Servidor ya está corriendo
) else (
    echo Iniciando servidor HTTP en puerto 8000...
    start /B python -m http.server 8000
    timeout /t 2 /nobreak >nul
)

REM Open browser to login page
start chrome http://localhost:8000/login.html

echo.
echo Sistema iniciado - Ingresa tus credenciales
echo Presiona Ctrl+C para detener el servidor
echo.
pause
