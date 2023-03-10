unit addlink;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Tools, LCLType;

type

  { TfrmAddLink }

  TfrmAddLink = class(TForm)
    cmdOK: TButton;
    cmdClose: TButton;
    cboIcons: TComboBox;
    ImgLogo: TImage;
    lblDescription: TLabeledEdit;
    lblLinkTitle: TLabel;
    lblLinkName: TLabeledEdit;
    lblLinkAddress: TLabeledEdit;
    StaticText1: TStaticText;
    procedure cboIconsDrawItem(Control: TWinControl; Index: integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure cboIconsMeasureItem(Control: TWinControl; Index: integer;
      var AHeight: integer);
    procedure cmdCloseClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblDescriptionKeyPress(Sender: TObject; var Key: char);
    procedure lblLinkAddressKeyPress(Sender: TObject; var Key: char);
    procedure lblLinkNameChange(Sender: TObject);
    procedure lblLinkNameKeyPress(Sender: TObject; var Key: char);
  private
    function VaildName(sName: string): boolean;
    procedure DoKeyPress(Sender: TObject; var Key: char);
  public

  end;

var
  frmAddLink: TfrmAddLink;

implementation

{$R *.lfm}

{ TfrmAddLink }

procedure TfrmAddLink.DoKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
  begin
    Key := #0;
    if cmdOK.Enabled then
    begin
      cmdOKClick(Sender);
    end;
  end;
end;

function TfrmAddLink.VaildName(sName: string): boolean;
var
  I: integer;
  Flag: boolean;
begin
  Flag := True;

  for I := 1 to Length(sName) do
  begin
    if (sName[I]) in ['['..']'] then
    begin
      Flag := False;
      Break;
    end;
  end;
  Result := Flag;
end;

procedure TfrmAddLink.lblLinkNameChange(Sender: TObject);
begin
  cmdOK.Enabled := Trim(lblLinkName.Text) <> '';
end;

procedure TfrmAddLink.lblLinkNameKeyPress(Sender: TObject; var Key: char);
begin
  if Key in ['[', ']'] then Key := #0;
  DoKeyPress(Sender, Key);
end;

procedure TfrmAddLink.cmdCloseClick(Sender: TObject);
begin
  Tools.ButtonPress := 0;
  Close;
end;

procedure TfrmAddLink.cboIconsDrawItem(Control: TWinControl; Index: integer;
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
  frmIcons.ilstBookmarks.Draw(cboIcons.Canvas, ARect.Left + 4, ARect.Top + 4, index);
  //Align text
  YPos := (ARect.Bottom - ARect.Top - cboIcons.Canvas.TextHeight(Text)) div 2;
  //Write the list item text
  cboIcons.Canvas.TextOut(ARect.left + frmIcons.ilstBookmarks.Width +
    8, ARect.Top + YPos,
    cboIcons.Items.Strings[index]);
end;

procedure TfrmAddLink.cboIconsMeasureItem(Control: TWinControl;
  Index: integer; var AHeight: integer);
begin
  AHeight := frmIcons.ilstBookmarks.Height + 8;
end;

procedure TfrmAddLink.cmdOKClick(Sender: TObject);
begin
  Tools.ButtonPress := 1;

  if not VaildName(lblLinkName.Text) then
  begin
    MessageDlg(Text, 'Bookmark name cannot contain any of the characters [ or ]',
      mtInformation, [mbOK], 0);
  end
  else
  begin
    Tools.LinkName := lblLinkName.Text;
    Tools.LinkUrl := lblLinkAddress.Text;
    Tools.LinkDesc := lblDescription.Text;
    Tools.LinkIcon := cboIcons.ItemIndex;
    Close;
  end;
end;

procedure TfrmAddLink.FormCreate(Sender: TObject);
var
  X: integer;
begin
  for X := 0 to 19 do
  begin
    cboIcons.Items.Add(IntToStr(X));
  end;
  cboIcons.ItemIndex := 0;
end;

procedure TfrmAddLink.lblDescriptionKeyPress(Sender: TObject; var Key: char);
begin
  DoKeyPress(Sender, Key);
end;

procedure TfrmAddLink.lblLinkAddressKeyPress(Sender: TObject; var Key: char);
begin
  DoKeyPress(Sender, Key);
end;

end.
