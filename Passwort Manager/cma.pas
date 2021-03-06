unit cMa;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, IpHtml, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Grids, ActnList, ExtCtrls,
  DCPsha512, DCPtwofish, windows, registry, IniFiles, shellapi;

type

  { TForm4 }

  TForm4 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    DCP_sha512_1: TDCP_sha512;
    DCP_twofish1: TDCP_twofish;
    Label1: TLabel;
    Panel1: TPanel;
    StringGrid1: TStringGrid;

    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form4: TForm4;
  sl : TStringList;
  var column, row: longint;


implementation

{$R *.lfm}

{ TForm4 }

        //WICHTIG: FÜR VERSCHLÜSSELUNG
function Encrypt(Str,Key  : String): String;
var
  Cipher: TDCP_twofish;
  KeyStr: string;
begin
  result := '';
  KeyStr:= Key;
  Cipher:= TDCP_twofish.Create(nil);
  Cipher.InitStr(KeyStr,TDCP_sha512);
  result := Cipher.EncryptString(Str);
  Cipher.Burn;
  Cipher.Free;
end;

function Decrypt(Str,Key  : String): String;
var
  Cipher: TDCP_twofish;
  KeyStr: string;
begin
  result := '';
  KeyStr:= Key;
  Cipher:= TDCP_twofish.Create(nil);
  Cipher.InitStr(KeyStr,TDCP_sha512);
  result := Cipher.DecryptString(Str);
  Cipher.Burn;
  Cipher.Free;
end;

{------------------------------------------------------------
 Fremdcode aus:
 http://www.swissdelphicenter.ch/de/showcode.php?id=651
 ------------------------------------------------------------}




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

procedure TForm4.Button2Click(Sender: TObject);
var
  path : String;
  ini : TIniFile;
  hash : String;
  z : integer;
  s : integer;
  salt : String;
  tmp : String;
begin
  path := (GetRegistryPath('AppData'));
  try
   if FileExists(path+'\PWHash.txt') then
   begin
     sl := TStringList.Create;
     sl.LoadFromFile(path+'\PWHash.txt');
     tmp := sl.CommaText;
     hash := tmp;
   end;
     salt := 'd09f9dßfsadfpdsjgdslkd98f9rr'+hash+'ffd+sar3+ür.a+üfe.+f3w';
     ini := TIniFile.Create(path+'\Passwort Manager.ini');
     s := 1;
     for z := 1 to 30 do begin
         ini.WriteString(hash, 'Benutzername'+inttostr(z), Encrypt(StringGrid1.Cells[s,z], salt));
         s := s + 1;
         ini.WriteString(hash, 'Passwort'+inttostr(z), Encrypt(StringGrid1.Cells[s,z], salt));
         s := s + 1;
         ini.WriteString(hash, 'SeitenURL'+inttostr(z), Encrypt(StringGrid1.Cells[s,z], salt));
         s := s + 1;
         ini.WriteString(hash, 'Anmerkung'+inttostr(z), Encrypt(StringGrid1.Cells[s,z], salt));
         s := 1;

     end;
  finally
         sl.Free;
         Application.MessageBox('Speichern erfolgreich', 'Hinweis', MB_ICONINFORMATION);
         StringGrid1.AutoEdit:=false;
         Label1.Caption := '' + #13#10 + 'Eingabe' + #13#10 + 'gesperrt';
         Label1.Color := clRed;
  end
end;

procedure TForm4.Button1Click(Sender: TObject);
begin
  StringGrid1.AutoEdit:= true;
  Label1.Caption := '' + #13#10 + 'Eingabe' + #13#10 + 'freigegeben';
  Label1.Color := clGreen;
end;

procedure TForm4.FormShow(Sender: TObject);
var
  path : String;
  ini : TIniFile;
  hash : String;
  z : integer;
  s : integer;
  salt : String;
  tmp : String;
begin
  path := (GetRegistryPath('AppData'));
  try
   if FileExists(path+'\PWHash.txt') then
   begin
     sl := TStringList.Create;
     sl.LoadFromFile(path+'\PWHash.txt');
     tmp := sl.CommaText;
     hash := tmp;
   end;
     salt := 'd09f9dßfsadfpdsjgdslkd98f9rr'+hash+'ffd+sar3+ür.a+üfe.+f3w';
     ini := TIniFile.Create(path+'\Passwort Manager.ini');
     s := 1;
     for z := 1 to 30 do begin
         StringGrid1.Cells[s,z] := Decrypt(ini.ReadString(hash, 'Benutzername'+inttostr(z), ''), salt);
         s := s + 1;
         StringGrid1.Cells[s,z] := Decrypt(ini.ReadString(hash, 'Passwort'+inttostr(z), ''), salt);
         s := s + 1;
         StringGrid1.Cells[s,z] := Decrypt(ini.ReadString(hash, 'SeitenURL'+inttostr(z), ''), salt);
         s := s + 1;
         StringGrid1.Cells[s,z] := Decrypt(ini.ReadString(hash, 'Anmerkung'+inttostr(z), ''), salt);
         s := 1;
     end;
  finally
         sl.Free;
  end;
  StringGrid1.AutoEdit:=false;
  Label1.Caption := '' + #13#10 + 'Eingabe' + #13#10 + 'gesperrt';
  Label1.Color := clRed;
end;


procedure TForm4.StringGrid1DblClick(Sender: TObject);
var
  hyper : String;
begin
   hyper := StringGrid1.Cells[StringGrid1.Col,StringGrid1.Row];
   if StringGrid1.Col = 3 then
      if hyper <> '' then
      begin;
          ShellExecute(Handle, 'open', PChar(hyper), nil,
          nil, sw_ShowNormal);
      end;
end;


end.

