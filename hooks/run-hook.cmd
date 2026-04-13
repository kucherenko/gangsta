: << 'BATCH_SCRIPT'
@echo off
setlocal enabledelayedexpansion

REM Gangsta cross-platform hook wrapper (bash/batch polyglot)
REM On Windows, finds bash and dispatches to the named hook script

set "HOOK_NAME=%~1"
set "HOOK_DIR=%~dp0"

REM Try Git for Windows bash
where bash >nul 2>&1 && (
    bash "%HOOK_DIR%%HOOK_NAME%" %*
    exit /b %ERRORLEVEL%
)

REM Try common locations
for %%B in (
    "C:\Program Files\Git\bin\bash.exe"
    "C:\Program Files (x86)\Git\bin\bash.exe"
    "%LOCALAPPDATA%\Programs\Git\bin\bash.exe"
) do (
    if exist %%B (
        %%B "%HOOK_DIR%%HOOK_NAME%" %*
        exit /b %ERRORLEVEL%
    )
)

echo ERROR: bash not found. Install Git for Windows.
exit /b 1
BATCH_SCRIPT

# Unix: dispatch to the named hook
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HOOK_NAME="$1"
shift
exec "$SCRIPT_DIR/$HOOK_NAME" "$@"
