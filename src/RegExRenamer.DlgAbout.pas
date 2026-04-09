unit RegExRenamer.DlgAbout;

interface

uses
  Winapi.Windows, Winapi.ShellAPI, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TdlgAbout = class(TForm)
    imgLogo: TImage;
    lblHeader: TLabel;
    lblHomepage: TLabel;
    lblEmail: TLabel;
    lblStats: TLabel;
    btnOK: TButton;
    Bevel1: TBevel;
    procedure btnOKClick(Sender: TObject);
    procedure lblHomepageClick(Sender: TObject);
    procedure lblEmailClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    procedure SetStats(ACountProgLaunches, ACountFilesRenamed: Integer);
  end;

implementation

{$R *.dfm}

procedure TdlgAbout.FormCreate(Sender: TObject);
begin
  lblHeader.Caption := 'RegExRenamer v1.0' + sLineBreak +
    'Delphi port of RegexRenamer by Xiperware' + sLineBreak +
    'GNU General Public License';
end;

procedure TdlgAbout.SetStats(ACountProgLaunches, ACountFilesRenamed: Integer);
var
  sLaunches, sFiles: string;
begin
  if ACountProgLaunches = 1 then sLaunches := 'time' else sLaunches := 'times';
  if ACountFilesRenamed = 1 then sFiles := 'file' else sFiles := 'files';

  lblStats.Caption := Format('RegExRenamer has been run %d %s and renamed a total of %d %s.',
    [ACountProgLaunches, sLaunches, ACountFilesRenamed, sFiles]);
end;

procedure TdlgAbout.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TdlgAbout.lblHomepageClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://regexrenamer.sourceforge.net/', nil, nil, SW_SHOWNORMAL);
end;

procedure TdlgAbout.lblEmailClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'mailto:xiperware@gmail.com', nil, nil, SW_SHOWNORMAL);
end;

end.
