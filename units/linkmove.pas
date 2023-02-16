unit linkmove;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Tools, LazFileUtils;

type

  { TfrmMoveLink }

  TfrmMoveLink = class(TForm)
    cmdOK: TButton;
    cmdClose: TButton;
    cboMoveTo: TComboBox;
    lblMoveTo: TLabel;
    procedure cmdCloseClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure LoadCats;
  public

  end;

var
  frmMoveLink: TfrmMoveLink;

implementation

{$R *.lfm}

{ TfrmMoveLink }

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

end.
