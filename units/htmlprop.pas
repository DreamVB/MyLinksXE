unit htmlprop;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Tools;

type

  { TfrmHtml }

  TfrmHtml = class(TForm)
    cmdLinkColor: TColorButton;
    cmdExport: TButton;
    cmdClose: TButton;
    cmdLinkColorHover: TColorButton;
    cmdPageColor: TColorButton;
    cmdHeaderColor: TColorButton;
    cmdCatColor: TColorButton;
    cmdBookmarkDescColor: TColorButton;
    lblHyperlink: TLabel;
    lblBookmarkHeader: TLabel;
    lblBookmarkLinkColor: TStaticText;
    lblBookmarkLinkColor1: TStaticText;
    lblPageCat: TLabel;
    lblPageBookmarkDesc: TLabel;
    txtHeaderText: TLabeledEdit;
    pPage: TPanel;
    lblBackcolor: TStaticText;
    lblHeadingcolor: TStaticText;
    lblCatColor: TStaticText;
    lblDescriptionColor: TStaticText;
    procedure cmdCloseClick(Sender: TObject);
    procedure cmdExportClick(Sender: TObject);
    procedure cmdLinkColorColorChanged(Sender: TObject);
    procedure cmdPageColorColorChanged(Sender: TObject);
    procedure cmdHeaderColorColorChanged(Sender: TObject);
    procedure cmdCatColorColorChanged(Sender: TObject);
    procedure cmdBookmarkDescColorColorChanged(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblHyperlinkMouseEnter(Sender: TObject);
    procedure lblHyperlinkMouseLeave(Sender: TObject);
    procedure txtHeaderTextChange(Sender: TObject);
  private
    procedure CenterHeader;
  public

  end;

var
  frmHtml: TfrmHtml;

implementation

{$R *.lfm}

{ TfrmHtml }

procedure TfrmHtml.CenterHeader;
begin
  lblBookmarkHeader.Left := (pPage.Width - lblBookmarkHeader.Width) div 2;
end;

procedure TfrmHtml.cmdExportClick(Sender: TObject);
begin
  Tools.ButtonPress := 1;
  Tools.HtmlPageTitle := txtHeaderText.Text;
  Tools.HtmlPageBkColor := ColorToHtml(cmdPageColor.ButtonColor);
  Tools.HtmlPageHeaderColor := ColorToHtml(cmdHeaderColor.ButtonColor);
  Tools.HtmlPageCatTextColor := ColorToHtml(cmdCatColor.ButtonColor);
  Tools.HtmlPageBookmarkDescription := ColorToHtml(cmdBookmarkDescColor.ButtonColor);
  Tools.HtmlPageLinkColor := ColorToHtml(cmdLinkColor.ButtonColor);
  Tools.HtmlPageLinkHoverColor := ColorToHtml(cmdLinkColorHover.ButtonColor);
  Close;
end;

procedure TfrmHtml.cmdLinkColorColorChanged(Sender: TObject);
begin
  lblHyperlink.Font.Color := cmdLinkColor.ButtonColor;
end;

procedure TfrmHtml.cmdPageColorColorChanged(Sender: TObject);
begin
  pPage.Color := cmdPageColor.ButtonColor;
end;

procedure TfrmHtml.cmdHeaderColorColorChanged(Sender: TObject);
begin
  lblBookmarkHeader.Font.Color := cmdHeaderColor.ButtonColor;
end;

procedure TfrmHtml.cmdCatColorColorChanged(Sender: TObject);
begin
  lblPageCat.Font.Color := cmdCatColor.ButtonColor;
end;

procedure TfrmHtml.cmdBookmarkDescColorColorChanged(Sender: TObject);
begin
  lblPageBookmarkDesc.Font.Color := cmdBookmarkDescColor.ButtonColor;
end;

procedure TfrmHtml.FormCreate(Sender: TObject);
begin
  CenterHeader;
end;

procedure TfrmHtml.lblHyperlinkMouseEnter(Sender: TObject);
begin
  lblHyperlink.Font.Color := cmdLinkColorHover.ButtonColor;
end;

procedure TfrmHtml.lblHyperlinkMouseLeave(Sender: TObject);
begin
  lblHyperlink.Font.Color := cmdLinkColor.ButtonColor;
end;

procedure TfrmHtml.txtHeaderTextChange(Sender: TObject);
begin
  lblBookmarkHeader.Caption := txtHeaderText.Text;
  CenterHeader;
end;

procedure TfrmHtml.cmdCloseClick(Sender: TObject);
begin
  Tools.ButtonPress := 0;
  Close;
end;

end.
