unit addcat;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Tools, LCLType;

type

  { TfrmCatAdd }

  TfrmCatAdd = class(TForm)
    cmdOK: TButton;
    cmdClose: TButton;
    cboIcons: TComboBox;
    imgIcon: TImage;
    lblTitle: TLabel;
    lblCatName: TLabeledEdit;
    lblIcon: TStaticText;
    procedure cboIconsDrawItem(Control: TWinControl; Index: integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure cboIconsMeasureItem(Control: TWinControl; Index: integer;
      var AHeight: integer);
    procedure cmdCloseClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblCatNameChange(Sender: TObject);
    procedure lblCatNameKeyPress(Sender: TObject; var Key: char);
  private

  public

  end;

var
  frmCatAdd: TfrmCatAdd;

implementation

{$R *.lfm}

{ TfrmCatAdd }

procedure TfrmCatAdd.FormCreate(Sender: TObject);
var
  X: integer;
begin
  //InitListIcons;
  for X := 0 to 19 do
  begin
    cboIcons.Items.Add(IntToStr(X));
  end;
  cboIcons.ItemIndex := 0;
end;

procedure TfrmCatAdd.lblCatNameChange(Sender: TObject);
begin
  cmdOK.Enabled := (lblCatName.Text <> '');
end;

procedure TfrmCatAdd.lblCatNameKeyPress(Sender: TObject; var Key: char);
begin
  if Key in ['<', '>', '/', '\', '?', '"', '*', ':', '|'] then
  begin
    Key := #0;
  end;
end;

procedure TfrmCatAdd.cmdOKClick(Sender: TObject);
begin
  Tools.CatIcon := cboIcons.ItemIndex;
  Tools.CatName := lblCatName.Text;
  Tools.ButtonPress := 1;
  Close;
end;

procedure TfrmCatAdd.cmdCloseClick(Sender: TObject);
begin
  Tools.ButtonPress := 0;
  Close;
end;

procedure TfrmCatAdd.cboIconsDrawItem(Control: TWinControl; Index: integer;
  ARect: TRect; State: TOwnerDrawState);
var
  YPos: integer;
begin
  //Draw the icons in the listbox
  if odSelected in State then
  begin
    cboIcons.Canvas.Brush.Color := $00A0637D;
  end;
  cboIcons.Canvas.FillRect(ARect);
  //Draw the icon on the listbox from the image list.
  frmIcons.iLstFolders.Draw(cboIcons.Canvas, ARect.Left + 4, ARect.Top + 4, index);
  //Align text
  YPos := (ARect.Bottom - ARect.Top - cboIcons.Canvas.TextHeight(Text)) div 2;
  //Write the list item text
  cboIcons.Canvas.TextOut(ARect.left + frmIcons.iLstFolders.Width + 8, ARect.Top + YPos,
    cboIcons.Items.Strings[index]);
end;

procedure TfrmCatAdd.cboIconsMeasureItem(Control: TWinControl;
  Index: integer; var AHeight: integer);
begin
  AHeight := frmIcons.iLstFolders.Height + 8;
end;

end.
