@echo off
chcp 65001 >nul
title Descargador de Clips | Hecho por @arturoeditor
color 0A

:: Asegurar que Deno y dependencias esten en el PATH si existen en WinGet
if exist "%LOCALAPPDATA%\Microsoft\WinGet\Packages\DenoLand.Deno_Microsoft.Winget.Source_8wekyb3d8bbwe" (
    set "PATH=%LOCALAPPDATA%\Microsoft\WinGet\Packages\DenoLand.Deno_Microsoft.Winget.Source_8wekyb3d8bbwe;%PATH%"
)

:: Cargar configuracion si existe
if exist "%~dp0config.bat" (
    call "%~dp0config.bat"
)

:: Si no se ha configurado la carpeta, usar Descargas por defecto
if "%OUTPUT_DIR%"=="" (
    set "OUTPUT_DIR=%USERPROFILE%\Downloads\Clips_ArturoEditor"
)

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

:inicio
cls
echo ====================================================================
echo             DESCARGADOR DE CLIPS EN CALIDAD MAXIMA
echo                   Hecho por @arturoeditor
echo   Compatible con: YouTube (Videos/Shorts), Instagram, TikTok
echo ====================================================================
echo Carpeta de guardado:
echo %OUTPUT_DIR%
echo --------------------------------------------------------------------
echo (Para cambiar la carpeta de guardado, ejecuta "cambiar_carpeta.bat")
echo.
set /p "URL=>> Pega el enlace aqui (o presiona ENTER sin escribir nada para salir): "

if "%URL%"=="" goto salir

echo.
echo ¿Que deseas descargar?
echo [1] Video en Maxima Calidad (.mp4 para CapCut/Premiere) [ENTER]
echo [2] Solo Audio / Musica (.mp3 en alta calidad)
set "FORMAT_CHOICE=1"
set /p "FORMAT_CHOICE=>> Elige [1 o 2] (Default 1): "

if "%FORMAT_CHOICE%"=="2" (
    echo.
    echo [*] Extrayendo audio en alta calidad MP3...
    echo.
    yt-dlp --no-playlist -x --audio-format mp3 --audio-quality 0 --remote-components ejs:github --windows-filenames -P "%OUTPUT_DIR%" -o "%%(uploader)s_%%(title).30s_%%(id)s.%%(ext)s" --no-warnings "%URL%"
) else (
    echo.
    echo [*] Obteniendo video a maxima tasa de bits sin re-comprimir...
    echo.
    yt-dlp --no-playlist -f "bestvideo+bestaudio/best" --merge-output-format mp4 --remux-video mp4 -S "vcodec:h264,res,fps,acodec:aac" --remote-components ejs:github --windows-filenames -P "%OUTPUT_DIR%" -o "%%(uploader)s_%%(title).30s_%%(id)s.%%(ext)s" --no-warnings "%URL%"
)

if %ERRORLEVEL% equ 0 (
    echo.
    echo ====================================================================
    echo   [LISTO] Descarga completada al 100%% sin perdida de calidad.
    echo   Archivo listo para editar! - Hecho por @arturoeditor
    echo   Abriendo carpeta para arrastrar a tu programa de edicion...
    echo ====================================================================
    explorer "%OUTPUT_DIR%"
) else (
    echo.
    echo [!] Hubo un detalle al descargar. Revisa que el enlace sea correcto y publico.
)

echo.
echo Presiona cualquier tecla para descargar otro enlace...
pause >nul
goto inicio

:salir
exit
