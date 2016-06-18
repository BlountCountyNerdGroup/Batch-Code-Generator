rem This will create index.html and app.js

title Template Code Generator
color 0A & rem this will make things look cool

rem This section is the where the folder will be saved; copied off of Google
setlocal enabledelayedexpansion

:: Does powershell.exe exist within %PATH%?
for %%I in (`powershell.exe`) do if "%%~$PATH:I" neq "" (
    set chooser=powershell -sta "Add-Type -AssemblyName System.windows.forms|Out-Null;$f=New-Object System.Windows.Forms.FolderBrowserDialog;$f.SelectedPath='%cd%';$f.Description='Please choose a folder.';$f.ShowNewFolderButton=$true;$f.ShowDialog();$f.SelectedPath"
) else (
rem :: If not, compose and link C# application to open folder browser dialog
    set chooser=%temp%\fchooser.exe
    if exist !chooser! del !chooser!
    >"%temp%\c.cs" echo using System;using System.Windows.Forms;
    >>"%temp%\c.cs" echo class dummy{[STAThread]
    >>"%temp%\c.cs" echo public static void Main^(^){
    >>"%temp%\c.cs" echo FolderBrowserDialog f=new FolderBrowserDialog^(^);
    >>"%temp%\c.cs" echo f.SelectedPath=System.Environment.CurrentDirectory;
    >>"%temp%\c.cs" echo f.Description="Please choose a folder.";
    >>"%temp%\c.cs" echo f.ShowNewFolderButton=true;
    >>"%temp%\c.cs" echo if^(f.ShowDialog^(^)==DialogResult.OK^){Console.Write^(f.SelectedPath^);}}}
    for /f "delims=" %%I in ('dir /b /s "%windir%\microsoft.net\*csc.exe"') do (
        if not exist "!chooser!" "%%I" /nologo /out:"!chooser!" "%temp%\c.cs" 2>NUL
    )
    del "%temp%\c.cs"
    if not exist "!chooser!" (
        echo Error: Please install .NET 2.0 or newer, or install PowerShell.
        goto :EOF
    )
)

:: capture choice to a variable
for /f "delims=" %%I in ('%chooser%') do set "saveLocation=%%I"

echo You chose %saveLocation%

:: Clean up the mess
del "%temp%\fchooser.exe" 2>NUL

rem This section makes a folder for the project

if exist "Coding Club" (
	goto folderCodingClubExists
)

set folder="Coding Club"
md %folder%
goto folderSuccessfullyCreated

set /a folderNumber = 1

:folderCodingClubExists

set /a folderNumber += 2
if exist "Coding Club %folderNumber%" (
	goto folderCodingClubExists
)

set folder="Coding Club %folderNumber%"
md %folder%


rem This section writes two files and inserts template code into them

:folderSuccessfullyCreated
set htmlFile=%folder%"/index.html"
set JSFile=%folder%"/app.js"

break > %htmlFile%
break > %JSFile%

echo ^<!DOCTYPE html^> >> %htmlFile%
echo ^<html lang="en"^> >> %htmlFile%
echo ^<head^> >> %htmlFile%
echo 	^<meta charset="UTF-8"^> >> %htmlFile%
echo 	^<title^>Coding Club^</title^> >> %htmlFile%
echo ^</head^> >> %htmlFile%
echo ^<body^> >> %htmlFile%
echo. >> %htmlFile%
echo. >> %htmlFile%
echo 	^<script src="app.js"^>^</script^> >> %htmlFile%
echo ^</body^> >> %htmlFile%
echo ^</html^> >> %htmlFile%