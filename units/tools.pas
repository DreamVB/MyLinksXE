unit Tools;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ComCtrls, lclintf;

function FixPath(S: string): string;
function RemoveExt(S: string): string;
function VaildFileName(S: string): boolean;
function AddCat(TheName: string): integer;
function EditCat(OldName, NewName: string): integer;
function OpenLink(Address: string): boolean;

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
  //Linkshare
  LinkShareUrl: string;
  LinkShareSrc: string;

implementation

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

function AddCat(TheName: string): integer;
var
  tf: TextFile;
begin
  if not VaildFileName(TheName) then
  begin
    Result := 0;
  end
  else if FileExists(BasePath + TheName + '.cat') then
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
  else if FileExists(lzNewFile) then
  begin
    Result := 1;
  end
  else
  begin
    RenameFile(lzOldFile, lzNewFile);
    Result := 2;
  end;
end;

function OpenLink(Address: string): boolean;
begin
  Result := OpenDocument(Address);
end;

end.
