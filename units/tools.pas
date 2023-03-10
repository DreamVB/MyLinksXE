unit Tools;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ComCtrls, LCLIntf, LazFileUtils, Graphics, listimages, Forms;

function FixPath(S: string): string;
function RemoveExt(S: string): string;
function VaildFileName(S: string): boolean;
function AddCatName(TheName: string): integer;
function EditCat(OldName, NewName: string): integer;
function ColorToHtml(c: TColor): string;
procedure InitListIcons;

var
  AppPath: string;
  BasePath: string;
  SelectedCatName: string;
  LinksMoveFromCat: string;
  LinksMoveToCat: string;
  ButtonPress: integer;
  ExportTemplate: string;
  IsAdding: boolean;
  //Link vars
  LinkName: string;
  LinkUrl: string;
  LinkDesc: string;
  LinkIcon: integer;
  //Cat icons
  CatIcon: integer;
  CatName: string;
  //Linkshare
  LinkShareUrl: string;
  LinkShareSrc: string;
  //Temp form to hold image lists for icons
  frmIcons: TfrmTemp;
  //Html export page properties
  HtmlPageTitle: string;
  HtmlPageBkColor: string;
  HtmlPageHeaderColor: string;
  HtmlPageCatTextColor: string;
  HtmlPageBookmarkDescription: string;
  HtmlPageLinkColor: string;
  HtmlPageLinkHoverColor: string;

implementation

procedure InitListIcons;
begin
  frmIcons := TfrmTemp.Create(nil);
end;

function ColorToHtml(c: TColor): string;
begin
  Result := '#' + IntToHex(GetRValue(c), 2) + IntToHex(GetGValue(c), 2) +
    IntToHex(GetBValue(c), 2);
end;

function VaildFileName(S: string): boolean;
var
  Flag: boolean;
  X: integer;
begin
  Flag := True;

  for X := 1 to Length(S) do
  begin
    if S[X] in ['<', '>', '/', '\', '?', '"', '*', ':', '|'] then
    begin
      Flag := False;
      Break;
    end;
  end;
  Result := Flag;
end;

function FixPath(S: string): string;
begin
  if RightStr(S, 1) <> PathDelim then
  begin
    Result := S + PathDelim;
  end
  else
  begin
    Result := S;
  end;
end;

function RemoveExt(S: string): string;
var
  sPos: integer;
begin
  sPos := Pos('.', S);
  if sPos > 0 then
  begin
    Result := LeftStr(S, sPos - 1);
  end
  else
  begin
    Result := S;
  end;
end;

function AddCatName(TheName: string): integer;
var
  tf: TextFile;
begin
  if not VaildFileName(TheName) then
  begin
    Result := 0;
  end
  else if FileExistsUTF8(BasePath + TheName + '.cat') then
  begin
    Result := 1;
  end
  else
  begin
    AssignFile(tf, BasePath + TheName + '.cat');
    Rewrite(tf);
    CloseFile(tf);
    Result := 2;
  end;
end;

function EditCat(OldName, NewName: string): integer;
var
  tf: TextFile;
  lzOldFile, lzNewFile: string;
begin

  lzOldFile := BasePath + OldName + '.cat';
  lzNewFile := BasePath + NewName + '.cat';

  if not VaildFileName(NewName) then
  begin
    Result := 0;
  end
  else if FileExistsUTF8(lzNewFile) then
  begin
    Result := 1;
  end
  else
  begin
    RenameFileUTF8(lzOldFile, lzNewFile);
    Result := 2;
  end;
end;

end.
