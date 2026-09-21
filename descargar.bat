@echo off
chcp 65001 >nul
title Descargador de Clips | Hecho por @arturoeditor
color 0A

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
echo       Compatible con: Instagram (Reels/Posts), TikTok, YouTube
echo ====================================================================
echo Carpeta de guardado:
echo %OUTPUT_DIR%
echo --------------------------------------------------------------------
echo (Para cambiar la carpeta de guardado, ejecuta "cambiar_carpeta.bat")
echo.
set /p "URL=>> Pega el enlace aqui (o presiona ENTER sin escribir nada para salir): "

if "%URL%"=="" goto salir

echo.
echo [*] Obteniendo video a maxima tasa de bits sin re-comprimir...
echo.

yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mp4 --remux-video mp4 -S "vcodec:h264,res,fps,acodec:aac" --windows-filenames -P "%OUTPUT_DIR%" -o "%%(uploader)s_%%(title).30s_%%(id)s.%%(ext)s" --no-warnings "%URL%"

if %ERRORLEVEL% equ 0 (
    echo.
    echo ====================================================================
    echo   [LISTO] Descarga completada al 100%% sin perdida de calidad.
    echo   Video listo para editar! - Hecho por @arturoeditor
    echo   Abriendo carpeta para arrastrar a tu programa de edicion...
    echo ====================================================================
    explorer "%OUTPUT_DIR%"
) else (
    echo.
    echo [!] Hubo un detalle al descargar. Revisa que la publicacion sea publica.
)

echo.
echo Presiona cualquier tecla para descargar otro video...
pause >nul
goto inicio

:salir
exit
