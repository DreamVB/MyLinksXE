unit linkshare;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Tools;

type

  { TfrmShareLink }

  TfrmShareLink = class(TForm)
    cmdOK: TButton;
    cmdClose: TButton;
    ImgShare: TImage;
    lblServiceTitle: TLabel;
    R1: TRadioButton;
    R2: TRadioButton;
    R3: TRadioButton;
    R4: TRadioButton;
    procedure cmdCloseClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure R1Change(Sender: TObject);
    procedure R2Change(Sender: TObject);
    procedure R3Change(Sender: TObject);
    procedure R4Change(Sender: TObject);
  private

  public

  end;

var
  frmShareLink: TfrmShareLink;
  ShareID: integer;

implementation

{$R *.lfm}

{ TfrmShareLink }

procedure TfrmShareLink.cmdOKClick(Sender: TObject);
begin

  case ShareID of
    0:
    begin
      Tools.LinkShareSrc :=
        'https://www.facebook.com/sharer/sharer.php?u=' + LinkShareUrl;
    end;
    1:
    begin
      Tools.LinkShareSrc := 'https://twitter.com/intent/tweet?text=' + LinkShareUrl;
    end;
    2:
    begin
      Tools.LinkShareSrc :=
        'https://www.linkedin.com/shareArticle?mini=true&url=' + LinkShareUrl;
    end;
    3:
    begin
      Tools.LinkShareSrc := 'mailto:?subject=Website Link&body=' +
        'Here is a link I like to share with you: ' + ' ' + LinkShareUrl;
    end;
    else
    begin
      Tools.LinkShareSrc := '';
    end;
  end;

  Tools.ButtonPress := 1;
  Close;
end;

procedure TfrmShareLink.FormCreate(Sender: TObject);
begin
  ShareID := 0;
end;

procedure TfrmShareLink.R1Change(Sender: TObject);
begin
  ShareID := 0;
end;

procedure TfrmShareLink.R2Change(Sender: TObject);
begin
  ShareID := 1;
end;

procedure TfrmShareLink.R3Change(Sender: TObject);
begin
  ShareID := 2;
end;

procedure TfrmShareLink.R4Change(Sender: TObject);
begin
  ShareID := 3;
end;

procedure TfrmShareLink.cmdCloseClick(Sender: TObject);
begin
  Tools.ButtonPress := 0;
  Close;
end;

end.
