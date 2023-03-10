unit listimages;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs;

type

  { TfrmTemp }

  TfrmTemp = class(TForm)
    LstFolders: TImageList;
    lstBookmarks: TImageList;
    procedure FormCreate(Sender: TObject);
  private

  public
    iLstFolders: TImageList;
    ilstBookmarks: TImageList;
  end;

var
  frmTemp: TfrmTemp;

implementation

{$R *.lfm}

{ TfrmTemp }

procedure TfrmTemp.FormCreate(Sender: TObject);
begin
  ilstBookmarks := TImageList.Create(self);
  iLstFolders := TImageList.Create(self);
  ilstBookmarks := lstBookmarks;
  iLstFolders := LstFolders;
end;

end.
