unit cPwAend;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  registry, windows, cPwEin, DCPsha256;

type

  { TForm3 }

  TForm3 = class(TForm)
    Button1: TButton;
    DCP_sha256_1: TDCP_sha256;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit2Enter(Sender: TObject);
    procedure Edit3Enter(Sender: TObject);
    procedure Edit4Enter(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form3: TForm3;
  path : String;
  AktPw : String;
  AktPwField : String;
  NeuPw : String;
  NeuPwWie : String;
  sl : TStringList;
  s : String;
  AktBenu : String;
  SS : String;
  Data : String;

implementation

{$R *.lfm}

{ TForm3 }

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

procedure TForm3.Button1Click(Sender: TObject);
begin
  AktBenu := Edit4.Text;
  AktPwField := Encrypt(Edit1.Text,AktBenu);
  NeuPw := Edit2.Text;
  NeuPwWie := Edit3.Text;

   if Edit1.Text = '' then
  begin
    Application.MessageBox('Bitte das alte Passwort eingeben.', 'Hinweis', MB_ICONWARNING or MB_OK);
  end;

   if AktBenu = '' then
  begin
    Application.MessageBox('Bitte den Benutzer eingeben.', 'Hinweis', MB_ICONWARNING or MB_OK);
  end;

  if NeuPw = '' then
  begin
    Application.MessageBox('Bitte das Neue Passwort eingeben.', 'Hinweis', MB_ICONWARNING or MB_OK);
  end;

  if NeuPwWie = '' then
  begin
    Application.MessageBox('Bitte das Neue Passwort bestätigen.', 'Hinweis', MB_ICONWARNING or MB_OK);
  end;

  if AktPwField = AktPw then
  begin
    if NeuPw = NeuPwWie then
    begin
      NeuPw := Encrypt(NeuPwWie,AktBenu);
      path := (GetRegistryPath('AppData'));
      sl := TStringList.Create;
      try
        sl.Add(NeuPw);
        sl.SaveToFile(path+'\PWHash.txt');
      finally
        sl.Free;
      end;
      Application.MessageBox('Neue Passwort gespeichert. Bitte Anwendung neustarten.', 'Hinweis', MB_ICONINFORMATION or MB_OK);
      Application.Terminate;
      Close;
    end
    else
    begin
      Application.MessageBox('Die neuen Passwörter sind nicht identisch.', 'Achtung', MB_ICONWARNING or MB_OK);
    end;
  end
  else
  begin
    Application.MessageBox('Das Alte Passwort ist nicht richtig.', 'Achtung', MB_ICONWARNING or MB_OK)
  end;
end;

procedure TForm3.Edit1Enter(Sender: TObject);
begin
  Edit1.Text := '';
  Edit1.PasswordChar := '*';
end;

procedure TForm3.Edit2Enter(Sender: TObject);
begin
  Edit2.Text := '';
  Edit2.PasswordChar := '*';
end;

procedure TForm3.Edit3Enter(Sender: TObject);
begin
  Edit3.Text := '';
  Edit3.PasswordChar := '*';
end;

procedure TForm3.Edit4Enter(Sender: TObject);
begin
  Edit4.Text := '';
end;

procedure TForm3.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Edit1.Text := 'Aktuelles Passwort eingeben';
  Edit1.PasswordChar := #0;
  Edit2.Text := 'Neues Passwort eingeben';
  Edit2.PasswordChar := #0;
  Edit3.Text := 'Neues Passwort eingeben';
  Edit3.PasswordChar := #0;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  path := (GetRegistryPath('AppData'));
  if FileExists(path+'\PWHash.txt') then
  begin
    sl := TStringList.Create;
    try
      sl.LoadFromFile(path+'\PWHash.txt');
      s := sl.CommaText;
      AktPw := s;
    finally
      sl.Free;
    end;
  end
  else
  begin
    if Application.MessageBox('Es wurde kein Zugangs Passwort auf dem PC gefunden. Bitte erstellen sie eins.', 'Achtung', MB_ICONINFORMATION or MB_OK) = 1 then
               Form2.showModal;
  end;
end;

end.

