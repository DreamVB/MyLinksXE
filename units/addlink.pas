unit addlink;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Tools;

type

  { TfrmAddLink }

  TfrmAddLink = class(TForm)
    cmdOK: TButton;
    cmdClose: TButton;
    ImgLogo: TImage;
    lblDescription: TLabeledEdit;
    lblLinkTitle: TLabel;
    lblLinkName: TLabeledEdit;
    lblLinkAddress: TLabeledEdit;
    procedure cmdCloseClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure lblLinkNameChange(Sender: TObject);
    procedure lblLinkNameKeyPress(Sender: TObject; var Key: char);
  private
    function VaildName(sName: string): boolean;
  public

  end;

var
  frmAddLink: TfrmAddLink;

implementation

{$R *.lfm}

{ TfrmAddLink }

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
end;

procedure TfrmAddLink.cmdCloseClick(Sender: TObject);
begin
  Tools.ButtonPress := 0;
  Close;
end;

procedure TfrmAddLink.cmdOKClick(Sender: TObject);
begin
  Tools.ButtonPress := 1;

  if not VaildName(lblLinkName.Text) then
  begin
    MessageDlg(Text, 'Bookmark name cannot contain the characters [ or ]',
      mtInformation, [mbOK], 0);
  end
  else
  begin
    Tools.LinkName := lblLinkName.Text;
    Tools.LinkUrl := lblLinkAddress.Text;
    Tools.LinkDesc := lblDescription.Text;
    Close;
  end;
end;

end.
