@echo off
echo Iniciando servidor local para Conteo de Camiones...
echo.
echo Servidor corriendo en: http://localhost:8000
echo Presiona Ctrl+C para detener el servidor
echo.

cd /d "%~dp0"
start http://localhost:8000
python -m http.server 8000
