unit cPwEin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, registry,
  windows, DCPsha256;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Edit1EditingDone(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit2EditingDone(Sender: TObject);
    procedure Edit2Enter(Sender: TObject);
    procedure Edit3EditingDone(Sender: TObject);
    procedure Edit3Enter(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form2: TForm2;
  PwNeu : String;
  PKey : String;
  result : integer;
  s : String;
  S1: String;
  Str1 : boolean;
  Str2 : boolean;
  Str3 : boolean;
  sl : TStringList;
  path : String;


implementation

{$R *.lfm}

{ TForm2 }

uses cPwMa;

function Encrypt(Str,Key  : String): String;
var
  hasher: TDCP_sha256;
  digest: array [0..31] of Byte;
  i: Integer;
  salt1 : String;
  salt2 : String;
begin
  hasher := TDCP_sha256.Create(nil);
  salt1 := 'dsiad8204u80uei3et474848dh98bfdb46,4,.#ü#8+ü8q+ä#.vöäüoi0erw78974344256d46f#+545.8ghm+rü04äasmnfdnbn,463';
  salt2 := '3786f74sdfd+#s.#+32ü,.sf,ß034,2üpfsd,ä,v,#öäb6oß4ü34,#bn#nßüüüüüü045ß0zk54kpüh,#üt#.h5+ß0isergkrgä9p43e-';
  try
    hasher.Init;
    hasher.UpdateStr(salt1+Str+Key+salt2);
    hasher.Final(digest);
    Result := '';
    for i := Low(digest) to High(digest) do
      Result := Result+IntToHex(digest[i], 2);
  finally
    hasher.Free;
  end;
end;

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

procedure TForm2.Button1Click(Sender: TObject);
begin
  if Edit3.Text = '' then
  begin
    ShowMessage('Bitte einen Benutzernamen eingeben');
    Str3 := false;
  end;

   if Edit1.Text = '' then
  begin
    ShowMessage('Bitte ein Passwort eingeben');
    Str1 := false;
  end;

  if Edit2.Text = '' then
  begin
    ShowMessage('Bitte das Neue Passwort bestätigen');
    Str2 := false;
  end;

  if Edit1.Text = Edit2.Text then
  begin
    if Str1 = true and Str2 = true and Str3 = true then
    begin
      PKey := Edit3.Text;
      PwNeu := Encrypt(Edit1.Text, PKey);
      path := (GetRegistryPath('AppData'));
      sl := TStringList.Create;
      cPwMa.PwEin := PwNeu;
      cPwMa.path := path;
      try
        sl.Add(PwNeu);
        sl.SaveToFile(path+'\PWHash.txt');
      finally
        sl.Free;
      end;
      ShowMessage('Zugangsdaten gespeichert. Bitte Anwendung neustarten.');
      Application.Terminate;
      Close;
    end;
  end
  else
  begin
    if Str1 = true and Str2 = true then
    begin
    ShowMessage('Die eingegebenen Passwörter sind nicht identisch')
    end;
  end;
end;

procedure TForm2.Edit1EditingDone(Sender: TObject);
begin
  Str1 := true;
end;

procedure TForm2.Edit1Enter(Sender: TObject);
begin
  Edit1.Text := '';
  Edit1.PasswordChar := '*';
end;

procedure TForm2.Edit2EditingDone(Sender: TObject);
begin
  Str2 := true;
end;

procedure TForm2.Edit3EditingDone(Sender: TObject);
begin
  Str3 := true;
end;

procedure TForm2.Edit2Enter(Sender: TObject);
begin
  Edit2.Text := '';
  Edit2.PasswordChar := '*';
end;

procedure TForm2.Edit3Enter(Sender: TObject);
begin
  Edit3.Text := '';
end;


procedure TForm2.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  {Edit1.Text := 'Neues Passwort eingeben';
  Edit1.PasswordChar := #0;
  Edit2.Text := 'Neues Passwort bestätigen';
  Edit2.PasswordChar := #0;  }
  Application.Terminate;
  Close;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Str1 := true;
  Str2 := true;
end;

end.
