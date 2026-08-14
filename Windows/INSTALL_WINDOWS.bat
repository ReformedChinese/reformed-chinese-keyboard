@echo off
REM Reformed Chinese Keyboard - Windows Installer
REM Double-click this file to install on Windows

echo.
echo ===================================================
echo   Reformed Chinese Keyboard - Windows Installer
echo ===================================================
echo.

REM Run PowerShell installer with execution policy bypass
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install_windows.ps1"

REM PowerShell script handles all messaging and user interaction
