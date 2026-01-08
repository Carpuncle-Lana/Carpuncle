<#
.SYNOPSIS
    Carpuncle Server-Integration und -Konfiguration

.DESCRIPTION
    Konfiguriert die Verbindungen zu:
    - Root-Server (carpu.carpuncle.eu) - 3TB + 500GB Storage
    - VPS (carpuncle.eu) - Windows Server 2025
    - Webhosting (lana-ki.de, carpucloud.de)
    - Netcup Storage Spaces
    - VLAN-Verbindungen

.NOTES
    Autor: Carpuncle DevOps Team
    Version: 1.0.0
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$RootServer = "carpu.carpuncle.eu",
    
    [Parameter(Mandatory=$false)]
    [string]$VPSServer = "carpuncle.eu",
    
    [Parameter(Mandatory=$false)]
    [string]$Username = "carpu"
)

#Requires -Version 7.0

# ============================================================================
# SERVER-KONFIGURATION
# ============================================================================

$Script:ServerConfig = @{
    RootServer = @{
        Hostname = $RootServer
        User = $Username
        Storage = @{
            Main = "3TB"
            Cache = "500GB"
        }
        Services = @("Lana Core", "DNS", "SSH", "Storage Sync", "Netcup API")
    }
    
    VPS = @{
        Hostname = $VPSServer
        User = $Username
        OS = "Windows Server 2025"
        Services = @("Web Server", "API", "Remote Desktop")
    }
    
    Webhosting = @{
        Sites = @(
            @{ Domain = "lana-ki.de"; Purpose = "Frontend" }
            @{ Domain = "carpuncle.eu"; Purpose = "API/Docs" }
            @{ Domain = "carpucloud.de"; Purpose = "Status/Admin" }
        )
    }
    
    StorageSpaces = @{
        Server1 = "256GB"
        Server2 = "256GB"
    }
}

# ============================================================================
# HILFSFUNKTIONEN
# ============================================================================

function Write-ServerLog {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet("Info", "Success", "Warning", "Error")]
        [string]$Level = "Info"
    )
    
    $color = switch ($Level) {
        "Info"    { "Cyan" }
        "Success" { "Green" }
        "Warning" { "Yellow" }
        "Error"   { "Red" }
    }
    
    Write-Host "[SERVER] $Message" -ForegroundColor $color
}

function Test-SSHConnection {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Hostname,
        
        [Parameter(Mandatory=$true)]
        [string]$Username
    )
    
    try {
        $result = ssh -o ConnectTimeout=5 -o BatchMode=yes "$Username@$Hostname" "echo 'connected'" 2>&1
        if ($result -like "*connected*") {
            return $true
        }
    } catch {
        return $false
    }
    
    return $false
}

function Setup-RootServerConnection {
    <#
    .SYNOPSIS
        Konfiguriert Verbindung zum Root-Server
    #>
    
    Write-ServerLog "=== Konfiguriere Root-Server-Verbindung ===" -Level Info
    
    $server = $Script:ServerConfig.RootServer
    $hostname = $server.Hostname
    $user = $server.User
    
    Write-ServerLog "Server: $hostname" -Level Info
    Write-ServerLog "Benutzer: $user" -Level Info
    Write-ServerLog "Storage: $($server.Storage.Main) + $($server.Storage.Cache)" -Level Info
    
    # SSH-Verbindung testen
    if (Test-SSHConnection -Hostname $hostname -Username $user) {
        Write-ServerLog "SSH-Verbindung erfolgreich: $hostname" -Level Success
        
        # Server-Info abrufen
        Write-ServerLog "Rufe Server-Informationen ab..." -Level Info
        $diskInfo = ssh "$user@$hostname" "df -h | grep -E '(Filesystem|/dev/)'"
        Write-ServerLog "Disk-Info:`n$diskInfo" -Level Info
        
    } else {
        Write-ServerLog "SSH-Verbindung fehlgeschlagen: $hostname" -Level Warning
        Write-ServerLog "Bitte SSH-Key zum Server hochladen:" -Level Warning
        Write-ServerLog "  ssh-copy-id $user@$hostname" -Level Warning
    }
}

function Setup-VPSConnection {
    <#
    .SYNOPSIS
        Konfiguriert Verbindung zum VPS (Windows Server 2025)
    #>
    
    Write-ServerLog "=== Konfiguriere VPS-Verbindung ===" -Level Info
    
    $vps = $Script:ServerConfig.VPS
    $hostname = $vps.Hostname
    $user = $vps.User
    
    Write-ServerLog "VPS: $hostname ($($vps.OS))" -Level Info
    
    # Für Windows Server: Remote Desktop und WinRM
    Write-ServerLog "Manuelle Schritte für Windows Server VPS:" -Level Warning
    Write-ServerLog "1. Remote Desktop aktivieren" -Level Warning
    Write-ServerLog "2. WinRM für PowerShell Remoting aktivieren" -Level Warning
    Write-ServerLog "3. SSH-Server installieren (Optional)" -Level Warning
    Write-ServerLog "4. Firewall-Regeln konfigurieren" -Level Warning
    
    # WinRM-Test
    try {
        $session = New-PSSession -ComputerName $hostname -Credential (Get-Credential) -ErrorAction Stop
        Write-ServerLog "WinRM-Verbindung erfolgreich" -Level Success
        Remove-PSSession $session
    } catch {
        Write-ServerLog "WinRM-Verbindung nicht verfügbar (normal bei erstmaliger Einrichtung)" -Level Info
    }
}

function Setup-StorageMapping {
    <#
    .SYNOPSIS
        Richtet Netzwerk-Laufwerke für Server-Storage ein
    #>
    
    Write-ServerLog "=== Konfiguriere Storage-Mapping ===" -Level Info
    
    # SSHFS für Linux-Server (Root-Server)
    Write-ServerLog "Für Linux-Server Storage:" -Level Info
    Write-ServerLog "1. WinFsp installieren (bereits in T:\Carpuncle\Tools\WinFsp)" -Level Info
    Write-ServerLog "2. SSHFS-Win installieren" -Level Info
    Write-ServerLog "3. Netzlaufwerk mounten mit SSHFS" -Level Info
    
    # SMB für Windows-Server (VPS)
    Write-ServerLog "Für Windows-Server Storage:" -Level Info
    Write-ServerLog "1. SMB-Share auf VPS einrichten" -Level Info
    Write-ServerLog "2. Netzlaufwerk in Windows verbinden" -Level Info
    
    # Beispiel-Befehle
    $sshfsCommand = "sshfs $($Script:ServerConfig.RootServer.User)@$($Script:ServerConfig.RootServer.Hostname):/path/to/storage S:"
    Write-ServerLog "SSHFS-Befehl: $sshfsCommand" -Level Info
}

function Setup-FTPAccess {
    <#
    .SYNOPSIS
        Konfiguriert FTP-Zugriff für Webhosting
    #>
    
    Write-ServerLog "=== Konfiguriere FTP-Zugriff ===" -Level Info
    
    # WinSCP ist bereits in Tools
    $winscpPath = "T:\Carpuncle\Tools\winscp"
    
    if (Test-Path $winscpPath) {
        Write-ServerLog "WinSCP gefunden: $winscpPath" -Level Success
    } else {
        Write-ServerLog "WinSCP nicht gefunden. Bitte installieren." -Level Warning
    }
    
    Write-ServerLog "Webhosting-Sites:" -Level Info
    foreach ($site in $Script:ServerConfig.Webhosting.Sites) {
        Write-ServerLog "  - $($site.Domain) ($($site.Purpose))" -Level Info
    }
    
    Write-ServerLog "FTP-Zugangsdaten in RoboForm gespeichert" -Level Info
}

function Setup-VLANConfiguration {
    <#
    .SYNOPSIS
        Konfiguriert VLAN-Verbindung zu Netcup-Servern
    #>
    
    Write-ServerLog "=== Konfiguriere VLAN-Verbindung ===" -Level Info
    
    Write-ServerLog "VLAN-Setup erfordert Netcup CCP-Zugriff" -Level Warning
    Write-ServerLog "Manuelle Schritte:" -Level Warning
    Write-ServerLog "1. In Netcup CCP einloggen" -Level Warning
    Write-ServerLog "2. VLAN-Interface konfigurieren" -Level Warning
    Write-ServerLog "3. IP-Adressen zuweisen" -Level Warning
    Write-ServerLog "4. Routing-Tabellen aktualisieren" -Level Warning
}

function Create-ServerConnectionScript {
    <#
    .SYNOPSIS
        Erstellt Convenience-Skripte für Server-Verbindungen
    #>
    
    Write-ServerLog "=== Erstelle Verbindungs-Skripte ===" -Level Info
    
    $scriptsPath = "T:\Carpuncle\Tools\bin"
    
    # Root-Server Connect
    $rootServerScript = @"
#!/usr/bin/env pwsh
# Verbindung zum Root-Server
ssh $($Script:ServerConfig.RootServer.User)@$($Script:ServerConfig.RootServer.Hostname)
"@
    
    $rootServerScriptPath = Join-Path $scriptsPath "connect-rootserver.ps1"
    Set-Content -Path $rootServerScriptPath -Value $rootServerScript
    Write-ServerLog "Skript erstellt: $rootServerScriptPath" -Level Success
    
    # VPS Connect
    $vpsScript = @"
#!/usr/bin/env pwsh
# Verbindung zum VPS
mstsc /v:$($Script:ServerConfig.VPS.Hostname)
"@
    
    $vpsScriptPath = Join-Path $scriptsPath "connect-vps.ps1"
    Set-Content -Path $vpsScriptPath -Value $vpsScript
    Write-ServerLog "Skript erstellt: $vpsScriptPath" -Level Success
}

function Show-ServerSummary {
    <#
    .SYNOPSIS
        Zeigt Zusammenfassung der Server-Konfiguration
    #>
    
    Write-ServerLog "" -Level Info
    Write-ServerLog "============================================" -Level Success
    Write-ServerLog "  Server-Konfiguration Abgeschlossen" -Level Success
    Write-ServerLog "============================================" -Level Success
    Write-ServerLog "" -Level Info
    
    Write-ServerLog "Root-Server: $($Script:ServerConfig.RootServer.Hostname)" -Level Info
    Write-ServerLog "  Storage: $($Script:ServerConfig.RootServer.Storage.Main) + $($Script:ServerConfig.RootServer.Storage.Cache)" -Level Info
    Write-ServerLog "  Services: $($Script:ServerConfig.RootServer.Services -join ', ')" -Level Info
    Write-ServerLog "" -Level Info
    
    Write-ServerLog "VPS: $($Script:ServerConfig.VPS.Hostname)" -Level Info
    Write-ServerLog "  OS: $($Script:ServerConfig.VPS.OS)" -Level Info
    Write-ServerLog "  Services: $($Script:ServerConfig.VPS.Services -join ', ')" -Level Info
    Write-ServerLog "" -Level Info
    
    Write-ServerLog "Verbindungs-Skripte:" -Level Success
    Write-ServerLog "  Root-Server: connect-rootserver.ps1" -Level Success
    Write-ServerLog "  VPS: connect-vps.ps1" -Level Success
    Write-ServerLog "" -Level Info
}

# ============================================================================
# HAUPTSKRIPT
# ============================================================================

function Main {
    try {
        Write-ServerLog "============================================" -Level Info
        Write-ServerLog "  Carpuncle Server-Integration" -Level Info
        Write-ServerLog "============================================" -Level Info
        Write-ServerLog "" -Level Info
        
        # Root-Server
        Setup-RootServerConnection
        
        # VPS
        Setup-VPSConnection
        
        # Storage
        Setup-StorageMapping
        
        # FTP
        Setup-FTPAccess
        
        # VLAN
        Setup-VLANConfiguration
        
        # Convenience-Skripte
        Create-ServerConnectionScript
        
        # Zusammenfassung
        Show-ServerSummary
        
    } catch {
        Write-ServerLog "Kritischer Fehler: $_" -Level Error
        Write-ServerLog $_.Exception.Message -Level Error
        exit 1
    }
}

# Skript ausführen
Main
