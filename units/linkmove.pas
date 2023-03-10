unit linkmove;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Tools, LazFileUtils, LCLType, IniFiles;

type

  { TfrmMoveLink }

  TfrmMoveLink = class(TForm)
    cmdOK: TButton;
    cmdClose: TButton;
    cboMoveTo: TComboBox;
    lblMoveTo: TLabel;
    procedure cboMoveToDrawItem(Control: TWinControl; Index: integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure cboMoveToMeasureItem(Control: TWinControl; Index: integer;
      var AHeight: integer);
    procedure cmdCloseClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure LoadCats;
    function GetCatIcon(cName: string): integer;
  public

  end;

var
  frmMoveLink: TfrmMoveLink;

implementation

{$R *.lfm}

{ TfrmMoveLink }


function TfrmMoveLink.GetCatIcon(cName: string): integer;
var
  ini: TIniFile;
  nIcon: integer;
begin
  ini := TIniFile.Create(BasePath + 'folders.ini');
  nIcon := ini.ReadInteger(cName, 'ICON', 0);
  FreeAndNil(ini);
  Result := nIcon;
end;

procedure TfrmMoveLink.LoadCats;
var
  sr: TSearchRec;
  S0: string;
begin
  if FindFirstUTF8(BasePath + '*.cat', faAnyFile, sr) = 0 then
  begin
    cboMoveTo.Clear;
    repeat
      S0 := RemoveExt(sr.Name);
      if lowercase(LinksMoveFromCat) <> (LowerCase(S0)) then
      begin
        cboMoveTo.Items.Add(S0);
      end;
    until FindNextUTF8(sr) <> 0;
  end;
end;

procedure TfrmMoveLink.FormCreate(Sender: TObject);
begin
  LoadCats;
end;

procedure TfrmMoveLink.cmdOKClick(Sender: TObject);
begin
  if cboMoveTo.ItemIndex <> -1 then
  begin
    Tools.LinksMoveToCat := cboMoveTo.Text;
    Tools.ButtonPress := 1;
    Close;
  end;
end;

procedure TfrmMoveLink.cmdCloseClick(Sender: TObject);
begin
  Tools.ButtonPress := 0;
  Close;
end;

procedure TfrmMoveLink.cboMoveToDrawItem(Control: TWinControl;
  Index: integer; ARect: TRect; State: TOwnerDrawState);
var
  YPos: integer;
begin
  if odSelected in State then
  begin
    cboMoveTo.Canvas.Brush.Color := $00A87189;
  end;
  //Draw the icons in the listbox
  cboMoveTo.Canvas.FillRect(ARect);
  //Draw the icon on the listbox from the image list.
  frmIcons.LstFolders.Draw(cboMoveTo.Canvas, ARect.Left + 4, ARect.Top + 4,
    GetCatIcon(cboMoveTo.Items.Strings[Index]));
  //Align text
  YPos := (ARect.Bottom - ARect.Top - cboMoveTo.Canvas.TextHeight(Text)) div 2;
  //Write the list item text
  cboMoveTo.Canvas.TextOut(ARect.left + frmIcons.LstFolders.Width + 8, ARect.Top + YPos,
    cboMoveTo.Items.Strings[index]);
end;

procedure TfrmMoveLink.cboMoveToMeasureItem(Control: TWinControl;
  Index: integer; var AHeight: integer);
begin
  AHeight := frmIcons.LstFolders.Height + 8;
end;

end.
