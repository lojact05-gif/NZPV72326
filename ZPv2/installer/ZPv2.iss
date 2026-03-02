[Setup]
AppId={{2C7752D8-4E8C-4D20-9B9A-6E03267E7C11}
AppName=ZPv2
#ifdef MyAppVersion
AppVersion={#MyAppVersion}
#else
AppVersion=2.0.0
#endif
AppPublisher=Zaldo
DefaultDirName={pf}\ZPv2
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
Source: "..\out\publish\_stage\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs

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
; Parar serviço somente se existir (evita erro sem precisar ignoreerrors)
Filename: "{sys}\sc.exe"; Parameters: "stop ""ZPv2Service"""; Flags: runhidden; Check: ServiceExists('ZPv2Service')

; Criar serviço somente se não existir
Filename: "{sys}\sc.exe"; Parameters: "create ""ZPv2Service"" binPath= ""{app}\ZPv2.Service.exe"" start= auto DisplayName= ""ZPv2 Service"""; Flags: runhidden; Check: not ServiceExists('ZPv2Service')

; Configurar serviço se existir (upgrade)
Filename: "{sys}\sc.exe"; Parameters: "config ""ZPv2Service"" binPath= ""{app}\ZPv2.Service.exe"" start= auto DisplayName= ""ZPv2 Service"""; Flags: runhidden; Check: ServiceExists('ZPv2Service')

; Descrição se existir
Filename: "{sys}\sc.exe"; Parameters: "description ""ZPv2Service"" ""ZPv2 local API and thermal print service"""; Flags: runhidden; Check: ServiceExists('ZPv2Service')

; Iniciar serviço se existir
Filename: "{sys}\sc.exe"; Parameters: "start ""ZPv2Service"""; Flags: runhidden; Check: ServiceExists('ZPv2Service')

; Abrir UI após instalar
Filename: "{app}\ZPv2.Ui.exe"; Description: "Abrir ZPv2"; Flags: nowait postinstall skipifsilent

[UninstallRun]
; Parar e apagar somente se existir (evita erro)
Filename: "{sys}\sc.exe"; Parameters: "stop ""ZPv2Service"""; Flags: runhidden; Check: ServiceExists('ZPv2Service')
Filename: "{sys}\sc.exe"; Parameters: "delete ""ZPv2Service"""; Flags: runhidden; Check: ServiceExists('ZPv2Service')

[Code]
function ServiceExists(const ServiceName: string): Boolean;
var
  ResultCode: Integer;
begin
  Result :=
    Exec(
      ExpandConstant('{sys}\sc.exe'),
      'query "' + ServiceName + '"',
      '',
      SW_HIDE,
      ewWaitUntilTerminated,
      ResultCode
    ) and (ResultCode = 0);
end;
