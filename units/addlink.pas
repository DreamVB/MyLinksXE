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
    lblLinkTitle: TLabel;
    lblLinkName: TLabeledEdit;
    lblLinkAddress: TLabeledEdit;
    procedure cmdCloseClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure lblLinkAddressKeyPress(Sender: TObject; var Key: char);
    procedure lblLinkNameChange(Sender: TObject);
    procedure lblLinkNameKeyPress(Sender: TObject; var Key: char);
  private

  public

  end;

var
  frmAddLink: TfrmAddLink;

implementation

{$R *.lfm}

{ TfrmAddLink }

procedure TfrmAddLink.lblLinkAddressKeyPress(Sender: TObject; var Key: char);
begin
  if Key = '|' then Key := #0;
end;

procedure TfrmAddLink.lblLinkNameChange(Sender: TObject);
begin
  cmdOK.Enabled := Trim(lblLinkName.Text) <> '';
end;

procedure TfrmAddLink.lblLinkNameKeyPress(Sender: TObject; var Key: char);
begin
  if Key = '|' then Key := #0;
end;

procedure TfrmAddLink.cmdCloseClick(Sender: TObject);
begin
  Tools.ButtonPress := 0;
  Close;
end;

procedure TfrmAddLink.cmdOKClick(Sender: TObject);
begin
  lblLinkName.Text := StringReplace(lblLinkName.Text, '|', '', [rfReplaceAll]);
  lblLinkAddress.Text := StringReplace(lblLinkAddress.Text, '|', '', [rfReplaceAll]);
  Tools.ButtonPress := 1;
  Tools.LinkName := lblLinkName.Text;
  Tools.LinkUrl := lblLinkAddress.Text;
  Close;
end;

end.
