# 🚀 Schnellstart-Anleitung - Carpuncle Lana System

## ⚡ Ein-Klick-Setup

Das Carpuncle Lana System kann mit einem einzigen PowerShell-Befehl vollautomatisch eingerichtet werden.

### Voraussetzungen

- ✅ Windows 10/11 oder Windows Server
- ✅ Administrator-Rechte
- ✅ PowerShell 5.0+
- ✅ Mindestens 500 GB freier Speicher auf T:\ (oder alternativem Laufwerk)

### Installation

1. **PowerShell als Administrator öffnen**
   ```powershell
   # Windows-Taste drücken
   # "PowerShell" eingeben
   # Rechtsklick auf "Windows PowerShell"
   # "Als Administrator ausführen" wählen
   ```

2. **Skript herunterladen und ausführen**
   ```powershell
   # Repository klonen (wenn Git installiert ist)
   git clone https://github.com/Isychan1/Carpuncle.git
   cd Carpuncle
   
   # Haupt-Setup ausführen
   .\Setup-CarpuncleLana.ps1
   ```

   **Oder mit direktem Download:**
   ```powershell
   # Skript herunterladen
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Isychan1/Carpuncle/main/Setup-CarpuncleLana.ps1" -OutFile "Setup-CarpuncleLana.ps1"
   
   # Ausführen
   .\Setup-CarpuncleLana.ps1
   ```

3. **Fertig!** Das System richtet automatisch ein:
   - ✅ Benutzer `carpu` mit passwortlosem Login
   - ✅ Verzeichnisstruktur unter `T:\Carpuncle`
   - ✅ SSH-Schlüssel für Server-Zugriff
   - ✅ Umgebungsvariablen
   - ✅ Basis-Konfiguration

4. **System neu starten**
   ```powershell
   Restart-Computer
   ```

Nach dem Neustart:
- Windows loggt automatisch als Benutzer `carpu` ein
- Terminal öffnet sich im Carpuncle-Verzeichnis
- Lana AI-Assistentin ist einsatzbereit

## 📋 Nach dem Setup

### 1. Lana Framework initialisieren

```powershell
.\Initialize-LanaFramework.ps1
```

### 2. PowerShell-Profil konfigurieren

```powershell
# Profil öffnen
notepad $PROFILE

# Folgende Zeile hinzufügen:
. "T:\Carpuncle\Lana\Config\LanaProfile.ps1"

# Speichern und PowerShell neu starten
```

### 3. SSH-Keys auf Servern installieren

```powershell
# Anleitung anzeigen
.\Connect-CarpuncleServers.ps1 -Action InstallKey -ServerType All

# Oder für einzelnen Server
.\Connect-CarpuncleServers.ps1 -Action InstallKey -ServerType RootServer
```

### 4. Server-Verbindungen testen

```powershell
# Alle Server testen
.\Connect-CarpuncleServers.ps1 -Action Test -ServerType All

# Zu Server verbinden
.\Connect-CarpuncleServers.ps1 -Action Connect -ServerType RootServer
```

### 5. OneDrive einrichten

**OneDrive Business** (carpu@carpuncle.eu):
1. OneDrive Business installieren/anmelden
2. Sync-Ordner nach `T:\OneDrive-Business` verschieben
3. Selektive Synchronisation aktivieren (nur wichtige Ordner)

**OneDrive Personal** (carpuncle-pc@live.de):
1. OneDrive anmelden
2. Sync-Ordner nach `T:\OneDrive-Personal` verschieben
3. Selektive Synchronisation aktivieren

**Wichtig:** Tools, Cache und Logs NICHT synchronisieren!

### 6. Windows Terminal konfigurieren

1. Windows Terminal installieren (Microsoft Store)
2. Einstellungen öffnen (`Ctrl + ,`)
3. Standardprofil: PowerShell 7
4. Startverzeichnis: `T:\Carpuncle`

### 7. RoboForm für 2FA einrichten

1. RoboForm herunterladen und installieren
2. 2FA für folgende Dienste einrichten:
   - Netcup CCP
   - Microsoft-Konten (beide)
   - Google Cloud
   - GitHub

### 8. Azure Deployment

```powershell
# Azure einrichten
.\Deploy-AzureCarpuncle.ps1 -Environment dev -Location westeurope
```

## 🧠 Lana verwenden

Nach dem Setup ist Lana einsatzbereit:

```powershell
# Lana fragen
lana "Wie behebe ich diesen Build-Fehler?"

# Automatische Problembehebung
lana-fix

# System-Status anzeigen
lana-status
```

## 🖥️ Server-Verbindungen

### Schnellverbindungen (nach SSH-Config-Setup)

```bash
# Root-Server
ssh root-server

# VPS
ssh vps-server

# Mit WinSCP (grafisch)
T:\Carpuncle\Tools\winscp\WinSCP.exe
```

### Server-Informationen

```powershell
# Alle Server-Infos anzeigen
.\Connect-CarpuncleServers.ps1 -Action Info
```

## 📁 Verzeichnisstruktur

Nach dem Setup:

```
T:\Carpuncle\
├── Tools\              # Alle Entwicklungstools
│   ├── git\
│   ├── python\
│   ├── node\
│   ├── vscode\
│   └── ... (siehe Dokumentation)
│
├── SDKs\               # Software Development Kits
├── Lang\               # Sprachpakete
├── Models\             # KI-Modelle
├── Cache\              # Cache-Dateien
├── Logs\               # System-Logs
└── Lana\               # Lana AI-Framework
    ├── Core\           # Kern-Module
    ├── Modules\        # Erweiterungen
    ├── Config\         # Konfiguration
    └── ...
```

## 🔧 Häufige Probleme

### "T:\ existiert nicht"

```powershell
# Temporär mit subst:
subst T: C:\CarpuncleData

# Oder Partition T:\ erstellen
# (Datenträgerverwaltung → Neue Partition)
```

### "ssh-keygen nicht gefunden"

```powershell
# OpenSSH installieren:
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

# Oder Git für Windows installieren
```

### "Zugriff verweigert"

```powershell
# PowerShell als Administrator neu starten
# Rechtsklick auf PowerShell → "Als Administrator ausführen"
```

### Server nicht erreichbar

```powershell
# Verbindung testen
.\Connect-CarpuncleServers.ps1 -Action Test -ServerType RootServer

# Firewall/VPN prüfen
```

## 📚 Vollständige Dokumentation

- **Systemarchitektur**: [docs/CARPUNCLE_LANA_SYSTEM.md](docs/CARPUNCLE_LANA_SYSTEM.md)
- **Implementierungsplan**: [docs/IMPLEMENTATION_PLAN.md](docs/IMPLEMENTATION_PLAN.md)
- **GitHub Copilot**: [.github/copilot-instructions.md](.github/copilot-instructions.md)

## 🆘 Support

**Bei Problemen oder Fragen:**
- GitHub Issues: https://github.com/Isychan1/Carpuncle/issues
- Email: carpuncle-pc@live.de
- GitHub: [@Carpuncle-Lana](https://github.com/Carpuncle-Lana)

## 🎯 Nächste Schritte nach Installation

1. ✅ System neu starten
2. ✅ Lana Framework initialisieren
3. ✅ SSH-Keys auf Servern installieren
4. ✅ OneDrive einrichten
5. ✅ Windows Terminal konfigurieren
6. ✅ RoboForm einrichten
7. ✅ Azure deployen
8. 🎉 Loslegen mit Entwicklung!

---

**Willkommen im Carpuncle Lana System! 🧠**

*Ein Skript, eine Lösung – vollautomatisiert und integriert.*
