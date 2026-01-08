# Carpuncle Vollautomatisches System - Dokumentation

## 🎯 Überblick

Das Carpuncle Vollautomatische System ist eine umfassende Automatisierungslösung für die komplette Windows-Workstation-Einrichtung. Ein einziges PowerShell-Skript konfiguriert alles automatisch.

## 🚀 Schnellstart

### Voraussetzungen

- Windows 10/11 Enterprise oder Pro
- PowerShell 7.0 oder höher
- Administrator-Rechte
- Mindestens 500 GB freier Speicherplatz auf Laufwerk T:\

### Installation

1. **PowerShell als Administrator öffnen**

2. **Vollständiges Setup ausführen:**
   ```powershell
   # Skript herunterladen und ausführen
   cd C:\Users\<DeinBenutzer>\Downloads
   .\Setup-CarpuncleSystem.ps1
   ```

3. **Das war's!** - Das Skript konfiguriert:
   - ✅ Benutzer "carpu" mit automatischem Login
   - ✅ Verzeichnisstruktur auf T:\Carpuncle
   - ✅ Umgebungsvariablen für alle Tools
   - ✅ SSH-Keys für passwortlosen Server-Zugriff
   - ✅ Git-Konfiguration
   - ✅ OneDrive-Vorbereitung

## 📁 Verzeichnisstruktur

```
T:\Carpuncle\
├── Tools\              # Alle Entwicklungstools
│   ├── bin\           # Binaries und Convenience-Skripte
│   ├── git\           # Git
│   ├── gh\            # GitHub CLI
│   ├── pwsh\          # PowerShell 7
│   ├── python\        # Python
│   ├── node\          # Node.js
│   ├── go\            # Go
│   ├── dotnet\        # .NET SDK
│   ├── vscode\        # VS Code
│   ├── WT\            # Windows Terminal
│   └── [weitere]      # Siehe vollständige Liste unten
├── SDKs\              # Software Development Kits
├── Lang\              # Sprachmodelle und Language Servers
├── Models\            # KI-Modelle (Ollama, etc.)
├── Cache\             # Build-Cache und temporäre Dateien
├── Logs\              # System- und Application-Logs
└── Lana\              # Lana KI-System
```

### Vollständige Tools-Liste

Die folgenden Tools werden automatisch erkannt und konfiguriert (falls vorhanden):

- **Entwicklung**: git, gh, vscode, IntelliJ IDEA 2025.3, npp (Notepad++)
- **Sprachen**: python, python-3.12, node, npm, go, dotnet, java
- **Cloud**: azurecli-py312, azurecli-venv, bicep
- **DevOps**: kiota, modules, dashboard
- **Utilities**: 7zip, WinFsp, rclone, PuTTY, winscp
- **Terminal**: pwsh (PowerShell 7), WT (Windows Terminal)
- **Server**: ollama, SteamCMD
- **Kommunikation**: Telegram, Monika
- **Tools**: JDownloader 2, DeepL, Hyperj, portable
- **Office**: Office

## 👤 Benutzer-Konfiguration

### Lokaler Benutzer

- **Benutzername**: `carpu`
- **Passwort**: `Beatom&2007` (lokal)
- **Gruppe**: Administratoren
- **Auto-Login**: Aktiviert

### Microsoft-Konten

Zwei Konten werden harmonisch auf den gleichen Benutzer gemappt:

1. **Business-Konto**: `carpu@carpuncle.eu`
   - Für: Azure, GitHub Copilot Business, Entra ID, Sharepoint
   - OneDrive: `T:\OneDrive - Carpuncle`

2. **Personal-Konto**: `carpuncle-pc@live.de`
   - Für: GitHub Copilot Pro, persönliche Projekte
   - OneDrive: `T:\OneDrive`

### OneDrive-Integration

**Wichtig**: OneDrive muss manuell konfiguriert werden:

1. Business-Konto anmelden und Ordner nach `T:\OneDrive - Carpuncle` verschieben
2. Personal-Konto anmelden und Ordner nach `T:\OneDrive` verschieben
3. In OneDrive-Einstellungen:
   - ❌ **Automatische Ordner-Synchronisation deaktivieren**
   - ✅ Nur ausgewählte Ordner synchronisieren
   - ✅ Zugriffskonflikte vermeiden

## 🖥️ Server-Integration

### Root-Server (carpu.carpuncle.eu)

- **Hauptspeicher**: 3 TB
- **Cache**: 500 GB
- **Services**: 
  - Lana Core (KI-Engine)
  - DNS
  - SSH Trust Anchor
  - Storage Sync
  - Netcup API Integration

**Verbindung**:
```powershell
ssh rootserver
# oder
connect-rootserver.ps1
```

### VPS (carpuncle.eu)

- **OS**: Windows Server 2025
- **Services**:
  - Web Server
  - API Gateway
  - Remote Desktop

**Verbindung**:
```powershell
mstsc /v:carpuncle.eu
# oder
connect-vps.ps1
```

### Webhosting

1. **lana-ki.de** - Frontend und Benutzer-Interface
2. **carpuncle.eu** - API und Dokumentation
3. **carpucloud.de** - Status-Dashboard und Admin-Panel

### Storage Spaces

- **Server 1**: 256 GB (Netcup Storage)
- **Server 2**: 256 GB (Netcup Storage)
- **Zweck**: Backup, Sync, Archive

## 🔐 Passwortlose Authentifizierung

### SSH-Keys

Das System erstellt automatisch SSH-Keys:

- **Speicherort**: `C:\Users\carpu\.ssh\`
- **Private Key**: `id_rsa`
- **Public Key**: `id_rsa.pub`
- **SSH Config**: Automatisch konfiguriert für Root-Server und VPS

**Public Key auf Server hochladen**:
```powershell
ssh-copy-id carpu@carpu.carpuncle.eu
ssh-copy-id carpu@carpuncle.eu
```

### RoboForm Integration

RoboForm verwaltet:
- ✅ 2FA für Netcup CCP
- ✅ 2FA für Microsoft-Konten (beide)
- ✅ 2FA für Google Cloud
- ✅ FTP-Zugangsdaten für Webhosting

**Manuelle Einrichtung erforderlich**: RoboForm muss separat installiert und konfiguriert werden.

## 💻 Windows Terminal & Chat

### Konfiguration

Windows Terminal mit folgenden Profilen:

1. **PowerShell 7** (Standard)
2. **Git Bash**
3. **SSH Root-Server**
4. **SSH VPS**
5. **Python REPL**
6. **Node.js REPL**

### GitHub Copilot Integration

**Copilot Business + Pro zusammen nutzen**:

1. In VS Code:
   - Business-Konto: Workspace-Einstellungen
   - Pro-Konto: Benutzer-Einstellungen

2. GitHub CLI mit Copilot:
   ```powershell
   gh copilot suggest "wie mache ich X"
   gh copilot explain "git reset --hard"
   ```

3. Terminal-Chat-Funktion:
   - Windows Terminal Preview installieren
   - GitHub Copilot Extension aktivieren
   - `Ctrl+Shift+P` für Chat öffnen

## 🤖 Lana KI-System

### Konzept

Lana ist die visuelle, realistische KI-Assistentin für das Carpuncle-System.

### Funktionen

- 🗣️ **Terminal-Chat**: Problem eingeben, automatische Lösung
- 🔧 **Automatische Fehlerbehebung**: Erkennt und behebt Fehler selbstständig
- 📊 **Dashboard**: Visuelles Interface für System-Status
- 🌐 **Multi-Server**: Koordiniert Windows, Root-Server, VPS, Webhosting

### Architektur

```
[ Windows Client ]
       ↕
[ Lana Desktop App ]
       ↕
[ Lana Core auf Root-Server ]
       ↕
[ VPS + Webhosting ]
```

### Zukünftige Features

- ⏳ Visuelles Avatar-Interface
- ⏳ Sprach-Interaktion
- ⏳ Predictive Maintenance
- ⏳ Automatisches Deployment

## 🛠️ Umgebungsvariablen

Das Skript setzt automatisch:

```powershell
$env:CARPUNCLE_ROOT = "T:\Carpuncle"
$env:CARPUNCLE_USER = "carpu"
$env:PATH += ";T:\Carpuncle\Tools\bin"
$env:PATH += ";T:\Carpuncle\Tools\git\cmd"
# ... und weitere
```

## 📝 Manuelle Nacharbeiten

Nach dem automatischen Setup müssen folgende Schritte manuell durchgeführt werden:

### 1. OneDrive-Konten

- [ ] Business-Konto `carpu@carpuncle.eu` anmelden
- [ ] Personal-Konto `carpuncle-pc@live.de` anmelden
- [ ] Ordner nach T:\ verschieben
- [ ] Automatische Synchronisation deaktivieren

### 2. Server-Zugriff

- [ ] SSH Public Key auf Root-Server hochladen
- [ ] SSH Public Key auf VPS hochladen
- [ ] Netcup CCP-Zugang testen
- [ ] VLAN-Verbindung konfigurieren

### 3. Entwicklungstools

- [ ] VS Code Extensions installieren
- [ ] GitHub Copilot Business aktivieren
- [ ] GitHub Copilot Pro aktivieren
- [ ] Windows Terminal Profiles anpassen

### 4. RoboForm

- [ ] RoboForm installieren
- [ ] 2FA-Tokens importieren
- [ ] FTP-Zugangsdaten speichern

### 5. Storage Mapping

- [ ] WinFsp und SSHFS installieren
- [ ] Netzlaufwerke für Server-Storage mounten
- [ ] SMB-Shares vom VPS verbinden

## 🔄 Workflow

### Täglicher Workflow

1. **System startet** → Auto-Login zu `carpu`
2. **Windows Terminal öffnet** → PowerShell 7 bereit
3. **OneDrive synchronisiert** → Automatisch im Hintergrund
4. **Server-Verbindungen** → SSH-Keys bereits geladen

### Problem lösen mit Lana

```powershell
# Im Terminal
lana "Python-Projekt startet nicht"

# Lana analysiert:
# - Prüft Python-Installation
# - Überprüft Dependencies
# - Testet Virtual Environment
# - Behebt automatisch gefundene Probleme
# - Gibt Bericht aus
```

## 📊 Monitoring & Logs

### Log-Dateien

Alle Setup-Logs werden gespeichert in:
```
T:\Carpuncle\Logs\Setup-YYYYMMDD-HHMMSS.log
```

### System-Status

```powershell
# Status-Übersicht
Get-CarpuncleStatus

# Server-Status
Get-ServerStatus

# Storage-Übersicht
Get-StorageStatus
```

## 🚨 Fehlerbehebung

### SSH-Verbindung funktioniert nicht

```powershell
# SSH-Agent starten
Start-Service ssh-agent

# Key hinzufügen
ssh-add $env:USERPROFILE\.ssh\id_rsa

# Verbindung testen
ssh -v carpu@carpu.carpuncle.eu
```

### Tools nicht im PATH

```powershell
# Umgebungsvariablen neu laden
$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine")

# Oder Terminal neu starten
```

### OneDrive-Konflikte

```powershell
# OneDrive-Status prüfen
Get-Process OneDrive

# OneDrive neu starten
Stop-Process -Name OneDrive -Force
Start-Process "$env:LOCALAPPDATA\Microsoft\OneDrive\OneDrive.exe"
```

## 🔄 Updates

### System aktualisieren

```powershell
# Setup erneut ausführen (idempotent)
.\Setup-CarpuncleSystem.ps1 -Force

# Nur Tools aktualisieren
.\Setup-CarpuncleSystem.ps1 -SkipUserSetup -SkipServerSetup
```

### Server-Konfiguration aktualisieren

```powershell
.\Setup-CarpuncleServers.ps1
```

## 📞 Support

- **Email**: carpuncle-pc@live.de
- **Business**: carpu@carpuncle.eu
- **GitHub**: [@Carpuncle-Lana](https://github.com/Carpuncle-Lana)
- **Dokumentation**: https://carpuncle.eu/docs

## 🎓 Erweiterte Themen

### ReFS Dev Drive erstellen

```powershell
# Disk 0 als ReFS formatieren
Format-Volume -DriveLetter T -FileSystem ReFS -DevDrive -SetIntegrityStreams
```

### VPS Windows Server 2025 Image

Für den VPS muss ein eigenes Image erstellt werden:

1. **Format**: QCOW2 oder RAW
2. **Größe**: Mindestens 40 GB
3. **Sysprep**: Image generalisieren
4. **Upload**: Zu Netcup hochladen

### Azure VNet Integration

Für Azure-Integration:
```powershell
.\Deploy-AzureCarpuncle.ps1 -Environment prod
```

## 📄 Lizenz

MIT License - Siehe LICENSE-Datei für Details.

---

**Version**: 1.0.0  
**Letzte Aktualisierung**: Januar 2025  
**Maintained by**: Carpuncle DevOps Team
