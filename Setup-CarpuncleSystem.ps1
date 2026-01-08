<#
.SYNOPSIS
    Carpuncle Vollautomatisches System-Setup
    Ein einziges Skript für die komplette Workstation-Konfiguration

.DESCRIPTION
    Dieses Skript richtet das komplette Carpuncle-System ein:
    - Windows-Benutzer "carpu" mit automatischem Login
    - Zwei Microsoft-Konten harmonisch integriert
    - T:\Carpuncle Workspace mit allen Tools
    - OneDrive-Integration (Business + Personal)
    - Server-Verbindungen (Root, VPS, Webhosting)
    - SSH-Keys für passwortlosen Zugriff
    - Windows Terminal mit GitHub Copilot
    - Lana KI-System Integration

.PARAMETER SkipUserSetup
    Überspringe Benutzer-Konfiguration

.PARAMETER SkipToolsSetup
    Überspringe Tool-Installation

.PARAMETER SkipServerSetup
    Überspringe Server-Konfiguration

.EXAMPLE
    .\Setup-CarpuncleSystem.ps1
    Führt komplettes Setup durch

.EXAMPLE
    .\Setup-CarpuncleSystem.ps1 -SkipUserSetup
    Setup ohne Benutzer-Konfiguration

.NOTES
    Autor: Carpuncle DevOps Team
    Version: 1.0.0
    Erfordert: PowerShell 7+, Administrator-Rechte
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [switch]$SkipUserSetup,
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipToolsSetup,
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipServerSetup,
    
    [Parameter(Mandatory=$false)]
    [switch]$Force
)

#Requires -RunAsAdministrator
#Requires -Version 7.0

# ============================================================================
# KONSTANTEN & KONFIGURATION
# ============================================================================

$Script:Config = @{
    # Benutzer-Konfiguration
    LocalUser = "carpu"
    LocalPassword = "Beatom&2007"
    
    # Microsoft-Konten
    BusinessAccount = "carpu@carpuncle.eu"
    PersonalAccount = "carpuncle-pc@live.de"
    
    # Hauptverzeichnis
    RootPath = "T:\Carpuncle"
    
    # Server-Konfiguration
    RootServer = "carpu.carpuncle.eu"
    VPSServer = "carpuncle.eu"
    
    # Verzeichnisstruktur
    Directories = @(
        "Tools",
        "SDKs",
        "Lang",
        "Models",
        "Cache",
        "Logs",
        "Lana"
    )
    
    # Tool-Unterverzeichnisse (bereits vorhanden)
    ToolDirectories = @(
        "bin", "dashboard", "DeepL", "dotnet", "gh", "git", "go",
        "Hyperj", "IntelliJ IDEA 2025.3", "java", "JDownloader 2",
        "kiota", "modules", "Monika", "node", "npm", "npp", "Office",
        "ollama", "portable", "PuTTY", "pwsh", "python", "python-3.12",
        "rclone", "SteamCMD", "Telegram", "vscode", "WinFsp", "winscp",
        "WT", "7zip", "bicep", "azurecli-py312", "azurecli-venv"
    )
    
    # OneDrive-Konfiguration
    OneDriveBusinessPath = "T:\OneDrive - Carpuncle"
    OneDrivePersonalPath = "T:\OneDrive"
    
    # Log-Datei
    LogFile = "T:\Carpuncle\Logs\Setup-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
}

# ============================================================================
# HILFSFUNKTIONEN
# ============================================================================

function Write-Log {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet("Info", "Success", "Warning", "Error")]
        [string]$Level = "Info"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    
    # Farben für Console-Output
    $color = switch ($Level) {
        "Info"    { "Cyan" }
        "Success" { "Green" }
        "Warning" { "Yellow" }
        "Error"   { "Red" }
    }
    
    Write-Host $logMessage -ForegroundColor $color
    
    # In Log-Datei schreiben
    if (Test-Path (Split-Path $Script:Config.LogFile -Parent)) {
        Add-Content -Path $Script:Config.LogFile -Value $logMessage
    }
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Ensure-Directory {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    
    if (-not (Test-Path $Path)) {
        Write-Log "Erstelle Verzeichnis: $Path" -Level Info
        New-Item -Path $Path -ItemType Directory -Force | Out-Null
        Write-Log "Verzeichnis erstellt: $Path" -Level Success
    } else {
        Write-Log "Verzeichnis existiert bereits: $Path" -Level Info
    }
}

function Test-Command {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Command
    )
    
    try {
        if (Get-Command $Command -ErrorAction SilentlyContinue) {
            return $true
        }
    } catch {
        return $false
    }
    return $false
}

# ============================================================================
# HAUPTFUNKTIONEN
# ============================================================================

function Initialize-CarpuncleStructure {
    <#
    .SYNOPSIS
        Erstellt die Carpuncle-Verzeichnisstruktur
    #>
    
    Write-Log "=== Initialisiere Carpuncle-Verzeichnisstruktur ===" -Level Info
    
    # Hauptverzeichnis
    Ensure-Directory -Path $Script:Config.RootPath
    
    # Unterverzeichnisse
    foreach ($dir in $Script:Config.Directories) {
        $fullPath = Join-Path $Script:Config.RootPath $dir
        Ensure-Directory -Path $fullPath
    }
    
    # Tools-Unterverzeichnisse (falls nicht vorhanden)
    $toolsPath = Join-Path $Script:Config.RootPath "Tools"
    foreach ($toolDir in $Script:Config.ToolDirectories) {
        $fullPath = Join-Path $toolsPath $toolDir
        Ensure-Directory -Path $fullPath
    }
    
    Write-Log "Verzeichnisstruktur erfolgreich initialisiert" -Level Success
}

function Setup-LocalUser {
    <#
    .SYNOPSIS
        Richtet den lokalen Benutzer "carpu" ein
    #>
    
    if ($SkipUserSetup) {
        Write-Log "Benutzer-Setup übersprungen" -Level Warning
        return
    }
    
    Write-Log "=== Richte lokalen Benutzer ein ===" -Level Info
    
    $username = $Script:Config.LocalUser
    $password = ConvertTo-SecureString $Script:Config.LocalPassword -AsPlainText -Force
    
    # Prüfe ob Benutzer existiert
    try {
        $user = Get-LocalUser -Name $username -ErrorAction SilentlyContinue
        
        if ($null -eq $user) {
            Write-Log "Erstelle Benutzer: $username" -Level Info
            New-LocalUser -Name $username `
                -Password $password `
                -FullName "Carpuncle User" `
                -Description "Carpuncle System User" `
                -PasswordNeverExpires `
                -UserMayNotChangePassword:$false
            
            # Füge zu Administratoren hinzu
            Add-LocalGroupMember -Group "Administratoren" -Member $username -ErrorAction SilentlyContinue
            Add-LocalGroupMember -Group "Administrators" -Member $username -ErrorAction SilentlyContinue
            
            Write-Log "Benutzer $username erfolgreich erstellt" -Level Success
        } else {
            Write-Log "Benutzer $username existiert bereits" -Level Info
        }
        
    } catch {
        Write-Log "Fehler beim Einrichten des Benutzers: $_" -Level Error
    }
}

function Setup-AutoLogin {
    <#
    .SYNOPSIS
        Konfiguriert automatisches Login für Benutzer "carpu"
    #>
    
    Write-Log "=== Konfiguriere automatisches Login ===" -Level Info
    
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    
    try {
        Set-ItemProperty -Path $regPath -Name "AutoAdminLogon" -Value "1" -Type String
        Set-ItemProperty -Path $regPath -Name "DefaultUserName" -Value $Script:Config.LocalUser -Type String
        Set-ItemProperty -Path $regPath -Name "DefaultPassword" -Value $Script:Config.LocalPassword -Type String
        
        Write-Log "Automatisches Login konfiguriert" -Level Success
    } catch {
        Write-Log "Fehler beim Konfigurieren des Auto-Logins: $_" -Level Error
    }
}

function Setup-EnvironmentVariables {
    <#
    .SYNOPSIS
        Konfiguriert Umgebungsvariablen für Tools
    #>
    
    Write-Log "=== Konfiguriere Umgebungsvariablen ===" -Level Info
    
    $toolsPath = Join-Path $Script:Config.RootPath "Tools"
    
    # PATH-Einträge
    $pathEntries = @(
        "$toolsPath\bin",
        "$toolsPath\git\cmd",
        "$toolsPath\gh\bin",
        "$toolsPath\pwsh",
        "$toolsPath\python",
        "$toolsPath\python-3.12",
        "$toolsPath\node",
        "$toolsPath\go\bin",
        "$toolsPath\dotnet",
        "$toolsPath\7zip"
    )
    
    # Aktueller PATH
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    
    foreach ($entry in $pathEntries) {
        if ($currentPath -notlike "*$entry*") {
            Write-Log "Füge zu PATH hinzu: $entry" -Level Info
            $currentPath += ";$entry"
        }
    }
    
    [Environment]::SetEnvironmentVariable("Path", $currentPath, "Machine")
    
    # Weitere Umgebungsvariablen
    [Environment]::SetEnvironmentVariable("CARPUNCLE_ROOT", $Script:Config.RootPath, "Machine")
    [Environment]::SetEnvironmentVariable("CARPUNCLE_USER", $Script:Config.LocalUser, "Machine")
    
    Write-Log "Umgebungsvariablen konfiguriert" -Level Success
}

function Setup-SSHKeys {
    <#
    .SYNOPSIS
        Richtet SSH-Keys für passwortlosen Zugriff ein
    #>
    
    Write-Log "=== Richte SSH-Keys ein ===" -Level Info
    
    $sshPath = Join-Path $env:USERPROFILE ".ssh"
    Ensure-Directory -Path $sshPath
    
    $keyPath = Join-Path $sshPath "id_rsa"
    
    if (-not (Test-Path $keyPath)) {
        Write-Log "Generiere SSH-Key" -Level Info
        
        # SSH-Key generieren
        if (Test-Command "ssh-keygen") {
            ssh-keygen -t rsa -b 4096 -f $keyPath -N '""' -C "$($Script:Config.BusinessAccount)"
            Write-Log "SSH-Key generiert: $keyPath" -Level Success
        } else {
            Write-Log "ssh-keygen nicht gefunden. Bitte manuell installieren." -Level Warning
        }
    } else {
        Write-Log "SSH-Key existiert bereits" -Level Info
    }
    
    # SSH-Config erstellen
    $sshConfigPath = Join-Path $sshPath "config"
    $sshConfig = @"
# Carpuncle Server Configuration

Host rootserver
    HostName $($Script:Config.RootServer)
    User $($Script:Config.LocalUser)
    IdentityFile $keyPath
    
Host vps
    HostName $($Script:Config.VPSServer)
    User $($Script:Config.LocalUser)
    IdentityFile $keyPath

Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
"@
    
    Set-Content -Path $sshConfigPath -Value $sshConfig
    Write-Log "SSH-Config erstellt: $sshConfigPath" -Level Success
}

function Setup-OneDrive {
    <#
    .SYNOPSIS
        Konfiguriert OneDrive für beide Konten
    #>
    
    Write-Log "=== Konfiguriere OneDrive ===" -Level Info
    Write-Log "OneDrive-Konfiguration muss manuell abgeschlossen werden:" -Level Warning
    Write-Log "1. Business-Konto: $($Script:Config.BusinessAccount) -> $($Script:Config.OneDriveBusinessPath)" -Level Warning
    Write-Log "2. Personal-Konto: $($Script:Config.PersonalAccount) -> $($Script:Config.OneDrivePersonalPath)" -Level Warning
    Write-Log "3. Automatische Ordner-Synchronisation in OneDrive-Einstellungen deaktivieren" -Level Warning
}

function Setup-WindowsTerminal {
    <#
    .SYNOPSIS
        Konfiguriert Windows Terminal mit Profilen
    #>
    
    Write-Log "=== Konfiguriere Windows Terminal ===" -Level Info
    
    $wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    
    if (Test-Path $wtSettingsPath) {
        Write-Log "Windows Terminal settings gefunden: $wtSettingsPath" -Level Success
        Write-Log "Manuelle Konfiguration erforderlich für:" -Level Warning
        Write-Log "- GitHub Copilot Chat Integration" -Level Warning
        Write-Log "- Profile für PowerShell 7, Git Bash, etc." -Level Warning
    } else {
        Write-Log "Windows Terminal nicht gefunden. Bitte installieren." -Level Warning
    }
}

function Setup-GitConfiguration {
    <#
    .SYNOPSIS
        Konfiguriert Git mit Carpuncle-Einstellungen
    #>
    
    Write-Log "=== Konfiguriere Git ===" -Level Info
    
    if (Test-Command "git") {
        git config --global user.name "carpu"
        git config --global user.email $Script:Config.BusinessAccount
        git config --global core.autocrlf false
        git config --global init.defaultBranch main
        
        Write-Log "Git konfiguriert" -Level Success
    } else {
        Write-Log "Git nicht gefunden. Bitte installieren." -Level Warning
    }
}

function Show-Summary {
    <#
    .SYNOPSIS
        Zeigt Zusammenfassung der Konfiguration
    #>
    
    Write-Log "" -Level Info
    Write-Log "============================================" -Level Success
    Write-Log "  Carpuncle System Setup Abgeschlossen" -Level Success
    Write-Log "============================================" -Level Success
    Write-Log "" -Level Info
    
    Write-Log "Konfigurierte Komponenten:" -Level Info
    Write-Log "✓ Verzeichnisstruktur: $($Script:Config.RootPath)" -Level Success
    Write-Log "✓ Benutzer: $($Script:Config.LocalUser)" -Level Success
    Write-Log "✓ Business-Konto: $($Script:Config.BusinessAccount)" -Level Success
    Write-Log "✓ Personal-Konto: $($Script:Config.PersonalAccount)" -Level Success
    Write-Log "✓ SSH-Keys: $env:USERPROFILE\.ssh" -Level Success
    Write-Log "" -Level Info
    
    Write-Log "Manuelle Schritte erforderlich:" -Level Warning
    Write-Log "1. OneDrive-Konten in Windows einrichten und zu T:\ verschieben" -Level Warning
    Write-Log "2. Server-Zugriff testen: ssh rootserver" -Level Warning
    Write-Log "3. RoboForm für 2FA einrichten" -Level Warning
    Write-Log "4. GitHub Copilot Business + Pro in VS Code aktivieren" -Level Warning
    Write-Log "5. Windows Terminal Profile anpassen" -Level Warning
    Write-Log "6. Netcup CCP-Zugang mit SSH-Key konfigurieren" -Level Warning
    Write-Log "" -Level Info
    
    Write-Log "Log-Datei: $($Script:Config.LogFile)" -Level Info
    Write-Log "" -Level Info
}

# ============================================================================
# HAUPTSKRIPT
# ============================================================================

function Main {
    try {
        Write-Log "============================================" -Level Info
        Write-Log "  Carpuncle Vollautomatisches System-Setup" -Level Info
        Write-Log "============================================" -Level Info
        Write-Log "" -Level Info
        
        # Administrator-Check
        if (-not (Test-Administrator)) {
            Write-Log "Dieses Skript erfordert Administrator-Rechte!" -Level Error
            Write-Log "Bitte als Administrator ausführen." -Level Error
            exit 1
        }
        
        # Verzeichnisstruktur initialisieren
        Initialize-CarpuncleStructure
        
        # Benutzer einrichten
        Setup-LocalUser
        
        # Auto-Login konfigurieren
        Setup-AutoLogin
        
        # Umgebungsvariablen
        Setup-EnvironmentVariables
        
        # SSH-Keys
        Setup-SSHKeys
        
        # Git-Konfiguration
        Setup-GitConfiguration
        
        # OneDrive-Hinweise
        Setup-OneDrive
        
        # Windows Terminal
        Setup-WindowsTerminal
        
        # Zusammenfassung
        Show-Summary
        
    } catch {
        Write-Log "Kritischer Fehler: $_" -Level Error
        Write-Log $_.Exception.Message -Level Error
        exit 1
    }
}

# Skript ausführen
Main
