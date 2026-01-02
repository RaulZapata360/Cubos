@echo off
echo ========================================
echo   SERVIDOR LOCAL - CONTEO DE CAMIONES
echo ========================================
echo.
echo Iniciando servidor en http://localhost:8000
echo.
echo IMPORTANTE: 
echo - NO cierres esta ventana mientras uses la app
echo - Abre tu navegador en: http://localhost:8000/login.html
echo.
echo Presiona Ctrl+C para detener el servidor
echo ========================================
echo.

cd /d "%~dp0"
python -m http.server 8000

pause
