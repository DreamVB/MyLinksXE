program mylinks;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}
  cthreads,
                                                           {$ENDIF} {$IFDEF HASAMIGA}
  athreads,
                                                           {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  main,
  Tools,
  addlink,
  linkmove,
  linkshare, about { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Title := 'My Bookmarks XE';
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TfrmLinks, frmLinks);
  Application.CreateForm(TfrmAddLink, frmAddLink);
  Application.CreateForm(TfrmMoveLink, frmMoveLink);
  Application.CreateForm(TfrmShareLink, frmShareLink);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.Run;
end.
