program RegExRenamer;

uses
  Vcl.Forms,
  RegExRenamer.FrmMain in 'src\RegExRenamer.FrmMain.pas' {frmMain},
  RegExRenamer.DlgAbout in 'src\RegExRenamer.DlgAbout.pas' {dlgAbout},
  RegExRenamer.DlgRenameError in 'src\RegExRenamer.DlgRenameError.pas' {dlgRenameError},
  RegExRenamer.Types in 'src\RegExRenamer.Types.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'RegExRenamer';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
