unit cPwMa;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, IpHtml, Forms, Controls, Graphics, Dialogs,
  ActnList, Menus, StdCtrls, cPwAend,
  cPwEin, DCPsha256, registry, windows, DCPrijndael,
  DCPtwofish, DCPserpent, cMa;

type

  { TForm1 }

    TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    DCP_serpent1: TDCP_serpent;
    DCP_sha256_1: TDCP_sha256;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    IdVersion: TLabel;
    Label3: TLabel;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit2EditingDone(Sender: TObject);
    procedure Edit2Enter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  PwEin : String;
  PwTmp : String;
  sl : TStringList;
  path : String;
  s : String;
  Key : String;
  tmp : String;
  S1, S2: String;
  c: TDCP_rijndael;
  a: Boolean;
  b: Boolean;



implementation

{$R *.lfm}

{ TForm1 }

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

procedure TForm1.Edit1Enter(Sender: TObject);
begin
  Edit1.Text := '';
  Edit1.PasswordChar := '*';
end;

procedure TForm1.Edit2EditingDone(Sender: TObject);
begin
  Key := Edit2.Text;
end;

procedure TForm1.Edit2Enter(Sender: TObject);
begin
  Edit2.Text := '';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  if PwEin = '' then
  begin
     MenuItem2.Enabled := true;
  end
  else
  begin
     MenuItem2.Enabled := false;
  end;
end;


procedure TForm1.Button1Click(Sender: TObject);
begin
  PwTmp := Encrypt(Edit1.Text, Key);
  if PwTmp = PwEin then
  begin
    Form1.Hide;
    Form4.ShowModal;
    Form1.Close;
  end
  else
  begin
    Application.MessageBox('Die eingegebenen Daten sind falsch. Bitte wiederholen.', 'Achtung', MB_ICONWARNING or MB_OK);
  end;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  Form2.ShowModal;
end;


procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  self.close;
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
  Form3.ShowModal;
end;

end.

