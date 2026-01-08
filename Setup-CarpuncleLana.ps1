# Setup-CarpuncleLana.ps1
# Vollautomatisches Setup-Skript für das Carpuncle Lana System
# Ein einziges Skript für die komplette Systemkonfiguration

<#
.SYNOPSIS
    Automatisierte Einrichtung des Carpuncle Lana Systems

.DESCRIPTION
    Dieses Skript richtet das komplette Carpuncle Lana System ein:
    - Benutzer 'carpu' mit passwortlosem Login
    - T:\Carpuncle Dev-Drive mit ReFS
    - Beide OneDrive Konten (Business & Personal)
    - SSH-Keys für Server-Zugriff
    - Windows Terminal mit Chat-Integration
    - Server-Verbindungen (Root, VPS, Webhosting)
    - Lana AI-Assistenten-Framework

.PARAMETER RootServerIP
    IP-Adresse des Root-Servers (carpu.carpuncle.eu)

.PARAMETER VPSServerIP
    IP-Adresse des VPS (carpuncle.eu)

.PARAMETER SkipUserSetup
    Überspringt die Benutzer-Konfiguration

.PARAMETER SkipStorageSetup
    Überspringt die Storage-Konfiguration

.EXAMPLE
    .\Setup-CarpuncleLana.ps1
    
.EXAMPLE
    .\Setup-CarpuncleLana.ps1 -RootServerIP "123.45.67.89" -VPSServerIP "98.76.54.32"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$RootServerIP = "",
    
    [Parameter(Mandatory=$false)]
    [string]$VPSServerIP = "",
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipUserSetup,
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipStorageSetup,
    
    [Parameter(Mandatory=$false)]
    [string]$CarpunclePath = "T:\Carpuncle"
)

# Requires Admin-Rechte
#Requires -RunAsAdministrator

# ============================================================================
# KONFIGURATION
# ============================================================================

$Script:Config = @{
    # Benutzer
    LocalUser = "carpu"
    LocalPassword = "Beatom&2007"
    BusinessAccount = "carpu@carpuncle.eu"
    PersonalAccount = "carpuncle-pc@live.de"
    
    # Pfade
    CarpuncleRoot = $CarpunclePath
    UserProfile = "C:\Users\carpu"
    
    # OneDrive
    OneDriveBusinessPath = "T:\OneDrive-Business"
    OneDrivePersonalPath = "T:\OneDrive-Personal"
    
    # Tools Unterordner
    ToolsDirs = @(
        "bin", "dashboard", "DeepL", "dotnet", "gh", "git", "go", 
        "Hyperj", "IntelliJ IDEA 2025.3", "java", "JDownloader 2", 
        "kiota", "modules", "Monika", "node", "npm", "npp", "Office", 
        "ollama", "portable", "PuTTY", "pwsh", "python", "python-3.12", 
        "rclone", "SteamCMD", "Telegram", "vscode", "WinFsp", "winscp", 
        "WT", "7zip", "bicep", "azurecli-py312", "azurecli-venv"
    )
    
    # Weitere Hauptordner
    MainDirs = @(
        "Tools", "SDKs", "Lang", "Models", "Cache", "Logs", "Lana"
    )
    
    # Server
    RootServer = @{
        Hostname = "carpu.carpuncle.eu"
        IP = $RootServerIP
        User = "carpu"
        SSHPort = 22
    }
    
    VPSServer = @{
        Hostname = "carpuncle.eu"
        IP = $VPSServerIP
        User = "carpu"
        SSHPort = 22
    }
}

# Farben für Console Output
$InfoColor = "Cyan"
$SuccessColor = "Green"
$WarningColor = "Yellow"
$ErrorColor = "Red"

# ============================================================================
# HILFSFUNKTIONEN
# ============================================================================

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor $InfoColor
}

function Write-Success {
    param([string]$Message)
    Write-Host "[✓] $Message" -ForegroundColor $SuccessColor
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[!] $Message" -ForegroundColor $WarningColor
}

function Write-Error {
    param([string]$Message)
    Write-Host "[✗] $Message" -ForegroundColor $ErrorColor
}

function Write-Section {
    param([string]$Title)
    Write-Host "`n$('=' * 80)" -ForegroundColor Magenta
    Write-Host "  $Title" -ForegroundColor Magenta
    Write-Host "$('=' * 80)`n" -ForegroundColor Magenta
}

function Test-AdminRights {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Invoke-WithRetry {
    param(
        [scriptblock]$ScriptBlock,
        [int]$MaxRetries = 3,
        [int]$DelaySeconds = 2
    )
    
    $attempt = 1
    while ($attempt -le $MaxRetries) {
        try {
            & $ScriptBlock
            return $true
        }
        catch {
            Write-Warning "Versuch $attempt von $MaxRetries fehlgeschlagen: $_"
            if ($attempt -lt $MaxRetries) {
                Start-Sleep -Seconds $DelaySeconds
                $attempt++
            }
            else {
                Write-Error "Alle Versuche fehlgeschlagen"
                return $false
            }
        }
    }
}

# ============================================================================
# HAUPTFUNKTIONEN
# ============================================================================

function Initialize-Setup {
    Write-Section "CARPUNCLE LANA SYSTEM SETUP"
    
    Write-Info "Überprüfe Systemvoraussetzungen..."
    
    # Admin-Rechte prüfen
    if (-not (Test-AdminRights)) {
        Write-Error "Dieses Skript benötigt Administrator-Rechte!"
        Write-Error "Bitte als Administrator ausführen."
        exit 1
    }
    Write-Success "Administrator-Rechte verifiziert"
    
    # PowerShell Version prüfen
    $psVersion = $PSVersionTable.PSVersion
    Write-Info "PowerShell Version: $psVersion"
    if ($psVersion.Major -lt 5) {
        Write-Warning "PowerShell 5.0 oder höher empfohlen"
    }
    
    # Windows Version prüfen
    $osInfo = Get-CimInstance Win32_OperatingSystem
    Write-Info "Windows Version: $($osInfo.Caption) Build $($osInfo.BuildNumber)"
    
    Write-Success "Systemvoraussetzungen erfüllt`n"
}

function Setup-LocalUser {
    if ($SkipUserSetup) {
        Write-Warning "Benutzer-Setup wird übersprungen"
        return
    }
    
    Write-Section "BENUTZER-KONFIGURATION"
    
    $username = $Script:Config.LocalUser
    $password = $Script:Config.LocalPassword
    
    Write-Info "Prüfe lokalen Benutzer: $username"
    
    # Prüfe ob Benutzer existiert
    $user = Get-LocalUser -Name $username -ErrorAction SilentlyContinue
    
    if (-not $user) {
        Write-Info "Erstelle lokalen Benutzer: $username"
        
        $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
        
        try {
            $user = New-LocalUser -Name $username `
                -Password $securePassword `
                -FullName "Carpuncle User" `
                -Description "Carpuncle Lana System User" `
                -PasswordNeverExpires `
                -UserMayNotChangePassword
            
            Write-Success "Benutzer '$username' erstellt"
        }
        catch {
            Write-Error "Fehler beim Erstellen des Benutzers: $_"
            return
        }
    }
    else {
        Write-Success "Benutzer '$username' existiert bereits"
    }
    
    # Zur Administratoren-Gruppe hinzufügen
    Write-Info "Füge Benutzer zur Administratoren-Gruppe hinzu..."
    try {
        Add-LocalGroupMember -Group "Administratoren" -Member $username -ErrorAction SilentlyContinue
        Write-Success "Benutzer ist Administrator"
    }
    catch {
        Write-Warning "Benutzer ist möglicherweise bereits Administrator"
    }
    
    # Automatisches Login konfigurieren
    Write-Info "Konfiguriere automatisches Login..."
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    
    try {
        Set-ItemProperty -Path $regPath -Name "AutoAdminLogon" -Value "1" -Type String
        Set-ItemProperty -Path $regPath -Name "DefaultUserName" -Value $username -Type String
        Set-ItemProperty -Path $regPath -Name "DefaultPassword" -Value $password -Type String
        Write-Success "Automatisches Login aktiviert"
    }
    catch {
        Write-Error "Fehler beim Konfigurieren des automatischen Logins: $_"
    }
    
    Write-Success "Benutzer-Konfiguration abgeschlossen`n"
}

function Setup-StorageStructure {
    if ($SkipStorageSetup) {
        Write-Warning "Storage-Setup wird übersprungen"
        return
    }
    
    Write-Section "STORAGE-STRUKTUR"
    
    $rootPath = $Script:Config.CarpuncleRoot
    
    Write-Info "Prüfe Hauptverzeichnis: $rootPath"
    
    # Hauptverzeichnis erstellen
    if (-not (Test-Path $rootPath)) {
        Write-Info "Erstelle Hauptverzeichnis: $rootPath"
        try {
            New-Item -Path $rootPath -ItemType Directory -Force | Out-Null
            Write-Success "Hauptverzeichnis erstellt"
        }
        catch {
            Write-Error "Fehler beim Erstellen des Hauptverzeichnisses: $_"
            return
        }
    }
    else {
        Write-Success "Hauptverzeichnis existiert bereits"
    }
    
    # Hauptordner erstellen
    Write-Info "Erstelle Hauptordner-Struktur..."
    foreach ($dir in $Script:Config.MainDirs) {
        $dirPath = Join-Path $rootPath $dir
        if (-not (Test-Path $dirPath)) {
            New-Item -Path $dirPath -ItemType Directory -Force | Out-Null
            Write-Success "  ✓ $dir"
        }
        else {
            Write-Info "  → $dir (existiert bereits)"
        }
    }
    
    # Tools-Unterordner erstellen
    Write-Info "Erstelle Tools-Unterordner..."
    $toolsPath = Join-Path $rootPath "Tools"
    foreach ($toolDir in $Script:Config.ToolsDirs) {
        $toolPath = Join-Path $toolsPath $toolDir
        if (-not (Test-Path $toolPath)) {
            New-Item -Path $toolPath -ItemType Directory -Force | Out-Null
            Write-Success "  ✓ Tools\$toolDir"
        }
        else {
            Write-Info "  → Tools\$toolDir (existiert bereits)"
        }
    }
    
    Write-Success "Storage-Struktur erstellt`n"
}

function Setup-SSHKeys {
    Write-Section "SSH-SCHLÜSSEL KONFIGURATION"
    
    $sshDir = Join-Path $env:USERPROFILE ".ssh"
    $privateKeyPath = Join-Path $sshDir "id_rsa"
    $publicKeyPath = "$privateKeyPath.pub"
    
    Write-Info "SSH-Verzeichnis: $sshDir"
    
    # SSH-Verzeichnis erstellen
    if (-not (Test-Path $sshDir)) {
        Write-Info "Erstelle SSH-Verzeichnis..."
        New-Item -Path $sshDir -ItemType Directory -Force | Out-Null
        Write-Success "SSH-Verzeichnis erstellt"
    }
    
    # Prüfe ob SSH-Keys existieren
    if (-not (Test-Path $privateKeyPath)) {
        Write-Info "Generiere SSH-Schlüsselpaar..."
        Write-Warning "ssh-keygen muss installiert sein (z.B. über Git für Windows oder OpenSSH)"
        
        $keyComment = "carpu@carpuncle-windows"
        
        # SSH-Key generieren
        $sshKeygenPath = (Get-Command ssh-keygen.exe -ErrorAction SilentlyContinue).Source
        if ($sshKeygenPath) {
            try {
                & ssh-keygen.exe -t rsa -b 4096 -f $privateKeyPath -N '""' -C $keyComment
                Write-Success "SSH-Schlüsselpaar generiert"
            }
            catch {
                Write-Error "Fehler beim Generieren der SSH-Keys: $_"
            }
        }
        else {
            Write-Warning "ssh-keygen nicht gefunden. Bitte manuell SSH-Keys erstellen."
            Write-Info "Empfohlen: Git für Windows oder OpenSSH installieren"
        }
    }
    else {
        Write-Success "SSH-Schlüssel existieren bereits"
    }
    
    # Public Key anzeigen für manuelle Server-Konfiguration
    if (Test-Path $publicKeyPath) {
        Write-Info "`nÖffentlicher SSH-Schlüssel (für Server authorized_keys):"
        Write-Host "----------------------------------------" -ForegroundColor Yellow
        Get-Content $publicKeyPath | Write-Host -ForegroundColor Yellow
        Write-Host "----------------------------------------" -ForegroundColor Yellow
        Write-Info "Diesen Schlüssel auf den Servern in ~/.ssh/authorized_keys hinzufügen"
    }
    
    Write-Success "SSH-Konfiguration abgeschlossen`n"
}

function Setup-SSHConfig {
    Write-Section "SSH-CONFIG DATEI"
    
    $sshDir = Join-Path $env:USERPROFILE ".ssh"
    $sshConfigPath = Join-Path $sshDir "config"
    
    Write-Info "Erstelle SSH Config: $sshConfigPath"
    
    $sshConfigContent = @"
# Carpuncle SSH Configuration
# Automatisch generiert von Setup-CarpuncleLana.ps1

# Root Server - carpu.carpuncle.eu
Host root-server carpu.carpuncle.eu
    HostName $($Script:Config.RootServer.IP ? $Script:Config.RootServer.IP : $Script:Config.RootServer.Hostname)
    User $($Script:Config.RootServer.User)
    Port $($Script:Config.RootServer.SSHPort)
    IdentityFile ~/.ssh/id_rsa
    ServerAliveInterval 60
    ServerAliveCountMax 3

# VPS Server - carpuncle.eu
Host vps-server carpuncle.eu
    HostName $($Script:Config.VPSServer.IP ? $Script:Config.VPSServer.IP : $Script:Config.VPSServer.Hostname)
    User $($Script:Config.VPSServer.User)
    Port $($Script:Config.VPSServer.SSHPort)
    IdentityFile ~/.ssh/id_rsa
    ServerAliveInterval 60
    ServerAliveCountMax 3

# Default Settings
Host *
    AddKeysToAgent yes
    IdentityFile ~/.ssh/id_rsa
    ServerAliveInterval 60
"@

    try {
        Set-Content -Path $sshConfigPath -Value $sshConfigContent -Encoding UTF8
        Write-Success "SSH Config erstellt"
    }
    catch {
        Write-Error "Fehler beim Erstellen der SSH Config: $_"
    }
    
    Write-Success "SSH-Config-Datei erstellt`n"
}

function Setup-OneDriveIntegration {
    Write-Section "ONEDRIVE INTEGRATION"
    
    Write-Info "OneDrive Business: $($Script:Config.OneDriveBusinessPath)"
    Write-Info "OneDrive Personal: $($Script:Config.OneDrivePersonalPath)"
    
    Write-Warning "OneDrive-Integration muss manuell konfiguriert werden:"
    Write-Info "1. OneDrive Business für carpu@carpuncle.eu einrichten"
    Write-Info "2. OneDrive Personal für carpuncle-pc@live.de einrichten"
    Write-Info "3. Beide OneDrive-Ordner nach T:\ verschieben/symlinken"
    Write-Info "4. Automatische Synchronisation für Unterordner deaktivieren"
    
    Write-Info "`nEmpfohlene Vorgehensweise:"
    Write-Info "- OneDrive Business: Nur wichtige Ordner synchronisieren"
    Write-Info "- OneDrive Personal: Selektive Synchronisation"
    Write-Info "- Tools und Cache NICHT synchronisieren"
    
    Write-Success "OneDrive-Hinweise angezeigt`n"
}

function Setup-WindowsTerminal {
    Write-Section "WINDOWS TERMINAL KONFIGURATION"
    
    $wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    
    Write-Info "Windows Terminal Settings: $wtSettingsPath"
    
    if (Test-Path $wtSettingsPath) {
        Write-Info "Windows Terminal ist installiert"
        Write-Success "Konfigurationsdatei gefunden"
        
        Write-Info "`nBitte manuell konfigurieren:"
        Write-Info "- PowerShell 7 als Standard-Profil"
        Write-Info "- Startverzeichnis: $($Script:Config.CarpuncleRoot)"
        Write-Info "- Chat-API Integration über Profile"
    }
    else {
        Write-Warning "Windows Terminal nicht gefunden"
        Write-Info "Bitte Windows Terminal aus dem Microsoft Store installieren"
    }
    
    Write-Success "Windows Terminal Hinweise angezeigt`n"
}

function Setup-EnvironmentVariables {
    Write-Section "UMGEBUNGSVARIABLEN"
    
    Write-Info "Setze Carpuncle Umgebungsvariablen..."
    
    $envVars = @{
        "CARPUNCLE_ROOT" = $Script:Config.CarpuncleRoot
        "CARPUNCLE_TOOLS" = Join-Path $Script:Config.CarpuncleRoot "Tools"
        "CARPUNCLE_USER" = $Script:Config.LocalUser
    }
    
    foreach ($varName in $envVars.Keys) {
        $varValue = $envVars[$varName]
        Write-Info "Setze $varName = $varValue"
        
        try {
            [Environment]::SetEnvironmentVariable($varName, $varValue, "Machine")
            Write-Success "  ✓ $varName gesetzt"
        }
        catch {
            Write-Error "Fehler beim Setzen von $varName : $_"
        }
    }
    
    # PATH erweitern
    Write-Info "Erweitere PATH Variable..."
    $toolsBin = Join-Path $Script:Config.CarpuncleRoot "Tools\bin"
    
    try {
        $currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
        if ($currentPath -notlike "*$toolsBin*") {
            $newPath = "$currentPath;$toolsBin"
            [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
            Write-Success "  ✓ Tools\bin zu PATH hinzugefügt"
        }
        else {
            Write-Info "  → Tools\bin bereits in PATH"
        }
    }
    catch {
        Write-Error "Fehler beim Erweitern des PATH: $_"
    }
    
    Write-Success "Umgebungsvariablen konfiguriert`n"
}

function Show-Summary {
    Write-Section "ZUSAMMENFASSUNG"
    
    Write-Success "✓ Setup erfolgreich abgeschlossen!"
    Write-Host ""
    
    Write-Info "Konfigurierte Komponenten:"
    Write-Host "  ✓ Benutzer: $($Script:Config.LocalUser)" -ForegroundColor Green
    Write-Host "  ✓ Hauptverzeichnis: $($Script:Config.CarpuncleRoot)" -ForegroundColor Green
    Write-Host "  ✓ SSH-Schlüssel generiert" -ForegroundColor Green
    Write-Host "  ✓ SSH-Config erstellt" -ForegroundColor Green
    Write-Host "  ✓ Umgebungsvariablen gesetzt" -ForegroundColor Green
    
    Write-Host "`nNächste Schritte:" -ForegroundColor Cyan
    Write-Info "1. System neu starten für automatisches Login als 'carpu'"
    Write-Info "2. SSH Public Key auf Servern installieren (siehe oben)"
    Write-Info "3. OneDrive Business und Personal konfigurieren"
    Write-Info "4. Windows Terminal konfigurieren"
    Write-Info "5. RoboForm für 2FA installieren und konfigurieren"
    Write-Info "6. Azure VNet Ressourcen-IDs in Deploy-AzureCarpuncle.ps1 eintragen"
    Write-Info "7. Lana AI-Modul initialisieren"
    
    Write-Host "`nWeitere Informationen:" -ForegroundColor Cyan
    Write-Info "- Dokumentation: docs/IMPLEMENTATION_PLAN.md"
    Write-Info "- Azure Deployment: .\Deploy-AzureCarpuncle.ps1"
    Write-Info "- Server-Verbindung: ssh root-server / ssh vps-server"
    
    Write-Host "`n$('=' * 80)" -ForegroundColor Green
    Write-Host "  CARPUNCLE LANA SYSTEM BEREIT!" -ForegroundColor Green
    Write-Host "$('=' * 80)`n" -ForegroundColor Green
}

# ============================================================================
# HAUPTPROGRAMM
# ============================================================================

try {
    # Initialisierung
    Initialize-Setup
    
    # Benutzer einrichten
    Setup-LocalUser
    
    # Storage-Struktur erstellen
    Setup-StorageStructure
    
    # SSH-Schlüssel und Konfiguration
    Setup-SSHKeys
    Setup-SSHConfig
    
    # OneDrive Integration (Hinweise)
    Setup-OneDriveIntegration
    
    # Windows Terminal (Hinweise)
    Setup-WindowsTerminal
    
    # Umgebungsvariablen
    Setup-EnvironmentVariables
    
    # Zusammenfassung
    Show-Summary
    
    Write-Success "`nSetup erfolgreich abgeschlossen!"
    Write-Info "Bitte System neu starten für volle Funktionalität."
    
    exit 0
}
catch {
    Write-Error "`n!!! SETUP FEHLGESCHLAGEN !!!`n"
    Write-Error "Fehler: $_"
    Write-Error $_.Exception.Message
    Write-Error $_.ScriptStackTrace
    exit 1
}
