@echo off
chcp 65001 >nul
title Instalador - Descargador de Clips - Por @arturoeditor
color 0B

echo ====================================================================
echo           INSTALADOR DEL DESCARGADOR DE CLIPS PARA EDITORES
echo                    Desarrollado por @arturoeditor
echo ====================================================================
echo.
echo Este asistente instalara las herramientas necesarias para descargar
echo videos de YouTube, Instagram y TikTok en maxima calidad sin marcas de agua.
echo.
echo Presiona cualquier tecla para comenzar la instalacion...
pause >nul
echo.

:: 1. Verificar e instalar Python / yt-dlp / ffmpeg / Deno / curl_cffi
echo [*] Paso 1/3: Verificando herramientas del sistema...

where winget >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [!] No se detecto winget. Asegurate de tener Windows 10/11 actualizado.
)

:: Verificar ffmpeg
where ffmpeg >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [*] Instalando FFmpeg (necesario para unir audio y video en maxima calidad)...
    winget install -e --id Gyan.FFmpeg --accept-source-agreements --accept-package-agreements
) else (
    echo [OK] FFmpeg ya esta instalado.
)

:: Verificar Deno (motor JavaScript necesario para YouTube)
where deno >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [*] Instalando Deno (motor JS para resolver firmas y bloqueos de YouTube)...
    winget install -e --id DenoLand.Deno --scope user --accept-source-agreements --accept-package-agreements
) else (
    echo [OK] Deno ya esta instalado.
)

:: Verificar Python
where python >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [*] Instalando Python...
    winget install -e --id Python.Python.3.12 --accept-source-agreements --accept-package-agreements
) else (
    echo [OK] Python ya esta instalado.
)

:: Instalar o actualizar yt-dlp y curl_cffi (antibot de TikTok)
echo.
echo [*] Paso 2/3: Instalando componentes de descarga y antibot (curl_cffi)...
python -m pip install --upgrade pip >nul 2>nul
python -m pip install -U yt-dlp curl_cffi

echo.
echo ====================================================================
echo   Paso 3/3: CONFIGURACION DE LA CARPETA DE GUARDADO
echo ====================================================================
echo ¿Donde deseas que se guarden automaticamente tus videos descargados?
echo.
echo [1] Carpeta automatica recomendada:
echo     %USERPROFILE%\Downloads\Clips_ArturoEditor
echo.
echo [2] Elegir una ruta personalizada (ejemplo: D:\Clips o en un disco SSD)
echo.
set /p "OPCION=Selecciona una opcion [1 o 2] (Presiona ENTER para la opcion 1): "

if "%OPCION%"=="2" (
    echo.
    set /p "CUSTOM_DIR=>> Pega o escribe la ruta exacta de tu carpeta: "
    set "FINAL_DIR=%CUSTOM_DIR%"
) else (
    set "FINAL_DIR=%USERPROFILE%\Downloads\Clips_ArturoEditor"
)

:: Limpiar comillas si el usuario las puso
set "FINAL_DIR=%FINAL_DIR:"=%"

if not exist "%FINAL_DIR%" mkdir "%FINAL_DIR%"

:: Guardar configuracion en config.bat
echo set "OUTPUT_DIR=%FINAL_DIR%" > "%~dp0config.bat"

:: Crear acceso directo en el escritorio
set "SCRIPT_PATH=%~dp0descargar.bat"
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut([Environment]::GetFolderPath('Desktop') + '\Descargador de Clips (@arturoeditor).lnk'); $Shortcut.TargetPath = '%SCRIPT_PATH%'; $Shortcut.WorkingDirectory = '%~dp0'; $Shortcut.IconLocation = 'shell32.dll,264'; $Shortcut.Save()"

echo.
echo ====================================================================
echo        ¡INSTALACION Y CONFIGURACION COMPLETADAS CON EXITO!
echo ====================================================================
echo 1. Tus videos se guardaran en: %FINAL_DIR%
echo 2. Se ha creado un acceso directo en tu Escritorio:
echo    "Descargador de Clips (@arturoeditor)"
echo.
echo ¡Ya puedes empezar a descargar!
echo ====================================================================
pause
exit
