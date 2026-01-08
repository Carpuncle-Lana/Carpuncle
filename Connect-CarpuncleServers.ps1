# Connect-CarpuncleServers.ps1
# Hilfsskript für Server-Verbindungen und Management

<#
.SYNOPSIS
    Server-Verbindungs-Manager für Carpuncle-System

.DESCRIPTION
    Vereinfacht die Verbindung zu Root-Server, VPS und Webhosting.
    Unterstützt SSH, RDP und FTP-Verbindungen.

.PARAMETER ServerType
    Art des Servers: RootServer, VPS, Webhosting, All

.PARAMETER Action
    Aktion: Connect, Status, Test, InstallKey

.PARAMETER PublicKey
    Pfad zum öffentlichen SSH-Schlüssel (für InstallKey)

.EXAMPLE
    .\Connect-CarpuncleServers.ps1 -ServerType RootServer -Action Connect
    
.EXAMPLE
    .\Connect-CarpuncleServers.ps1 -ServerType All -Action Test
    
.EXAMPLE
    .\Connect-CarpuncleServers.ps1 -ServerType VPS -Action InstallKey
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("RootServer", "VPS", "Webhosting", "All")]
    [string]$ServerType = "All",
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("Connect", "Status", "Test", "InstallKey", "Info")]
    [string]$Action = "Info",
    
    [Parameter(Mandatory=$false)]
    [string]$PublicKey = "$env:USERPROFILE\.ssh\id_rsa.pub"
)

# Farben
$InfoColor = "Cyan"
$SuccessColor = "Green"
$WarningColor = "Yellow"
$ErrorColor = "Red"

function Write-Info { param([string]$Message) Write-Host "[INFO] $Message" -ForegroundColor $InfoColor }
function Write-Success { param([string]$Message) Write-Host "[✓] $Message" -ForegroundColor $SuccessColor }
function Write-Warning { param([string]$Message) Write-Host "[!] $Message" -ForegroundColor $WarningColor }
function Write-Error { param([string]$Message) Write-Host "[✗] $Message" -ForegroundColor $ErrorColor }

function Write-Section { 
    param([string]$Title)
    Write-Host "`n$('=' * 80)" -ForegroundColor Magenta
    Write-Host "  $Title" -ForegroundColor Magenta
    Write-Host "$('=' * 80)`n" -ForegroundColor Magenta
}

# Server-Konfiguration
$Script:Servers = @{
    RootServer = @{
        Name = "Root Server"
        Hostname = "carpu.carpuncle.eu"
        Type = "Linux"
        User = "carpu"
        Port = 22
        Protocol = "SSH"
        Description = "Haupt-Server mit 3TB + 500GB Storage"
    }
    VPS = @{
        Name = "VPS"
        Hostname = "carpuncle.eu"
        Type = "Windows Server 2025"
        User = "carpu"
        Port = 22
        RDPPort = 3389
        Protocol = "SSH/RDP"
        Description = "Windows VPS für Anwendungs-Hosting"
    }
    Webhosting = @{
        Name = "Webhosting"
        Hostname = "webhosting.netcup.de"
        Type = "Shared Hosting"
        User = "carpuncle"
        Port = 22
        FTPPort = 21
        Protocol = "SSH/FTP"
        Description = "Webhosting für lana-ki.de, carpuncle.eu, carpucloud.de"
    }
}

function Test-ServerConnection {
    param(
        [string]$Hostname,
        [int]$Port = 22
    )
    
    try {
        $result = Test-NetConnection -ComputerName $Hostname -Port $Port -WarningAction SilentlyContinue
        return $result.TcpTestSucceeded
    }
    catch {
        return $false
    }
}

function Show-ServerInfo {
    param([string]$ServerName)
    
    $server = $Script:Servers[$ServerName]
    
    Write-Host "`n┌─────────────────────────────────────────────────┐" -ForegroundColor Cyan
    Write-Host "│ " -NoNewline -ForegroundColor Cyan
    Write-Host "$($server.Name)" -NoNewline -ForegroundColor White
    Write-Host (" " * (48 - $server.Name.Length)) -NoNewline
    Write-Host "│" -ForegroundColor Cyan
    Write-Host "├─────────────────────────────────────────────────┤" -ForegroundColor Cyan
    
    Write-Host "│ Hostname:    " -NoNewline -ForegroundColor Cyan
    Write-Host $server.Hostname -NoNewline -ForegroundColor White
    Write-Host (" " * (34 - $server.Hostname.Length)) -NoNewline
    Write-Host "│" -ForegroundColor Cyan
    
    Write-Host "│ Type:        " -NoNewline -ForegroundColor Cyan
    Write-Host $server.Type -NoNewline -ForegroundColor White
    Write-Host (" " * (34 - $server.Type.Length)) -NoNewline
    Write-Host "│" -ForegroundColor Cyan
    
    Write-Host "│ User:        " -NoNewline -ForegroundColor Cyan
    Write-Host $server.User -NoNewline -ForegroundColor White
    Write-Host (" " * (34 - $server.User.Length)) -NoNewline
    Write-Host "│" -ForegroundColor Cyan
    
    Write-Host "│ Protocol:    " -NoNewline -ForegroundColor Cyan
    Write-Host $server.Protocol -NoNewline -ForegroundColor White
    Write-Host (" " * (34 - $server.Protocol.Length)) -NoNewline
    Write-Host "│" -ForegroundColor Cyan
    
    Write-Host "│ SSH Port:    " -NoNewline -ForegroundColor Cyan
    Write-Host $server.Port -NoNewline -ForegroundColor White
    Write-Host (" " * (34 - $server.Port.ToString().Length)) -NoNewline
    Write-Host "│" -ForegroundColor Cyan
    
    if ($server.RDPPort) {
        Write-Host "│ RDP Port:    " -NoNewline -ForegroundColor Cyan
        Write-Host $server.RDPPort -NoNewline -ForegroundColor White
        Write-Host (" " * (34 - $server.RDPPort.ToString().Length)) -NoNewline
        Write-Host "│" -ForegroundColor Cyan
    }
    
    Write-Host "├─────────────────────────────────────────────────┤" -ForegroundColor Cyan
    Write-Host "│ " -NoNewline -ForegroundColor Cyan
    Write-Host $server.Description -NoNewline -ForegroundColor Yellow
    Write-Host (" " * (48 - $server.Description.Length)) -NoNewline
    Write-Host "│" -ForegroundColor Cyan
    Write-Host "└─────────────────────────────────────────────────┘" -ForegroundColor Cyan
}

function Test-ServerStatus {
    param([string]$ServerName)
    
    $server = $Script:Servers[$ServerName]
    
    Write-Info "Teste Verbindung zu $($server.Name) ($($server.Hostname))..."
    
    # Hostname auflösen
    Write-Host "  → DNS-Auflösung..." -NoNewline
    try {
        $resolved = [System.Net.Dns]::GetHostAddresses($server.Hostname)
        Write-Host " ✓" -ForegroundColor Green
        Write-Host "    IP: $($resolved[0].IPAddressToString)" -ForegroundColor White
    }
    catch {
        Write-Host " ✗" -ForegroundColor Red
        Write-Warning "    DNS-Auflösung fehlgeschlagen"
        return
    }
    
    # Ping-Test
    Write-Host "  → Ping-Test..." -NoNewline
    try {
        $ping = Test-Connection -ComputerName $server.Hostname -Count 1 -Quiet
        if ($ping) {
            Write-Host " ✓" -ForegroundColor Green
        }
        else {
            Write-Host " ✗" -ForegroundColor Red
            Write-Warning "    Server antwortet nicht auf Ping"
        }
    }
    catch {
        Write-Host " ✗" -ForegroundColor Red
    }
    
    # SSH-Port testen
    Write-Host "  → SSH Port $($server.Port)..." -NoNewline
    $sshOpen = Test-ServerConnection -Hostname $server.Hostname -Port $server.Port
    if ($sshOpen) {
        Write-Host " ✓" -ForegroundColor Green
    }
    else {
        Write-Host " ✗" -ForegroundColor Red
        Write-Warning "    SSH-Port nicht erreichbar"
    }
    
    # RDP-Port testen (wenn vorhanden)
    if ($server.RDPPort) {
        Write-Host "  → RDP Port $($server.RDPPort)..." -NoNewline
        $rdpOpen = Test-ServerConnection -Hostname $server.Hostname -Port $server.RDPPort
        if ($rdpOpen) {
            Write-Host " ✓" -ForegroundColor Green
        }
        else {
            Write-Host " ✗" -ForegroundColor Red
        }
    }
    
    # Gesamtstatus
    if ($sshOpen) {
        Write-Success "`n  Server ist erreichbar!"
    }
    else {
        Write-Error "`n  Server ist nicht erreichbar!"
    }
}

function Connect-ToServer {
    param([string]$ServerName)
    
    $server = $Script:Servers[$ServerName]
    
    Write-Info "Verbinde mit $($server.Name)..."
    Write-Host "  Hostname: $($server.Hostname)" -ForegroundColor White
    Write-Host "  User: $($server.User)" -ForegroundColor White
    Write-Host "  Port: $($server.Port)" -ForegroundColor White
    
    # SSH-Befehl
    $sshCommand = "ssh $($server.User)@$($server.Hostname) -p $($server.Port)"
    
    Write-Info "`nFühre aus: $sshCommand"
    Write-Info "(Verwende 'exit' zum Beenden der SSH-Sitzung)`n"
    
    # SSH-Verbindung starten
    try {
        & ssh "$($server.User)@$($server.Hostname)" -p $server.Port
    }
    catch {
        Write-Error "SSH-Verbindung fehlgeschlagen: $_"
        Write-Info "`nStelle sicher, dass:"
        Write-Info "1. SSH-Client installiert ist (OpenSSH oder Git für Windows)"
        Write-Info "2. SSH-Keys konfiguriert sind (~/.ssh/id_rsa)"
        Write-Info "3. Public Key auf dem Server installiert ist"
    }
}

function Install-SSHKeyOnServer {
    param([string]$ServerName)
    
    $server = $Script:Servers[$ServerName]
    
    Write-Section "SSH-KEY INSTALLATION"
    
    Write-Info "Installiere SSH Public Key auf $($server.Name)..."
    
    # Prüfe ob Public Key existiert
    if (-not (Test-Path $PublicKey)) {
        Write-Error "Public Key nicht gefunden: $PublicKey"
        Write-Info "Bitte zuerst SSH-Keys generieren mit Setup-CarpuncleLana.ps1"
        return
    }
    
    # Public Key laden
    $pubKeyContent = Get-Content $PublicKey -Raw
    
    Write-Success "Public Key geladen: $PublicKey"
    Write-Host "`nPublic Key Inhalt:" -ForegroundColor Yellow
    Write-Host "─────────────────────────────────────────────" -ForegroundColor Yellow
    Write-Host $pubKeyContent -ForegroundColor White
    Write-Host "─────────────────────────────────────────────" -ForegroundColor Yellow
    
    Write-Info "`nInstallations-Schritte für $($server.Name):"
    Write-Host ""
    Write-Host "1. Mit dem Server verbinden (manuell mit Passwort):" -ForegroundColor Cyan
    Write-Host "   ssh $($server.User)@$($server.Hostname)" -ForegroundColor White
    Write-Host ""
    Write-Host "2. Auf dem Server ausführen:" -ForegroundColor Cyan
    Write-Host "   mkdir -p ~/.ssh" -ForegroundColor White
    Write-Host "   chmod 700 ~/.ssh" -ForegroundColor White
    Write-Host "   nano ~/.ssh/authorized_keys" -ForegroundColor White
    Write-Host ""
    Write-Host "3. Den obigen Public Key in die Datei einfügen" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "4. Berechtigungen setzen:" -ForegroundColor Cyan
    Write-Host "   chmod 600 ~/.ssh/authorized_keys" -ForegroundColor White
    Write-Host ""
    Write-Host "5. SSH-Verbindung beenden und erneut verbinden (jetzt passwortlos)" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Info "Alternativ: Einzeiler-Installation (wenn ssh-copy-id verfügbar):"
    Write-Host "ssh-copy-id -i $PublicKey $($server.User)@$($server.Hostname)" -ForegroundColor Yellow
}

function Show-ServerCommands {
    Write-Section "SCHNELLBEFEHLE"
    
    Write-Info "SSH-Verbindungen (nach SSH-Config-Setup):"
    Write-Host ""
    
    foreach ($serverName in $Script:Servers.Keys) {
        $server = $Script:Servers[$serverName]
        $alias = $serverName.ToLower() -replace 'server', '-server'
        
        Write-Host "  # $($server.Name)" -ForegroundColor Cyan
        Write-Host "  ssh $alias" -ForegroundColor White
        Write-Host "  # oder direkt:" -ForegroundColor Gray
        Write-Host "  ssh $($server.User)@$($server.Hostname)" -ForegroundColor Gray
        Write-Host ""
    }
    
    Write-Info "Datei-Transfer:"
    Write-Host ""
    Write-Host "  # Datei zum Server kopieren" -ForegroundColor Cyan
    Write-Host "  scp localfile.txt root-server:~/remotefile.txt" -ForegroundColor White
    Write-Host ""
    Write-Host "  # Datei vom Server holen" -ForegroundColor Cyan
    Write-Host "  scp root-server:~/remotefile.txt .\localfile.txt" -ForegroundColor White
    Write-Host ""
    
    Write-Info "Weitere Tools:"
    Write-Host ""
    Write-Host "  # WinSCP für grafischen Dateitransfer" -ForegroundColor Cyan
    Write-Host "  T:\Carpuncle\Tools\winscp\WinSCP.exe" -ForegroundColor White
    Write-Host ""
    Write-Host "  # PuTTY für SSH mit GUI" -ForegroundColor Cyan
    Write-Host "  T:\Carpuncle\Tools\PuTTY\putty.exe" -ForegroundColor White
    Write-Host ""
}

# Hauptlogik
Write-Section "CARPUNCLE SERVER-MANAGER"

switch ($Action) {
    "Info" {
        if ($ServerType -eq "All") {
            foreach ($serverName in $Script:Servers.Keys) {
                Show-ServerInfo -ServerName $serverName
            }
        }
        else {
            Show-ServerInfo -ServerName $ServerType
        }
        
        Write-Host ""
        Show-ServerCommands
    }
    
    "Status" {
        if ($ServerType -eq "All") {
            foreach ($serverName in $Script:Servers.Keys) {
                Test-ServerStatus -ServerName $serverName
                Write-Host ""
            }
        }
        else {
            Test-ServerStatus -ServerName $ServerType
        }
    }
    
    "Test" {
        # Alias für Status
        if ($ServerType -eq "All") {
            foreach ($serverName in $Script:Servers.Keys) {
                Test-ServerStatus -ServerName $serverName
                Write-Host ""
            }
        }
        else {
            Test-ServerStatus -ServerName $ServerType
        }
    }
    
    "Connect" {
        if ($ServerType -eq "All") {
            Write-Warning "Bitte spezifischen Server auswählen (RootServer, VPS, Webhosting)"
            return
        }
        
        Connect-ToServer -ServerName $ServerType
    }
    
    "InstallKey" {
        if ($ServerType -eq "All") {
            foreach ($serverName in $Script:Servers.Keys) {
                Install-SSHKeyOnServer -ServerName $serverName
                Write-Host "`n$('─' * 80)`n"
            }
        }
        else {
            Install-SSHKeyOnServer -ServerName $ServerType
        }
    }
}

Write-Host ""
Write-Success "Fertig!"
