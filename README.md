# 🧠 Carpuncle Lana System

[![Azure Deployment](https://github.com/Carpuncle-Lana/Carpuncle/workflows/Azure%20Carpuncle%20Cloud%20Deployment/badge.svg)](https://github.com/Carpuncle-Lana/Carpuncle/actions)
[![Security Scan](https://github.com/Carpuncle-Lana/Carpuncle/workflows/CodeQL/badge.svg)](https://github.com/Carpuncle-Lana/Carpuncle/security)

Willkommen bei **Carpuncle Lana** – Ein vollautomatisiertes System, das Windows, Server, Cloud-Storage und KI-Assistenz nahtlos und passwortlos integriert.

> **🚀 Ein Skript, eine Lösung** – Kopieren, Enter drücken, fertig!

## ⚡ Schnellstart - Ein-Klick-Installation

```powershell
# PowerShell als Administrator öffnen, dann:
.\Setup-CarpuncleLana.ps1
```

Das war's! Das System richtet automatisch ein:
- ✅ Benutzer `carpu` mit passwortlosem Login
- ✅ Vollständige Verzeichnisstruktur unter `T:\Carpuncle`
- ✅ SSH-Schlüssel für Server-Zugriff
- ✅ Integration mit Root-Server, VPS und Webhosting
- ✅ Lana KI-Assistentin Framework
- ✅ OneDrive Business + Personal Vorbereitung
- ✅ Windows Terminal Konfiguration

**➡️ [Ausführliche Schnellstart-Anleitung](SCHNELLSTART.md)**

## 🧠 Was ist Lana?

**Lana** ist die zentrale KI-Assistentin des Carpuncle-Systems:

- 🤖 **Automatische Problemlösung** – Problem im Terminal-Chat eingeben, Lana behebt es automatisch
- 🔄 **Self-Healing** – Erkennt und behebt System-Fehler selbstständig
- 🖥️ **Terminal-Integration** – Direkt im Windows Terminal verfügbar
- 🌐 **Multi-Server-Management** – Koordiniert Windows, Root-Server, VPS und Cloud
- 🔐 **Passwortlose Authentifizierung** – SSH-Keys für alle Server-Verbindungen

```powershell
# Lana verwenden
lana "Wie behebe ich diesen Build-Fehler?"
lana-fix                    # Automatische Problembehebung
lana-status                 # System-Status anzeigen
```

## 🎯 Systemarchitektur

```
┌──────────────────────────────────────────────────────────┐
│              CARPUNCLE LANA SYSTEM                       │
└──────────────────────────────────────────────────────────┘
                        │
        ┌───────────────┼───────────────┐
        ▼               ▼               ▼
   [Windows]      [Root Server]     [VPS]
   Enterprise     3TB + 500GB       Win 2025
   T:\Carpuncle   carpu.carpuncle   carpuncle.eu
        │               .eu               │
        └───────────────┴────────────────┘
                        │
                [Webhosting]
                lana-ki.de
                carpucloud.de
```

## 🚀 Features

### Vollautomatisches Setup
- **Ein Skript** für die komplette Konfiguration
- **Passwortloses Login** – Automatisch als Benutzer `carpu`
- **Dev-Drive Setup** – ReFS für optimale Performance
- **Tool-Integration** – Alle Entwicklungstools vorinstalliert

### Multi-Account Integration
- **Business**: carpu@carpuncle.eu (Copilot Business, Azure, SharePoint)
- **Personal**: carpuncle-pc@live.de (Copilot Pro, OneDrive)
- **Harmonische Zusammenarbeit** – Beide Konten auf User `carpu`

### Server-Integration
- **Root-Server** – 3TB Hauptdaten + 500GB Cache/Snapshots
- **VPS** – Windows Server 2025 für Anwendungen
- **Webhosting** – lana-ki.de, carpuncle.eu, carpucloud.de
- **VLAN** – Direkte Netcup-Verbindung

### Lana AI-Assistentin
- **Chat-API** im Windows Terminal
- **Automatische Fehlerbehandlung**
- **System-Überwachung**
- **Recovery-System** (EFI/PE Integration)

## 📦 Projekte

- **Carpuncle-Cloud**: Azure-basierte Infrastruktur mit Dashboard
- **Lana-Core**: KI-Module für Lana (selbstlernende KI-Assistenz)
- **dotnet**: Backend-Services in .NET

## 🔐 Technologien

- PowerShell 7 & Azure CLI
- Node.js, Python, Go, .NET
- GitHub Actions & GitHub Copilot (Business + Pro)
- Microsoft Graph API
- SSH-Key-basierte Authentifizierung
- RoboForm 2FA Integration

## 📦 Verfügbare Skripte

| Skript | Beschreibung |
|--------|-------------|
| `Setup-CarpuncleLana.ps1` | **Haupt-Setup** – Richtet das komplette System ein |
| `Initialize-LanaFramework.ps1` | **Lana Framework** – Initialisiert Lana AI-Assistentin |
| `Connect-CarpuncleServers.ps1` | **Server-Manager** – Verbindung zu Root-Server, VPS, Webhosting |
| `Deploy-AzureCarpuncle.ps1` | **Azure Deployment** – Deployed Cloud-Infrastruktur |

## 📚 Dokumentation

- 🚀 **[Schnellstart-Anleitung](SCHNELLSTART.md)** – Sofort loslegen!
- 📖 **[Vollständige Systemdokumentation](docs/CARPUNCLE_LANA_SYSTEM.md)** – Architektur, Konfiguration, Nutzung
- 📋 **[Implementierungsplan](docs/IMPLEMENTATION_PLAN.md)** – 6-Phasen-Strategie
- ⚙️ **[GitHub Copilot Instructions](.github/copilot-instructions.md)** – Copilot-Konfiguration

## 🔧 Tägliche Nutzung

```powershell
# Server-Verbindungen (passwortlos)
ssh root-server             # Root-Server
ssh vps-server             # VPS

# Lana AI-Assistentin
lana "Problem beschreibung"
lana-fix

# Azure Management
.\Deploy-AzureCarpuncle.ps1 -Environment prod

# Server-Status prüfen
.\Connect-CarpuncleServers.ps1 -Action Test -ServerType All
```

## 🧭 Organisationsstruktur

| Bereich | Inhalt |
|--------|--------|
| **Enterprise** | `carpuncle` - Übergeordnete Verwaltungseinheit |
| **Organisation** | `carpunclede` - Technische Repos (Carpuncle-Cloud, dotnet, lana-core) |
| **Benutzer** | `Carpuncle-Lana` - Persönliches Profil für kreative & operative Aufgaben |
| **Teams** | DevOps, KI, Frontend, Security - mit Rollen & Rechten |

## 👥 Kontakt

**Inhaber**: Thomas Heckhoff  
**Email**: carpuncle-pc@live.de  
**GitHub**: [@Carpuncle-Lana](https://github.com/Carpuncle-Lana)

---

# GitHub CLI

`gh` is GitHub on the command line. It brings pull requests, issues, and other GitHub concepts to the terminal next to where you are already working with `git` and your code.

![screenshot of gh pr status](https://user-images.githubusercontent.com/98482/84171218-327e7a80-aa40-11ea-8cd1-5177fc2d0e72.png)

GitHub CLI is supported for users on GitHub.com, GitHub Enterprise Cloud, and GitHub Enterprise Server 2.20+ with support for macOS, Windows, and Linux.

## Documentation

For [installation options see below](#installation), for usage instructions [see the manual]( https://cli.github.com/manual/).

## Contributing

If anything feels off or if you feel that some functionality is missing, please check out the [contributing page](.github/CONTRIBUTING.md). There you will find instructions for sharing your feedback, building the tool locally, and submitting pull requests to the project.

If you are a hubber and are interested in shipping new commands for the CLI, check out our [doc on internal contributions](docs/working-with-us.md)

<!-- this anchor is linked to from elsewhere, so avoid renaming it -->
## Installation

### [macOS](docs/install_macos.md)

- [Homebrew](docs/install_macos.md#homebrew)
- [Precompiled binaries](docs/install_macos.md#precompiled-binaries) on [releases page][]

For additional macOS packages and installers, see [community-supported docs](docs/install_macos.md#community-unofficial)

### [Linux & Unix](docs/install_linux.md)

- [Debian, Raspberry Pi, Ubuntu](docs/install_linux.md#debian)
- [Amazon Linux, CentOS, Fedora, openSUSE, RHEL, SUSE](docs/install_linux.md#rpm)
- [Precompiled binaries](docs/install_linux.md#precompiled-binaries) on [releases page][]

For additional Linux & Unix packages and installers, see [community-supported docs](docs/install_linux.md#community-unofficial)

### [Windows](docs/install_windows.md)

- [WinGet](docs/install_windows.md#winget)
- [Precompiled binaries](docs/install_windows.md#precompiled-binaries) on [releases page][]

For additional Windows packages and installers, see [community-supported docs](docs/install_windows.md#community-unofficial)

### Build from source

See here on how to [build GitHub CLI from source](docs/install_source.md).

### GitHub Codespaces

To add GitHub CLI to your codespace, add the following to your [devcontainer file](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-features-to-a-devcontainer-file):

```json
"features": {
  "ghcr.io/devcontainers/features/github-cli:1": {}
}
```

### GitHub Actions

[GitHub-hosted runners](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners) have the GitHub CLI pre-installed, which is updated weekly.

If a specific version is needed, your GitHub Actions workflow will need to install it based on the [macOS](#macos), [Linux & Unix](#linux--unix), or [Windows](#windows) instructions above.

For information on all pre-installed tools, see [`actions/runner-images`](https://github.com/actions/runner-images)

### Verification of binaries

Since version 2.50.0, `gh` has been producing [Build Provenance Attestation](https://github.blog/changelog/2024-06-25-artifact-attestations-is-generally-available/), enabling a cryptographically verifiable paper-trail back to the origin GitHub repository, git revision, and build instructions used. The build provenance attestations are signed and rely on Public Good [Sigstore](https://www.sigstore.dev/) for PKI.

There are two common ways to verify a downloaded release, depending on whether `gh` is already installed or not. If `gh` is installed, it's trivial to verify a new release:

- **Option 1: Using `gh` if already installed:**

  ```shell
  $ gh at verify -R cli/cli gh_2.62.0_macOS_arm64.zip
  Loaded digest sha256:fdb77f31b8a6dd23c3fd858758d692a45f7fc76383e37d475bdcae038df92afc for file://gh_2.62.0_macOS_arm64.zip
  Loaded 1 attestation from GitHub API
  ✓ Verification succeeded!

  sha256:fdb77f31b8a6dd23c3fd858758d692a45f7fc76383e37d475bdcae038df92afc was attested by:
  REPO     PREDICATE_TYPE                  WORKFLOW
  cli/cli  https://slsa.dev/provenance/v1  .github/workflows/deployment.yml@refs/heads/trunk
  ```

- **Option 2: Using Sigstore [`cosign`](https://github.com/sigstore/cosign):**

  To perform this, download the [attestation](https://github.com/cli/cli/attestations) for the downloaded release and use cosign to verify the authenticity of the downloaded release:

  ```shell
  $ cosign verify-blob-attestation --bundle cli-cli-attestation-3120304.sigstore.json \
        --new-bundle-format \
        --certificate-oidc-issuer="https://token.actions.githubusercontent.com" \
        --certificate-identity="https://github.com/cli/cli/.github/workflows/deployment.yml@refs/heads/trunk" \
        gh_2.62.0_macOS_arm64.zip
  Verified OK
  ```

## Comparison with hub

For many years, [hub](https://github.com/github/hub) was the unofficial GitHub CLI tool. `gh` is a new project that helps us explore
what an official GitHub CLI tool can look like with a fundamentally different design. While both
tools bring GitHub to the terminal, `hub` behaves as a proxy to `git`, and `gh` is a standalone
tool. Check out our [more detailed explanation](docs/gh-vs-hub.md) to learn more.

[releases page]: https://github.com/cli/cli/releases/latest
