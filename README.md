# GitHub CLI

`gh` is GitHub on the command line. It brings pull requests, issues, and other GitHub concepts to the terminal next to where you are already working with `git` and your code.

![screenshot of gh pr status](https://user-images.githubusercontent.com/98482/84171218-327e7a80-aa40-11ea-8cd1-5177fc2d0e72.png)

GitHub CLI is available for repositories hosted on GitHub.com and GitHub Enterprise Server 2.20+, and to install on macOS, Windows, and Linux.

## Documentation

[See the manual][manual] for setup and usage instructions.

## Contributing

If anything feels off, or if you feel that some functionality is missing, please check out the [contributing page][contributing]. There you will find instructions for sharing your feedback, building the tool locally, and submitting pull requests to the project.


<!-- this anchor is linked to from elsewhere, so avoid renaming it -->
## Installation

### macOS

`gh` is available via [Homebrew][], [MacPorts][], and as a downloadable binary from the [releases page][].

#### Homebrew

| Install:          | Upgrade:          |
| ----------------- | ----------------- |
| `brew install gh` | `brew upgrade gh` |

#### MacPorts

| Install:               | Upgrade:                                       |
| ---------------------- | ---------------------------------------------- |
| `sudo port install gh` | `sudo port selfupdate && sudo port upgrade gh` |

### Linux

`gh` is available via [Homebrew](#homebrew), and as downloadable binaries from the [releases page][].

For more information and distro-specific instructions, see the [Linux installation docs](./docs/install_linux.md).

### Windows

`gh` is available via [WinGet][], [scoop][], [Chocolatey][], and as downloadable MSI.


#### WinGet

| Install:            | Upgrade:            |
| ------------------- | --------------------|
| `winget install gh` | `winget install gh` |

<i>WinGet does not have a specialized `upgrade` command yet, but the `install` command should work for upgrading to a newer version of GitHub CLI.</i>

#### scoop

| Install:           | Upgrade:           |
| ------------------ | ------------------ |
| `scoop install gh` | `scoop update gh`  |

#### Chocolatey

| Install:           | Upgrade:           |
| ------------------ | ------------------ |
| `choco install gh` | `choco upgrade gh` |

#### Signed MSI

MSI installers are available for download on the [releases page][].

### Other platforms

Download packaged binaries from the [releases page][].

### Build from source

See here on how to [build GitHub CLI from source][build from source].

## Comparison with hub

For many years, [hub][] was the unofficial GitHub CLI tool. `gh` is a new project that helps us explore
what an official GitHub CLI tool can look like with a fundamentally different design. While both
tools bring GitHub to the terminal, `hub` behaves as a proxy to `git`, and `gh` is a standalone
tool. Check out our [more detailed explanation][gh-vs-hub] to learn more.


[manual]: https://cli.github.com/manual/
[Homebrew]: https://brew.sh
[MacPorts]: https://www.macports.org
[winget]: https://github.com/microsoft/winget-cli
[scoop]: https://scoop.sh
[Chocolatey]: https://chocolatey.org
[releases page]: https://github.com/cli/cli/releases/latest
[hub]: https://github.com/github/hub
[contributing]: ./.github/CONTRIBUTING.md
[gh-vs-hub]: ./docs/gh-vs-hub.md
[build from source]: ./docs/source.mdJa, es gibt verschiedene Möglichkeiten, wie KI-Agenten, einschließlich mir als KI-Modell, mit Gemini auf Google Cloud zusammenarbeiten können.

**Gemini ist das zugrunde liegende KI-Modell**, das Google Cloud in vielen seiner generativen KI-Angebote verwendet. Hier sind die Hauptansatzpunkte für eine Zusammenarbeit:

1.  **AI Agenten-Modus in Entwicklungsumgebungen (IDEs):**
    *   Gemini Code Assist bietet einen "Agenten-Modus" in Entwicklungsumgebungen wie VS Code und IntelliJ.
    *   In diesem Modus kann Gemini als Co-Programmierer agieren. Es kann Fragen zu Ihrem Code beantworten, Kontext und integrierte Tools nutzen, um generierte Inhalte zu verbessern, und Lösungen für komplexe Aufgaben bereitstellen.
    *   Der Agenten-Modus kann auch zum Generieren von Code aus Designdokumenten oder Kommentaren verwendet werden.

2.  **Gemini API und Vertex AI:**
    *   Sie können Ihre eigenen KI-Agenten auf Google Cloud erstellen und dabei Gemini als leistungsstarkes Sprachmodell ("Gehirn") verwenden.
    *   Die Gemini API ermöglicht den Zugriff auf die Fähigkeiten von Gemini, um Ihren Agenten mit Sprachverständnis, Generierungsfunktionen und Problemlösungsfähigkeiten auszustatten.
    *   Plattformen wie Vertex AI bieten die notwendige Infrastruktur, um diese Agenten zu entwickeln, zu trainieren und bereitzustellen. Hier können Sie die Gemini-Modelle integrieren und so Agenten bauen, die auf spezifische Aufgaben zugeschnitten sind.

3.  **Tools und Datenintegration:**
    *   KI-Agenten, die auf Gemini basieren, können mit verschiedenen Tools und Datenquellen ausgestattet werden. Diese "Tools" können interne Funktionen sein, die Dateisysteme ändern, oder auch externe Dienste.
    *   Durch die Integration von Tools und Daten können Agenten kontextbezogen agieren und spezifische Aktionen ausführen, die über reine Textgenerierung hinausgehen.

4.  **Colab Enterprise und Data Science Agent:**
    *   In Colab Enterprise können Sie mit Gemini über Ihre Notizbücher chatten und erhalten Unterstützung beim Programmieren, Code-Vervollständigung und der Erklärung von Code-Zellen oder Fehlern.
    *   Es gibt auch einen Data Science Agent, der speziell für die Arbeit mit Daten und Diensten wie BigQuery in Colab Enterprise entwickelt wurde und Gemini für seine Funktionen nutzt.

Zusammenfassend lässt sich sagen, dass Gemini als leistungsstarkes KI-Modell die Grundlage für die Entwicklung und den Betrieb vieler KI-Agenten auf Google Cloud bildet. Es ermöglicht diesen Agenten, intelligenter und vielseitiger zu agieren, indem es ihnen fortgeschrittene Sprach- und Denkfähigkeiten zur Verfügung stellt.
