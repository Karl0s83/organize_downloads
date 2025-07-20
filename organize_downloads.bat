@echo off
REM Script: organize_downloads.bat
REM Purpose: Organize files in the Downloads folder by file type into subfolders.
REM          Intended for Windows 10/11 users.

REM -------------------------------------------------------------
REM IMPORTANT NOTES:
REM - Please read the README.md carefully before using this script.
REM - This script is provided "as-is", without any warranty. Use at your own risk.
REM - It will NOT delete any files, only move them into categorized subfolders.
REM - The script does NOT move itself, so you can keep it safely in your Downloads folder.
REM - Feel free to customize folder names and file extensions in the script.
REM -------------------------------------------------------------

REM Author: Carlos Escribano Tiñena
REM Contact: LinkedIn https://www.linkedin.com/in/carlos-escribano-ti%C3%B1ena/ | GitHub https://github.com/Karl0s83
REM License: MIT License (see LICENSE file)

REM -------------------------------------------------------------

REM 0. Set Downloads folder path
set "DOWNLOADS=%USERPROFILE%\Downloads"

REM 1. Define file categories and extensions
REM Format: FolderName=*.ext1 *.ext2 ...

setlocal enabledelayedexpansion
set "SCRIPTNAME=%~nx0"

REM 2. Loop through file categories
for %%C in (
    "Images=*.jpg *.jpeg *.png *.gif *.bmp *.webp"
    "Videos=*.mp4 *.mkv *.avi *.mov *.wmv"
    "Music=*.mp3 *.wav *.flac *.aac *.ogg"
    "Documents=*.pdf *.doc *.docx *.xls *.xlsx *.ppt *.pptx *.txt"
    "Compressed=*.zip *.rar *.7z *.tar *.gz"
    "ISOs=*.iso *.img"
    "Executables=*.exe *.msi"
    "Scripts=*.bat *.cmd *.ps1 *.sh"
    "Others=*.*"
) do (
    for /f "tokens=1,2 delims==" %%A in ("%%~C") do (
        set "FOLDER=%%A"
        set "PATTERNS=%%B"

        REM 3. Create folder if it doesn't exist
        if not exist "%DOWNLOADS%\!FOLDER!" (
            mkdir "%DOWNLOADS%\!FOLDER!"
        )

        REM 4. Move matching files (but skip the script itself)
        for %%P in (!PATTERNS!) do (
            for %%F in ("%DOWNLOADS%\%%P") do (
                if /I not "%%~nxF"=="%SCRIPTNAME%" (
                    move "%%F" "%DOWNLOADS%\!FOLDER!" >nul 2>&1
                )
            )
        )
    )
)

REM 5. Done
echo Downloads folder organized successfully.
pause
