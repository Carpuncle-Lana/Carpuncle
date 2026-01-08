# Cleanup-CarpuncleDrive.ps1
# Bereinigt T:\ von fehlgeschlagenen Skript-Versuchen und doppelten Installationen

<#
.SYNOPSIS
    Bereinigt T:\Carpuncle von Duplikaten und Fehlversuchen

.DESCRIPTION
    Analysiert das T:\Carpuncle Verzeichnis und findet:
    - Doppelte Tool-Installationen (z.B. mehrere Python-Versionen)
    - Fehlgeschlagene Skript-Versuche
    - Verwaiste Dateien
    - Cache-Müll
    
    Der Benutzer kann dann entscheiden, was gelöscht werden soll.

.PARAMETER DryRun
    Zeigt nur an, was gelöscht würde, ohne tatsächlich zu löschen

.PARAMETER Force
    Löscht ohne Nachfrage (VORSICHT!)

.PARAMETER CarpunclePath
    Pfad zum Carpuncle-Verzeichnis (Standard: T:\Carpuncle)

.EXAMPLE
    .\Cleanup-CarpuncleDrive.ps1 -DryRun
    
.EXAMPLE
    .\Cleanup-CarpuncleDrive.ps1 -Force
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [switch]$DryRun,
    
    [Parameter(Mandatory=$false)]
    [switch]$Force,
    
    [Parameter(Mandatory=$false)]
    [string]$CarpunclePath = "T:\Carpuncle"
)

#Requires -RunAsAdministrator

$ErrorActionPreference = "Continue"

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

function Get-FolderSize {
    param([string]$Path)
    
    if (-not (Test-Path $Path)) {
        return 0
    }
    
    try {
        $size = (Get-ChildItem $Path -Recurse -File -ErrorAction SilentlyContinue | 
                 Measure-Object -Property Length -Sum).Sum
        return $size
    }
    catch {
        return 0
    }
}

function Format-FileSize {
    param([long]$Size)
    
    if ($Size -gt 1GB) {
        return "{0:N2} GB" -f ($Size / 1GB)
    }
    elseif ($Size -gt 1MB) {
        return "{0:N2} MB" -f ($Size / 1MB)
    }
    elseif ($Size -gt 1KB) {
        return "{0:N2} KB" -f ($Size / 1KB)
    }
    else {
        return "$Size Bytes"
    }
}

Write-Section "CARPUNCLE DRIVE CLEANUP"

if (-not (Test-Path $CarpunclePath)) {
    Write-Error "Carpuncle-Pfad nicht gefunden: $CarpunclePath"
    exit 1
}

Write-Info "Analysiere: $CarpunclePath"

if ($DryRun) {
    Write-Warning "DRY RUN MODUS - Es wird nichts gelöscht!"
}

# Sammle Probleme
$script:Issues = @()
$script:TotalSizeToFree = 0

function Add-Issue {
    param(
        [string]$Type,
        [string]$Path,
        [string]$Description,
        [long]$Size
    )
    
    $script:Issues += [PSCustomObject]@{
        Type = $Type
        Path = $Path
        Description = $Description
        Size = $Size
    }
    
    $script:TotalSizeToFree += $Size
}

# 1. Doppelte Tool-Installationen finden
Write-Section "1. SUCHE NACH DOPPELTEN TOOL-INSTALLATIONEN"

$toolsPath = Join-Path $CarpunclePath "Tools"

if (Test-Path $toolsPath) {
    # Python-Duplikate
    Write-Info "Prüfe Python-Installationen..."
    $pythonDirs = Get-ChildItem $toolsPath -Directory | Where-Object { $_.Name -like "python*" }
    
    if ($pythonDirs.Count -gt 1) {
        Write-Warning "Mehrere Python-Installationen gefunden: $($pythonDirs.Count)"
        
        foreach ($dir in $pythonDirs) {
            $size = Get-FolderSize $dir.FullName
            $sizeStr = Format-FileSize $size
            Write-Host "  - $($dir.Name): $sizeStr" -ForegroundColor Yellow
            
            if ($dir.Name -ne "python") {
                Add-Issue -Type "Duplicate" -Path $dir.FullName -Description "Doppelte Python-Installation" -Size $size
            }
        }
    }
    else {
        Write-Success "Nur eine Python-Installation gefunden"
    }
    
    # Node.js-Duplikate
    Write-Info "Prüfe Node.js-Installationen..."
    $nodeDirs = Get-ChildItem $toolsPath -Directory | Where-Object { $_.Name -like "node*" }
    
    if ($nodeDirs.Count -gt 1) {
        Write-Warning "Mehrere Node.js-Installationen gefunden: $($nodeDirs.Count)"
        
        foreach ($dir in $nodeDirs) {
            $size = Get-FolderSize $dir.FullName
            $sizeStr = Format-FileSize $size
            Write-Host "  - $($dir.Name): $sizeStr" -ForegroundColor Yellow
            
            if ($dir.Name -ne "node") {
                Add-Issue -Type "Duplicate" -Path $dir.FullName -Description "Doppelte Node.js-Installation" -Size $size
            }
        }
    }
    else {
        Write-Success "Nur eine Node.js-Installation gefunden"
    }
    
    # .NET-Duplikate
    Write-Info "Prüfe .NET-Installationen..."
    $dotnetDirs = Get-ChildItem $toolsPath -Directory | Where-Object { $_.Name -like "dotnet*" }
    
    if ($dotnetDirs.Count -gt 1) {
        Write-Warning "Mehrere .NET-Installationen gefunden: $($dotnetDirs.Count)"
        
        foreach ($dir in $dotnetDirs) {
            $size = Get-FolderSize $dir.FullName
            $sizeStr = Format-FileSize $size
            Write-Host "  - $($dir.Name): $sizeStr" -ForegroundColor Yellow
            
            if ($dir.Name -ne "dotnet") {
                Add-Issue -Type "Duplicate" -Path $dir.FullName -Description "Doppelte .NET-Installation" -Size $size
            }
        }
    }
    else {
        Write-Success "Nur eine .NET-Installation gefunden"
    }
}

# 2. Alte/Verwaiste Skripte finden
Write-Section "2. SUCHE NACH ALTEN SKRIPTEN UND VERWAISTEN DATEIEN"

# Skript-Dateien auf Root-Ebene
$rootScripts = Get-ChildItem $CarpunclePath -File | Where-Object { 
    $_.Extension -in @(".ps1", ".bat", ".cmd", ".sh") 
}

if ($rootScripts.Count -gt 0) {
    Write-Warning "Skript-Dateien auf Root-Ebene gefunden: $($rootScripts.Count)"
    
    foreach ($script in $rootScripts) {
        $size = $script.Length
        Write-Host "  - $($script.Name): $(Format-FileSize $size)" -ForegroundColor Yellow
        Add-Issue -Type "OrphanedScript" -Path $script.FullName -Description "Skript auf Root-Ebene" -Size $size
    }
}
else {
    Write-Success "Keine Skripte auf Root-Ebene gefunden"
}

# 3. Cache bereinigen
Write-Section "3. CACHE-ANALYSE"

$cachePath = Join-Path $CarpunclePath "Cache"

if (Test-Path $cachePath) {
    $cacheSize = Get-FolderSize $cachePath
    $cacheSizeStr = Format-FileSize $cacheSize
    
    Write-Info "Cache-Größe: $cacheSizeStr"
    
    if ($cacheSize -gt 1GB) {
        Write-Warning "Cache ist größer als 1 GB!"
        
        # Alte Cache-Dateien (älter als 30 Tage)
        $oldCacheFiles = Get-ChildItem $cachePath -Recurse -File -ErrorAction SilentlyContinue | 
                        Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) }
        
        $oldCacheSize = ($oldCacheFiles | Measure-Object -Property Length -Sum).Sum
        
        if ($oldCacheSize -gt 0) {
            Write-Warning "Alte Cache-Dateien (>30 Tage): $(Format-FileSize $oldCacheSize)"
            Add-Issue -Type "OldCache" -Path $cachePath -Description "Alte Cache-Dateien (>30 Tage)" -Size $oldCacheSize
        }
    }
    else {
        Write-Success "Cache-Größe ist akzeptabel"
    }
}

# 4. Logs bereinigen
Write-Section "4. LOG-ANALYSE"

$logsPath = Join-Path $CarpunclePath "Logs"

if (Test-Path $logsPath) {
    $logsSize = Get-FolderSize $logsPath
    $logsSizeStr = Format-FileSize $logsSize
    
    Write-Info "Logs-Größe: $logsSizeStr"
    
    if ($logsSize -gt 500MB) {
        Write-Warning "Logs sind größer als 500 MB!"
        
        # Alte Log-Dateien (älter als 60 Tage)
        $oldLogFiles = Get-ChildItem $logsPath -Recurse -File -ErrorAction SilentlyContinue | 
                      Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-60) }
        
        $oldLogsSize = ($oldLogFiles | Measure-Object -Property Length -Sum).Sum
        
        if ($oldLogsSize -gt 0) {
            Write-Warning "Alte Log-Dateien (>60 Tage): $(Format-FileSize $oldLogsSize)"
            Add-Issue -Type "OldLogs" -Path $logsPath -Description "Alte Log-Dateien (>60 Tage)" -Size $oldLogsSize
        }
    }
    else {
        Write-Success "Logs-Größe ist akzeptabel"
    }
}

# 5. Leere Verzeichnisse
Write-Section "5. LEERE VERZEICHNISSE"

$emptyDirs = Get-ChildItem $CarpunclePath -Recurse -Directory -ErrorAction SilentlyContinue | 
             Where-Object { -not (Get-ChildItem $_.FullName -ErrorAction SilentlyContinue) }

if ($emptyDirs.Count -gt 0) {
    Write-Warning "Leere Verzeichnisse gefunden: $($emptyDirs.Count)"
    
    foreach ($dir in $emptyDirs) {
        Write-Host "  - $($dir.FullName)" -ForegroundColor Yellow
        Add-Issue -Type "EmptyDir" -Path $dir.FullName -Description "Leeres Verzeichnis" -Size 0
    }
}
else {
    Write-Success "Keine leeren Verzeichnisse gefunden"
}

# Zusammenfassung
Write-Section "ZUSAMMENFASSUNG"

if ($script:Issues.Count -eq 0) {
    Write-Success "Keine Probleme gefunden! T:\Carpuncle ist sauber."
    exit 0
}

Write-Warning "Gefundene Probleme: $($script:Issues.Count)"
Write-Info "Freizugebender Speicherplatz: $(Format-FileSize $script:TotalSizeToFree)"
Write-Host ""

# Probleme gruppiert anzeigen
$groupedIssues = $script:Issues | Group-Object Type

foreach ($group in $groupedIssues) {
    Write-Host "`n[$($group.Name)]" -ForegroundColor Cyan
    
    foreach ($issue in $group.Group) {
        Write-Host "  - $($issue.Path)" -ForegroundColor Yellow
        Write-Host "    $($issue.Description) - $(Format-FileSize $issue.Size)" -ForegroundColor Gray
    }
}

# Aktion durchführen
Write-Host ""

if ($DryRun) {
    Write-Info "DRY RUN abgeschlossen. Ohne -DryRun würde gelöscht werden."
    exit 0
}

if (-not $Force) {
    Write-Host "`nMöchten Sie diese Dateien/Verzeichnisse löschen?" -ForegroundColor Yellow
    $response = Read-Host "(j/N)"
    
    if ($response -ne "j" -and $response -ne "J") {
        Write-Info "Abgebrochen."
        exit 0
    }
}

# Löschen durchführen
Write-Section "BEREINIGUNG"

$successCount = 0
$errorCount = 0

foreach ($issue in $script:Issues) {
    Write-Info "Lösche: $($issue.Path)"
    
    try {
        if (Test-Path $issue.Path) {
            if ((Get-Item $issue.Path) -is [System.IO.DirectoryInfo]) {
                Remove-Item $issue.Path -Recurse -Force -ErrorAction Stop
            }
            else {
                Remove-Item $issue.Path -Force -ErrorAction Stop
            }
            
            Write-Success "  ✓ Gelöscht"
            $successCount++
        }
        else {
            Write-Warning "  → Existiert nicht mehr"
        }
    }
    catch {
        Write-Error "  ✗ Fehler: $_"
        $errorCount++
    }
}

Write-Section "ERGEBNIS"

Write-Success "Erfolgreich gelöscht: $successCount"

if ($errorCount -gt 0) {
    Write-Warning "Fehler: $errorCount"
}

Write-Success "Freigegeben: $(Format-FileSize $script:TotalSizeToFree)"
Write-Host ""

Write-Success "Bereinigung abgeschlossen!"
