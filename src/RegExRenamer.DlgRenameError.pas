unit RegExRenamer.DlgRenameError;

interface

uses
  Winapi.Windows, Winapi.CommCtrl, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls;

type
  TdlgRenameError = class(TForm)
    imgError: TImage;
    lblMessage: TLabel;
    lvwErrors: TListView;
    btnOK: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lvwErrorsEnter(Sender: TObject);
  private
  public
    procedure AddEntry(const AOldName, ANewName, AErrorMessage: string);
    procedure AutoSizeColumns;
    procedure SetMessage(const AMessage: string);
  end;

implementation

{$R *.dfm}

procedure TdlgRenameError.FormCreate(Sender: TObject);
begin
  lvwErrors.ViewStyle := vsReport;
  lvwErrors.ReadOnly := True;
  lvwErrors.RowSelect := True;
  lvwErrors.GridLines := True;
end;

procedure TdlgRenameError.AddEntry(const AOldName, ANewName, AErrorMessage: string);
var
  Item: TListItem;
begin
  Item := lvwErrors.Items.Add;
  Item.Caption := AOldName;
  Item.SubItems.Add(#$2192); // Unicode right arrow
  Item.SubItems.Add(ANewName);
  Item.SubItems.Add('');
  Item.SubItems.Add(StringReplace(AErrorMessage, sLineBreak, ' ', [rfReplaceAll]));
end;

procedure TdlgRenameError.AutoSizeColumns;
var
  I: Integer;
begin
  for I := 0 to lvwErrors.Columns.Count - 1 do
    lvwErrors.Columns[I].Width := LVSCW_AUTOSIZE_USEHEADER;

  // Make error column wider
  if lvwErrors.Columns.Count > 4 then
    lvwErrors.Columns[4].Width := LVSCW_AUTOSIZE;
end;

procedure TdlgRenameError.SetMessage(const AMessage: string);
begin
  lblMessage.Caption := AMessage;
end;

procedure TdlgRenameError.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TdlgRenameError.lvwErrorsEnter(Sender: TObject);
begin
  btnOK.SetFocus;
end;

end.
