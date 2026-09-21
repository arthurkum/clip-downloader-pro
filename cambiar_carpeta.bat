@echo off
chcp 65001 >nul
title Cambiar Carpeta de Descarga | @arturoeditor
color 0E

echo ====================================================================
echo         CAMBIAR CARPETA DE GUARDADO DE CLIPS - @arturoeditor
echo ====================================================================
echo.

if exist "%~dp0config.bat" (
    call "%~dp0config.bat"
    echo Carpeta actual: %OUTPUT_DIR%
) else (
    echo Carpeta actual: %USERPROFILE%\Downloads\Clips_ArturoEditor
)
echo --------------------------------------------------------------------
echo.
echo [1] Usar carpeta por defecto (%USERPROFILE%\Downloads\Clips_ArturoEditor)
echo [2] Escribir una nueva ruta (ejemplo: D:\Marcas\Videos o disco externo)
echo.
set /p "OPCION=Elige una opcion [1 o 2]: "

if "%OPCION%"=="2" (
    echo.
    set /p "NEW_DIR=>> Pega o escribe la nueva ruta de la carpeta: "
    set "FINAL_DIR=%NEW_DIR%"
) else (
    set "FINAL_DIR=%USERPROFILE%\Downloads\Clips_ArturoEditor"
)

set "FINAL_DIR=%FINAL_DIR:"=%"

if not exist "%FINAL_DIR%" mkdir "%FINAL_DIR%"

echo set "OUTPUT_DIR=%FINAL_DIR%" > "%~dp0config.bat"

echo.
echo ====================================================================
echo [LISTO] ¡Carpeta actualizada con exito!
echo Ahora tus videos se guardaran en: %FINAL_DIR%
echo ====================================================================
echo.
pause
exit
