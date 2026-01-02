@echo off
title Servidor Local - Conteo de Camiones
color 0A

echo ========================================
echo   SERVIDOR LOCAL - CONTEO DE CAMIONES
echo ========================================
echo.
echo Proyecto: Sistema de Conteo de Camiones
echo Version: v3.1.3
echo Puerto: 8080
echo.
echo ========================================
echo   URLS DISPONIBLES
echo ========================================
echo.
echo  [LOGIN]     http://localhost:8080/login.html
echo  [JEFE]      http://localhost:8080/boss.html
echo  [CONTADOR]  http://localhost:8080/index.html
echo  [SELECTOR]  http://localhost:8080/site-selector.html
echo  [CACHE]     http://localhost:8080/clear-cache.html
echo.
echo ========================================
echo   USUARIOS DE PRUEBA
echo ========================================
echo.
echo  JEFE:
echo    Email: jefe@demo.com
echo    Pass:  Demo123!
echo.
echo  CONTADORES:
echo    Email: contador1@demo.com (Aeroparque)
echo    Email: contador2@demo.com (VAIN)
echo    Email: contador3@demo.com (Azul)
echo    Pass:  Demo123!
echo.
echo ========================================
echo   SERVIDOR INICIANDO...
echo ========================================
echo.
echo  URL: http://localhost:8080
echo  Presiona Ctrl+C para detener
echo.

cd /d "%~dp0"

REM Abrir navegador automáticamente
start http://localhost:8080/login.html

REM Iniciar servidor Python
python -m http.server 8080
