@echo off
echo ========================================
echo   ABRIENDO ANDROID STUDIO
echo ========================================
echo.

REM Sincronizar cambios antes de abrir
echo Sincronizando ultimos cambios...
call npx cap sync android

echo.
echo Abriendo Android Studio...
echo.
call npx cap open android

echo.
echo ========================================
echo   INSTRUCCIONES EN ANDROID STUDIO
echo ========================================
echo.
echo 1. Espera a que Android Studio termine de cargar
echo 2. Conecta tu telefono Android por USB O usa un emulador
echo 3. Habilita "Depuracion USB" en tu telefono
echo 4. Click en el boton verde "Run" (Play)
echo 5. Selecciona tu dispositivo
echo.
echo PARA GENERAR APK:
echo 1. Build ^> Build Bundle(s) / APK(s) ^> Build APK(s)
echo 2. Espera a que compile
echo 3. El APK estara en: android\app\build\outputs\apk\debug\
echo.
pause
