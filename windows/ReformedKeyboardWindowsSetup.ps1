# Reformed Chinese Keyboard for Windows Automated Installer
# This script automates the complete installation process for Windows

# Requires: PowerShell 5.1 or later, Administrator privileges for Weasel installation

# Set console to UTF-8 to display Chinese characters correctly
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Set error action preference
$ErrorActionPreference = "Stop"

# Color output functions
function Write-Success {
    param([string]$Message)
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-Info {
    param([string]$Message)
    Write-Host "[>>] $Message" -ForegroundColor Cyan
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[!!] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[XX] $Message" -ForegroundColor Red
}

function Write-Header {
    param([string]$Message)
    Write-Host ""
    Write-Host "====================================================" -ForegroundColor Magenta
    Write-Host "  $Message" -ForegroundColor Magenta
    Write-Host "====================================================" -ForegroundColor Magenta
    Write-Host ""
}

# Main installation function
function Install-ReformedKeyboard {
    Write-Header "Reformed Chinese Keyboard Installer"
    Write-Info "This will install Reformed Chinese keyboard on your Windows PC"
    Write-Host ""

    # Get script directory (Windows subdirectory)
    $ScriptDir = if ($PSScriptRoot) {
        $PSScriptRoot
    } elseif ($MyInvocation.MyCommand.Path) {
        Split-Path -Parent $MyInvocation.MyCommand.Path
    } else {
        Get-Location
    }
    
    # Rime files are in the same directory as this installer
    $ReformedDir = Split-Path -Parent $ScriptDir
    $RimeFilesDir = $ScriptDir
    
    Write-Info "Installation directory: $ReformedDir"
    Write-Host ""

    # Step 1: Check if Weasel is installed
    Write-Header "Step 1/6: Checking Weasel Installation"
    
    $WeaselPaths = @(
        "C:\Program Files\Rime\weasel-*\WeaselServer.exe",
        "C:\Program Files (x86)\Rime\weasel-*\WeaselServer.exe"
    )
    
    $WeaselPath = $null
    foreach ($Pattern in $WeaselPaths) {
        $Matches = Get-ChildItem -Path $Pattern -ErrorAction SilentlyContinue | Sort-Object FullName -Descending
        if ($Matches) {
            $WeaselPath = $Matches[0].FullName
            break
        }
    }
    
    if (-not $WeaselPath) {
        # Check if WeaselServer is running
        $WeaselProcess = Get-Process -Name "WeaselServer" -ErrorAction SilentlyContinue
        if ($WeaselProcess) {
            $WeaselPath = $WeaselProcess.Path
        }
    }
    
    if ($WeaselPath) {
        Write-Success "Weasel found at: $WeaselPath"
        $WeaselDir = Split-Path -Parent $WeaselPath
        $DeployerPath = Join-Path $WeaselDir "WeaselDeployer.exe"
    } else {
        Write-Warning "Weasel not found!"
        Write-Info "Please install Weasel first:"
        Write-Info "1. Visit https://rime.im/download/"
        Write-Info "2. Download and install Weasel (小狼毫)"
        Write-Info "3. Run this installer again"
        Write-Host ""
        
        $OpenBrowser = Read-Host "Open Weasel download page in browser? (Y/N)"
        if ($OpenBrowser -eq "Y" -or $OpenBrowser -eq "y") {
            Start-Process "https://rime.im/download/"
            Write-Host ""
            Write-Info "Opening download page in your browser..."
            Write-Info "After installing Weasel, please run this installer again."
        }
        
        Write-Host ""
        Write-Host "Installation paused, Weasel needs to be installed first." -ForegroundColor Yellow
        Write-Host ""
        Write-Info "Next steps:"
        Write-Host "  1. Download and install Weasel from the browser"
        Write-Host "  2. Run this installer again: .\ReformedKeyboardWindowsSetup.bat"
        Write-Host ""
        Write-Host "Press any key to exit..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        exit 0
    }
    
    # Step 2: Check Python installation
    Write-Header "Step 2/6: Checking Python Installation"
    
    try {
        $PythonVersion = & python --version 2>&1
        Write-Success "Python found: $PythonVersion"
    } catch {
        Write-Warning "Python not found"
        Write-Info "Python is optional but recommended for customization"
        Write-Info "You can install it later from: https://www.python.org/downloads/"
        Write-Host ""
    }
    
    # Step 3: Verify required files
    Write-Header "Step 3/6: Verifying Required Files"
    
    $RequiredFiles = @(
        "reformed.schema.yaml",
        "reformed.dict.yaml",
        "rime.lua",
        "default.custom.yaml"
    )
    $RequiredLuaFiles = @(
        "reformed_filter.lua",
        "reformed_commit_filter.lua"
    )
    
    $MissingFiles = @()
    foreach ($File in $RequiredFiles) {
        $FilePath = Join-Path $RimeFilesDir $File
        if (Test-Path $FilePath) {
            Write-Success "$File found"
        } else {
            Write-Error "$File missing"
            $MissingFiles += $File
        }
    }
    foreach ($File in $RequiredLuaFiles) {
        $FilePath = Join-Path (Join-Path $RimeFilesDir "lua") $File
        if (Test-Path $FilePath) {
            Write-Success "lua\$File found"
        } else {
            Write-Error "lua\$File missing"
            $MissingFiles += "lua\$File"
        }
    }
    
    if ($MissingFiles.Count -gt 0) {
        Write-Error "Missing required files: $($MissingFiles -join ', ')"
        Write-Info "Please make sure all files are in the same directory as this installer"
        exit 1
    }
    
    # Step 4: Deploy schema files
    Write-Header "Step 4/6: Deploying Schema Files"
    
    $RimeDir = Join-Path $env:APPDATA "Rime"
    if (-not (Test-Path $RimeDir)) {
        New-Item -ItemType Directory -Path $RimeDir -Force | Out-Null
        Write-Success "Created Rime directory: $RimeDir"
    }
    
    $SchemaFiles = @(
        "reformed.schema.yaml",
        "reformed.dict.yaml",
        "default.custom.yaml"
    )
    
    # Check if reformed.custom.dict.yaml exists
    if (Test-Path (Join-Path $RimeFilesDir "reformed.custom.dict.yaml")) {
        $SchemaFiles += "reformed.custom.dict.yaml"
    }
    
    foreach ($File in $SchemaFiles) {
        $SourcePath = Join-Path $RimeFilesDir $File
        $DestPath = Join-Path $RimeDir $File
        Copy-Item $SourcePath $DestPath -Force
        Write-Success "Deployed $File"
    }
    
    # Step 5: Deploy Lua filters with UTF-8 preservation
    Write-Header "Step 5/6: Deploying Lua Filters (UTF-8 Encoding)"
    
    $LuaDir = Join-Path $RimeDir "lua"
    if (-not (Test-Path $LuaDir)) {
        New-Item -ItemType Directory -Path $LuaDir -Force | Out-Null
        Write-Success "Created lua directory: $LuaDir"
    }
    
    Write-Info "Using UTF-8 encoding preservation..."
    
    # Deploy reformed_filter.lua with UTF-8 preservation
    try {
        $SourcePath = Join-Path (Join-Path $RimeFilesDir "lua") "reformed_filter.lua"
        $DestPath = Join-Path $LuaDir "reformed_filter.lua"
        
        $Content = [System.IO.File]::ReadAllText($SourcePath, [System.Text.Encoding]::UTF8)
        [System.IO.File]::WriteAllText($DestPath, $Content, [System.Text.UTF8Encoding]::new($false))
        
        Write-Success "Deployed reformed_filter.lua (UTF-8 preserved)"
    } catch {
        Write-Error "Failed to deploy reformed_filter.lua: $_"
        exit 1
    }
    
    # Deploy reformed_commit_filter.lua with UTF-8 preservation
    try {
        $SourcePath = Join-Path (Join-Path $RimeFilesDir "lua") "reformed_commit_filter.lua"
        $DestPath = Join-Path $LuaDir "reformed_commit_filter.lua"
        
        $Content = [System.IO.File]::ReadAllText($SourcePath, [System.Text.Encoding]::UTF8)
        [System.IO.File]::WriteAllText($DestPath, $Content, [System.Text.UTF8Encoding]::new($false))
        
        Write-Success "Deployed reformed_commit_filter.lua (UTF-8 preserved)"
    } catch {
        Write-Error "Failed to deploy reformed_commit_filter.lua: $_"
        exit 1
    }
    
    # Deploy rime.lua (regular copy is fine for this file)
    try {
        $SourcePath = Join-Path $RimeFilesDir "rime.lua"
        $DestPath = Join-Path $RimeDir "rime.lua"
        Copy-Item $SourcePath $DestPath -Force
        Write-Success "Deployed rime.lua"
    } catch {
        Write-Error "Failed to deploy rime.lua: $_"
        exit 1
    }
    
    # Verify UTF-8 encoding
    Write-Info "Verifying UTF-8 encoding..."
    try {
        $FilterPath = Join-Path $LuaDir "reformed_filter.lua"
        $Content = [System.IO.File]::ReadAllText($FilterPath, [System.Text.Encoding]::UTF8)
        
        # Check for Chinese characters (should be readable, not garbled)
        if ($Content -match "[\u4e00-\u9fff]") {
            Write-Success "UTF-8 encoding verified"
        } else {
            Write-Warning "Warning: Could not verify Chinese characters in filter"
        }
    } catch {
        Write-Warning "Could not verify UTF-8 encoding: $_"
    }
    
    Write-Success "Reformed set as default schema (via default.custom.yaml)"
    
    # Step 6: Deploy and restart Weasel
    Write-Header "Step 6/6: Deploying Configuration and Restarting Weasel"
    
    Write-Info "Deploying Rime configuration..."
    try {
        & $DeployerPath /deploy
        Write-Success "Configuration deployed successfully"
    } catch {
        Write-Error "Failed to deploy configuration: $_"
        Write-Info "You may need to deploy manually later"
    }
    
    Write-Info "Restarting Weasel server..."
    try {
        $WeaselServerExe = Join-Path (Split-Path -Parent $WeaselPath) "WeaselServer.exe"
        Stop-Process -Name "WeaselServer" -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        Start-Process -FilePath $WeaselServerExe
        Start-Sleep -Seconds 2
        Write-Success "Weasel server restarted"
    } catch {
        Write-Warning "Could not restart WeaselServer automatically"
        Write-Info "Please restart it manually or log out and back in"
    }
    
    # Final success message
    Write-Header "Installation Complete!"
    
    Write-Success "Reformed Chinese Keyboard is now installed!"
    Write-Host ""
    Write-Info "Next steps:"
    Write-Host "  1. Select Weasel keyboard by ⊞ Windows key+Spacebar"
    Write-Host "     or from bottom right corner of your Windows taskbar"
    Write-Host "  2. Type some 拼音 Pinyin (e.g. 'zenmeyang')"
    Write-Host "  3. You should see Reformed Chinese characters (怎庅样 not 怎麼樣 nor 怎么样)"
    Write-Host ""
    
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# Run the installer
try {
    Install-ReformedKeyboard
} catch {
    Write-Error "Installation failed: $_"
    Write-Host ""
    Write-Info "Please review instructions in reformed-chinese-keyboard/windows/README.md"
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}
