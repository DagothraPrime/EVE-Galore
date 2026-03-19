# EVG Dev Symlink
# Links the mod folder from your git repo into the Vortex mods directory
# Run as Administrator (symlinks require elevated privileges)

$source = "C:\gitrepos\EVE Galore\zzz_dag_evegalore"
$target = "C:\Users\Robert\AppData\Roaming\Vortex\x4foundations\mods\EVE Galore\zzz_dag_evegalore"

# Check for admin
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run this script as Administrator (symlinks require elevation)" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Verify source exists
if (-not (Test-Path $source)) {
    Write-Host "ERROR: Source not found: $source" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Create parent directory if needed
$parentDir = Split-Path $target -Parent
if (-not (Test-Path $parentDir)) {
    New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    Write-Host "Created parent directory: $parentDir" -ForegroundColor Yellow
}

# Remove existing target if present
if (Test-Path $target) {
    $item = Get-Item $target -Force
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        # Already a symlink — remove and recreate
        cmd /c rmdir "$target"
        Write-Host "Removed existing symlink" -ForegroundColor Yellow
    } else {
        Write-Host "ERROR: $target already exists and is NOT a symlink. Remove it manually first." -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
}

# Create symlink
New-Item -ItemType SymbolicLink -Path $target -Target $source | Out-Null
Write-Host "Symlink created:" -ForegroundColor Green
Write-Host "  $target" -ForegroundColor Cyan
Write-Host "  -> $source" -ForegroundColor Cyan
Write-Host ""
Write-Host "Edits in your git repo will be live in Vortex immediately." -ForegroundColor Green
Read-Host "Press Enter to exit"
