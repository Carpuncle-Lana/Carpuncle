# 🔐 RoboForm und 2FA Integration - Konfigurationsanleitung

## Überblick

Diese Anleitung beschreibt die Einrichtung von RoboForm als Passwort-Manager und 2-Faktor-Authentifizierung (2FA) für das Carpuncle Lana System.

## 🎯 Warum RoboForm?

RoboForm wird als zentraler Passwort-Manager verwendet für:
- ✅ Netcup CCP (Customer Control Panel)
- ✅ Microsoft-Konten (Business & Personal)
- ✅ Google Cloud
- ✅ GitHub
- ✅ Alle weiteren Online-Dienste

**Wichtig**: RoboForm speichert auch die 2FA-Codes (TOTP), sodass Login-Vorgänge vollautomatisch ablaufen können.

## 📥 Installation

### 1. RoboForm herunterladen

**Windows Desktop-Anwendung**:
- Download: https://www.roboform.com/download
- Version: RoboForm für Windows (Desktop + Browser-Extension)

**Installation durchführen**:
```powershell
# Falls heruntergeladen nach:
# T:\Carpuncle\Tools\portable\RoboForm\

# Installation starten
.\RoboFormSetup.exe
```

### 2. RoboForm Account erstellen

1. RoboForm öffnen
2. "Neues Konto erstellen" wählen
3. **Master-Passwort** festlegen (WICHTIG: Sicher aufbewahren!)
4. Optional: RoboForm Everywhere aktivieren (Cloud-Sync)

## 🔑 Passwort-Management

### Wichtige Passwörter speichern

#### Windows Lokal
```
Name: Windows - Benutzer carpu
URL: -
Benutzername: carpu
Passwort: [Ihr lokales Passwort - siehe Setup-Skript]
Notizen: Lokaler Windows-Benutzer, automatisches Login aktiviert
         HINWEIS: Passwort aus Setup-CarpuncleLana.ps1 übernehmen
```

#### Microsoft Business
```
Name: Microsoft 365 Business
URL: https://portal.office.com
Benutzername: carpu@carpuncle.eu
Passwort: [Ihr Business-Passwort]
2FA: [Wird automatisch von RoboForm verwaltet]
Notizen: OneDrive Business, SharePoint, Copilot Business
```

#### Microsoft Personal
```
Name: Microsoft Personal
URL: https://account.microsoft.com
Benutzername: carpuncle-pc@live.de
Passwort: [Ihr Personal-Passwort]
2FA: [Wird automatisch von RoboForm verwaltet]
Notizen: OneDrive Personal, Copilot Pro
```

#### Netcup CCP
```
Name: Netcup CCP
URL: https://www.customercontrolpanel.de
Benutzername: [Ihre Netcup Kundennummer]
Passwort: [Ihr Netcup-Passwort]
2FA: [TOTP in RoboForm speichern]
Notizen: Server-Management, DNS, Storage
```

#### Root-Server
```
Name: Root-Server SSH
URL: ssh://carpu.carpuncle.eu
Benutzername: carpu
Passwort: -
SSH Key: T:\Users\carpu\.ssh\id_rsa
Notizen: SSH-Key-Authentifizierung, kein Passwort
```

#### VPS
```
Name: VPS SSH
URL: ssh://carpuncle.eu
Benutzername: carpu
Passwort: -
SSH Key: T:\Users\carpu\.ssh\id_rsa
Notizen: Windows Server 2025, SSH-Key-Authentifizierung
```

#### GitHub
```
Name: GitHub
URL: https://github.com
Benutzername: Carpuncle-Lana (oder Isychan1)
Passwort: [Ihr GitHub-Passwort]
2FA: [TOTP in RoboForm speichern]
Notizen: Repository-Management, GitHub Actions
```

#### Azure
```
Name: Azure Portal
URL: https://portal.azure.com
Benutzername: carpu@carpuncle.eu
Passwort: [Siehe Microsoft Business]
2FA: [Siehe Microsoft Business]
Notizen: Verwendet Microsoft Business Account
```

## 🔐 2FA (TOTP) Einrichtung

### Was ist TOTP?

TOTP (Time-based One-Time Password) generiert zeitbasierte 6-stellige Codes für zusätzliche Sicherheit.

### RoboForm als Authenticator verwenden

RoboForm kann TOTP-Codes speichern und automatisch ausfüllen!

#### Schritt-für-Schritt: 2FA mit RoboForm

**Beispiel: Netcup CCP 2FA einrichten**

1. **Bei Netcup anmelden** und zu Sicherheitseinstellungen navigieren
2. **2FA aktivieren** wählen
3. **QR-Code wird angezeigt**
4. **In RoboForm**:
   - Passwort-Eintrag für Netcup öffnen
   - "Authenticator hinzufügen" klicken
   - QR-Code scannen ODER Secret-Key manuell eingeben
5. **Bestätigungs-Code** aus RoboForm kopieren und bei Netcup eingeben
6. **Backup-Codes** speichern (in RoboForm-Notizen)

**Das war's!** Ab jetzt füllt RoboForm Login UND 2FA-Code automatisch aus.

### 2FA für alle Dienste aktivieren

#### Microsoft-Konten (beide)

1. https://account.microsoft.com/security
2. "Erweiterte Sicherheitsoptionen"
3. "Zweistufige Überprüfung einrichten"
4. QR-Code mit RoboForm erfassen
5. Im RoboForm-Eintrag "Microsoft Business/Personal" speichern

#### Netcup CCP

1. https://www.customercontrolpanel.de
2. Login → Profil → Sicherheit
3. "Zwei-Faktor-Authentifizierung"
4. QR-Code mit RoboForm erfassen

#### GitHub

1. https://github.com/settings/security
2. "Two-factor authentication" → "Enable"
3. "Use an app" wählen
4. QR-Code mit RoboForm erfassen
5. Recovery Codes in RoboForm-Notizen speichern

#### Google Cloud

1. https://myaccount.google.com/security
2. "2-Step Verification" → "Get started"
3. Authenticator App wählen
4. QR-Code mit RoboForm erfassen

## 🌐 Browser-Integration

### RoboForm Browser-Extension

**Unterstützte Browser**:
- Chrome / Edge (Chromium)
- Firefox
- Safari

**Installation**:
1. Browser öffnen
2. Zu Extension-Store navigieren
3. "RoboForm" suchen und installieren
4. Mit RoboForm-Account anmelden

**Auto-Fill aktivieren**:
- RoboForm Extension → Einstellungen
- "Auto-Fill" aktivieren
- "Auto-Submit" aktivieren (optional, für vollautomatisches Login)

## 🔄 Synchronisation

### RoboForm Everywhere (Cloud-Sync)

**Empfohlen**: RoboForm Everywhere für Sync zwischen Geräten

**Aktivierung**:
1. RoboForm öffnen
2. "RoboForm Everywhere" → "Upgrade"
3. Nach Upgrade: Automatische Synchronisation aktiv

**Vorteile**:
- ✅ Passwörter auf allen Geräten verfügbar
- ✅ Automatische Backups
- ✅ Wiederherstellung bei Verlust

## 📱 Mobile Integration (Optional)

**RoboForm auf Smartphone**:
1. App Store / Google Play: "RoboForm" herunterladen
2. Mit gleichem Account anmelden
3. Passwörter und 2FA-Codes auch mobil verfügbar

## 🔒 Sicherheit

### Best Practices

1. **Master-Passwort**: 
   - Mindestens 16 Zeichen
   - Buchstaben, Zahlen, Sonderzeichen
   - Nirgendwo digital speichern!

2. **Backup-Codes speichern**:
   - Alle 2FA-Backup-Codes in RoboForm-Notizen
   - Zusätzlich offline ausdrucken und sicher aufbewahren

3. **Regelmäßige Updates**:
   - RoboForm automatisch updaten lassen
   - Passwörter regelmäßig ändern

4. **RoboForm-Account absichern**:
   - Master-Passwort nie weitergeben
   - Computer-Zugriff schützen (Benutzer carpu ist bereits gesichert)

### Notfall-Zugriff

**Falls Master-Passwort vergessen**:
- RoboForm Everywhere: Email-Recovery möglich
- Lokale Installation: Backup-Datei verwenden

**Backup erstellen**:
```
RoboForm → Optionen → Backup → Backup erstellen
Speicherort: T:\Carpuncle\Logs\RoboForm-Backup\
```

## 🚀 Automatisierung mit PowerShell

### RoboForm via CLI ansprechen (Erweitert)

RoboForm bietet begrenzte CLI-Funktionalität:

```powershell
# RoboForm-Pfad
$roboformPath = "C:\Program Files (x86)\Siber Systems\AI RoboForm\RoboForm.exe"

# Passwort-Center öffnen
& $roboformPath /SHOW

# Login zu bestimmter Seite (falls gespeichert)
& $roboformPath /OPEN="Netcup CCP"
```

**Hinweis**: Vollautomatische Logins funktionieren am besten über Browser-Extension.

## 📋 Checkliste: 2FA-Einrichtung

- [ ] RoboForm installiert
- [ ] Master-Passwort festgelegt
- [ ] Browser-Extension installiert
- [ ] Microsoft Business 2FA eingerichtet
- [ ] Microsoft Personal 2FA eingerichtet
- [ ] Netcup CCP 2FA eingerichtet
- [ ] GitHub 2FA eingerichtet
- [ ] Google Cloud 2FA eingerichtet (falls verwendet)
- [ ] Alle Backup-Codes gespeichert
- [ ] RoboForm Everywhere aktiviert (optional)
- [ ] Backup erstellt

## 🎯 Integration mit Carpuncle Lana

### Lana + RoboForm

Zukünftig kann Lana mit RoboForm interagieren für:
- Automatisches Login bei Server-Problemen
- Credential-Management
- Passwort-Rotation
- Security-Audits

**Vorerst**: RoboForm manuell verwenden, bis Lana-Integration implementiert ist.

## 📞 Support

**RoboForm Support**:
- Website: https://www.roboform.com/support
- Dokumentation: https://www.roboform.com/manual

**Carpuncle Support**:
- GitHub Issues: https://github.com/Isychan1/Carpuncle/issues
- Email: carpuncle-pc@live.de

## 🔗 Nützliche Links

- RoboForm Download: https://www.roboform.com/download
- RoboForm Manual: https://www.roboform.com/manual
- Microsoft 2FA: https://support.microsoft.com/en-us/account-billing/how-to-use-two-step-verification-with-your-microsoft-account-c7910146-672f-01e9-50a0-93b4585e7eb4
- GitHub 2FA: https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa
- Netcup 2FA: https://www.netcup-wiki.de/wiki/Zwei-Faktor-Authentifizierung

---

*Letzte Aktualisierung: 2026-01-08*  
*Mit RoboForm: Sicher, automatisch, integriert.*
