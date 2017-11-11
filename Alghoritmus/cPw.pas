unit cPw;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, Math;

type

  { TForm1 }

  TForm1 = class(TForm)
    IdSchluessel: TEdit;
    IdPass: TEdit;
    IdOk: TToggleBox;
    Label1: TLabel;
    Label2: TLabel;
    IdTest: TLabel;
    Label3: TLabel;
    IdCpass: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure IdOkChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  a : String;
  b : String;
  c : String;
  d : String;
  e : String;
  f : String;
  g : String;
  h : String;
  i : String;
  j : String;
  k : String;
  l : String;
  m : String;
  n : String;
  o : String;
  p : String;
  q : String;
  r : String;
  s : String;
  t : String;
  Passwort : String;
  SCodPasswort : String;
  CodPasswort : integer;

implementation

{$R *.lfm}

{ TForm1 }

function XorStr(const Text: string; Key: Integer): string;
var
  i: Integer;
begin
  SetLength(Result, Length(Text));
  if not (Key in [0..31]) then
    raise EInvalidArgument.CreateFmt('Key muss ein Integer zwischen 0 und 31 sein, ist aber %d', [Key]);

  for i:=1 to Length(Text) do
  begin
    if Text[i] > #31 then
      Result[i] := Chr(Ord(Text[i]) xor Key)
    else
      Result[i] := Text[i];
  end;
end;

procedure TForm1.IdOkChange(Sender: TObject);
begin
  IdCpass.Text := '';
  Passwort := IdPass.Text;
  SCodPasswort := IdSchluessel.Text;
  CodPasswort := StrToInt(SCodPasswort);
  if Passwort = '' then
  begin
     if SCodPasswort = '' then
     begin
     ShowMessage('Bitte alles ausfüllen');
     end;
  end
  else
  begin
     Passwort := IdPass.Text;
     a := Passwort[1];
     b := Passwort[2];
     c := Passwort[3];
     d := Passwort[4];
     e := Passwort[5];
     f := Passwort[6];
     g := Passwort[7];
     h := Passwort[8];
     i := Passwort[9];
     j := Passwort[10];
     k := 'A01jP2'+a+'J1aK'+b+'1(aK92U?'+c+'4ak9"f0'+d+'12j'+e+'12*ak2'+f+'_5'+g+'K02O1*D2j4'+h+'D2ef4ö=5Ä'+i+'e'+j+'fgc3';
     l := '5kZ'+a+'Ö2m)a'+b+'H'+c+'9a1)/7'+d+'3hHd'+e+'al0231=S!c3aJAdfu'+f+'§'+g+'9724nKD25'+h+'F2vv4365c'+i+'v'+j+'we5V';
     m := '.i(zF'+a+'5'+b+'1202K=OWI'+c+'92J#'+d+'fgds9ls0"'+e+'S21fv4'+f+'fSMC98q2f3j'+g+'4§%Ö'+h+'Dk'+i+'8dsF354m'+j+'1';
     n := '´d'+a+'^#KMä1'+b+'KAß1'+c+'-:ka9/9sj9'+d+')hQI'+e+'sxYKWD2-;D(§h'+f+'vlö_.'+g+'4h'+h+'f3&'+i+'CVni2'+j+'%23fc8';
     o := 'Ö)72'+a+'Jh'+b+'9sÄ0'+c+'21lK'+d+'a92gALs03d*2dv'+e+'L"f'+f+'Dk156JKdk72'+g+'§"ß8f30Ci8'+h+'1'+i+'2G§FFV'+j+'F';
     p := 'Pan53jv'+a+'312'+b+'9s'+c+'LA'+d+'09Adi3'+e+'0jasJ8&x9s_'+f+'LDk1'+g+'5)=§jcbMXD9'+h+'b5VÖä6'+i+'52F3'+j+'5vs§';
     q := 'p'+a+'w'+b+'972nSDs912_:ö?)a'+c+'_ks'+d+')23)2uh'+e+'!"ß'+f+'K27ku(§ncfW'+g+'§j'+h+'ja_g"'+i+'954lvbn5t%'+j+'E';
     r := '=2J'+a+'hzK-a_.1'+b+'2'+c+'Öa02kg5lSß)"'+d+'kjxwS"'+e+'9'+f+'Kcv82Ls08"D?§'+g+'´6'+h+'$GS=$kfvHJz3'+i+'§'+j+'d';
     s := 'ÖÄs92K'+a+'§A'+b+'19J1'+c+'02jkdAL'+d+'ld002Q41Ö'+e+'ÜQ%'+f+'Dfjk'+g+'1sd2ui3Ä34k'+h+'Hß1'+i+'K$KNcG'+j+'32ff1';
     t := 'p_33'+a+'w'+b+'02jkdAL:ö?)a'+c+'_ks'+d+')23)F32uh'+e+'!"ß'+f+'Dfjk(§ncfW'+g+'§jf3'+h+'ja_g"'+i+'§jcbMXD9'+j+'E';

     case CodPasswort of
          0: IdCpass.Text := XorStr(t, 0);
          1: IdCpass.Text := XorStr(k, 1);
          2: IdCpass.Text := XorStr(l, 2);
          3: IdCpass.Text := XorStr(m, 3);
          4: IdCpass.Text := XorStr(n, 4);
          5: IdCpass.Text := XorStr(o, 5);
          6: IdCpass.Text := XorStr(p, 6);
          7: IdCpass.Text := XorStr(q, 7);
          8: IdCpass.Text := XorStr(r, 8);
          9: IdCpass.Text := XorStr(s, 9);
     end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     IdCpass.Caption := '';
end;


end.

