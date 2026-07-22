@echo off
set SCRIPT_DIR=%~dp0
where python3 >nul 2>nul
if %ERRORLEVEL%==0 (
  python3 "%SCRIPT_DIR%armarius_write.py" %*
  exit /b %ERRORLEVEL%
)
where python >nul 2>nul
if %ERRORLEVEL%==0 (
  python "%SCRIPT_DIR%armarius_write.py" %*
  exit /b %ERRORLEVEL%
)
where py >nul 2>nul
if %ERRORLEVEL%==0 (
  py -3 "%SCRIPT_DIR%armarius_write.py" %*
  exit /b %ERRORLEVEL%
)
echo Armarius needs Python 3, but no python3, python, or py launcher was found on PATH. 1>&2
exit /b 127
