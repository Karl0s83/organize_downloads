# Script: organize_downloads.ps1
# Purpose: Organize files in the Downloads folder by file type into subfolders.
# Intended for Windows 10/11 users.
#
# -------------------------------------------------------------
# IMPORTANT NOTES:
# - Please read the README.md carefully before using this script.
# - This script is provided "as-is", without any warranty. Use at your own risk.
# - It will NOT delete any files, only move them into categorized subfolders.
# - The script does NOT move itself, so you can keep it safely in your Downloads folder.
# - Feel free to customize folder names and file extensions in the script.
# -------------------------------------------------------------
#
# Author: Carlos Escribano Tiñena
# Contact: LinkedIn https://www.linkedin.com/in/carlos-escribano-ti%C3%B1ena/ | GitHub https://github.com/Karl0s83
# License: MIT License (see LICENSE file)
#
# -------------------------------------------------------------
# organize-downloads.ps1
# Author: Carlos Estivill
# Description: Automatically organize your Downloads folder by file type.
# Supports logs, special characters, and folder creation.

$downloadsPath = "$env:USERPROFILE\Downloads"
$logPath = "$downloadsPath\organize-log.txt"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Define categories and extensions
$categories = @{
    "PDFs"        = @(".pdf")
    "Images"      = @(".png", ".jpg", ".jpeg", ".gif", ".bmp", ".svg", ".webp")
    "Audio"       = @(".mp3", ".wav", ".ogg", ".flac", ".m4a")
    "Video"       = @(".mp4", ".avi", ".mov", ".mkv", ".wmv")
    "Documents"   = @(".doc", ".docx", ".txt", ".odt", ".rtf")
    "Sheets"      = @(".xls", ".xlsx", ".ods", ".csv")
    "Executables" = @(".exe", ".msi", ".bat", ".cmd")
    "Compressed"  = @(".zip", ".rar", ".7z", ".tar", ".gz")
    "Design"      = @(".psd", ".ai", ".xd", ".fig", ".sketch")
    "Code"        = @(".html", ".css", ".js", ".py", ".c", ".cpp", ".java", ".cs", ".ts", ".json", ".xml")
}

# Create log header
Add-Content -Path $logPath -Value "`n===== $timestamp ====="
Add-Content -Path $logPath -Value "Starting organization of Downloads folder..."

# Get all files in Downloads
$files = Get-ChildItem -Path $downloadsPath -File -Force

foreach ($file in $files) {
    # Skip the script itself
    if ($file.FullName -eq $MyInvocation.MyCommand.Definition) {
        Add-Content -Path $logPath -Value "Skipped script file: $($file.Name)"
        continue
    }
    $moved = $false
    foreach ($category in $categories.Keys) {
        if ($categories[$category] -contains $file.Extension.ToLower()) {
            $targetFolder = Join-Path -Path $downloadsPath -ChildPath $category
            if (-not (Test-Path -Path $targetFolder)) {
                New-Item -ItemType Directory -Path $targetFolder | Out-Null
            }
            $targetPath = Join-Path -Path $targetFolder -ChildPath $file.Name

            try {
                Move-Item -Path $file.FullName -Destination $targetPath -Force
                Add-Content -Path $logPath -Value "Moved: $($file.Name) → $category"
                $moved = $true
                break
            }
            catch {
                Add-Content -Path $logPath -Value "X Failed to move $($file.Name): $_"
            }
        }
    }

    if (-not $moved) {
        $othersFolder = Join-Path -Path $downloadsPath -ChildPath "Others"
        if (-not (Test-Path -Path $othersFolder)) {
            New-Item -ItemType Directory -Path $othersFolder | Out-Null
        }

        try {
            Move-Item -Path $file.FullName -Destination (Join-Path $othersFolder $file.Name) -Force
            Add-Content -Path $logPath -Value "Moved: $($file.Name) → Others"
        }
        catch {
            Add-Content -Path $logPath -Value "X Failed to move $($file.Name): $_"
        }
    }
}

Add-Content -Path $logPath -Value "Downloads folder organized successfully.`n"

Write-Host "Downloads folder organized successfully!"
Write-Host "Log saved to: $logPath"
Pause