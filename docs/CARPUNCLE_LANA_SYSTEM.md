# 🧠 Carpuncle Lana System - Vollständige Dokumentation

## Überblick

Das Carpuncle Lana System ist eine vollautomatisierte Infrastruktur, die Windows, Root-Server, VPS, Webhosting und Cloud-Storage nahtlos und passwortlos integriert. Gesteuert wird alles von der KI-Assistentin **Lana**.

## 🎯 Systemarchitektur

```
┌─────────────────────────────────────────────────────────────────┐
│                    CARPUNCLE LANA SYSTEM                        │
└─────────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌──────────────┐      ┌──────────────┐     ┌──────────────┐
│   Windows    │      │ Root Server  │     │   VPS        │
│  Enterprise  │◄────►│ carpu.       │◄───►│ carpuncle.eu │
│  (lokal)     │      │ carpuncle.eu │     │ Win 2025     │
└──────────────┘      └──────────────┘     └──────────────┘
        │                     │                     │
        └─────────────────────┴─────────────────────┘
                              │
                              ▼
                      ┌──────────────┐
                      │  Webhosting  │
                      │ lana-ki.de   │
                      │ carpucloud.de│
                      └──────────────┘
```

## 📋 Komponenten

### 1. Windows Enterprise (Lokal)

**Benutzer**: `carpu`  
**Hauptverzeichnis**: `T:\Carpuncle`

#### EFI-Struktur
```
EFI
├─ Windows Boot
├─ Windows-PE (Recovery)
└─ Lana-Recovery
```

#### Verzeichnisstruktur
```
T:\Carpuncle\
├─ Tools\          # Alle Entwicklungstools
│  ├─ bin\
│  ├─ git\
│  ├─ pwsh\
│  ├─ python\
│  ├─ node\
│  ├─ dotnet\
│  ├─ go\
│  ├─ vscode\
│  └─ ... (siehe Toolsliste unten)
│
├─ SDKs\           # Software Development Kits
├─ Lang\           # Sprachpakete und Compiler
├─ Models\         # KI-Modelle für Lana
├─ Cache\          # Temporäre Dateien und Cache
├─ Logs\           # System- und Anwendungslogs
└─ Lana\           # Lana AI-Assistenten-Framework
```

#### Tools-Verzeichnis (vollständige Liste)
```
T:\Carpuncle\Tools\
├─ 7zip\                    # Archivierungs-Tool
├─ azurecli-py312\          # Azure CLI mit Python 3.12
├─ azurecli-venv\           # Azure CLI Virtual Environment
├─ bicep\                   # Azure Bicep
├─ bin\                     # Executable Binaries
├─ dashboard\               # Dashboard-Tools
├─ DeepL\                   # DeepL Übersetzer
├─ dotnet\                  # .NET SDK
├─ gh\                      # GitHub CLI
├─ git\                     # Git Version Control
├─ go\                      # Go Programming Language
├─ Hyperj\                  # Hyperj IDE
├─ IntelliJ IDEA 2025.3\    # JetBrains IntelliJ IDEA
├─ java\                    # Java Development Kit
├─ JDownloader 2\           # Download Manager
├─ kiota\                   # Kiota API Client Generator
├─ modules\                 # PowerShell/Node Modules
├─ Monika\                  # Monika Monitoring
├─ node\                    # Node.js
├─ npm\                     # Node Package Manager
├─ npp\                     # Notepad++
├─ Office\                  # Office Tools
├─ ollama\                  # Ollama LLM Runner
├─ portable\                # Portable Applications
├─ PuTTY\                   # SSH Client
├─ pwsh\                    # PowerShell 7
├─ python\                  # Python (Latest)
├─ python-3.12\             # Python 3.12
├─ rclone\                  # Cloud Storage Sync
├─ SteamCMD\                # Steam Command Line
├─ Telegram\                # Telegram Desktop
├─ vscode\                  # Visual Studio Code
├─ WinFsp\                  # Windows File System Proxy
├─ winscp\                  # WinSCP File Transfer
└─ WT\                      # Windows Terminal
```

### 2. Root-Server (carpu.carpuncle.eu)

**Speicher**:
- 3 TB Disk → Hauptdaten
- 500 GB Disk → Cache / Snapshots

**Funktionen**:
- Lana Core (Haupt-KI-Logik)
- Netcup API Integration
- DNS Management
- SSH Trust Anchor
- Storage Sync Zentrale
- Backup & Recovery

### 3. VPS (carpuncle.eu)

**Betriebssystem**: Windows Server 2025

**Funktionen**:
- Windows-Server-Anwendungen
- RDP-Zugriff
- Datenbank-Server
- Anwendungs-Hosting

### 4. Webhosting

**Domains**:
- `lana-ki.de` - Frontend & Benutzer-Interface
- `carpuncle.eu` - API & Dokumentation
- `carpucloud.de` - Status Dashboard & Admin

## 🔐 Identitäts- und Zugriffsmanagement

### Benutzerkonten

#### Primärer Benutzer
- **Lokaler Windows-Benutzer**: `carpu`
- **Lokales Passwort**: `Beatom&2007`
- **Automatischer Login**: Ja (passwortlos)

#### Cloud-Identitäten
1. **Business-Konto**
   - Email: `carpu@carpuncle.eu`
   - Verwendung: Cloud, Azure, Server-Governance, RBAC, Copilot Agents
   - OneDrive Business + SharePoint

2. **Privatkonto**
   - Email: `carpuncle-pc@live.de`
   - Verwendung: OS-Zugriff, persönliche Dienste
   - OneDrive Personal

**Wichtig**: Beide Konten werden auf den lokalen Benutzer `carpu` gemappt.

### Authentifizierung

#### SSH-Schlüssel (Passwortlos)
- **Private Key**: `~/.ssh/id_rsa`
- **Public Key**: `~/.ssh/id_rsa.pub`
- **Verwendung**: Alle Server-Verbindungen
- **Konfiguration**: `~/.ssh/config`

#### 2-Faktor-Authentifizierung
- **Tool**: RoboForm
- **Verwendung**: 
  - Netcup CCP
  - Microsoft-Konten (beide)
  - Google Cloud
  - Alle Online-Dienste

### Zugriffsstrategie

```
Windows Login (lokal, passwortlos)
    ↓
Benutzer: carpu
    ↓
    ├─→ OneDrive Business (carpu@carpuncle.eu)
    ├─→ OneDrive Personal (carpuncle-pc@live.de)
    ├─→ SSH → Root-Server (passwortlos)
    ├─→ SSH → VPS (passwortlos)
    └─→ Azure Cloud (SSO)
```

## 💾 Storage-Strategie

### Lokaler Speicher (Windows)

#### Hauptlaufwerk C:\
- **Typ**: Großes Volume (RAID-0 empfohlen)
- **Verwendung**: System und Programme
- **User-Profil**: `C:\Users\carpu`

#### Dev-Drive T:\
- **Typ**: ReFS (Resilient File System)
- **Größe**: Nach Verfügbarkeit
- **Verwendung**: Entwicklung, Tools, Cache
- **Hauptverzeichnis**: `T:\Carpuncle`

**Empfehlung**: ReFS für bessere Performance und Zuverlässigkeit bei Entwicklungsarbeiten.

### OneDrive-Integration

#### OneDrive Business
- **Pfad**: `T:\OneDrive-Business` (empfohlen)
- **Konto**: carpu@carpuncle.eu
- **Features**: SharePoint-Anbindung
- **Synchronisation**: Selektiv (nur wichtige Ordner)

#### OneDrive Personal
- **Pfad**: `T:\OneDrive-Personal` (empfohlen)
- **Konto**: carpuncle-pc@live.de
- **Synchronisation**: Selektiv

**Wichtig**: 
- ❌ **NICHT** synchronisieren: `Tools\`, `Cache\`, `Logs\`
- ✅ **Synchronisieren**: Nur wichtige Projektdaten und Dokumente

### Remote Storage

#### Root-Server Storage Spaces
- **Disk 1**: 256 GB (Storage Space)
- **Disk 2**: 256 GB (Storage Space)
- **Verwendung**: 
  - Backup
  - Offsite-Sync
  - Archivierung
  - Log-Aggregation

### Zugriffskonflikte vermeiden

**Regel**: Automatische Ordner-Synchronisation für Dev-Ordner **DEAKTIVIEREN**

```powershell
# OneDrive-Sync für bestimmte Ordner pausieren
# Tools, Cache und temporäre Dateien NICHT synchronisieren
```

## 🌐 Netzwerk & Server-Integration

### SSH-Konfiguration

Die Datei `~/.ssh/config` wird automatisch erstellt:

```ssh
# Root Server
Host root-server carpu.carpuncle.eu
    HostName <IP oder Hostname>
    User carpu
    Port 22
    IdentityFile ~/.ssh/id_rsa
    ServerAliveInterval 60

# VPS Server
Host vps-server carpuncle.eu
    HostName <IP oder Hostname>
    User carpu
    Port 22
    IdentityFile ~/.ssh/id_rsa
    ServerAliveInterval 60
```

### Schnellzugriff

```bash
# Root-Server verbinden
ssh root-server

# VPS verbinden
ssh vps-server

# FTP-Zugriff (mit WinSCP)
# Verwendet SSH-Keys automatisch
```

### VLAN-Verbindung

**Netcup VLAN** zu den Servern:
- VPN/VLAN-Konfiguration über Netcup CCP
- Direkter privater Netzwerkzugang
- Geringere Latenz, höhere Sicherheit

### Netcup CCP Integration

**Zugriff**: 2FA über RoboForm erforderlich

**Funktionen**:
- Server-Management
- DNS-Konfiguration
- Backup-Verwaltung
- Storage-Management
- VLAN/VPN-Einstellungen

## 🖥️ Windows Terminal Integration

### Konfiguration

**Settings.json Pfad**:
```
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
```

### Profile einrichten

1. **PowerShell 7 (Standard)**
   - Startverzeichnis: `T:\Carpuncle`
   - Integration mit Lana Chat-API
   
2. **Git Bash**
   - Für Linux-ähnliche Befehle
   
3. **SSH-Profile**
   - Direkte Verbindungen zu Servern
   
4. **Azure Cloud Shell**
   - Integrierter Cloud-Zugriff

### Chat-API-Funktionen

Integration von GitHub Copilot Chat in Windows Terminal:

```powershell
# Lana Chat-Kommando
lana "Problem beschreibung"

# Automatische Problemlösung
lana-fix

# Copilot Integration
copilot chat
```

## 🤖 Copilot Integration

### GitHub Copilot Business

**Konto**: carpu@carpuncle.eu

**Features**:
- Code-Vervollständigung
- Chat-Integration
- Agents auf SharePoint
- Code-Reviews
- Dokumentations-Generierung

### GitHub Copilot Pro

**Konto**: carpuncle-pc@live.de

**Features**:
- Persönliche Entwicklung
- Private Repositories
- Erweiterte Code-Vorschläge

### Zusammenarbeit

Beide Copilot-Konten arbeiten harmonisch auf dem User `carpu`:

```
User: carpu
├─ Copilot Business (carpu@carpuncle.eu)
│  └─ SharePoint Agents
│  └─ Team-Entwicklung
│
└─ Copilot Pro (carpuncle-pc@live.de)
   └─ Persönliche Projekte
   └─ Private Repositories
```

### Copilot Agents auf SharePoint

**Verwendung**:
- Automatische Code-Reviews auf SharePoint-Seiten
- Dokumentations-Agents
- Workflow-Automatisierung
- Team-Kollaboration

## 🧠 Lana AI-Assistentin

### Überblick

Lana ist die zentrale KI-Assistentin des Carpuncle-Systems.

### Komponenten

#### 1. Lana Client (Windows Terminal + Desktop)
- Terminal-Chat-Interface
- Sprachintegration
- Visuelles Interface (geplant)
- Automatische Problemerkennung

#### 2. Lana Core (Root-Server)
- Haupt-KI-Logik
- Modell-Hosting
- Zentrale Datenverarbeitung
- Synchronisation

#### 3. Lana Recovery (EFI/PE)
- EFI-Boot-Integration
- Windows PE Recovery
- System-Wiederherstellung
- Unabhängig vom Windows-Zustand

### Funktionen

#### Automatische Problemlösung

```powershell
# Problem im Terminal-Chat eingeben
lana "Python-Skript funktioniert nicht mehr"

# Lana analysiert automatisch:
# 1. Fehlermeldung lesen
# 2. Logs prüfen
# 3. Lösung suchen
# 4. Fix automatisch anwenden
# 5. Testen
# 6. Bestätigung
```

#### Self-Healing System

Lana überwacht kontinuierlich:
- System-Fehler
- Anwendungs-Crashes
- Netzwerk-Probleme
- Storage-Issues
- Performance-Probleme

Bei Problemen:
1. **Erkennung**: Automatische Fehler-Detektion
2. **Analyse**: Root-Cause-Analysis
3. **Lösung**: Automatische Behebung
4. **Dokumentation**: Log-Eintrag
5. **Lernen**: Verbesserung für zukünftige Fälle

### Visuelle Realisierung

**Ziel**: Realistische, visuelle KI-Präsenz

**Geplante Features**:
- Avatar-Interface
- Sprachausgabe
- Emotionale Reaktionen
- Kontext-bewusste Kommunikation

## 🚀 Setup & Installation

### Voraussetzungen

1. **Windows Enterprise** (empfohlen) oder Windows 10/11 Pro
2. **Administrator-Rechte**
3. **PowerShell 5.0 oder höher**
4. **Internetverbindung**
5. **Mindestens 500 GB freier Speicher** für T:\

### Automatische Installation

```powershell
# 1. Skript herunterladen
# 2. Als Administrator PowerShell öffnen
# 3. Skript ausführen:

.\Setup-CarpuncleLana.ps1

# Optional mit Parametern:
.\Setup-CarpuncleLana.ps1 -RootServerIP "123.45.67.89" -VPSServerIP "98.76.54.32"
```

### Was macht das Setup?

1. ✅ **Benutzer 'carpu' erstellen**
   - Mit lokalem Passwort
   - Als Administrator
   - Automatisches Login aktivieren

2. ✅ **Storage-Struktur erstellen**
   - `T:\Carpuncle\` Hauptverzeichnis
   - Alle Unterordner (Tools, SDKs, etc.)
   - Tools-Verzeichnisse

3. ✅ **SSH-Konfiguration**
   - SSH-Schlüsselpaar generieren
   - SSH-Config erstellen
   - Public Key anzeigen (für Server)

4. ✅ **Umgebungsvariablen**
   - CARPUNCLE_ROOT
   - CARPUNCLE_TOOLS
   - PATH erweitern

5. ✅ **Hinweise für manuelle Schritte**
   - OneDrive-Integration
   - Windows Terminal
   - RoboForm
   - Server-Konfiguration

### Nach dem Setup

1. **System neu starten** für automatisches Login
2. **SSH Public Key auf Servern installieren**
3. **OneDrive konfigurieren** (beide Konten)
4. **Windows Terminal einrichten**
5. **RoboForm installieren** und 2FA einrichten
6. **Azure-Deployment** mit `Deploy-AzureCarpuncle.ps1`
7. **Lana initialisieren**

## 📝 Tägliche Nutzung

### Typischer Workflow

```powershell
# 1. System startet automatisch als 'carpu'
# 2. Windows Terminal öffnet sich

# 3. Arbeitsverzeichnis ist bereits T:\Carpuncle
cd T:\Carpuncle

# 4. Server-Verbindung (passwortlos)
ssh root-server

# 5. Entwicklung starten
code .

# 6. Bei Problemen: Lana fragen
lana "Wie behebe ich diesen Build-Fehler?"

# 7. Automatisches Backup läuft im Hintergrund
```

### Wichtige Befehle

```powershell
# Server-Verbindungen
ssh root-server           # Root-Server
ssh vps-server           # VPS

# Azure
az login                 # Azure-Login
.\Deploy-AzureCarpuncle.ps1  # Azure-Deployment

# Lana
lana "frage"            # Lana fragen
lana-fix                # Automatische Problembehebung
lana-status             # System-Status

# Tools
gh repo list            # GitHub Repositories
code .                  # VS Code öffnen
git status              # Git Status
```

## 🔧 Fehlerbehebung

### Setup-Probleme

#### "Nicht als Administrator ausgeführt"
```powershell
# PowerShell als Administrator öffnen:
# Windows-Taste → "PowerShell" → Rechtsklick → "Als Administrator ausführen"
```

#### "T:\ existiert nicht"
```powershell
# Laufwerk T:\ muss existieren oder erstellt werden
# Option 1: Partition erstellen
# Option 2: Subst-Befehl verwenden (temporär):
subst T: C:\CarpuncleData
```

#### "SSH-Keygen nicht gefunden"
```powershell
# Git für Windows installieren oder
# OpenSSH Feature aktivieren:
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
```

### Verbindungsprobleme

#### Server nicht erreichbar
```powershell
# 1. Ping testen
ping carpu.carpuncle.eu

# 2. SSH-Port prüfen
Test-NetConnection -ComputerName carpu.carpuncle.eu -Port 22

# 3. SSH-Key prüfen
ssh-add -l
```

#### OneDrive-Sync-Probleme
```powershell
# OneDrive neu starten
taskkill /F /IM OneDrive.exe
Start-Process "$env:LOCALAPPDATA\Microsoft\OneDrive\OneDrive.exe"
```

## 🔐 Sicherheit

### Best Practices

1. ✅ **SSH-Keys schützen**
   - Private Keys niemals weitergeben
   - Regelmäßig rotieren
   - Mit Passphrase schützen (optional)

2. ✅ **2FA überall aktivieren**
   - Microsoft-Konten
   - Netcup CCP
   - Google Cloud
   - GitHub

3. ✅ **Backups**
   - Automatische Backups auf Root-Server
   - Offsite-Backups
   - Regelmäßig testen

4. ✅ **Updates**
   - Windows Updates
   - Tool-Updates
   - Server-Updates
   - Security Patches

### Zugriffskontrolle

- Lokaler Benutzer: Nur `carpu`
- Server: Nur SSH-Key-Authentifizierung
- Cloud: SSO mit 2FA
- Passwörter: In RoboForm gesichert

## 📊 Monitoring

### System-Überwachung

- **Azure Application Insights**: Cloud-Monitoring
- **Server-Logs**: Zentralisiert auf Root-Server
- **Lana-Monitoring**: Automatische Überwachung
- **Status-Dashboard**: carpucloud.de

### Metriken

- System-Performance
- Netzwerk-Latenz
- Storage-Nutzung
- Fehlerrate
- Backup-Status

## 🎯 Nächste Schritte

### Phase 1: Basis-Setup (aktuell)
- ✅ Setup-Skript erstellen
- ⏳ Ausführen und testen
- ⏳ Server konfigurieren

### Phase 2: Lana Integration
- ⏳ Lana Core entwickeln
- ⏳ Terminal-Integration
- ⏳ Automatische Problemlösung

### Phase 3: Visuelles Interface
- ⏳ Lana Avatar entwickeln
- ⏳ Desktop-Integration
- ⏳ Sprachsteuerung

### Phase 4: Erweiterungen
- ⏳ SharePoint Copilot Agents
- ⏳ Erweiterte Automatisierung
- ⏳ Team-Kollaboration

## 📞 Support & Kontakt

**Projekt-Inhaber**: Thomas Heckhoff  
**Email**: carpuncle-pc@live.de  
**GitHub**: [@Carpuncle-Lana](https://github.com/Carpuncle-Lana)  
**Organisation**: [carpunclede](https://github.com/carpunclede)

## 📚 Weitere Dokumentation

- [Implementierungsplan](IMPLEMENTATION_PLAN.md)
- [Azure Deployment](../Deploy-AzureCarpuncle.ps1)
- [GitHub Copilot Instructions](../.github/copilot-instructions.md)
- [README](../README.md)

---

*Letzte Aktualisierung: 2026-01-08*  
*Version: 1.0.0*  
*Ein Skript, eine Lösung – Carpuncle Lana System*
