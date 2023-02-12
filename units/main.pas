unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  StdCtrls, Buttons, Tools, addlink, linkmove, LCLType, lclintf,
  Menus, FileBag, httpprotocol, linkshare, Clipbrd, process, IniFiles, Types;

type

  { TfrmLinks }

  TfrmLinks = class(TForm)
    cmdBackup: TSpeedButton;
    cmdCopyUrl: TSpeedButton;
    cmdShareTwitter: TSpeedButton;
    cmdRestore: TSpeedButton;
    cmdCatEdit: TSpeedButton;
    cmdCatDelete: TSpeedButton;
    cmdExportLinks: TSpeedButton;
    cmdOpenLink: TSpeedButton;
    cmdMoveLink: TSpeedButton;
    cmdShortcut: TSpeedButton;
    ImgIcons: TImageList;
    mnuCopyUrl: TMenuItem;
    txtSearchCats: TEdit;
    txtSearchLinks: TEdit;
    lblSearchCats: TLabel;
    lblSearchLinks: TLabel;
    LstLinks: TListBox;
    lstCats: TListBox;
    mnuCatInportLinks: TMenuItem;
    mnuCatExport: TMenuItem;
    mnuCatDelete: TMenuItem;
    mnuCatEdit: TMenuItem;
    Separator2: TMenuItem;
    mnuNewCat: TMenuItem;
    mnuLinkNew: TMenuItem;
    mnuLinkMove: TMenuItem;
    mnuLinkEdit: TMenuItem;
    mnuLinkDelete: TMenuItem;
    mnuCats: TPopupMenu;
    Separator1: TMenuItem;
    mnuOpenLink: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    pBase: TPanel;
    cmdCatAdd: TSpeedButton;
    cmdLinkAdd: TSpeedButton;
    cmdLinkEdit: TSpeedButton;
    cmdLinksDelete: TSpeedButton;
    mnuLinks: TPopupMenu;
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    procedure cmdBackupClick(Sender: TObject);
    procedure cmdCatAddClick(Sender: TObject);
    procedure cmdCatDeleteClick(Sender: TObject);
    procedure cmdCatEditClick(Sender: TObject);
    procedure cmdCopyUrlClick(Sender: TObject);
    procedure cmdExportLinksClick(Sender: TObject);
    procedure cmdLinkAddClick(Sender: TObject);
    procedure cmdLinkEditClick(Sender: TObject);
    procedure cmdLinksDeleteClick(Sender: TObject);
    procedure cmdMoveLinkClick(Sender: TObject);
    procedure cmdOpenLinkClick(Sender: TObject);
    procedure cmdRestoreClick(Sender: TObject);
    procedure cmdShareTwitterClick(Sender: TObject);
    procedure cmdShortcutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstCatsClick(Sender: TObject);
    procedure lstCatsDblClick(Sender: TObject);
    procedure lstCatsDrawItem(Control: TWinControl; Index: integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure lstCatsKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure lstCatsMeasureItem(Control: TWinControl; Index: integer;
      var AHeight: integer);
    procedure LstLinksClick(Sender: TObject);
    procedure LstLinksDblClick(Sender: TObject);
    procedure LstLinksDrawItem(Control: TWinControl; Index: integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure LstLinksKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure LstLinksMeasureItem(Control: TWinControl; Index: integer;
      var AHeight: integer);
    procedure mnuCatDeleteClick(Sender: TObject);
    procedure mnuCatEditClick(Sender: TObject);
    procedure mnuCatExportClick(Sender: TObject);
    procedure mnuCatInportLinksClick(Sender: TObject);
    procedure mnuCopyUrlClick(Sender: TObject);
    procedure mnuLinkDeleteClick(Sender: TObject);
    procedure mnuLinkEditClick(Sender: TObject);
    procedure mnuLinkMoveClick(Sender: TObject);
    procedure mnuLinkNewClick(Sender: TObject);
    procedure mnuNewCatClick(Sender: TObject);
    procedure txtSearchCatsChange(Sender: TObject);
    procedure txtSearchLinksChange(Sender: TObject);
  private
    procedure LoadCats;
    procedure ErrorMsgCat(S: string);
    procedure AddLinkInfo(lName, lAddress: string);
    procedure LoadLinks;
    procedure EditCatLink(lName, lAddress: string; Index: integer);
    procedure DeleteLink(Index: integer);
    function GetLinkName(Index: integer): string;
    function GetLinkUrl(Index: integer): string;
    procedure MoveLinkToCat(MoveToCat: string; Index: integer);
    procedure BackupLinks;
    procedure RestoreLinks;
    function GetDlgSaveName(Title, dFilter, Filename, defExt: string): string;
    function GetDlgOpenName(Title, dFilter: string): string;
    procedure MoveToListIndex(sItem: string; lBox: TListBox);
    procedure SearchListBox(sFind: string; lBox: TListBox);
    function GetProfileName: string;
    procedure LoadBrowsers;
    procedure Broswer_Click(Sender: TObject);
  public

  end;

var
  frmLinks: TfrmLinks;
  CatLinks, Broswers: TStringList;
  CatLinkID: integer;
  CatName: string;

const
  BadCatName = 'Category name contains illegal characters.' +
    sLineBreak + sLineBreak +
    'The category name cannot contain any of the following characters \ / : * ? " < > |';

const
  BackupFaild = 'Backup process failed.';

implementation

{$R *.lfm}

{ TfrmLinks }

procedure TfrmLinks.LoadBrowsers;
var
  mi: TMenuItem;
  sSelection: string;
  ini: TIniFile;
  X: integer;
begin

  ini := TIniFile.Create(AppPath + 'broswers.ini');
  Broswers := TStringList.Create;
  ini.ReadSections(Broswers);

  for X := 0 to Broswers.Count - 1 do
  begin
    sSelection := Broswers[X];
    mi := TMenuItem.Create(mnuOpenLink);
    mi.Caption := ini.ReadString(sSelection, 'Name', 'Untitled');
    mi.Tag := X;
    mi.OnClick := @Broswer_Click;
    mnuOpenLink.Add(mi);
  end;

  FreeAndNil(ini);
end;

procedure TfrmLinks.Broswer_Click(Sender: TObject);
var
  mi: TMenuItem;
  exec, sSelection: string;
  ini: TIniFile;
  p: TProcess;
  Id: integer;
begin
  mi := TMenuItem(Sender);
  ini := TIniFile.Create(AppPath + 'broswers.ini');
  p := TProcess.Create(self);
  //Get ini selection
  sSelection := Broswers[mi.Tag];
  //Get broswer exe
  exec := ini.ReadString(sSelection, 'Path', '');

  if not FileExists(exec) then
  begin
    MessageDlg(Text, 'Can Not Find File:' + sLineBreak + sLineBreak + exec,
      mtWarning, [mbOK], 0);
    Exit;
  end;

  //Create process
  Id := LstLinks.ItemIndex;
  if (lstCats.ItemIndex <> -1) and (Id <> -1) then
  begin
    p.Executable := exec;
    p.Parameters.Add(GetLinkUrl(ID));
    p.Execute;
  end;
  FreeAndNil(p);
  FreeAndNil(ini);
end;

function TfrmLinks.GetProfileName: string;
var
  S1, S2, S3: string;
begin

  S1 := GetEnvironmentVariable('USER');
  S2 := GetEnvironmentVariable('USERNAME');
  if S1 <> '' then
  begin
    S3 := S1;
  end;

  if S2 <> '' then
  begin
    S3 := S2;
  end;

  if (S1 = '') and (S2 = '') then
  begin
    S3 := 'sites';
  end;

  Result := S3;
end;

procedure TfrmLinks.SearchListBox(sFind: string; lBox: TListBox);
var
  X: integer;
  sLeft: string;
begin
  sLeft := '';
  lBox.ItemIndex := -1;

  for X := 0 to lBox.Count - 1 do
  begin

    sLeft := lowercase(leftstr(lBox.Items[X], length(sFind)));

    if lowercase(sFind) = sLeft then
    begin
      lBox.ItemIndex := X;
    end;
  end;
end;

procedure TfrmLinks.MoveToListIndex(sItem: string; lBox: TListBox);
var
  X: integer;
begin
  if sItem <> '' then
  begin
    for X := 0 to lBox.Count - 1 do
    begin
      if lowercase(lBox.Items[X]) = lowercase(sItem) then
      begin
        //Select the link name
        lBox.ItemIndex := X;
        Break;
      end;
    end;
  end;
end;

function TfrmLinks.GetDlgOpenName(Title, dFilter: string): string;
var
  lzFile: string;
  od: TOpenDialog;
begin
  od := TOpenDialog.Create(self);
  od.Title := Title;
  od.Filter := dFilter;
  if od.Execute then
  begin
    lzFile := od.FileName;
  end;
  FreeAndNil(od);
  Result := lzFile;
end;

function TfrmLinks.GetDlgSaveName(Title, dFilter, Filename, defExt: string): string;
var
  sd: TSaveDialog;
  lzFile: string;
begin
  sd := TSaveDialog.Create(self);
  sd.Title := Title;
  sd.FileName := Filename;
  sd.Filter := dFilter;
  sd.DefaultExt := defExt;

  if sd.Execute then
  begin
    lzFile := sd.FileName;
  end;

  if FileExists(lzFile) then
  begin
    if MessageDlg(Text, 'The filename ' + sd.FileName + ' already exsits.' +
      sLineBreak + sLineBreak + 'Do you want to replace the filename now?',
      mtInformation, [mbYes, mbNo], 0) <> mrYes then
    begin
      lzFile := '';
    end;
  end;

  FreeAndNil(sd);
  Result := lzFile;

end;

procedure TfrmLinks.RestoreLinks;
var
  lzFile: string;
  pak: TBagFile;
begin
  //Get open filename
  lzFile := GetDlgOpenName('Restore Backup', 'Bag Files(*.bag)|*.bag');

  if lzFile <> '' then
  begin
    pak := TBagFile.Create;
    if pak.UnPak(lzFile, BasePath) then
    begin
      MessageDlg(Text, 'Restore complete.', mtInformation, [mbOK], 0);
      CatLinkID := -1;
      LoadCats;
      LstLinks.Clear;
    end
    else
    begin
      ErrorMsgCat('Restore process failed.');
    end;
  end;
end;

procedure TfrmLinks.BackupLinks;
var
  pak: TBagFile;
  sr: TSearchRec;
  SrcFile, lzFile, sBackupName: string;
begin
  pak := TBagFile.Create;

  //Create backup name
  sBackupName := FormatDateTime('DDMMYY_MMHHMMSS', Now);

  if FindFirst(BasePath + '*.cat', faAnyFile, sr) = 0 then
  begin
    repeat
      SrcFile := BasePath + sr.Name;
      pak.AddFile(SrcFile);
    until FindNext(sr) <> 0;
  end;

  //Get filename from save dialog.
  lzFile := GetDlgSaveName('Backup', 'Bag Files(*.bag)|*.bag', sBackupName, 'bag');

  if lzFile <> '' then
  begin
    if pak.Pak(lzFile) then
    begin
      MessageDlg(Text, 'Backup complete.', mtInformation, [mbOK], 0);
    end
    else
    begin
      ErrorMsgCat(BackupFaild);
    end;
  end;

  FreeAndNil(pak);
end;

function TfrmLinks.GetLinkName(Index: integer): string;
var
  sPos: integer;
begin
  sPos := Pos('|', CatLinks[Index]);
  if sPos > 0 then
  begin
    Result := LeftStr(CatLinks[Index], sPos - 1);
  end;
end;

function TfrmLinks.GetLinkUrl(Index: integer): string;
var
  sPos: integer;
begin
  sPos := Pos('|', CatLinks[Index]);
  if sPos > 0 then
  begin
    Result := Copy(CatLinks[Index], sPos + 1);
  end;
end;

procedure TfrmLinks.LoadLinks;
var
  I, sPos: integer;
  sLine: string;
begin
  if FileExists(SelectedCatName) then
  begin
    CatLinks.LoadFromFile(SelectedCatName);
    //Load into listbox
    LstLinks.Clear;
    CatLinks.Sort;
    for I := 0 to CatLinks.Count - 1 do
    begin
      sLine := Trim(CatLinks[I]);
      //Loop for | seperator
      sPos := Pos('|', sLine);
      if sPos > 0 then
      begin
        //Add link name to listbox
        LstLinks.Items.Add(LeftStr(sLine, sPos - 1));
      end;
    end;
  end;
end;

procedure TfrmLinks.ErrorMsgCat(S: string);
begin
  MessageDlg(Text, S, mtInformation, [mbOK], 0);
end;

procedure TfrmLinks.AddLinkInfo(lName, lAddress: string);
begin
  CatLinks.Add(lName + '|' + lAddress);
  CatLinks.SaveToFile(SelectedCatName);
end;

procedure TfrmLinks.EditCatLink(lName, lAddress: string; Index: integer);
begin
  CatLinks[Index] := lName + '|' + lAddress;
  CatLinks.SaveToFile(SelectedCatName);
end;

procedure TfrmLinks.DeleteLink(Index: integer);
begin
  CatLinks.Delete(Index);
  CatLinks.SaveToFile(SelectedCatName);
end;

procedure TfrmLinks.MoveLinkToCat(MoveToCat: string; Index: integer);
var
  Temp: TStringList;
begin

  Temp := TStringList.Create;
  Temp.LoadFromFile(MoveToCat);
  Temp.Add(CatLinks[Index]);
  Temp.SaveToFile(MoveToCat);

  //Delete from original
  CatLinks.Delete(Index);
  CatLinks.SaveToFile(SelectedCatName);
  LstLinks.Items.Delete(Index);
end;

procedure TfrmLinks.LoadCats;
var
  sr: TSearchRec;
begin
  if FindFirst(BasePath + '*.cat', faAnyFile, sr) = 0 then
  begin
    lstCats.Clear;
    repeat
      lstCats.Items.Add(RemoveExt(sr.Name));
    until FindNext(sr) <> 0;
  end;
  if lstcats.Count > 0 then
  begin
    lstCats.ItemIndex := 0;
    lstCatsClick(nil);
  end;
end;

procedure TfrmLinks.FormCreate(Sender: TObject);

begin
  AppPath := FixPath(ExtractFileDir(Application.ExeName));

  ExportTemplate := AppPath + 'export.tpl';

  BasePath := AppPath + 'profiles' + PathDelim + GetProfileName + PathDelim;

  if not DirectoryExists(BasePath) then
  begin
    ForceDirectories(BasePath);
  end;

  LoadBrowsers;

  CatLinkID := -1;
  CatLinks := TStringList.Create;
  LoadCats;

end;

procedure TfrmLinks.cmdCatAddClick(Sender: TObject);
var
  S: string;
  isOk: boolean;
begin
  S := '';
  isOk := InputQuery('New', 'Name:', S);

  if (isOk) and (Trim(S) <> '') then
  begin
    case AddCat(S) of
      0:
      begin
        ErrorMsgCat(BadCatName);
      end;
      1:
      begin
        ErrorMsgCat('The category "' + S + '" already exists.');
      end;
      2:
      begin
        //Add to the listbox
        lstCats.Items.Add(S);
        //Select the last added item
        //Check for selected link name
        MoveToListIndex(S, lstCats);
        lstCatsClick(Sender);
      end;
      else
      begin
        Exit;
      end;
    end;
  end;
end;

procedure TfrmLinks.cmdCatDeleteClick(Sender: TObject);
begin
  if lstCats.ItemIndex <> -1 then
  begin
    if MessageDlg(Text, 'You are about the delete the category "' +
      CatName + '"' + sLineBreak + 'Any links will also be removed.' +
      sLineBreak + sLineBreak + 'Are you sure you want to continue?',
      mtInformation, [mbYes, mbNo], 0) = mrYes then
    begin
      //Delete the file.
      DeleteFile(SelectedCatName);
      //Remove from the list
      lstCats.Items.Delete(lstCats.ItemIndex);
      //Clear the links
      LstLinks.Clear;
      CatLinks.Clear;
    end;
  end;
end;

procedure TfrmLinks.cmdCatEditClick(Sender: TObject);
var
  S, S1: string;
  isOk: boolean;
begin
  if lstCats.ItemIndex <> -1 then
  begin
    S := lstCats.Items[lstCats.ItemIndex];
    S1 := S;

    isOk := InputQuery('Edit', 'Name:', S);
    if (isOk) and (Trim(S) <> '') then
    begin
      case EditCat(S1, S) of
        0:
        begin
          ErrorMsgCat(BadCatName);
        end;
        2:
        begin
          //Add to the listbox
          lstCats.Sorted := False;
          lstCats.Items[lstCats.ItemIndex] := S;
          lstCats.Sorted := True;
          MoveToListIndex(S, lstCats);
          lstCatsClick(Sender);
        end;
        else
        begin
          Exit;
        end;
      end;
    end;
  end;
end;

procedure TfrmLinks.cmdCopyUrlClick(Sender: TObject);
var
  ID: integer;

begin
  //Get link ID
  ID := LstLinks.ItemIndex;

  if (lstCats.ItemIndex <> -1) and (ID <> -1) then
  begin
    //Copy link url to clipboard.
    Clipboard.AsText := GetLinkUrl(ID);
  end;
end;

procedure TfrmLinks.cmdExportLinksClick(Sender: TObject);
var
  lst: TStringList;
  iData: TStringList;
  sData, lzFile: string;
  I: integer;
  tf: TextFile;
  sName, sLink, cName: string;
begin

  if (lstCats.ItemIndex <> -1) and (LstLinks.Count > 0) then
  begin
    cName := lstCats.Items[lstCats.ItemIndex];
    //Load template
    iData := TStringList.Create;
    iData.LoadFromFile(ExportTemplate);
    //Get save filename
    lzFile := GetDlgSaveName('Export', 'Html Files(*.html)|*.html|All Files(*.*)|*.*',
      cName, 'html');

    if lzFile <> '' then
    begin
      //Create string list for html data
      lst := TStringList.Create;
      for I := 0 to CatLinks.Count - 1 do
      begin
        sName := GetLinkName(I);
        sLink := GetLinkUrl(I);
        lst.Add('  <a href="' + sLink + '" target="_blank">' + sName + '</a>');
      end;

      sData := iData.Text;
      sData := StringReplace(sData, '%LINKS_DATA%', lst.Text,
        [rfIgnoreCase, rfReplaceAll]);
      sData := StringReplace(sData, '%TITLE%', cName, [rfIgnoreCase, rfReplaceAll]);

      //Write data to source file.
      AssignFile(tf, lzFile);
      Rewrite(tf);
      Write(tf, sData);
      CloseFile(tf);

      //Clear up
      sData := '';
      FreeAndNil(lst);
      FreeAndNil(iData);
    end;
  end;
end;

procedure TfrmLinks.cmdLinkAddClick(Sender: TObject);
var
  frm: TfrmAddLink;
begin

  if lstCats.ItemIndex <> -1 then
  begin
    Tools.ButtonPress := 0;
    frm := TfrmAddLink.Create(self);
    frm.cmdOK.Caption := 'Add';
    frm.Caption := 'New';
    frm.ShowModal;
    if ButtonPress = 1 then
    begin
      AddLinkInfo(Tools.LinkName, Tools.LinkUrl);
      //Reload links
      LoadLinks;
      MoveToListIndex(Tools.LinkName, LstLinks);
    end;
    FreeAndNil(frm);
  end;
end;

procedure TfrmLinks.cmdLinkEditClick(Sender: TObject);
var
  frm: TfrmAddLink;
begin

  CatLinkID := LstLinks.ItemIndex;

  if (lstCats.ItemIndex <> -1) and (CatLinkID <> -1) then
  begin
    Tools.ButtonPress := 0;
    frm := TfrmAddLink.Create(self);
    frm.cmdOK.Caption := 'Update';
    frm.Caption := 'Edit';
    frm.lblLinkName.Text := GetLinkName(CatLinkID);
    frm.lblLinkAddress.Text := GetLinkUrl(CatLinkID);
    frm.ShowModal;
    if ButtonPress = 1 then
    begin
      //Update catLinks.
      EditCatLink(Tools.LinkName, Tools.LinkUrl, CatLinkID);
      //Reload links
      LoadLinks;
      MoveToListIndex(Tools.LinkName, LstLinks);
    end;
    FreeAndNil(frm);
  end;
end;

procedure TfrmLinks.cmdLinksDeleteClick(Sender: TObject);
var
  oId: integer;
begin
  oId := LstLinks.ItemIndex;

  if (lstCats.ItemIndex <> -1) and (oId <> -1) then
  begin
    if MessageDlg(Text, 'Are you sure you want to delete the hyperlink' +
      sLineBreak + sLineBreak + '"' + LstLinks.Items[oId] + '"',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      //Delete the link
      DeleteLink(oId);
      //Remove from the list
      LstLinks.Items.Delete(oId);
    end;
  end;
end;

procedure TfrmLinks.cmdMoveLinkClick(Sender: TObject);
var
  frm: TfrmMoveLink;
  lzCatFile: string;
begin
  if (lstCats.ItemIndex <> -1) and (LstLinks.ItemIndex <> -1) then
  begin
    Tools.ButtonPress := 0;
    Tools.LinksMoveFromCat := lstCats.Items[lstCats.ItemIndex];
    frm := TfrmMoveLink.Create(self);
    frm.ShowModal;
    if Tools.ButtonPress = 1 then
    begin
      //New file to move to
      lzCatFile := BasePath + Tools.LinksMoveToCat + '.cat';
      //Do the move
      MoveLinkToCat(lzCatFile, LstLinks.ItemIndex);
    end;
    FreeAndNil(frm);
  end;
end;

procedure TfrmLinks.cmdOpenLinkClick(Sender: TObject);
begin
  LstLinksDblClick(Sender);
end;

procedure TfrmLinks.cmdRestoreClick(Sender: TObject);
begin
  RestoreLinks;
end;

procedure TfrmLinks.cmdShareTwitterClick(Sender: TObject);
var
  ID: integer;
  frm: TfrmShareLink;
begin
  ID := LstLinks.ItemIndex;
  Tools.ButtonPress := 0;
  //Email a link to someone
  if (lstCats.ItemIndex <> -1) and (ID <> -1) then
  begin
    frm := TfrmShareLink.Create(self);
    Tools.LinkShareUrl := GetLinkUrl(ID);
    frm.ShowModal;
    if ButtonPress = 1 then
    begin
      OpenDocument(Tools.LinkShareSrc);
    end;
    FreeAndNil(frm);
  end;
end;

procedure TfrmLinks.cmdShortcutClick(Sender: TObject);
var
  tf: TextFile;
  ID: integer;
  lzFile, cName, cUrl: string;
begin

  ID := LstLinks.ItemIndex;

  if (lstCats.ItemIndex <> -1) and (ID <> -1) then
  begin
    cName := GetLinkName(ID);
    cUrl := GetLinkUrl(ID);

    lzFile := GetDlgSaveName('Save Shortcut', 'Shortcut Files(*.url)|*.url',
      cName, 'url');

    if lzFile <> '' then
    begin
      //Write internet shortcut
      AssignFile(tf, lzFile);
      Rewrite(tf);
      Writeln(tf, '[InternetShortcut]');
      Writeln(tf, 'URL=' + cUrl);
      CloseFile(tf);
    end;

  end;
end;

procedure TfrmLinks.cmdBackupClick(Sender: TObject);
begin
  BackupLinks;
end;

procedure TfrmLinks.lstCatsClick(Sender: TObject);
begin
  if lstCats.ItemIndex <> -1 then
  begin
    CatName := lstCats.Items[lstCats.ItemIndex];
    SelectedCatName := BasePath + CatName + '.cat';
    //Load links into listbox.
    LoadLinks;
  end;
end;

procedure TfrmLinks.lstCatsDblClick(Sender: TObject);
begin
  cmdCatEditClick(Sender);
end;

procedure TfrmLinks.lstCatsDrawItem(Control: TWinControl; Index: integer;
  ARect: TRect; State: TOwnerDrawState);
var
  YPos: integer;
begin
  lstCats.Canvas.FillRect(ARect);

  ImgIcons.Draw(lstCats.Canvas, ARect.Left + 4, ARect.Top + 4, 0);

  YPos := (ARect.Bottom - ARect.Top - lstCats.Canvas.TextHeight(Text)) div 2;

  lstCats.Canvas.TextOut(ARect.left + ImgIcons.Width + 8, ARect.Top + YPos,
    lstCats.Items.Strings[index]);

end;

procedure TfrmLinks.lstCatsKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    cmdCatDeleteClick(Sender);
  end;
  if Key = VK_RETURN then
  begin
    cmdCatEditClick(Sender);
  end;
end;

procedure TfrmLinks.lstCatsMeasureItem(Control: TWinControl; Index: integer;
  var AHeight: integer);
begin
  AHeight := ImgIcons.Height + 4;
end;

procedure TfrmLinks.LstLinksClick(Sender: TObject);
begin
  CatLinkID := LstLinks.ItemIndex;
end;

procedure TfrmLinks.LstLinksDblClick(Sender: TObject);
begin
  if LstLinks.ItemIndex <> -1 then
  begin
    if not OpenLink(GetLinkUrl(LstLinks.ItemIndex)) then
    begin
      MessageDlg(Text, 'There was an error opening the hyperlink.', mtError,
        [mbOK], 0);
    end;
  end;
end;

procedure TfrmLinks.LstLinksDrawItem(Control: TWinControl; Index: integer;
  ARect: TRect; State: TOwnerDrawState);
var
  YPos: integer;
begin
  LstLinks.Canvas.FillRect(ARect);

  ImgIcons.Draw(LstLinks.Canvas, ARect.Left + 4, ARect.Top + 4, 1);

  YPos := (ARect.Bottom - ARect.Top - LstLinks.Canvas.TextHeight(Text)) div 2;

  LstLinks.Canvas.TextOut(ARect.left + ImgIcons.Width + 8, ARect.Top + YPos,
    LstLinks.Items.Strings[index]);

end;

procedure TfrmLinks.LstLinksKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    cmdLinksDeleteClick(Sender);
  end;
  if Key = VK_RETURN then
  begin
    cmdOpenLinkClick(Sender);
  end;
end;

procedure TfrmLinks.LstLinksMeasureItem(Control: TWinControl;
  Index: integer; var AHeight: integer);
begin
  AHeight := ImgIcons.Height + 4;
end;

procedure TfrmLinks.mnuCatDeleteClick(Sender: TObject);
begin
  cmdCatDeleteClick(Sender);
end;

procedure TfrmLinks.mnuCatEditClick(Sender: TObject);
begin
  cmdCatEditClick(Sender);
end;

procedure TfrmLinks.mnuCatExportClick(Sender: TObject);
var
  lzCopyFrom, lzCatName, lzFile: string;
  sData: TStringList;
begin

  lzCatName := lstCats.Items[lstCats.ItemIndex];
  lzCopyFrom := BasePath + lzCatName + '.cat';
  sData := TStringList.Create;

  //Get save filename
  lzFile := GetDlgSaveName('Export', 'Cat Files(*.cat)|*.cat', lzCatName, 'cat');

  if lzFile <> '' then
  begin
    sData.LoadFromFile(lzCopyFrom);
    sData.SaveToFile(lzFile);
  end;

  FreeAndNil(sData);
end;

procedure TfrmLinks.mnuCatInportLinksClick(Sender: TObject);
var
  sLine, sLinkName, lzFile: string;
  sData: TStringList;
  X, oId: integer;
begin
  oId := LstLinks.ItemIndex;
  //Check for vaild index
  if oId <> -1 then
  begin
    //Get selected link name
    sLinkName := GetLinkName(oId);
  end;

  if (lstCats.ItemIndex <> -1) then
  begin
    //Get open filename
    lzFile := GetDlgOpenName('Inport', 'Cat Files(*.cat)|*.cat');

    if lzFile <> '' then
    begin
      sData := TStringList.Create;
      //Open the source file
      sData.LoadFromFile(lzFile);
      //Load sData into CatLinks object
      for X := 0 to sData.Count - 1 do
      begin
        sline := Trim(sData[X]);
        if sLine <> '' then
        begin
          CatLinks.Add(sLine);
        end;
      end;
      //Save the links
      CatLinks.SaveToFile(SelectedCatName);
      //Reload the links
      LoadLinks;
      MoveToListIndex(sLinkName, LstLinks);
      //Clear up
      FreeAndNil(sData);
    end;
  end;
end;

procedure TfrmLinks.mnuCopyUrlClick(Sender: TObject);
begin
  cmdCopyUrlClick(Sender);
end;

procedure TfrmLinks.mnuLinkDeleteClick(Sender: TObject);
begin
  cmdLinksDeleteClick(Sender);
end;

procedure TfrmLinks.mnuLinkEditClick(Sender: TObject);
begin
  cmdLinkEditClick(Sender);
end;

procedure TfrmLinks.mnuLinkMoveClick(Sender: TObject);
begin
  cmdMoveLinkClick(Sender);
end;

procedure TfrmLinks.mnuLinkNewClick(Sender: TObject);
begin
  cmdLinkAddClick(Sender);
end;

procedure TfrmLinks.mnuNewCatClick(Sender: TObject);
begin
  cmdCatAddClick(Sender);
end;

procedure TfrmLinks.txtSearchCatsChange(Sender: TObject);
begin
  SearchListBox(txtSearchCats.Text, lstCats);
  lstCatsClick(Sender);
end;

procedure TfrmLinks.txtSearchLinksChange(Sender: TObject);
begin
  SearchListBox(txtSearchLinks.Text, LstLinks);
end;

end.
