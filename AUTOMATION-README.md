# 🚀 Carpuncle Vollautomatisches System - Quick Start

**Ein einziger Befehl für die komplette Windows-Workstation-Einrichtung!**

## 🎯 Was macht dieses System?

Dieses Automation-System richtet Ihre komplette Carpuncle-Entwicklungsumgebung mit **einem einzigen PowerShell-Befehl** ein:

- ✅ Windows-Benutzer `carpu` mit automatischem Login
- ✅ Komplette Verzeichnisstruktur auf `T:\Carpuncle`
- ✅ Alle Tools korrekt konfiguriert und im PATH
- ✅ SSH-Keys für passwortlosen Server-Zugriff
- ✅ Zwei Microsoft-Konten harmonisch integriert
- ✅ OneDrive-Vorbereitung (Business + Personal)
- ✅ Git, GitHub CLI, Windows Terminal
- ✅ Server-Verbindungen (Root-Server, VPS, Webhosting)
- ✅ Grundlage für Lana KI-System

## ⚡ Schnellstart - NUR DIESER BEFEHL!

**PowerShell als Administrator öffnen und kopieren:**

```powershell
# Option 1: Direkter Download und Ausführung (empfohlen)
irm https://raw.githubusercontent.com/Isychan1/Carpuncle/main/Install-Carpuncle.ps1 | iex
```

**Fertig!** 🎉

Das System richtet alles automatisch ein.

### Alternative: Lokale Ausführung

Wenn Sie das Repository bereits geklont haben:

```powershell
cd C:\Pfad\zum\Carpuncle
.\Install-Carpuncle.ps1
```

### Mit Tool-Installation:

```powershell
.\Install-Carpuncle.ps1 -InstallTools
```

Dies installiert automatisch:
- Git, GitHub CLI
- Visual Studio Code
- Python, Node.js
- 7-Zip, WinSCP, PuTTY
- Windows Terminal

## 📋 Voraussetzungen

Bevor Sie das Skript ausführen, stellen Sie sicher:

- ✅ Windows 10/11 Enterprise oder Pro
- ✅ PowerShell 7.0 oder höher
- ✅ Administrator-Rechte
- ✅ Laufwerk T:\ mit mindestens 100 GB frei

### PowerShell 7 installieren (falls nicht vorhanden):

```powershell
winget install Microsoft.PowerShell
```

### Laufwerk T:\ erstellen (falls nicht vorhanden):

Option 1 - Existierende Partition:
```powershell
# Wenn Sie bereits eine Partition haben, Laufwerksbuchstaben ändern
# Datenträgerverwaltung (diskmgmt.msc) öffnen
```

Option 2 - VHD erstellen:
```powershell
# Erstellt virtuelle 500GB Festplatte
New-VHD -Path C:\Carpuncle.vhdx -SizeBytes 500GB -Dynamic
Mount-VHD -Path C:\Carpuncle.vhdx
# Dann in Datenträgerverwaltung initialisieren und als T: formatieren
```

## 📁 Was wird eingerichtet?

### Verzeichnisstruktur

```
T:\Carpuncle\
├── Tools\          # Alle Entwicklungstools
├── SDKs\           # Software Development Kits
├── Lang\           # Sprachmodelle und Language Servers
├── Models\         # KI-Modelle
├── Cache\          # Build-Cache
├── Logs\           # System-Logs
└── Lana\           # Lana KI-System
```

### Benutzer-Konfiguration

- **Lokaler Benutzer**: `carpu` (Passwort: `Beatom&2007`)
- **Business-Konto**: `carpu@carpuncle.eu`
- **Personal-Konto**: `carpuncle-pc@live.de`
- **Auto-Login**: Aktiviert

### Server-Integration

- **Root-Server**: `carpu.carpuncle.eu` (3TB + 500GB)
- **VPS**: `carpuncle.eu` (Windows Server 2025)
- **Webhosting**: lana-ki.de, carpuncle.eu, carpucloud.de

### Tools (bereits vorhanden in T:\Carpuncle\Tools)

Die folgenden Tools werden erkannt und konfiguriert:
- git, gh, vscode, IntelliJ IDEA
- python, node, npm, go, dotnet, java
- azurecli, bicep, kiota
- 7zip, WinFsp, rclone
- PuTTY, winscp, WinSCP
- PowerShell 7, Windows Terminal
- ollama, Telegram, Office
- und viele mehr...

## 🔐 Passwortlose Authentifizierung

Das System erstellt automatisch SSH-Keys:

```powershell
# Public Key auf Server hochladen
ssh-copy-id carpu@carpu.carpuncle.eu
ssh-copy-id carpu@carpuncle.eu

# Dann einfach verbinden (kein Passwort!)
ssh rootserver
```

## 📖 Vollständige Dokumentation

Nach der Installation finden Sie die komplette Dokumentation hier:
```
T:\Carpuncle\CARPUNCLE-SYSTEM-SETUP.md
```

## 🔄 Manuelle Nacharbeiten

Nach dem automatischen Setup:

1. **OneDrive-Konten anmelden:**
   - Business: `carpu@carpuncle.eu` → `T:\OneDrive - Carpuncle`
   - Personal: `carpuncle-pc@live.de` → `T:\OneDrive`
   - ⚠️ Automatische Ordner-Sync deaktivieren!

2. **SSH-Keys hochladen:**
   ```powershell
   ssh-copy-id carpu@carpu.carpuncle.eu
   ```

3. **RoboForm installieren** (2FA-Manager)

4. **GitHub Copilot aktivieren:**
   - Business-Konto in VS Code (Workspace)
   - Pro-Konto in VS Code (User)

5. **Windows Terminal Profile anpassen**

## 🛠️ Verfügbare Skripte

Nach der Installation sind folgende Skripte verfügbar:

```powershell
# System erneut einrichten
.\Setup-CarpuncleSystem.ps1

# Server konfigurieren
.\Setup-CarpuncleServers.ps1

# Root-Server verbinden
connect-rootserver.ps1

# VPS verbinden
connect-vps.ps1
```

## 🤖 Lana KI-System

Das Setup bereitet die Grundlage für Lana vor:

- 🗣️ Terminal-Chat für automatische Problemlösung
- 🔧 Fehler-Erkennung und -Behebung
- 📊 Visuelles Dashboard
- 🌐 Multi-Server-Koordination

Zukünftige Lana-Befehle:
```powershell
lana "Python-Projekt startet nicht"
lana status
lana deploy
```

## 🔍 Fehlerbehebung

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
# Terminal neu starten oder PATH neu laden
$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine")
```

### Setup-Fehler

```powershell
# Log-Datei prüfen
Get-Content T:\Carpuncle\Logs\Setup-*.log -Tail 50

# Setup mit Force erneut ausführen
.\Install-Carpuncle.ps1 -Force
```

## 📊 Features

| Feature | Status | Beschreibung |
|---------|--------|--------------|
| Benutzer-Setup | ✅ | Auto-Login, passwortlos |
| Verzeichnisse | ✅ | Komplette Struktur |
| Tools | ✅ | PATH, Umgebungsvariablen |
| SSH-Keys | ✅ | Passwortloser Zugriff |
| Git | ✅ | Konfiguriert |
| OneDrive | ⏳ | Manuell (Vorbereitet) |
| Server | ⏳ | Verbindungen vorbereitet |
| Lana | ⏳ | Grundlage geschaffen |

## 🎓 Architektur

```
[ Windows Enterprise - Benutzer: carpu ]
           ↕
    [ T:\Carpuncle ]
           ↕
  [ Lana Desktop Client ]
           ↕
  [ Root Server - Lana Core ]
           ↕
[ VPS + Webhosting + Storage ]
```

## 🔒 Sicherheit

- ✅ SSH-Key-basierte Authentifizierung
- ✅ Keine Passwörter in Klartext
- ✅ RoboForm für 2FA
- ✅ Lokale Admin-Rechte für `carpu`
- ✅ EFI + PE Absicherung (manuell)

## 📞 Support & Kontakt

- **Email**: carpuncle-pc@live.de
- **Business**: carpu@carpuncle.eu
- **GitHub**: [@Carpuncle-Lana](https://github.com/Carpuncle-Lana)
- **Repository**: [Isychan1/Carpuncle](https://github.com/Isychan1/Carpuncle)

## 🎯 Vision

Ziel ist ein **vollautomatisches, selbstheilendes System**, gesteuert von Lana:

> "Einfach das Problem im Terminal-Chat eingeben, und es behebt sich automatisch."

## 📄 Lizenz

MIT License

---

**Ein Befehl. Alles eingerichtet. Los geht's!** 🚀

```powershell
irm https://raw.githubusercontent.com/Isychan1/Carpuncle/main/Install-Carpuncle.ps1 | iex
```
