[Setup]
AppId={{2C7752D8-4E8C-4D20-9B9A-6E03267E7C11}
AppName=ZPv2
#ifdef MyAppVersion
AppVersion={#MyAppVersion}
#else
AppVersion=2.0.0
#endif
AppPublisher=Zaldo
DefaultDirName={autopf}\ZPv2
DefaultGroupName=ZPv2
DisableProgramGroupPage=no
UninstallDisplayIcon={app}\ZPv2.Ui.exe
OutputDir=..\out\installer
OutputBaseFilename=ZPv2Setup
Compression=lzma
SolidCompression=yes
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
PrivilegesRequired=admin
WizardStyle=modern

[Files]
Source: "..\out\publish\_stage\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Dirs]
Name: "{commonappdata}\ZPv2"; Permissions: users-modify
Name: "{commonappdata}\ZPv2\config"; Permissions: users-modify
Name: "{commonappdata}\ZPv2\log"; Permissions: users-modify

[Icons]
Name: "{autoprograms}\ZPv2\ZPv2"; Filename: "{app}\ZPv2.Ui.exe"
Name: "{autodesktop}\ZPv2"; Filename: "{app}\ZPv2.Ui.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Criar atalho no desktop"; GroupDescription: "Atalhos:"

[Run]
Filename: "{cmd}"; Parameters: "/C sc.exe stop ""ZPv2Service"" >NUL 2>&1 & exit /b 0"; Flags: runhidden waituntilterminated
Filename: "{cmd}"; Parameters: "/C sc.exe create ""ZPv2Service"" binPath= ""{app}\ZPv2.Service.exe"" start= auto DisplayName= ""ZPv2 Service"" >NUL 2>&1 & exit /b 0"; Flags: runhidden waituntilterminated
Filename: "{cmd}"; Parameters: "/C sc.exe config ""ZPv2Service"" binPath= ""{app}\ZPv2.Service.exe"" start= auto DisplayName= ""ZPv2 Service"" >NUL 2>&1 & exit /b 0"; Flags: runhidden waituntilterminated
Filename: "{cmd}"; Parameters: "/C sc.exe description ""ZPv2Service"" ""ZPv2 local print service"" >NUL 2>&1 & exit /b 0"; Flags: runhidden waituntilterminated
Filename: "{cmd}"; Parameters: "/C sc.exe start ""ZPv2Service"" >NUL 2>&1 & exit /b 0"; Flags: runhidden waituntilterminated
Filename: "{app}\ZPv2.Ui.exe"; Description: "Abrir ZPv2"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "{cmd}"; Parameters: "/C sc.exe stop ""ZPv2Service"" >NUL 2>&1 & exit /b 0"; Flags: runhidden
Filename: "{cmd}"; Parameters: "/C sc.exe delete ""ZPv2Service"" >NUL 2>&1 & exit /b 0"; Flags: runhidden
