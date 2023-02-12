//This is a small class I made to pack files into one file then extract them.
// It supports the option of adding files.
// Extracts with full folder paths.

unit FileBag;

{$mode ObjFPC}{$H+}

interface


uses
  Classes, SysUtils;

type

  TBAGFileHeader = packed record
    fName: string[30];
    fSize: longint;
  end;

  TBagFile = class
  private
    FileLst: TStringList;
    FileCount: integer;
    BagHeader: string[4];
    BagFileInfo: TBAGFileHeader;
    TBuffer: array[0..10240] of byte;
  public
    procedure AddFile(lzFile: string);
    function Pak(Filename: string): boolean;
    function UnPak(Filename: string; ExtractTo: string): boolean;
    constructor Create;
  end;

implementation

function ExtractFolder(Path: string): string;
var
  s_pos: integer;
begin
  //Used to extract the path of the file, but removes the drive letter.
  s_pos := Pos(':\', Path);

  if s_pos > 0 then
  begin
    Result := Copy(Path, s_pos + 2);
  end
  else
  begin
    Result := Path;
  end;
end;

constructor TBagFile.Create;
begin
  FileLst := TStringList.Create;
end;

procedure TBagFile.AddFile(lzFile: string);
begin
  FileLst.Add(lzFile);
end;

function TBagFile.Pak(Filename: string): boolean;
var
  flag: boolean;
  infile: file;
  BagFile: file;
  bWrote, bRead: longint;
  X: integer;
  lzFile: string;
begin
  flag := True;
  FileCount := FileLst.Count;

  //Set read and write vars to zero.
  bRead := 0;
  bWrote := 0;

  if FileCount = 0 then
  begin
    flag := False;
  end
  else
  begin
    //Set bag file header
    BagHeader := 'TBAG';
    //Write bag header to file.
    assignfile(BagFile, Filename);
    Rewrite(BagFile, 1);
    BlockWrite(BagFile, BagHeader, sizeof(BagHeader));
    BlockWrite(BagFile, FileCount, sizeof(FileCount));

    //Write the ssource files to the bag file.
    for X := 0 to FileCount - 1 do
    begin
      //Get file.
      lzFile := FileLst[X];
      //Open source file.
      AssignFile(infile, lzFile);
      Reset(infile, 1);
      //Set bag file header
      BagFileInfo.fName := ExtractFileName(lzFile);
      BagFileInfo.fSize := FileSize(infile);
      BlockWrite(BagFile, BagFileInfo, sizeof(BagFileInfo));

      //Write data to bag file
      repeat
        BlockRead(infile, TBuffer, sizeof(TBuffer), bRead);
        BlockWrite(BagFile, TBuffer, bRead, bWrote);
      until (bRead <> bWrote) or (bRead = 0);

      //Close Source File.
      CloseFile(infile);
    end;
    CloseFile(BagFile);
  end;

  Result := flag;
end;

function TBagFile.UnPak(Filename: string; ExtractTo: string): boolean;
var
  DestFile: file;
  BagFile: file;
  bWrote, bRead: longint;
  lzFullFile: string;
  lzFilePath: string;
  X: integer;
  flag: boolean;
begin
  flag := True;
  FileCount := 0;
  //Open bag file.
  AssignFile(BagFile, Filename);
  Reset(BagFile, 1);
  //Read header info
  BlockRead(BagFile, BagHeader, sizeof(BagHeader));
  BlockRead(BagFile, FileCount, sizeof(FileCount));

  if FileCount = 0 then
  begin
    flag := False;
  end
  else
  begin
    //Extract the files.
    if not DirectoryExists(ExtractTo, True) then
    begin
      ForceDirectories(ExtractTo);
    end;

    bRead := 0;
    bWrote := 0;

    for X := 0 to FileCount - 1 do
    begin
      BlockRead(BagFile, BagFileInfo, Sizeof(BagFileInfo));
      //Full extract to path
      lzFullFile := ExtractTo + BagFileInfo.fName;
      //Get the full path of lzFullFile;
      //Assign out file
      AssignFile(DestFile, lzFullFile);
      Rewrite(DestFile, 1);
      //Write the data in the bag file to the extracted files.
      while BagFileInfo.fSize > sizeof(TBuffer) do
      begin
        blockread(BagFile, TBuffer, sizeof(TBuffer), bRead);
        blockwrite(DestFile, TBuffer, bRead, bWrote);
        Dec(BagFileInfo.fSize, sizeof(TBuffer));
      end;
      blockread(BagFile, TBuffer, BagFileInfo.fSize, bRead);
      blockwrite(DestFile, TBuffer, bRead, bWrote);
      //Close dest file
      CloseFile(DestFile);
    end;
    //Close bag file
    CloseFile(BagFile);

    Result := flag;
  end;
end;

end.
