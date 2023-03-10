unit browsercfg;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, EditBtn,
  StdCtrls, IniFiles, Tools;

type

  { TfrmBrowsers }

  TfrmBrowsers = class(TForm)
    cmdOK: TButton;
    cmdClose: TButton;
    cboDefault: TComboBox;
    Label1: TLabel;
    lblTitle1: TLabel;
    lblTitle2: TLabel;
    lblTitle3: TLabel;
    lblTitle4: TLabel;
    txtFileEd1: TFileNameEdit;
    lblTitle: TLabel;
    txtFileEd2: TFileNameEdit;
    txtFileEd3: TFileNameEdit;
    txtFileEd4: TFileNameEdit;
    txtFileEd5: TFileNameEdit;
    procedure cmdCloseClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BrowsersInfo;
    procedure SaveBrowserInfo;
  private

  public

  end;

var
  frmBrowsers: TfrmBrowsers;

implementation

{$R *.lfm}

{ TfrmBrowsers }

procedure TfrmBrowsers.BrowsersInfo;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(AppPath + 'browsers.ini');

  txtFileEd1.Text := ini.ReadString('browser1', 'Path', '');
  txtFileEd2.Text := ini.ReadString('browser2', 'Path', '');
  txtFileEd3.Text := ini.ReadString('browser3', 'Path', '');
  txtFileEd4.Text := ini.ReadString('browser4', 'Path', '');
  txtFileEd5.Text := ini.ReadString('browser5', 'Path', '');

  txtFileEd1.InitialDir := ExtractFilePath(txtFileEd1.Text);
  txtFileEd2.InitialDir := ExtractFilePath(txtFileEd2.Text);
  txtFileEd3.InitialDir := ExtractFilePath(txtFileEd3.Text);
  txtFileEd4.InitialDir := ExtractFilePath(txtFileEd4.Text);
  txtFileEd5.InitialDir := ExtractFilePath(txtFileEd5.Text);
  cboDefault.ItemIndex := ini.ReadInteger('Browsers', 'default', 0);

  FreeAndNil(ini);
end;

procedure TfrmBrowsers.SaveBrowserInfo;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(AppPath + 'browsers.ini');

  ini.WriteString('browser1', 'Path', txtFileEd1.Text);
  ini.WriteString('browser2', 'Path', txtFileEd2.Text);
  ini.WriteString('browser3', 'Path', txtFileEd3.Text);
  ini.WriteString('browser4', 'Path', txtFileEd4.Text);
  ini.WriteString('browser5', 'Path', txtFileEd5.Text);
  ini.WriteInteger('Browsers', 'default', cboDefault.ItemIndex);
  FreeAndNil(ini);

end;

procedure TfrmBrowsers.FormCreate(Sender: TObject);
begin
  BrowsersInfo;
end;

procedure TfrmBrowsers.cmdOKClick(Sender: TObject);
begin
  SaveBrowserInfo;
  tools.ButtonPress := 1;
  Close;
end;

procedure TfrmBrowsers.cmdCloseClick(Sender: TObject);
begin
  tools.ButtonPress := 0;
  Close;
end;

end.
