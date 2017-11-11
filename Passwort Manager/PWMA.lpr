program PWMA;

{$mode objfpc}{$H+}


uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, cPwMa, cPwEin, cPwAend, cLink, cMa, registry, FileUtil, SysUtils, Classes;

{$R *.res}

function GetRegistryPath(valuename : string) : string;
begin
  result := '';
  with TRegistry.Create do
    begin
      RootKey := HKey_CURRENT_USER;
      OpenKeyReadOnly('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer'+
                      '\Shell Folders');
      if ValueExists(valuename) then
        result := ReadString(valuename);
      CloseKey;
      Free;
    end;
end;

function pruef: boolean;
begin
  path := (GetRegistryPath('AppData'));
  if FileExists(path+'\PWHash.txt') then
  begin
    sl := TStringList.Create;
  try
    sl.LoadFromFile(path+'\PWHash.txt');
    s := sl.CommaText;
    PwEin := s;
  finally
    sl.Free;
  end;
    result := true;
  end
  else
  begin
    result := false;
  end;
end;


begin

  Application.Title:='Passwort Manager';
  RequireDerivedFormResource := True;
  Application.Initialize;
  if pruef then
    Application.CreateForm(TForm1, Form1)
  else
    Application.CreateForm(TForm2, Form2);

  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.

