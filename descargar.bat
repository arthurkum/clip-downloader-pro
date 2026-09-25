@echo off
chcp 65001 >nul
title Descargador de Clips - Hecho por @arturoeditor
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

set "DEFAULT_DIR=%OUTPUT_DIR%"
set "CURRENT_DIR=%DEFAULT_DIR%"

:inicio
cls
set "URL="
set "CHOICE="
set "CUSTOM_DIR="
set "MANTENER="
set "SUB_CHOICE="

echo ====================================================================
echo             DESCARGADOR DE CLIPS EN CALIDAD MAXIMA
echo                   Hecho por @arturoeditor
echo   Compatible con: YouTube, Instagram, TikTok, Pinterest, Twitter/X
echo ====================================================================
echo Carpeta de guardado actual:
echo %CURRENT_DIR%
if not "%CURRENT_DIR%"=="%DEFAULT_DIR%" (
    echo [AVISO: Carpeta personalizada activa. Escribe R para volver a la default]
)
echo --------------------------------------------------------------------
echo (Para cambiar la carpeta principal por defecto, ejecuta "cambiar_carpeta.bat")
echo.
set /p "URL=>> Pega el enlace aqui (o presiona ENTER para salir): "

if not defined URL goto salir
if "%URL%"=="" goto salir

:: Opcion para resetear a la carpeta default
if /i "%URL%"=="R" (
    set "CURRENT_DIR=%DEFAULT_DIR%"
    goto inicio
)

echo.
echo Â¿Que deseas hacer?
echo [1] Video en Maxima Calidad (.mp4 para CapCut/Premiere) [ENTER]
echo [2] Solo Audio / Musica (.mp3 en alta calidad)
echo [3] Enviar a otra carpeta especifica (ej: Emojis, Recursos, B-Roll)
set "CHOICE=1"
set /p "CHOICE=>> Elige [1, 2 o 3] (Default 1): "

:: Opcion 3: Carpeta personalizada
if "%CHOICE%"=="3" (
    echo.
    echo ====================================================================
    echo             SELECCION DE CARPETA ESPECIFICA
    echo ====================================================================
    set /p "CUSTOM_DIR=>> Pega o escribe la ruta de la carpeta de destino: "
    
    :: Si no escribio nada, usar la actual
    if not defined CUSTOM_DIR set "CUSTOM_DIR=%CURRENT_DIR%"
    
    :: Limpiar comillas
    set "CUSTOM_DIR=%CUSTOM_DIR:"=%"
    if not exist "%CUSTOM_DIR%" mkdir "%CUSTOM_DIR%"
    set "TARGET_DIR=%CUSTOM_DIR%"
    
    echo.
    echo Â¿Deseas mantener esta carpeta para los siguientes enlaces de esta sesion?
    echo [S] Si, mantener para los siguientes (ideal para paquetes/packs)
    echo [N] No, solo para este archivo (Default N)
    set "MANTENER=N"
    set /p "MANTENER=>> [S/N]: "
    
    if /i "%MANTENER%"=="S" (
        set "CURRENT_DIR=%CUSTOM_DIR%"
    )
    
    echo.
    echo Â¿Que formato deseas para este archivo?
    echo [1] Video en Maxima Calidad (.mp4) [ENTER]
    echo [2] Solo Audio / Musica (.mp3)
    set "SUB_CHOICE=1"
    set /p "SUB_CHOICE=>> Elige [1 o 2] (Default 1): "
    
    if "%SUB_CHOICE%"=="2" (
        goto descargar_audio
    ) else (
        goto descargar_video
    )
)

set "TARGET_DIR=%CURRENT_DIR%"

if "%CHOICE%"=="2" (
    goto descargar_audio
) else (
    goto descargar_video
)

:descargar_audio
echo.
echo [*] Extrayendo audio en alta calidad MP3 en:
echo %TARGET_DIR%
echo.
yt-dlp --no-playlist -x --audio-format mp3 --audio-quality 0 --extractor-args "youtube:player_client=web_embedded,web_safari,android,ios,mweb" --remote-components ejs:github --windows-filenames -P "%TARGET_DIR%" -o "%%(uploader)s_%%(title).30s_%%(id)s.%%(ext)s" --no-warnings "%URL%"
goto finalizar

:descargar_video
echo.
echo [*] Obteniendo video a maxima tasa de bits sin re-comprimir en:
echo %TARGET_DIR%
echo.
yt-dlp --no-playlist -f "bestvideo+bestaudio/best" --merge-output-format mp4 --remux-video mp4 -S "vcodec:h264,res,fps,acodec:aac" --extractor-args "youtube:player_client=web_embedded,web_safari,android,ios,mweb" --remote-components ejs:github --windows-filenames -P "%TARGET_DIR%" -o "%%(uploader)s_%%(title).30s_%%(id)s.%%(ext)s" --no-warnings "%URL%"
goto finalizar

:finalizar
if %ERRORLEVEL% equ 0 (
    echo.
    echo ====================================================================
    echo   [LISTO] Descarga completada al 100%% sin perdida de calidad.
    echo   Archivo guardado en: %TARGET_DIR%
    echo   Video listo para editar! - Hecho por @arturoeditor
    echo   Abriendo carpeta para arrastrar a tu programa de edicion...
    echo ====================================================================
    explorer "%TARGET_DIR%"
) else (
    echo.
    echo [!] Hubo un detalle al descargar. Revisa que el enlace sea correcto y publico.
)

echo.
echo Presiona cualquier tecla para continuar...
pause >nul
goto inicio

:salir
exit
