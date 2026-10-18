@echo off
setlocal EnableExtensions
set "REPO_URL=https://github.com/Craftpick/CraftpickCLI-Code.git"
set "INSTALL_ROOT=%LOCALAPPDATA%\CraftpickAI\Code"

where git >nul 2>&1 || (echo Git est requis.& exit /b 1)
where node >nul 2>&1 || (echo Node.js 20 ou plus est requis.& exit /b 1)
node -e "process.exit(Number(process.versions.node.split('.')[0]) >= 20 ? 0 : 1)" || (echo Node.js 20 ou plus est requis.& exit /b 1)

if exist "%INSTALL_ROOT%\.git" (
  git -C "%INSTALL_ROOT%" pull --ff-only || exit /b 1
) else (
  if exist "%INSTALL_ROOT%" rmdir /s /q "%INSTALL_ROOT%"
  git clone --depth 1 "%REPO_URL%" "%INSTALL_ROOT%" || exit /b 1
)

set "APP_DIR=%INSTALL_ROOT%\Code"
if exist "%INSTALL_ROOT%\CLI\Code\package.json" set "APP_DIR=%INSTALL_ROOT%\CLI\Code"
if exist "%INSTALL_ROOT%\package.json" set "APP_DIR=%INSTALL_ROOT%"
if not exist "%APP_DIR%\package.json" (echo Le projet CraftpickAI Code est introuvable dans le depot.& exit /b 1)
npm install --omit=dev --prefix "%APP_DIR%" || exit /b 1

set "BIN_DIR=%LOCALAPPDATA%\CraftpickAI\bin"
if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"
> "%BIN_DIR%\craftpick-code.cmd" echo @echo off
>> "%BIN_DIR%\craftpick-code.cmd" echo node "%APP_DIR%\bin\craftpick-code.mjs" %%*
powershell -NoProfile -ExecutionPolicy Bypass -Command "$bin=[Environment]::GetEnvironmentVariable('Path','User'); if(($bin -split ';') -notcontains '%BIN_DIR%'){[Environment]::SetEnvironmentVariable('Path',($bin.TrimEnd(';')+';%BIN_DIR%'),'User')}"

echo CraftpickAI Code installe.
echo Ouvrez un nouveau terminal puis lancez : craftpick-code
