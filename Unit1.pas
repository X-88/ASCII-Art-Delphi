unit Unit1;

interface

uses
  Windows, SysUtils, Forms, Grids, Menus, ExtCtrls, ComCtrls, StdCtrls, Classes, Controls, Dialogs;

type
  ErrorMsg = class(Exception);

type
  TFZSN = class(TForm)
    SGE: TStringGrid;
    MM: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Import1: TMenuItem;
    Export1: TMenuItem;
    Exit1: TMenuItem;
    Option1: TMenuItem;
    Help1: TMenuItem;
    PN: TPanel;
    SB: TStatusBar;
    Grid1: TMenuItem;
    GB1: TGroupBox;
    SGT: TStringGrid;
    About1: TMenuItem;
    OD: TOpenDialog;
    SD: TSaveDialog;
    N2: TMenuItem;
    Setting1: TMenuItem;
    FontColor1: TMenuItem;
    EditorColor1: TMenuItem;
    CD: TColorDialog;
    Color1: TMenuItem;
    N1: TMenuItem;
    Save1: TMenuItem;
    GB2: TGroupBox;
    CB1: TComboBox;
    procedure SGESelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure Grid1Click(Sender: TObject);
    procedure SGTSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure New1Click(Sender: TObject);
    procedure Export1Click(Sender: TObject);
    procedure Import1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure SGEMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure SGEMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure Exit1Click(Sender: TObject);
    procedure FontColor1Click(Sender: TObject);
    procedure EditorColor1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure CB1Change(Sender: TObject);
  private
     procedure CreateTable;
     procedure DefaulConfig;
     procedure GetFontNames;
     procedure ImportFromFile(FileName: String);
     procedure ExportToFile(FileName: String);
    { Created By: X-88/Zephio Sept 19, 2011 }
  public
    { amateur.guide@gmail.com }
  end;

var
    FZSN: TFZSN;
const
    DFN = 'ZS Ascii Art v1.0';
implementation

{$R *.dfm}

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; stdcall;
begin
  TStrings(Data).Add(LogFont.lfFaceName);
  Result := 1;
end;

procedure TFZSN.GetFontNames;
var
  DC: HDC;
begin
  DC := GetDC(0);
  EnumFonts(DC, nil, @EnumFontsProc, Pointer(CB1.Items));
  ReleaseDC(0, DC);
  CB1.Sorted := True;
end;

procedure TFZSN.CreateTable;
var
    I, J: Integer;
begin
for I := 0 to $f do
for J := 0 to $f do
    SGT.Cells[I + 1, J + 1] := Chr(16 * J + I);
end;

procedure TFZSN.DefaulConfig;
begin
    CB1.Text := SGE.Font.Name;
    GetFontNames;
    SGT.Cells[1, 0] := 'C';
    SGT.Cells[2, 0] := 'h';
    SGT.Cells[3, 0] := 'a';
    SGT.Cells[4, 0] := 'r';
    SGT.Cells[6, 0] := ':';
//------------------------------------------------------------------------------>
    FZSN.Caption := DFN;
    Application.Title := DFN;
//------------------------------------------------------------------------------>
    SGT.Height := 138;
    SGT.Width := 167;
    SGT.ColCount := 17;
    SGT.RowCount := 17;
    SGT.Font.Size := 9;
    SGT.Font.Handle := GetStockObject(OEM_Fixed_Font);
//------------------------------------------------------------------------------>

    SGE.ColCount := 100;
    SGE.RowCount := 100;
    SGE.Font.Size := 9;
    SGE.Font.Handle := GetStockObject(OEM_Fixed_Font);
    SB.Panels[2].Text := 'Cols: ' + IntToStr(SGE.ColCount) + ', Rows: ' + IntToStr(SGE.RowCount);
end;

procedure TFZSN.FormCreate(Sender: TObject);
begin
    DefaulConfig;
    CreateTable;
end;

procedure TFZSN.SGESelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
    SGE.Cells[ACol, ARow] := SGT.Cells[8, 0];
    SB.Panels[1].Text := ' X : '+IntToStr(ACol)+', Y : '+IntToStr(ARow);
end;

procedure TFZSN.Grid1Click(Sender: TObject);
begin
    SGE.GridLineWidth := not SGE.GridLineWidth;
    Grid1.Checked := not Grid1.Checked;
end;

procedure TFZSN.SGTSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
    SGT.Cells[8, 0] := SGT.Cells[ACol, ARow];
end;

procedure TFZSN.New1Click(Sender: TObject);
var
    I: Integer;
begin
for I := 0 to SGE.RowCount - 1 do
    SGE.Rows[I].Clear;
end;

procedure TFZSN.Export1Click(Sender: TObject);
begin
if not SD.Execute then
    Exit
else
    ExportToFile(SD.FileName);
    FZSN.Caption := DFN + ' - ['+ChangeFileExt(ExtractFileName(SD.FileName), ']');
end;

procedure TFZSN.Import1Click(Sender: TObject);
begin
    New1Click(Self);
if not OD.Execute then
    exit
else
    ImportFromFile(OD.FileName);
    FZSN.Caption := DFN + ' - ['+ChangeFileExt(ExtractFileName(OD.FileName), ']');
end;

procedure TFZSN.About1Click(Sender: TObject);
var
    MB, MC : String;
    NL : String;
    MsgType, UserResp : integer;
begin
    NL := #13#10;
    MC := '.: Info :.';
    MB := MB + 'Application Name : ZS Ascii Art' + NL;
    MB := MB + 'Application Version : 1.0' + NL;
    MB := MB + 'OS/Platform : Win XP SP 1.2.3, Vista, 7 & Linux + WinE' + NL;
    MB := MB + 'Coded By : Zephio/X-88' + NL;
    MB := MB + 'Contact : amateur.guide@gmail.com' + NL;
    MB := MB + 'Blog : http://amateur-guide.blogspot.com' + NL;
    MB := MB + 'Hi To : All Tuts 4 You Members' + NL;
    MB := MB + 'X-88 Idiot 4 Life, 09, 2011.';
    MsgType := MB_OK + MB_ICONINFORMATION + MB_DEFBUTTON1 + MB_APPLMODAL;
    UserResp := MessageBox( Handle, PChar(MB), PChar(MC), MsgType);
end;

procedure TFZSN.SGEMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
    handled := true;
    exit;
end;

procedure TFZSN.SGEMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
    handled := true;
    exit;
end;

procedure TFZSN.Exit1Click(Sender: TObject);
begin
    Application.Terminate;
end;

procedure TFZSN.FontColor1Click(Sender: TObject);
begin
if not CD.Execute then
    exit
else
    SGE.Font.Color := CD.Color;
end;

procedure TFZSN.EditorColor1Click(Sender: TObject);
begin
if not CD.Execute then
    exit
else
    SGE.Color := CD.Color;
end;

//------ this part from https://www.swissdelphicenter.ch ----------------------->
procedure TFZSN.ExportToFile(FileName: String);
var
    I, J: Integer;
    S: string;
    f: TextFile;
begin
    AssignFile(f, FileName);
    Rewrite(f);
for i := 0 to SGE.RowCount - 1 do
begin
for j := 0 to SGE.ColCount - 1 do
begin
    S := '#' + IntToStr(i) + ',' + IntToStr(j) + ' ' + SGE.Cells[j, i];
if (Length(S) > Length(IntToStr(i)) + Length(IntToStr(j)) + 3) then
    Writeln(f, S);
end;

end;
    CloseFile(f);
end;

//------ this part from https://www.swissdelphicenter.ch ----------------------->
procedure TFZSN.ImportFromFile(FileName: String);
var
    X, Y, L: Integer;
    S, SI: string;
    F: TextFile;
begin
    AssignFile(f, FileName);
    Reset(f);
if IOResult <> 0 then
raise
    ErrorMsg.Create('File ' + FileName + ' not found.');
    X:=0;
    Y:=0;
while not Eof(f) do
begin
    Readln(f, S);
    S:=S + ' ';
while not (S = '') do
begin
    SI := Copy(S, 1, Pos(' ', S) - 1);
    S := Copy(S, Pos(' ', S) + 1, Length(S));
if Copy(SI, 1, 1) = '#' then
begin
    L := Length(SI);
    X := StrToInt(Copy(SI, Pos('#', SI)+1, Pos(',',SI)-2));
    Y := StrToInt(Copy(SI, Pos(',', SI)+1, L - Pos(',', SI)));
end;
if (SI <> ' ') and
   (SI <> '') and
   (Copy(SI, 1, 1) <> '#') then
begin
    SGE.Cells[Y+1,X+1] := SI;
    Inc(Y);
end;

end;
    Y := 0;
    Inc(X);
end;
    CloseFile(f);
end;

procedure TFZSN.Save1Click(Sender: TObject);
var
    I: Integer;
    SL: TStringList;
begin
    SL := TStringList.Create;
for I := 0 to pred(SGE.RowCount) do
    SL.add(SGE.Rows[I].CommaText);
    SL.SaveToFile(ExtractFilePath(Application.ExeName) + 'ZTest.diz');
//    SL.SaveToFile(ExtractFilePath(Application.ExeName) + 'ZTest.nfo');
end;

procedure TFZSN.CB1Change(Sender: TObject);
begin
if Length(CB1.Text) < 1 then
    exit
else
begin
    SGT.Font.Name := CB1.Text;
    SGE.Font.Name := CB1.Text;
end;

end;

end.
