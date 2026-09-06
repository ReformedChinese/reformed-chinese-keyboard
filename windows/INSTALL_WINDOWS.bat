@echo off
chcp 65001 >nul
REM Reformed Chinese Keyboard for Windows Installer
REM Double-click this file to install on Windows

echo.
echo ==================================================================
echo   改革字拼音輸入法 Reformed Chinese Keyboard for Windows Installer
echo ==================================================================
echo.

REM Run PowerShell installer with execution policy bypass
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install_windows.ps1"

REM PowerShell script handles all messaging and user interaction
