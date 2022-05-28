@echo off

echo Starting updates...

Rem Check git version: git --version
echo Updating git...
git update-git-for-windows

Rem Check pip version: pip --version
echo Updating pip...
py -m pip install --upgrade pip

Rem Upgrade pip packages
echo Upgrading pip packages...

:ask
set /p input=Do you want to update interactively or automatically? (i/a) 
if /i "%input%"=="i" goto interact
if /i "%input%"=="a" goto auto
echo Option not found: only (i/a) allowed.
goto ask

Rem Upgrade all packages interactively
:interact
pip-review --local --interactive
goto commonexit

Rem Upgrade all packages automatically
:auto
pip-review --local --auto
goto commonexit

:commonexit
pause
