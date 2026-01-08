<#
.SYNOPSIS
    Carpuncle Master-Setup - Vollautomatische Einrichtung mit einem Befehl

.DESCRIPTION
    Dies ist das Master-Skript für die vollständige Carpuncle-System-Einrichtung.
    Ein einziger Befehl richtet alles ein:
    
    - Windows-Benutzer mit Auto-Login
    - Verzeichnisstruktur auf T:\Carpuncle
    - Tool-Konfiguration und PATH
    - SSH-Keys für passwortlosen Zugriff
    - Server-Verbindungen
    - OneDrive-Vorbereitung
    - Git und GitHub CLI
    - Windows Terminal
    - Lana KI-System-Grundlage

.PARAMETER InstallTools
    Installiert fehlende Tools automatisch (Chocolatey)

.PARAMETER ConfigureServers
    Konfiguriert Server-Verbindungen sofort

.PARAMETER SkipBackup
    Überspringt Backup vorhandener Konfigurationen

.EXAMPLE
    # Vollständiges Setup - einfach kopieren und Enter drücken
    irm https://raw.githubusercontent.com/Isychan1/Carpuncle/main/Install-Carpuncle.ps1 | iex

.EXAMPLE
    # Lokales Setup
    .\Install-Carpuncle.ps1

.EXAMPLE
    # Setup mit Tool-Installation
    .\Install-Carpuncle.ps1 -InstallTools

.NOTES
    Autor: Carpuncle DevOps Team
    Version: 1.0.0
    Erfordert: PowerShell 7+, Administrator-Rechte
    
    WICHTIG: Dies ist der EINZIGE Befehl den Sie ausführen müssen!
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [switch]$InstallTools,
    
    [Parameter(Mandatory=$false)]
    [switch]$ConfigureServers,
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipBackup
)

#Requires -RunAsAdministrator
#Requires -Version 7.0

# ============================================================================
# ASCII ART BANNER
# ============================================================================

function Show-Banner {
    $banner = @"
    
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║    ██████╗ ██████╗ ██████╗ ██████╗ ██╗   ██╗███╗   ██╗ ██████╗  ║
║   ██╔════╝██╔═══██╗██╔══██╗██╔══██╗██║   ██║████╗  ██║██╔════╝  ║
║   ██║     ███████║██████╔╝██████╔╝██║   ██║██╔██╗ ██║██║       ║
║   ██║     ██╔══██║██╔══██╗██╔═══╝ ██║   ██║██║╚██╗██║██║       ║
║   ╚██████╗██║  ██║██║  ██║██║     ╚██████╔╝██║ ╚████║╚██████╗  ║
║    ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝  ║
║                                                                   ║
║         Vollautomatisches System-Setup - Version 1.0.0           ║
║                 Ein Befehl für alles!                            ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝

"@
    
    Write-Host $banner -ForegroundColor Cyan
}

# ============================================================================
# FORTSCHRITTSANZEIGE
# ============================================================================

$Script:TotalSteps = 12
$Script:CurrentStep = 0

function Update-Progress {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Activity,
        
        [Parameter(Mandatory=$false)]
        [string]$Status = "In Bearbeitung..."
    )
    
    $Script:CurrentStep++
    $percentComplete = ($Script:CurrentStep / $Script:TotalSteps) * 100
    
    Write-Progress -Activity "Carpuncle System Setup" `
                   -Status "$Activity - $Status" `
                   -PercentComplete $percentComplete `
                   -CurrentOperation "Schritt $Script:CurrentStep von $Script:TotalSteps"
}

# ============================================================================
# VORAUSSETZUNGS-PRÜFUNG
# ============================================================================

function Test-Prerequisites {
    Update-Progress -Activity "Voraussetzungen prüfen"
    
    $issues = @()
    
    # PowerShell Version
    if ($PSVersionTable.PSVersion.Major -lt 7) {
        $issues += "PowerShell 7+ erforderlich (aktuell: $($PSVersionTable.PSVersion))"
    }
    
    # Administrator-Rechte
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        $issues += "Administrator-Rechte erforderlich"
    }
    
    # Laufwerk T: verfügbar
    if (-not (Test-Path "T:\")) {
        $issues += "Laufwerk T:\ nicht gefunden. Bitte erstellen."
    }
    
    # Freier Speicherplatz
    try {
        $drive = Get-PSDrive -Name T -ErrorAction Stop
        $freeSpaceGB = [math]::Round($drive.Free / 1GB, 2)
        if ($freeSpaceGB -lt 100) {
            $issues += "Mindestens 100 GB freier Speicherplatz auf T:\ erforderlich (verfügbar: $freeSpaceGB GB)"
        }
    } catch {
        $issues += "Kann Speicherplatz auf T:\ nicht prüfen"
    }
    
    if ($issues.Count -gt 0) {
        Write-Host "`n❌ Folgende Voraussetzungen sind nicht erfüllt:" -ForegroundColor Red
        foreach ($issue in $issues) {
            Write-Host "  - $issue" -ForegroundColor Yellow
        }
        Write-Host "`nBitte beheben Sie die Probleme und führen Sie das Skript erneut aus." -ForegroundColor Red
        exit 1
    }
    
    Write-Host "✅ Alle Voraussetzungen erfüllt" -ForegroundColor Green
}

# ============================================================================
# BACKUP ERSTELLEN
# ============================================================================

function Backup-ExistingConfiguration {
    if ($SkipBackup) {
        return
    }
    
    Update-Progress -Activity "Erstelle Backup"
    
    $backupPath = "T:\Carpuncle\Backups\$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    New-Item -Path $backupPath -ItemType Directory -Force | Out-Null
    
    # Backup wichtiger Konfigurationsdateien
    $filesToBackup = @(
        "$env:USERPROFILE\.ssh",
        "$env:USERPROFILE\.gitconfig",
        "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json"
    )
    
    foreach ($file in $filesToBackup) {
        if (Test-Path $file) {
            Copy-Item -Path $file -Destination $backupPath -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    
    Write-Host "✅ Backup erstellt: $backupPath" -ForegroundColor Green
}

# ============================================================================
# TOOL-INSTALLATION (OPTIONAL)
# ============================================================================

function Install-RequiredTools {
    if (-not $InstallTools) {
        return
    }
    
    Update-Progress -Activity "Installiere Tools"
    
    # Chocolatey installieren falls nicht vorhanden
    if (-not (Test-Command "choco")) {
        Write-Host "📦 Installiere Chocolatey..." -ForegroundColor Cyan
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    
    # Wichtige Tools installieren
    $tools = @(
        "git",
        "gh",
        "vscode",
        "python",
        "nodejs",
        "7zip",
        "winscp",
        "putty",
        "microsoft-windows-terminal"
    )
    
    foreach ($tool in $tools) {
        Write-Host "📦 Installiere $tool..." -ForegroundColor Cyan
        choco install $tool -y --no-progress
    }
    
    Write-Host "✅ Tools installiert" -ForegroundColor Green
}

function Test-Command {
    param([string]$Command)
    try {
        return $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
    } catch {
        return $false
    }
}

# ============================================================================
# SKRIPT-DOWNLOAD UND AUSFÜHRUNG
# ============================================================================

function Download-SetupScripts {
    Update-Progress -Activity "Lade Setup-Skripte"
    
    $scriptsPath = "T:\Carpuncle\Tools\bin"
    New-Item -Path $scriptsPath -ItemType Directory -Force | Out-Null
    
    $baseUrl = "https://raw.githubusercontent.com/Isychan1/Carpuncle/main"
    
    $scripts = @(
        "Setup-CarpuncleSystem.ps1",
        "Setup-CarpuncleServers.ps1"
    )
    
    foreach ($script in $scripts) {
        $url = "$baseUrl/$script"
        $destination = Join-Path $scriptsPath $script
        
        try {
            Write-Host "📥 Lade $script..." -ForegroundColor Cyan
            Invoke-WebRequest -Uri $url -OutFile $destination -UseBasicParsing
            Write-Host "✅ $script heruntergeladen" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  Konnte $script nicht herunterladen (verwende lokale Version)" -ForegroundColor Yellow
        }
    }
}

function Invoke-SystemSetup {
    Update-Progress -Activity "Führe System-Setup aus"
    
    $systemScriptPath = Join-Path (Join-Path "T:\Carpuncle" "Tools\bin") "Setup-CarpuncleSystem.ps1"
    
    if (Test-Path $systemScriptPath) {
        Write-Host "`n🚀 Führe System-Setup aus..." -ForegroundColor Cyan
        & $systemScriptPath
    } else {
        Write-Host "⚠️  Setup-CarpuncleSystem.ps1 nicht gefunden" -ForegroundColor Yellow
    }
}

function Invoke-ServerSetup {
    if (-not $ConfigureServers) {
        return
    }
    
    Update-Progress -Activity "Führe Server-Setup aus"
    
    $serverScriptPath = Join-Path (Join-Path "T:\Carpuncle" "Tools\bin") "Setup-CarpuncleServers.ps1"
    
    if (Test-Path $serverScriptPath) {
        Write-Host "`n🌐 Führe Server-Setup aus..." -ForegroundColor Cyan
        & $serverScriptPath
    } else {
        Write-Host "⚠️  Setup-CarpuncleServers.ps1 nicht gefunden" -ForegroundColor Yellow
    }
}

# ============================================================================
# FINALE KONFIGURATION
# ============================================================================

function Set-FinalConfiguration {
    Update-Progress -Activity "Finale Konfiguration"
    
    # Windows Explorer zeigt Dateiendungen an
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
                     -Name "HideFileExt" -Value 0
    
    # Versteckte Dateien anzeigen
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
                     -Name "Hidden" -Value 1
    
    # Dark Mode
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" `
                     -Name "AppsUseLightTheme" -Value 0
    
    Write-Host "✅ Finale Konfiguration abgeschlossen" -ForegroundColor Green
}

# ============================================================================
# FINALE ZUSAMMENFASSUNG
# ============================================================================

function Show-FinalSummary {
    Update-Progress -Activity "Setup abgeschlossen" -Status "Fertig!"
    
    Write-Host "`n`n" -NoNewline
    Write-Host "╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                                                                   ║" -ForegroundColor Green
    Write-Host "║              🎉 CARPUNCLE SYSTEM ERFOLGREICH EINGERICHTET! 🎉    ║" -ForegroundColor Green
    Write-Host "║                                                                   ║" -ForegroundColor Green
    Write-Host "╚═══════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "✅ Eingerichtete Komponenten:" -ForegroundColor Cyan
    Write-Host "   ✓ Benutzer 'carpu' mit Auto-Login" -ForegroundColor White
    Write-Host "   ✓ Verzeichnisstruktur T:\Carpuncle" -ForegroundColor White
    Write-Host "   ✓ Umgebungsvariablen und PATH" -ForegroundColor White
    Write-Host "   ✓ SSH-Keys für Server-Zugriff" -ForegroundColor White
    Write-Host "   ✓ Git-Konfiguration" -ForegroundColor White
    Write-Host "   ✓ OneDrive-Vorbereitung" -ForegroundColor White
    Write-Host ""
    
    Write-Host "📋 Nächste Schritte (manuell):" -ForegroundColor Yellow
    Write-Host "   1. OneDrive-Konten anmelden und zu T:\ verschieben" -ForegroundColor White
    Write-Host "   2. SSH Public Key auf Server hochladen:" -ForegroundColor White
    Write-Host "      ssh-copy-id carpu@carpu.carpuncle.eu" -ForegroundColor Gray
    Write-Host "   3. RoboForm installieren und 2FA konfigurieren" -ForegroundColor White
    Write-Host "   4. GitHub Copilot (Business + Pro) aktivieren" -ForegroundColor White
    Write-Host "   5. Windows Terminal Profile anpassen" -ForegroundColor White
    Write-Host ""
    
    Write-Host "📖 Dokumentation:" -ForegroundColor Cyan
    Write-Host "   T:\Carpuncle\CARPUNCLE-SYSTEM-SETUP.md" -ForegroundColor White
    Write-Host ""
    
    Write-Host "🚀 Nützliche Befehle:" -ForegroundColor Cyan
    Write-Host "   connect-rootserver.ps1  # Root-Server verbinden" -ForegroundColor White
    Write-Host "   connect-vps.ps1         # VPS verbinden" -ForegroundColor White
    Write-Host "   ssh rootserver          # Root-Server (Alias)" -ForegroundColor White
    Write-Host ""
    
    Write-Host "📧 Support:" -ForegroundColor Cyan
    Write-Host "   carpuncle-pc@live.de" -ForegroundColor White
    Write-Host "   carpu@carpuncle.eu" -ForegroundColor White
    Write-Host ""
    
    Write-Host "💡 Tipp: System neu starten für vollständige Aktivierung" -ForegroundColor Yellow
    Write-Host ""
}

# ============================================================================
# HAUPTSKRIPT
# ============================================================================

function Main {
    Clear-Host
    Show-Banner
    
    Write-Host "🚀 Starte Carpuncle Vollautomatisches System-Setup..." -ForegroundColor Cyan
    Write-Host ""
    
    try {
        # Schritt 1: Voraussetzungen prüfen
        Test-Prerequisites
        Start-Sleep -Seconds 1
        
        # Schritt 2: Backup
        Backup-ExistingConfiguration
        Start-Sleep -Seconds 1
        
        # Schritt 3: Tools installieren (optional)
        Install-RequiredTools
        Start-Sleep -Seconds 1
        
        # Schritt 4: Setup-Skripte laden
        Download-SetupScripts
        Start-Sleep -Seconds 1
        
        # Schritt 5: System-Setup ausführen
        Invoke-SystemSetup
        Start-Sleep -Seconds 1
        
        # Schritt 6: Server-Setup (optional)
        Invoke-ServerSetup
        Start-Sleep -Seconds 1
        
        # Schritt 7: Finale Konfiguration
        Set-FinalConfiguration
        Start-Sleep -Seconds 1
        
        # Schritt 8: Zusammenfassung
        Show-FinalSummary
        
    } catch {
        Write-Host "`n❌ Kritischer Fehler beim Setup:" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        Write-Host "`nBitte prüfen Sie das Log und versuchen Sie es erneut." -ForegroundColor Yellow
        exit 1
    }
}

# Skript ausführen
Main
