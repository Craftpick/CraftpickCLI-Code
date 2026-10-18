@echo off
setlocal EnableExtensions DisableDelayedExpansion
title CraftpickAI Code - Installation

set "REPO_URL=https://github.com/Craftpick/CraftpickCLI-Code.git"
set "INSTALL_ROOT=%LOCALAPPDATA%\CraftpickAI\Code"
set "BIN_DIR=%LOCALAPPDATA%\CraftpickAI\bin"
set "LOCAL_SOURCE=%~dp0..\Code"

echo.
echo   CraftpickAI Code - Installation Windows
echo   --------------------------------------
echo.

where git >nul 2>&1 || (echo [ERREUR] Git est requis : https://git-scm.com/download/win& exit /b 1)
where node >nul 2>&1 || (echo [ERREUR] Node.js 20+ est requis : https://nodejs.org/& exit /b 1)
where npm >nul 2>&1 || (echo [ERREUR] npm est introuvable. Reinstallez Node.js.& exit /b 1)
node -e "process.exit(Number(process.versions.node.split('.')[0]) >= 20 ? 0 : 1)" || (echo [ERREUR] Node.js 20 ou plus est requis.& exit /b 1)

if /I "%~1"=="--local" goto :installLocal

echo [1/4] Recuperation de CraftpickAI Code...
if exist "%INSTALL_ROOT%\.git" (
  git -C "%INSTALL_ROOT%" pull --ff-only || (echo [ERREUR] La mise a jour Git a echoue.& exit /b 1)
) else (
  if exist "%INSTALL_ROOT%" (
    echo [ERREUR] Le dossier d'installation existe mais n'est pas un depot Git :
    echo          %INSTALL_ROOT%
    echo          Supprimez-le ou utilisez un autre dossier avant de relancer l'installation.
    exit /b 1
  )
  git clone --depth 1 "%REPO_URL%" "%INSTALL_ROOT%" || (echo [ERREUR] Le clonage du depot a echoue.& exit /b 1)
)
goto :resolveApp

:installLocal
echo [1/4] Utilisation des sources locales...
if not exist "%LOCAL_SOURCE%\package.json" (
  echo [ERREUR] Sources locales introuvables : %LOCAL_SOURCE%
  exit /b 1
)
set "INSTALL_ROOT=%~dp0.."
goto :resolveApp

:resolveApp
set "APP_DIR=%INSTALL_ROOT%\Code"
if exist "%INSTALL_ROOT%\CLI\Code\package.json" set "APP_DIR=%INSTALL_ROOT%\CLI\Code"
if exist "%INSTALL_ROOT%\package.json" set "APP_DIR=%INSTALL_ROOT%"
if not exist "%APP_DIR%\package.json" (
  echo [ERREUR] package.json introuvable dans le depot.
  exit /b 1
)

echo [2/4] Installation des dependances Node.js...
if exist "%APP_DIR%\package-lock.json" (
  call npm ci --omit=dev --prefix "%APP_DIR%" || (echo [ERREUR] Installation npm impossible.& exit /b 1)
) else (
  call npm install --omit=dev --prefix "%APP_DIR%" || (echo [ERREUR] Installation npm impossible.& exit /b 1)
)

echo [3/4] Creation de la commande craftpick-code...
if not exist "%BIN_DIR%" mkdir "%BIN_DIR%" || (echo [ERREUR] Impossible de creer %BIN_DIR%& exit /b 1)
> "%BIN_DIR%\craftpick-code.cmd" echo @echo off
>> "%BIN_DIR%\craftpick-code.cmd" echo node "%APP_DIR%\bin\craftpick-code.mjs" %%*
if not exist "%BIN_DIR%\craftpick-code.cmd" (echo [ERREUR] Lanceur Windows non cree.& exit /b 1)

echo [4/4] Ajout au PATH utilisateur...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$bin='%BIN_DIR%'; $path=[Environment]::GetEnvironmentVariable('Path','User'); $parts=@(); foreach($entry in ($path -split ';')) { if($entry) { $parts += $entry } }; if($parts -notcontains $bin) { [Environment]::SetEnvironmentVariable('Path',(($parts + $bin) -join ';'),'User') }" || (echo [ERREUR] Impossible de mettre a jour le PATH utilisateur.& exit /b 1)

echo.
echo   Installation terminee.
echo   Fermez puis rouvrez PowerShell, puis lancez : craftpick-code
echo.
echo   Pour tester tout de suite dans cette fenetre :
echo   "%BIN_DIR%\craftpick-code.cmd"
exit /b 0
