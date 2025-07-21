@echo off
REM Script: organize_downloads.bat
REM Purpose: Organize files in the Downloads folder by file type into subfolders.
REM  Intended for Windows 10/11 users.

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

REM === 0. Set the Downloads folder path ===
set "DOWNLOADS=%USERPROFILE%\Downloads"

REM === Define file categories and patterns ===
set "CATEGORIES=Images Videos Music Documents Compressed ISOs Executables Scripts Others"

REM === Define patterns for each category ===
set "CATEGORIES=Images Videos Music Documents Compressed ISOs Executables Scripts"
set "Compressed=*.zip *.rar *.7z *.tar *.gz"
set "Documents=*.pdf *.doc *.docx *.xls *.xlsx *.ppt *.pptx *.txt *.psd"
set "Executables=*.exe *.msi"
set "Images=*.jpg *.jpeg *.png *.gif *.bmp *.webp *.svg"
set "ISOs=*.iso *.img"
set "Music=*.mp3 *.wav *.flac *.aac *.ogg"
set "Scripts=*.bat *.cmd *.ps1 *.sh"
set "Videos=*.mp4 *.mkv *.avi *.mov *.wmv"

REM Step 1: Move files according to their patterns
pushd "%DOWNLOADS%"
for %%C in (%CATEGORIES%) do (
  set "FOLDER=%%C"
  set "PATTERNS=!%%C!"
  if not exist "!FOLDER!" mkdir "!FOLDER!"
  
  for %%P in (!PATTERNS!) do (
    REM Use for /f with dir to avoid errors when no files match
    for /f "delims=" %%F in ('dir /b /a-d "%%P" 2^>nul') do (
      if /I not "%%F"=="%SCRIPTNAME%" (
        if not exist "!FOLDER!\%%F" (
          move "%%F" "!FOLDER!\" >nul
        )
      )
    )
  )
)
popd

REM Step 2: Move remaining files (that are not folders or the script) to "Others"
pushd "%DOWNLOADS%"
for %%F in (*.*) do (
  if /I not "%%F"=="%SCRIPTNAME%" (
    if not exist "Images\%%F" if not exist "Videos\%%F" if not exist "Music\%%F" if not exist "Documents\%%F" if not exist "Compressed\%%F" if not exist "ISOs\%%F" if not exist "Executables\%%F" if not exist "Scripts\%%F" (
      if not exist "Others" mkdir "Others"
      move "%%F" "Others\" >nul
    )
  )
)
popd

echo Downloads folder organized successfully.
pause
