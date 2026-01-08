# ⚙️ Konfigurationsdateien

Dieses Verzeichnis enthält Template-Konfigurationsdateien für das Carpuncle Lana System.

## 📁 Inhalt

### windows-terminal-settings.json

**Beschreibung**: Vorkonfigurierte Windows Terminal Einstellungen

**Verwendung**:
```powershell
# Aktuelles Settings-Backup erstellen
Copy-Item "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" `
          "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json.backup"

# Carpuncle Settings kopieren
Copy-Item ".\config\windows-terminal-settings.json" `
          "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# Windows Terminal neu starten
```

**Features**:
- ✅ Carpuncle PowerShell als Standard-Profil
- ✅ Lana automatisch beim Start geladen
- ✅ SSH-Profile für Root-Server und VPS
- ✅ Carpuncle Dark & Light Farbschemas
- ✅ Optimierte Tastenkombinationen
- ✅ Startverzeichnis: T:\Carpuncle

**Hinweis**: Pfade müssen ggf. angepasst werden, wenn Tools woanders installiert sind.

## 🎨 Farbschemas

### Carpuncle Dark (Standard)
- Dunkler Hintergrund (#0C0C0C)
- Optimiert für lange Coding-Sessions
- Reduzierte Augenbelastung

### Carpuncle Light
- Heller Hintergrund (#FFFFFF)
- Für gut beleuchtete Umgebungen
- Hoher Kontrast für Lesbarkeit

## 🔧 Anpassungen

### Eigene Profile hinzufügen

Öffne `windows-terminal-settings.json` und füge unter `profiles.list` hinzu:

```json
{
    "guid": "{NEUE-GUID-HIER}",
    "name": "Mein Profil",
    "commandline": "pwsh.exe",
    "startingDirectory": "T:\\MeinPfad",
    "colorScheme": "Carpuncle Dark"
}
```

**GUID generieren** in PowerShell:
```powershell
[guid]::NewGuid().ToString()
```

### Weitere SSH-Server hinzufügen

```json
{
    "guid": "{NEUE-GUID}",
    "name": "SSH → Mein Server",
    "commandline": "pwsh.exe -NoExit -Command ssh mein-server",
    "tabTitle": "📡 Mein Server"
}
```

## 📚 Weitere Dokumentation

- [Windows Terminal Dokumentation](https://docs.microsoft.com/en-us/windows/terminal/)
- [Carpuncle Lana System](../docs/CARPUNCLE_LANA_SYSTEM.md)
- [Schnellstart](../SCHNELLSTART.md)

## 🆘 Probleme?

**Terminal startet nicht**:
- Settings.json auf Syntax-Fehler prüfen
- Backup wiederherstellen: `.backup` Datei umbenennen

**Profile erscheinen nicht**:
- Windows Terminal neu starten
- Pfade in den Profilen überprüfen

**Lana lädt nicht**:
- `$env:CARPUNCLE_ROOT` Umgebungsvariable prüfen
- Lana-Framework mit `Initialize-LanaFramework.ps1` initialisieren

---

*Template-Dateien für schnelle Einrichtung – Anpassen nach Bedarf!*
