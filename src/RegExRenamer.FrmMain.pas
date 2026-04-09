unit RegExRenamer.FrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, Winapi.ShlObj,
  System.SysUtils, System.Classes, System.IOUtils, System.Types,
  System.RegularExpressions, System.Generics.Collections,
  System.Generics.Defaults, System.Win.Registry, System.Character,

  System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Menus, Vcl.Buttons, Vcl.ActnList,
  Vcl.ImgList, Vcl.Shell.ShellCtrls, Vcl.FileCtrl,
  RegExRenamer.Types, System.Actions, System.ImageList, Vcl.ToolWin;

type
  TChangeCaseMode = (ccNone, ccUppercase, ccLowercase, ccTitlecase);

  TRenameThread = class(TThread)
  private
    FActiveFiles: TRRItemList;
    FRenameFolders: Boolean;
    FPreserveExt: Boolean;
    FRenameInPlace: Boolean;
    FMoveTo: Boolean;
    FCopyTo: Boolean;
    FBackupTo: Boolean;
    FRenameSelectedOnly: Boolean;
    FActivePath: string;
    FOutputPath: string;
    FBackupPath: string;
    FProgress: Integer;
    FCancelled: Boolean;
    FCountSuccess: Integer;
    FCountErrors: Integer;
    FErrors: TList<TPair<string, TPair<string, string>>>; // old, new, error
    procedure DoProgress;
  protected
    procedure Execute; override;
  public
    constructor Create(AActiveFiles: TRRItemList; const AActivePath, AOutputPath,
      ABackupPath: string; ARenameFolders, APreserveExt, ARenameInPlace,
      AMoveTo, ACopyTo, ABackupTo, ARenameSelectedOnly: Boolean);
    destructor Destroy; override;
    property Progress: Integer read FProgress;
    property CountSuccess: Integer read FCountSuccess;
    property CountErrors: Integer read FCountErrors;
    property Errors: TList<TPair<string, TPair<string, string>>> read FErrors;
    property Cancelled: Boolean read FCancelled;
  end;

  TfrmMain = class(TForm)
    splMain: TSplitter;
    tlbMain: TToolBar;
    tbnChangeCase: TToolButton;
    tbnSep1: TToolButton;
    tbnNumbering: TToolButton;
    tbnSep2: TToolButton;
    tbnMoveCopy: TToolButton;
    pnlLeft: TPanel;
    ShellTree: TShellTreeView;
    pnlPath: TPanel;
    txtPath: TEdit;
    btnNetwork: TButton;
    pnlRight: TPanel;
    splRegex: TSplitter;
    pnlRegex: TPanel;
    lblMatch: TLabel;
    lblReplace: TLabel;
    cmbMatch: TComboBox;
    txtReplace: TEdit;
    cbModifierI: TCheckBox;
    cbModifierG: TCheckBox;
    cbModifierX: TCheckBox;
    gbFilter: TGroupBox;
    txtFilter: TEdit;
    rbFilterGlob: TRadioButton;
    rbFilterRegex: TRadioButton;
    cbFilterExclude: TCheckBox;
    lblStats: TLabel;
    pnlStats: TPanel;
    lblStatsTotal: TLabel;
    lblStatsShown: TLabel;
    lblStatsFiltered: TLabel;
    lblStatsHidden: TLabel;
    lvFiles: TListView;
    pnlBottom: TPanel;
    lblNumMatched: TLabel;
    lblNumConflict: TLabel;
    btnRename: TButton;
    btnRenameDrop: TSpeedButton;
    btnCancel: TButton;
    ProgressBar: TProgressBar;
    btnOptions: TButton;
    btnHelp: TButton;
    ilFiles: TImageList;
    pmChangeCase: TPopupMenu;
    itmChangeCaseNoChange: TMenuItem;
    itmChangeCaseSep: TMenuItem;
    itmChangeCaseUppercase: TMenuItem;
    itmChangeCaseLowercase: TMenuItem;
    itmChangeCaseTitlecase: TMenuItem;
    pmNumbering: TPopupMenu;
    itmNumberingStart: TMenuItem;
    itmNumberingPad: TMenuItem;
    itmNumberingInc: TMenuItem;
    itmNumberingReset: TMenuItem;
    pmMoveCopy: TPopupMenu;
    itmOutputRenameInPlace: TMenuItem;
    itmOutputSep: TMenuItem;
    itmOutputMoveTo: TMenuItem;
    itmOutputCopyTo: TMenuItem;
    itmOutputBackupTo: TMenuItem;
    pmOptions: TPopupMenu;
    itmOptionsShowHidden: TMenuItem;
    itmOptionsPreserveExt: TMenuItem;
    itmOptionsRealtimePreview: TMenuItem;
    itmOptionsAllowRenSub: TMenuItem;
    itmOptionsSep1: TMenuItem;
    itmOptionsRememberWinPos: TMenuItem;
    itmOptionsRenameSelectedRows: TMenuItem;
    itmOptionsSep2: TMenuItem;
    itmOptionsAddContextMenu: TMenuItem;
    pmHelp: TPopupMenu;
    itmHelpAbout: TMenuItem;
    pmRenameMode: TPopupMenu;
    itmRenameFiles: TMenuItem;
    itmRenameFolders: TMenuItem;
    pmRegexMatch: TPopupMenu;
    pmRegexReplace: TPopupMenu;
    pmGlobMatch: TPopupMenu;
    ActionList: TActionList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ShellTreeChange(Sender: TObject; Node: TTreeNode);
    procedure cmbMatchChange(Sender: TObject);
    procedure cmbMatchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cmbMatchSelect(Sender: TObject);
    procedure txtReplaceChange(Sender: TObject);
    procedure txtReplaceKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbModifierClick(Sender: TObject);
    procedure txtFilterChange(Sender: TObject);
    procedure txtFilterKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure rbFilterTypeClick(Sender: TObject);
    procedure cbFilterExcludeClick(Sender: TObject);
    procedure txtPathKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnNetworkClick(Sender: TObject);
    procedure lvFilesColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvFilesCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lvFilesDblClick(Sender: TObject);
    procedure lvFilesDrawItem(Sender: TCustomListView; Item: TListItem;
      Rect: TRect; State: TOwnerDrawState);
    procedure lvFilesKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lvFilesSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure lblStatsMouseEnter(Sender: TObject);
    procedure lblStatsMouseLeave(Sender: TObject);
    procedure itmChangeCaseClick(Sender: TObject);
    procedure itmNumberingClick(Sender: TObject);
    procedure itmOutputClick(Sender: TObject);
    procedure itmOptionsShowHiddenClick(Sender: TObject);
    procedure itmOptionsPreserveExtClick(Sender: TObject);
    procedure itmOptionsRealtimePreviewClick(Sender: TObject);
    procedure itmOptionsAllowRenSubClick(Sender: TObject);
    procedure itmOptionsAddContextMenuClick(Sender: TObject);
    procedure itmHelpAboutClick(Sender: TObject);
    procedure itmRenameModeClick(Sender: TObject);
    procedure btnRenameClick(Sender: TObject);
    procedure btnRenameDropClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FActiveFiles: TRRItemList;
    FInactiveFiles: TInactiveFileDict;
    FIconCache: TDictionary<string, Integer>;
    FInsertArgsObjects: TObjectList<TInsertArgsObject>;
    FActivePath: string;
    FActiveFilter: string;
    FMoveCopyPath: string;
    FFileCount: TFileCount;
    FEnableUpdates: Boolean;
    FRenameFolders: Boolean;
    FValidFilter: Boolean;
    FValidMatch: Boolean;
    FValidNumber: Boolean;
    FCountProgLaunches: Integer;
    FCountFilesRenamed: Integer;
    FChangeCaseMode: TChangeCaseMode;
    FNumberingStart: string;
    FNumberingPad: string;
    FNumberingInc: string;
    FNumberingReset: string;
    FRenameThread: TRenameThread;
    FSortColumn: Integer;
    FSortAscending: Boolean;
    FLastControlRightClicked: TControl;
    FPrevMatch: string;
    FPrevReplace: string;
    FOldCmbMatchWndProc: TWndMethod;
    FOldTxtReplaceWndProc: TWndMethod;
    FOldTxtFilterWndProc: TWndMethod;
    // Error tracking per listview item: index -> error string
    FPreviewErrors: TDictionary<Integer, string>;

    MAX_FILES: Integer;

    procedure SetEnableUpdates(Value: Boolean);
    procedure SetRenameFolders(Value: Boolean);
    function PreviewNeedsUpdate: Boolean;
    procedure ResetPreviewNeedsUpdate;

    // Core methods
    procedure LoadSettings;
    procedure SaveSettings;
    procedure LoadRegexHistory;
    procedure SaveRegexHistory;
    procedure UpdateFileList;
    procedure UpdatePreview;
    procedure UpdateValidation;
    procedure UpdateSelection;
    procedure UpdateFileStats;
    procedure ResetFields;

    // Validation
    function ValidateGlob(const ATestGlob: string): string;
    function ValidateRegex(const ATestRegex: string): string;
    function ValidateFilename(const ATestFilename: string; AAllowRenSub: Boolean): string;
    procedure ValidateMatch;
    procedure ValidateFilter;
    procedure ApplyFilter;

    // Helpers
    function GetStrFile: string;
    function GetStrFilename: string;
    function RegExReplaceCount(const AInput, APattern, AReplacement: string;
      AOptions: TRegExOptions; ACount: Integer): string;
    class function SequenceNumberToLetter(ANum: Integer): string; static;
    class function SequenceLetterToNumber(const ALetter: string): Integer; static;
    function MatchEvalChangeCase(const AMatch: TMatch): string;
    function GetFileIcon(const AFilePath: string; AByExtension: Boolean): Integer;
    function GetFolderIcon: Integer;

    // Context menu
    procedure BuildRegexContextMenus;
    procedure InsertRegexFragment(Sender: TObject);
    function AddContextMenuItem(AMenu: TPopupMenu; const ACaption: string;
      const AArgs: TInsertArgs; ABreak: Boolean = False): TMenuItem;

    // WindowProc interceptors for mouse down on controls
    procedure CmbMatchWndProc(var Message: TMessage);
    procedure TxtReplaceWndProc(var Message: TMessage);
    procedure TxtFilterWndProc(var Message: TMessage);

    // Rename thread
    procedure OnRenameThreadTerminate(Sender: TObject);
    procedure OnRenameProgress(Sender: TObject);
  end;

var
  frmMain: TfrmMain;

implementation

uses
  RegExRenamer.DlgAbout, RegExRenamer.DlgRenameError;

{$R *.dfm}

const
  MAX_HISTORY = 20;

// Helper: check if $ at position Pos in S is a real (non-escaped) dollar.
// A $ is escaped if it is part of a $$ pair. We count consecutive $ backwards.
function IsRealDollar(const S: string; Pos: Integer): Boolean;
var
  Count: Integer;
begin
  Count := 0;
  while (Pos - 1 - Count >= 1) and (S[Pos - 1 - Count] = '$') do
    Inc(Count);
  Result := (Count mod 2) = 0;
end;

// Check if string contains a non-escaped $#
function ContainsAutoNum(const S: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 1 to Length(S) - 1 do
    if (S[I] = '$') and (S[I + 1] = '#') and IsRealDollar(S, I) then
      Exit(True);
end;

// Replace non-escaped $# with Replacement
function ReplaceAutoNum(const S, Replacement: string): string;
var
  I: Integer;
begin
  Result := '';
  I := 1;
  while I <= Length(S) do
  begin
    if (I < Length(S)) and (S[I] = '$') and (S[I + 1] = '#') and IsRealDollar(S, I) then
    begin
      Result := Result + Replacement;
      Inc(I, 2);
    end
    else
    begin
      Result := Result + S[I];
      Inc(I);
    end;
  end;
end;

// Transform $n$# patterns to ${n}$# so numbered captures aren't confused with auto-num
function TransformAutoNumCaptures(const S: string): string;
var
  I, J: Integer;
  NumStr: string;
begin
  Result := '';
  I := 1;
  while I <= Length(S) do
  begin
    if (I < Length(S)) and (S[I] = '$') and IsRealDollar(S, I) and
       (S[I + 1] >= '0') and (S[I + 1] <= '9') then
    begin
      J := I + 1;
      NumStr := '';
      while (J <= Length(S)) and (S[J] >= '0') and (S[J] <= '9') do
      begin
        NumStr := NumStr + S[J];
        Inc(J);
      end;
      if (J < Length(S)) and (S[J] = '$') and (S[J + 1] = '#') and IsRealDollar(S, J) then
      begin
        Result := Result + '${' + NumStr + '}$#';
        I := J;
        Continue;
      end
      else
      begin
        Result := Result + S[I];
        Inc(I);
      end;
    end
    else
    begin
      Result := Result + S[I];
      Inc(I);
    end;
  end;
end;

{ TRenameThread }

constructor TRenameThread.Create(AActiveFiles: TRRItemList;
  const AActivePath, AOutputPath, ABackupPath: string;
  ARenameFolders, APreserveExt, ARenameInPlace, AMoveTo, ACopyTo,
  ABackupTo, ARenameSelectedOnly: Boolean);
begin
  inherited Create(True);
  FreeOnTerminate := False;
  FActiveFiles := AActiveFiles;
  FActivePath := AActivePath;
  FOutputPath := AOutputPath;
  FBackupPath := ABackupPath;
  FRenameFolders := ARenameFolders;
  FPreserveExt := APreserveExt;
  FRenameInPlace := ARenameInPlace;
  FMoveTo := AMoveTo;
  FCopyTo := ACopyTo;
  FBackupTo := ABackupTo;
  FRenameSelectedOnly := ARenameSelectedOnly;
  FProgress := 0;
  FCancelled := False;
  FCountSuccess := 0;
  FCountErrors := 0;
  FErrors := TList<TPair<string, TPair<string, string>>>.Create;
end;

destructor TRenameThread.Destroy;
begin
  FErrors.Free;
  inherited;
end;

procedure TRenameThread.DoProgress;
begin
  // Called via Synchronize - main form reads FProgress
end;

procedure TRenameThread.Execute;
var
  I, FilesToRename: Integer;
  FilesRenamed: Single;
  OutputPath, NewFullpath, NewDirectory: string;
  Item: TRRItem;
begin
  OutputPath := FOutputPath;
  FilesToRename := 0;

  // Count files to rename
  for I := 0 to FActiveFiles.Count - 1 do
  begin
    Item := FActiveFiles[I];
    if FRenameSelectedOnly and not Item.Selected then
      Continue;
    if FRenameInPlace then
    begin
      if Item.Name <> Item.Preview then
        Inc(FilesToRename);
    end
    else
    begin
      if Item.Matched then
        Inc(FilesToRename);
    end;
  end;

  if FilesToRename = 0 then
    Exit;

  FilesRenamed := 0.5;

  for I := 0 to FActiveFiles.Count - 1 do
  begin
    if Terminated then
    begin
      FCancelled := True;
      Break;
    end;

    Item := FActiveFiles[I];

    // Skip unmatched/unchanged
    if FRenameInPlace then
    begin
      if Item.Name = Item.Preview then Continue;
    end
    else
    begin
      if not Item.Matched then Continue;
    end;

    if FRenameSelectedOnly and not Item.Selected then
      Continue;

    // Update progress
    FProgress := Round((FilesRenamed / FilesToRename) * 100);
    Synchronize(DoProgress);
    FilesRenamed := FilesRenamed + 1;

    // Build new path
    NewFullpath := TPath.Combine(OutputPath, Item.Preview);
    if FPreserveExt then
      NewFullpath := NewFullpath + Item.Extension;

    // Create subdirs if needed
    if Item.Preview.Contains('\') then
    begin
      NewDirectory := TPath.GetDirectoryName(NewFullpath);
      if not TDirectory.Exists(NewDirectory) then
      begin
        try
          TDirectory.CreateDirectory(NewDirectory);
        except
          on E: Exception do
          begin
            Inc(FCountErrors);
            FErrors.Add(TPair<string, TPair<string, string>>.Create(
              Item.Name, TPair<string, string>.Create(Item.Preview, 'Create folder failed: ' + E.Message)));
            Continue;
          end;
        end;
      end;
    end;

    // Perform rename/move/copy
    try
      if FRenameFolders then
      begin
        TDirectory.Move(Item.Fullpath, NewFullpath);
      end
      else
      begin
        if FRenameInPlace or FMoveTo then
          TFile.Move(Item.Fullpath, NewFullpath)
        else if FCopyTo then
          TFile.Copy(Item.Fullpath, NewFullpath)
        else if FBackupTo then
        begin
          TFile.Copy(Item.Fullpath, TPath.Combine(FBackupPath, TPath.GetFileName(Item.Filename)));
          TFile.Move(Item.Fullpath, NewFullpath);
        end;
      end;
      Inc(FCountSuccess);
    except
      on E: Exception do
      begin
        Inc(FCountErrors);
        FErrors.Add(TPair<string, TPair<string, string>>.Create(
          Item.Name, TPair<string, string>.Create(Item.Preview, E.Message)));
      end;
    end;
  end;

  FProgress := 100;
  Synchronize(DoProgress);
end;

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  MAX_FILES := 10000;
  FActiveFiles := TRRItemList.Create(True);
  FInactiveFiles := TInactiveFileDict.Create;
  FIconCache := TDictionary<string, Integer>.Create;
  FInsertArgsObjects := TObjectList<TInsertArgsObject>.Create(True);
  FPreviewErrors := TDictionary<Integer, string>.Create;
  FActiveFilter := '*.*';
  FEnableUpdates := True;
  FRenameFolders := False;
  FValidFilter := True;
  FValidMatch := True;
  FValidNumber := True;
  FCountProgLaunches := 1;
  FCountFilesRenamed := 0;
  FChangeCaseMode := ccNone;
  FNumberingStart := '1';
  FNumberingPad := '000';
  FNumberingInc := '1';
  FNumberingReset := '0';
  FSortColumn := 1;
  FSortAscending := True;

  BuildRegexContextMenus;

  // Wire up mouse down events via WindowProc interception
  FOldCmbMatchWndProc := cmbMatch.WindowProc;
  cmbMatch.WindowProc := CmbMatchWndProc;
  FOldTxtReplaceWndProc := txtReplace.WindowProc;
  txtReplace.WindowProc := TxtReplaceWndProc;
  FOldTxtFilterWndProc := txtFilter.WindowProc;
  txtFilter.WindowProc := TxtFilterWndProc;

  LoadSettings;
  LoadRegexHistory;

  // Set initial path
  if (ParamCount > 0) and TDirectory.Exists(ParamStr(1)) then
    FActivePath := ParamStr(1);

  if (FActivePath = '') or not TDirectory.Exists(FActivePath) then
    FActivePath := GetEnvironmentVariable('SystemDrive') + '\';

  ShellTree.Path := FActivePath;
  txtPath.Text := FActivePath;
  UpdateFileList;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FPreviewErrors.Free;
  FInsertArgsObjects.Free;
  FIconCache.Free;
  FInactiveFiles.Free;
  FActiveFiles.Free;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveSettings;
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if btnRename.Enabled and (ssCtrl in Shift) then
  begin
    if Key = Ord('R') then
    begin
      Key := 0;
      btnRenameClick(btnRename);
    end
    else if Key = Ord('M') then
    begin
      Key := 0;
      cmbMatch.SetFocus;
    end;
  end
  else if btnCancel.Enabled and (Key = VK_ESCAPE) and (Shift = []) then
  begin
    Key := 0;
    btnCancelClick(btnCancel);
  end;
end;

procedure TfrmMain.SetEnableUpdates(Value: Boolean);
begin
  if Value and Assigned(FRenameThread) then
    Exit;
  FEnableUpdates := Value;
end;

procedure TfrmMain.SetRenameFolders(Value: Boolean);
begin
  if FRenameFolders = Value then
    Exit;
  FRenameFolders := Value;

  itmRenameFiles.Checked := not FRenameFolders;
  itmRenameFolders.Checked := FRenameFolders;
  itmOptionsPreserveExt.Enabled := not FRenameFolders;
  itmOutputCopyTo.Enabled := not FRenameFolders;
  itmOutputBackupTo.Enabled := not FRenameFolders;

  if FRenameFolders and (itmOutputCopyTo.Checked or itmOutputBackupTo.Checked) then
  begin
    itmOutputRenameInPlace.Checked := True;
    itmOutputCopyTo.Checked := False;
    itmOutputBackupTo.Checked := False;
  end;
end;

function TfrmMain.PreviewNeedsUpdate: Boolean;
begin
  Result := (cmbMatch.Text <> FPrevMatch) or (txtReplace.Text <> FPrevReplace);
end;

procedure TfrmMain.ResetPreviewNeedsUpdate;
begin
  FPrevMatch := cmbMatch.Text;
  FPrevReplace := txtReplace.Text;
end;

function TfrmMain.GetStrFile: string;
begin
  if FRenameFolders then Result := 'folder' else Result := 'file';
end;

function TfrmMain.GetStrFilename: string;
begin
  if FRenameFolders then Result := 'folder name' else Result := 'filename';
end;

// Settings

procedure TfrmMain.LoadSettings;
var
  Reg: TRegistry;
  MaxOverride: Integer;
  WinX, WinY, WinW, WinH: Integer;
  CmdVal: string;
begin
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_CURRENT_USER;

    if Reg.OpenKeyReadOnly('Software\RegexRenamer') then
    begin
      if (FActivePath = '') and Reg.ValueExists('LastPath') then
        FActivePath := Reg.ReadString('LastPath');
      if Reg.ValueExists('MoveCopyPath') then
        FMoveCopyPath := Reg.ReadString('MoveCopyPath');
      if Reg.ValueExists('RenameFolders') then
        SetRenameFolders(Reg.ReadString('RenameFolders') = 'True');
      if Reg.ValueExists('MaxFileLimit') then
      begin
        try
          MaxOverride := Reg.ReadInteger('MaxFileLimit');
          if MaxOverride > MAX_FILES then
            MAX_FILES := MaxOverride;
        except
        end;
      end;
      Reg.CloseKey;
    end;

    if Reg.OpenKeyReadOnly('Software\RegexRenamer\Options') then
    begin
      FEnableUpdates := False;
      if Reg.ValueExists('ShowHiddenFiles') then
        itmOptionsShowHidden.Checked := Reg.ReadString('ShowHiddenFiles') = 'True';
      if Reg.ValueExists('PreserveExtension') then
        itmOptionsPreserveExt.Checked := Reg.ReadString('PreserveExtension') = 'True';
      if Reg.ValueExists('RealtimePreview') then
        itmOptionsRealtimePreview.Checked := Reg.ReadString('RealtimePreview') = 'True';
      if Reg.ValueExists('AllowRenameIntoSubfolders') then
        itmOptionsAllowRenSub.Checked := Reg.ReadString('AllowRenameIntoSubfolders') = 'True';
      if Reg.ValueExists('RememberWindowPosition') then
        itmOptionsRememberWinPos.Checked := Reg.ReadString('RememberWindowPosition') = 'True';
      if Reg.ValueExists('OnlyRenameSelectedRows') then
        itmOptionsRenameSelectedRows.Checked := Reg.ReadString('OnlyRenameSelectedRows') = 'True';
      FEnableUpdates := True;
      Reg.CloseKey;
    end;

    if Reg.OpenKeyReadOnly('Software\RegexRenamer\Stats') then
    begin
      if Reg.ValueExists('ProgramLaunches') then
        FCountProgLaunches := Reg.ReadInteger('ProgramLaunches') + 1;
      if Reg.ValueExists('FilesRenamed') then
        FCountFilesRenamed := Reg.ReadInteger('FilesRenamed');
      Reg.CloseKey;
    end;

    // Window position
    if itmOptionsRememberWinPos.Checked and Reg.OpenKeyReadOnly('Software\RegexRenamer\WindowPosition') then
    begin
      if Reg.ValueExists('WindowState') and (Reg.ReadString('WindowState') = 'wsMaximized') then
        WindowState := wsMaximized
      else
      begin
        WinX := StrToIntDef(Reg.ReadString('WindowX'), Left);
        WinY := StrToIntDef(Reg.ReadString('WindowY'), Top);
        WinW := Reg.ReadInteger('WindowWidth');
        WinH := Reg.ReadInteger('WindowHeight');

        if (WinW >= Constraints.MinWidth) and (WinH >= Constraints.MinHeight) then
        begin
          SetBounds(WinX, WinY, WinW, WinH);
        end;
      end;

      if Reg.ValueExists('SplitMain') then
        pnlLeft.Width := Reg.ReadInteger('SplitMain');
      if Reg.ValueExists('SplitRegex') then
        pnlRegex.Height := Reg.ReadInteger('SplitRegex');

      Reg.CloseKey;
    end;

    // Explorer context menu check
    Reg.RootKey := HKEY_CLASSES_ROOT;
    if Reg.OpenKeyReadOnly('Folder\shell\RegexRenamer\command') then
    begin
      CmdVal := Reg.ReadString('');
      if CmdVal.StartsWith(Application.ExeName) then
        itmOptionsAddContextMenu.Checked := True;
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;

  FEnableUpdates := True;
end;

procedure TfrmMain.SaveSettings;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_WRITE);
  try
    Reg.RootKey := HKEY_CURRENT_USER;

    if Reg.OpenKey('Software\RegexRenamer', True) then
    begin
      Reg.WriteString('LastPath', FActivePath);
      Reg.WriteString('MoveCopyPath', FMoveCopyPath);
      Reg.WriteString('RenameFolders', BoolToStr(FRenameFolders, True));
      Reg.CloseKey;
    end;

    if Reg.OpenKey('Software\RegexRenamer\Options', True) then
    begin
      Reg.WriteString('ShowHiddenFiles', BoolToStr(itmOptionsShowHidden.Checked, True));
      Reg.WriteString('PreserveExtension', BoolToStr(itmOptionsPreserveExt.Checked, True));
      Reg.WriteString('RealtimePreview', BoolToStr(itmOptionsRealtimePreview.Checked, True));
      Reg.WriteString('AllowRenameIntoSubfolders', BoolToStr(itmOptionsAllowRenSub.Checked, True));
      Reg.WriteString('RememberWindowPosition', BoolToStr(itmOptionsRememberWinPos.Checked, True));
      Reg.WriteString('OnlyRenameSelectedRows', BoolToStr(itmOptionsRenameSelectedRows.Checked, True));
      Reg.CloseKey;
    end;

    if Reg.OpenKey('Software\RegexRenamer\Stats', True) then
    begin
      Reg.WriteInteger('ProgramLaunches', FCountProgLaunches);
      Reg.WriteInteger('FilesRenamed', FCountFilesRenamed);
      Reg.CloseKey;
    end;

    if Reg.OpenKey('Software\RegexRenamer\WindowPosition', True) then
    begin
      Reg.WriteString('WindowX', IntToStr(Left));
      Reg.WriteString('WindowY', IntToStr(Top));
      Reg.WriteInteger('WindowHeight', Height);
      Reg.WriteInteger('WindowWidth', Width);
      Reg.WriteInteger('SplitMain', pnlLeft.Width);
      Reg.WriteInteger('SplitRegex', pnlRegex.Height);
      if WindowState = wsMaximized then
        Reg.WriteString('WindowState', 'wsMaximized')
      else
        Reg.WriteString('WindowState', 'wsNormal');
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TfrmMain.LoadRegexHistory;
var
  Reg: TRegistry;
  Names: TStringList;
  I: Integer;
begin
  Reg := TRegistry.Create(KEY_READ);
  Names := TStringList.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKeyReadOnly('Software\RegexRenamer\History') then
    begin
      cmbMatch.Items.Clear;
      Reg.GetValueNames(Names);
      Names.Sort;
      for I := 0 to Names.Count - 1 do
        cmbMatch.Items.Add(Reg.ReadString(Names[I]));
      Reg.CloseKey;
    end;
  finally
    Names.Free;
    Reg.Free;
  end;
end;

procedure TfrmMain.SaveRegexHistory;
var
  Reg: TRegistry;
  Names: TStringList;
  I: Integer;
begin
  Reg := TRegistry.Create(KEY_WRITE);
  Names := TStringList.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('Software\RegexRenamer\History', True) then
    begin
      Reg.GetValueNames(Names);
      for I := 0 to Names.Count - 1 do
        Reg.DeleteValue(Names[I]);
      for I := 0 to cmbMatch.Items.Count - 1 do
        Reg.WriteString(Format('%.2d', [I]), cmbMatch.Items[I]);
      Reg.CloseKey;
    end;
  finally
    Names.Free;
    Reg.Free;
  end;
end;

// Core update methods

procedure TfrmMain.UpdateFileList;
var
  SearchRec: TSearchRec;
  Filter: TRegEx;
  FilterText: string;
  HasFilter: Boolean;
  IsHidden: Boolean;
  Ext: string;
  I, ImgIdx: Integer;
  Item: TListItem;
begin
  if not FEnableUpdates then Exit;

  FFileCount.Reset;
  txtPath.Text := FActivePath;

  if FActivePath = '' then
  begin
    FActiveFiles.Clear;
    FInactiveFiles.Clear;
    FIconCache.Clear;
    ilFiles.Clear;
    lvFiles.Items.Clear;
    lblNumMatched.Caption := 'Matched: 0';
    lblNumConflict.Caption := 'Conflicts: 0';
    UpdateFileStats;
    Exit;
  end;

  Screen.Cursor := crAppStart;
  lvFiles.Items.BeginUpdate;
  try
    // Build filter regex
    HasFilter := False;
    FilterText := FActiveFilter;

    if FilterText <> '' then
    begin
      if rbFilterGlob.Checked and (FilterText = '*.*') then
        FilterText := '*';

      if rbFilterGlob.Checked then
        FilterText := '^' + TRegEx.Escape(FilterText).Replace('\*', '.*').Replace('\?', '.') + '$';

      Filter := TRegEx.Create(FilterText, [roIgnoreCase]);
      HasFilter := True;
    end;

    FActiveFiles.Clear;
    FInactiveFiles.Clear;
    FIconCache.Clear;
    ilFiles.Clear;
    lvFiles.Items.Clear;

    // Set icon size
    ilFiles.Width := 16;
    ilFiles.Height := 16;

    if FRenameFolders then
    begin
      // Enumerate directories
      if FindFirst(TPath.Combine(FActivePath, '*'), faDirectory, SearchRec) = 0 then
      begin
        try
          repeat
            if (SearchRec.Name = '.') or (SearchRec.Name = '..') then
              Continue;
            if (SearchRec.Attr and faDirectory) = 0 then
              Continue;

            Inc(FFileCount.Total);

            // Filter check
            if HasFilter then
            begin
              if Filter.IsMatch(SearchRec.Name) = cbFilterExclude.Checked then
              begin
                if not FInactiveFiles.ContainsKey(LowerCase(SearchRec.Name)) then
                  FInactiveFiles.Add(LowerCase(SearchRec.Name), irFiltered);
                Inc(FFileCount.Filtered);
                Continue;
              end;
            end;

            // Hidden check
            IsHidden := (SearchRec.Attr and faHidden) <> 0;
            if IsHidden then Inc(FFileCount.Hidden);
            if not itmOptionsShowHidden.Checked and IsHidden then
            begin
              if not FInactiveFiles.ContainsKey(LowerCase(SearchRec.Name)) then
                FInactiveFiles.Add(LowerCase(SearchRec.Name), irHidden);
              Continue;
            end;

            FActiveFiles.Add(TRRItem.CreateFromDir(
              SearchRec.Name,
              TPath.Combine(FActivePath, SearchRec.Name),
              IsHidden,
              itmOptionsPreserveExt.Checked));
          until FindNext(SearchRec) <> 0;
        finally
          FindClose(SearchRec);
        end;
      end;
    end
    else
    begin
      // Enumerate files
      if FindFirst(TPath.Combine(FActivePath, '*'), faAnyFile, SearchRec) = 0 then
      begin
        try
          repeat
            if (SearchRec.Attr and faDirectory) <> 0 then
              Continue;

            Inc(FFileCount.Total);

            // Filter check
            if HasFilter then
            begin
              if Filter.IsMatch(SearchRec.Name) = cbFilterExclude.Checked then
              begin
                if not FInactiveFiles.ContainsKey(LowerCase(SearchRec.Name)) then
                  FInactiveFiles.Add(LowerCase(SearchRec.Name), irFiltered);
                Inc(FFileCount.Filtered);
                Continue;
              end;
            end;

            // Hidden check
            IsHidden := (SearchRec.Attr and faHidden) <> 0;
            if IsHidden then Inc(FFileCount.Hidden);
            if not itmOptionsShowHidden.Checked and IsHidden then
            begin
              if not FInactiveFiles.ContainsKey(LowerCase(SearchRec.Name)) then
                FInactiveFiles.Add(LowerCase(SearchRec.Name), irHidden);
              Continue;
            end;

            FActiveFiles.Add(TRRItem.CreateFromFile(SearchRec, FActivePath,
              IsHidden, itmOptionsPreserveExt.Checked));
          until FindNext(SearchRec) <> 0;
        finally
          FindClose(SearchRec);
        end;
      end;
    end;

    // Populate list view
    for I := 0 to FActiveFiles.Count - 1 do
    begin
      if I >= MAX_FILES then
        Break;

      Item := lvFiles.Items.Add;
      Item.Caption := '';
      Item.Data := Pointer(I); // store activeFiles index
      Item.SubItems.Add(FActiveFiles[I].Name);
      Item.SubItems.Add('');

      // Get icon
      if FRenameFolders then
      begin
        if not FIconCache.ContainsKey('folder') then
          FIconCache.Add('folder', GetFolderIcon);
        Item.ImageIndex := FIconCache['folder'];
      end
      else
      begin
        Ext := LowerCase(FActiveFiles[I].Extension);
        if not FIconCache.ContainsKey(Ext) then
        begin
          ImgIdx := GetFileIcon(FActiveFiles[I].Fullpath, Ext <> '.lnk');
          FIconCache.Add(Ext, ImgIdx);
        end;
        Item.ImageIndex := FIconCache[Ext];
      end;
    end;

    FFileCount.Shown := lvFiles.Items.Count;
  finally
    lvFiles.Items.EndUpdate;
    Screen.Cursor := crDefault;
  end;

  UpdateFileStats;
  UpdateSelection;
  UpdatePreview;

  if FActiveFiles.Count > MAX_FILES then
  begin
    MessageDlg(Format('For performance reasons, RegExRenamer will only display %d %ss at once (%d %ss ignored).'#13#10 +
      'Use a filter to display only the %ss you need to rename.',
      [MAX_FILES, GetStrFile, FActiveFiles.Count - MAX_FILES, GetStrFile, GetStrFile]),
      mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmMain.UpdatePreview;
var
  Regex: TRegEx;
  Options: TRegExOptions;
  Count: Integer;
  NumCurrent, NumInc, NumStart, NumReset: Integer;
  NumFormatted: string;
  DoingAutoNum, DoingAutoNumLetter, DoingAutoNumLetterUpper: Boolean;
  UserReplacePattern, ReplacePattern: string;
  I, Afi: Integer;
  Match: TMatch;
begin
  if not FEnableUpdates or not FValidMatch then Exit;

  Screen.Cursor := crAppStart;
  try
    if cmbMatch.Text <> '' then
    begin
      // Compile regex options
      Options := [];
      Count := 1; // default: replace first only
      if cbModifierG.Checked then Count := -1; // replace all
      if cbModifierI.Checked then Include(Options, roIgnoreCase);
      if cbModifierX.Checked then Include(Options, roIgnorePatternSpace);

      Regex := TRegEx.Create(cmbMatch.Text, Options);

      // Auto numbering
      NumCurrent := 0;
      NumInc := 0;
      NumStart := 0;
      NumReset := 0;
      NumFormatted := '';
      DoingAutoNum := False;
      DoingAutoNumLetter := False;
      DoingAutoNumLetterUpper := False;

      if FValidNumber and ContainsAutoNum(txtReplace.Text) then
        DoingAutoNum := True;

      Match := TRegEx.Match(FNumberingStart, '^(([a-z]+)|([A-Z]+))$');
      DoingAutoNumLetter := Match.Success;
      DoingAutoNumLetterUpper := Match.Success and (Match.Groups[3].Length > 0);

      if DoingAutoNum then
      begin
        if DoingAutoNumLetter then
          NumStart := SequenceLetterToNumber(LowerCase(FNumberingStart))
        else
          NumStart := StrToIntDef(FNumberingStart, 1);

        NumInc := StrToIntDef(FNumberingInc, 1);
        NumReset := StrToIntDef(FNumberingReset, 0);
      end;
      NumCurrent := NumStart - NumInc;

      // Prepare replace pattern
      UserReplacePattern := txtReplace.Text;
      if DoingAutoNum then
        UserReplacePattern := TransformAutoNumCaptures(UserReplacePattern);

      // Process each file
      for I := 0 to FActiveFiles.Count - 1 do
      begin
        if I >= MAX_FILES then Break;

        FActiveFiles[I].Matched := Regex.IsMatch(FActiveFiles[I].Name);

        if not FActiveFiles[I].Matched then
        begin
          FActiveFiles[I].Preview := FActiveFiles[I].Name;
          Continue;
        end;

        // Auto numbering
        if DoingAutoNum then
        begin
          NumCurrent := NumCurrent + NumInc;

          if (NumReset <> 0) and ((NumCurrent - NumStart) mod NumReset = 0) then
            NumCurrent := NumStart;

          if NumFormatted <> '$#' then
          begin
            if not DoingAutoNumLetter then
            begin
              if NumCurrent < 0 then
                NumFormatted := '$#'
              else
                NumFormatted := FormatFloat(FNumberingPad, NumCurrent);
            end
            else
            begin
              if NumCurrent < 1 then
                NumFormatted := '$#'
              else if DoingAutoNumLetterUpper then
                NumFormatted := UpperCase(SequenceNumberToLetter(NumCurrent))
              else
                NumFormatted := SequenceNumberToLetter(NumCurrent);
            end;
          end;

          ReplacePattern := ReplaceAutoNum(UserReplacePattern, NumFormatted);
        end
        else
          ReplacePattern := UserReplacePattern;

        // Apply change case delimiters
        if FChangeCaseMode <> ccNone then
          ReplacePattern := #10 + ReplacePattern + #10;

        // Do the replacement
        FActiveFiles[I].Preview := RegExReplaceCount(FActiveFiles[I].Name,
          cmbMatch.Text, ReplacePattern, Options, Count);

        // Apply change case
        if FChangeCaseMode <> ccNone then
          FActiveFiles[I].Preview := TRegEx.Replace(FActiveFiles[I].Preview,
            '\n([^\n]*)\n', MatchEvalChangeCase);

        if FActiveFiles[I].Preview = '' then
          FActiveFiles[I].Preview := FActiveFiles[I].Name;
      end;
    end
    else
    begin
      // No match pattern - reset all
      for I := 0 to FActiveFiles.Count - 1 do
      begin
        FActiveFiles[I].Preview := FActiveFiles[I].Name;
        FActiveFiles[I].Matched := False;
      end;
    end;

    // Update preview column in list view
    lvFiles.Items.BeginUpdate;
    try
      for I := 0 to lvFiles.Items.Count - 1 do
      begin
        Afi := Integer(lvFiles.Items[I].Data);
        if Afi < FActiveFiles.Count then
          lvFiles.Items[I].SubItems[1] := FActiveFiles[Afi].Preview;
      end;
    finally
      lvFiles.Items.EndUpdate;
    end;

    UpdateValidation;
    ResetPreviewNeedsUpdate;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMain.UpdateValidation;
var
  HasError: array of Boolean;
  HashPreview: TDictionary<string, TList<Integer>>;
  I, Afi, Afi2, J: Integer;
  Preview, OutputPath, ErrorMsg, PreviewFullpath: string;
  DupeList: TList<Integer>;
  Matched, Conflict: Integer;
  Pair: TPair<string, TList<Integer>>;
begin
  FPreviewErrors.Clear;

  if lvFiles.Items.Count = 0 then
  begin
    lblNumMatched.Caption := 'Matched: 0';
    lblNumConflict.Caption := 'Conflicts: 0';
    lvFiles.Invalidate;
    Exit;
  end;

  SetLength(HasError, lvFiles.Items.Count);
  HashPreview := TDictionary<string, TList<Integer>>.Create;
  try
    // Build hash of preview filenames
    for I := 0 to lvFiles.Items.Count - 1 do
    begin
      Afi := Integer(lvFiles.Items[I].Data);
      if Afi >= FActiveFiles.Count then Continue;

      Preview := LowerCase(FActiveFiles[Afi].PreviewExt);
      if not HashPreview.ContainsKey(Preview) then
        HashPreview.Add(Preview, TList<Integer>.Create);
      HashPreview[Preview].Add(I);
    end;

    // Determine output path
    OutputPath := FActivePath;
    if itmOutputMoveTo.Checked or itmOutputCopyTo.Checked then
      OutputPath := FMoveCopyPath;

    // Check for errors
    for I := 0 to lvFiles.Items.Count - 1 do
    begin
      Afi := Integer(lvFiles.Items[I].Data);
      if (Afi >= FActiveFiles.Count) or HasError[I] then Continue;

      Preview := LowerCase(FActiveFiles[Afi].PreviewExt);

      // Skip unchanged/unmatched
      if itmOutputRenameInPlace.Checked then
      begin
        if FActiveFiles[Afi].Name = FActiveFiles[Afi].Preview then Continue;
      end
      else
      begin
        if not FActiveFiles[Afi].Matched then Continue;
      end;

      // Validate filename
      ErrorMsg := ValidateFilename(FActiveFiles[Afi].PreviewExt, itmOptionsAllowRenSub.Checked);
      if ErrorMsg <> '' then
      begin
        FPreviewErrors.AddOrSetValue(I, ErrorMsg);
        Continue;
      end;

      // Check for duplicate conflicts
      if not FActiveFiles[Afi].Preview.Contains('\') and
         (itmOutputRenameInPlace.Checked or itmOutputBackupTo.Checked) then
      begin
        // Check against active files
        if HashPreview.TryGetValue(Preview, DupeList) and (DupeList.Count > 1) then
        begin
          for J := 0 to DupeList.Count - 1 do
          begin
            if not HasError[DupeList[J]] then
            begin
              HasError[DupeList[J]] := True;
              Afi2 := Integer(lvFiles.Items[DupeList[J]].Data);
              FPreviewErrors.AddOrSetValue(DupeList[J],
                Format('The %s ''%s'' conflicts with another %s in the preview column.',
                  [GetStrFilename, FActiveFiles[Afi2].PreviewExt, GetStrFile]));
            end;
          end;
          Continue;
        end;

        // Check against inactive files
        if FInactiveFiles.ContainsKey(Preview) then
        begin
          case FInactiveFiles[Preview] of
            irFiltered:
              FPreviewErrors.AddOrSetValue(I, Format('The %s ''%s'' already exists but is currently filtered out.',
                [GetStrFilename, FActiveFiles[Afi].PreviewExt]));
            irHidden:
              FPreviewErrors.AddOrSetValue(I, Format('The %s ''%s'' already exists as a hidden %s.',
                [GetStrFilename, FActiveFiles[Afi].PreviewExt, GetStrFile]));
          end;
          Continue;
        end;

        // Check file-folder conflicts (expensive, only for small lists)
        if lvFiles.Items.Count < 2000 then
        begin
          PreviewFullpath := TPath.Combine(OutputPath, FActiveFiles[Afi].PreviewExt);
          if FRenameFolders then
          begin
            if TFile.Exists(PreviewFullpath) then
            begin
              FPreviewErrors.AddOrSetValue(I, Format('The %s ''%s'' conflicts with a file in the current path.',
                [GetStrFilename, FActiveFiles[Afi].PreviewExt]));
              Continue;
            end;
          end
          else
          begin
            if TDirectory.Exists(PreviewFullpath) then
            begin
              FPreviewErrors.AddOrSetValue(I, Format('The %s ''%s'' conflicts with a folder in the current path.',
                [GetStrFilename, FActiveFiles[Afi].PreviewExt]));
              Continue;
            end;
          end;
        end;
      end
      else
      begin
        // Destination is other directory
        PreviewFullpath := TPath.Combine(OutputPath, FActiveFiles[Afi].PreviewExt);

        if (FRenameFolders and TDirectory.Exists(PreviewFullpath)) or
           (not FRenameFolders and TFile.Exists(PreviewFullpath)) then
        begin
          FPreviewErrors.AddOrSetValue(I, Format('The %s ''%s'' already exists in the destination folder.',
            [GetStrFilename, TPath.GetFileName(FActiveFiles[Afi].PreviewExt)]));
          Continue;
        end;
      end;

      // Backup check
      if itmOutputBackupTo.Checked and not FRenameFolders then
      begin
        PreviewFullpath := TPath.Combine(FMoveCopyPath, FActiveFiles[Afi].Filename);
        if TFile.Exists(PreviewFullpath) then
        begin
          FPreviewErrors.AddOrSetValue(I, Format('The original filename ''%s'' already exists in the backup folder.',
            [FActiveFiles[Afi].Filename]));
          Continue;
        end;
      end;
    end;

    // Update counters
    Matched := 0;
    Conflict := 0;
    for I := 0 to FActiveFiles.Count - 1 do
      if (I < MAX_FILES) and FActiveFiles[I].Matched then
        Inc(Matched);
    Conflict := FPreviewErrors.Count;

    lblNumMatched.Caption := Format('Matched: %d', [Matched]);
    lblNumConflict.Caption := Format('Conflicts: %d', [Conflict]);

  finally
    for Pair in HashPreview do
      Pair.Value.Free;
    HashPreview.Free;
  end;

  lvFiles.Invalidate;
end;

procedure TfrmMain.UpdateSelection;
var
  I, Afi: Integer;
begin
  for I := 0 to lvFiles.Items.Count - 1 do
  begin
    Afi := Integer(lvFiles.Items[I].Data);
    if Afi < FActiveFiles.Count then
      FActiveFiles[Afi].Selected := lvFiles.Items[I].Selected;
  end;
end;

procedure TfrmMain.UpdateFileStats;
begin
  lblStatsTotal.Caption := IntToStr(FFileCount.Total) + ' total';
  lblStatsShown.Caption := IntToStr(FFileCount.Shown) + ' shown';
  lblStatsFiltered.Caption := IntToStr(FFileCount.Filtered) + ' filtered';
  lblStatsHidden.Caption := IntToStr(FFileCount.Hidden) + ' hidden';
end;

procedure TfrmMain.ResetFields;
begin
  FEnableUpdates := False;
  cmbMatch.Text := '';
  txtReplace.Text := '';
  cbModifierI.Checked := False;
  cbModifierG.Checked := False;
  cbModifierX.Checked := False;
  FEnableUpdates := True;
end;

// Validation

function TfrmMain.ValidateGlob(const ATestGlob: string): string;
var
  M: TMatch;
begin
  M := TRegEx.Match(ATestGlob, '([\\/:\"<>|])');
  if M.Success then
    Result := 'Invalid character: ' + M.Groups[0].Value
  else
    Result := '';
end;

function TfrmMain.ValidateRegex(const ATestRegex: string): string;
begin
  Result := '';
  try
    TRegEx.Create(ATestRegex);
  except
    on E: Exception do
      Result := TRegEx.Replace(E.Message, '^parsing ".+" - ', '');
  end;
end;

function TfrmMain.ValidateFilename(const ATestFilename: string; AAllowRenSub: Boolean): string;
var
  Parts: TArray<string>;
  I: Integer;
  M: TMatch;
begin
  Result := '';

  if AAllowRenSub then
    Parts := ATestFilename.Split(['\'])
  else
    Parts := [ATestFilename];

  // Invalid characters
  for I := 0 to Length(Parts) - 1 do
  begin
    if AAllowRenSub then
      M := TRegEx.Match(Parts[I], '([/:*?\"<>|])')
    else
      M := TRegEx.Match(Parts[I], '([\\/:*?\"<>|])');

    if M.Success then
    begin
      if (Length(Parts) > 1) and (I <> Length(Parts) - 1) then
        Result := Format('The subfolder ''%s'' contains an invalid character: ''%s''.',
          [Parts[I], M.Groups[0].Value])
      else
        Result := Format('The %s ''%s'' contains an invalid character: ''%s''.',
          [GetStrFilename, Parts[I], M.Groups[0].Value]);
      Exit;
    end;
  end;

  // Starts with backslash
  if ATestFilename.StartsWith('\') then
  begin
    if Length(Parts) > 2 then
      Result := 'The subfolder cannot begin with ''\''.'
    else
      Result := 'The ' + GetStrFilename + ' cannot begin with a backslash.';
    Exit;
  end;

  // Empty elements
  for I := 0 to Length(Parts) - 1 do
  begin
    if Parts[I] = '' then
    begin
      if I <> Length(Parts) - 1 then
        Result := 'Duplicate path separator'
      else
        Result := 'The ' + GetStrFilename + ' cannot end with a backslash.';
      Exit;
    end;
  end;

  // Element is only dots/spaces
  for I := 0 to Length(Parts) - 1 do
  begin
    if TRegEx.IsMatch(Parts[I], '^[ .]+$') then
    begin
      if I <> Length(Parts) - 1 then
        Result := Format('Invalid subfolder: ''%s''.', [Parts[I]])
      else
        Result := Format('Invalid %s: ''%s''.', [GetStrFilename, Parts[I]]);
      Exit;
    end;
  end;

  // Element ends with dots/spaces
  for I := 0 to Length(Parts) - 1 do
  begin
    M := TRegEx.Match(Parts[I], '([ .]+)$');
    if M.Success then
    begin
      if I <> Length(Parts) - 1 then
        Result := Format('The subfolder ''%s'' ends with invalid character(s): ''%s''.',
          [Parts[I], M.Groups[0].Value])
      else
        Result := Format('The %s ''%s'' ends with invalid character(s): ''%s''.',
          [GetStrFilename, Parts[I], M.Groups[0].Value]);
      Exit;
    end;
  end;
end;

procedure TfrmMain.ValidateMatch;
var
  ErrorMsg: string;
begin
  ErrorMsg := ValidateRegex(cmbMatch.Text);
  if ErrorMsg = '' then
  begin
    cmbMatch.Color := clWindow;
    FValidMatch := True;
  end
  else
  begin
    cmbMatch.Color := $00C0C0FF; // MistyRose
    FValidMatch := False;
  end;
end;

procedure TfrmMain.ValidateFilter;
var
  ErrorMsg: string;
begin
  if not FEnableUpdates then Exit;

  if rbFilterGlob.Checked then
    ErrorMsg := ValidateGlob(txtFilter.Text)
  else
    ErrorMsg := ValidateRegex(txtFilter.Text);

  if ErrorMsg = '' then
  begin
    txtFilter.Color := clWindow;
    FValidFilter := True;
  end
  else
  begin
    txtFilter.Color := $00C0C0FF; // MistyRose
    FValidFilter := False;
  end;
end;

procedure TfrmMain.ApplyFilter;
begin
  if not FEnableUpdates or not FValidFilter then Exit;
  FActiveFilter := txtFilter.Text;
  UpdateFileList;
end;

// Regex helpers

function TfrmMain.RegExReplaceCount(const AInput, APattern, AReplacement: string;
  AOptions: TRegExOptions; ACount: Integer): string;
var
  Regex: TRegEx;
  M: TMatch;
  Offset: Integer;
  ReplaceCount: Integer;
begin
  if ACount = -1 then
  begin
    // Replace all
    Regex := TRegEx.Create(APattern, AOptions);
    Result := Regex.Replace(AInput, AReplacement);
  end
  else
  begin
    // Replace first N matches
    Regex := TRegEx.Create(APattern, AOptions);
    Result := AInput;
    M := Regex.Match(Result);
    ReplaceCount := 0;
    Offset := 0;

    while M.Success and (ReplaceCount < ACount) do
    begin
      var Replacement := TRegEx.Create(APattern, AOptions).Replace(
        Copy(Result, M.Index + Offset, M.Length), AReplacement);

      Result := Copy(Result, 1, M.Index - 1 + Offset) + Replacement +
        Copy(Result, M.Index + M.Length + Offset, MaxInt);

      Inc(ReplaceCount);
      if ReplaceCount < ACount then
      begin
        Offset := M.Index - 1 + Length(Replacement);
        var Remaining := Copy(Result, Offset + 1, MaxInt);
        M := Regex.Match(Remaining);
      end;
    end;
  end;
end;

class function TfrmMain.SequenceNumberToLetter(ANum: Integer): string;
var
  Dividend, Modulo: Integer;
begin
  Result := '';
  Dividend := ANum;
  while Dividend > 0 do
  begin
    Modulo := (Dividend - 1) mod 26;
    Result := Chr(97 + Modulo) + Result;
    Dividend := (Dividend - Modulo) div 26;
  end;
end;

class function TfrmMain.SequenceLetterToNumber(const ALetter: string): Integer;
var
  I, Pow: Integer;
begin
  Result := 0;
  Pow := 1;
  for I := Length(ALetter) downto 1 do
  begin
    Result := Result + (Ord(ALetter[I]) - Ord('a') + 1) * Pow;
    Pow := Pow * 26;
  end;
end;

function TfrmMain.MatchEvalChangeCase(const AMatch: TMatch): string;
var
  S: string;
  I: Integer;
  CapNext: Boolean;
begin
  if AMatch.Groups.Count < 2 then
    Exit(AMatch.Value);

  S := AMatch.Groups[1].Value;

  case FChangeCaseMode of
    ccUppercase:
      Result := UpperCase(S);
    ccLowercase:
      Result := LowerCase(S);
    ccTitlecase:
    begin
      Result := LowerCase(S);
      CapNext := True;
      for I := 1 to Length(Result) do
      begin
        if CapNext and Result[I].IsLetter then
        begin
          Result[I] := UpCase(Result[I]);
          CapNext := False;
        end
        else if Result[I] = ' ' then
          CapNext := True;
      end;
    end;
  else
    Result := S;
  end;
end;

// Icon helpers

function TfrmMain.GetFileIcon(const AFilePath: string; AByExtension: Boolean): Integer;
var
  SHFileInfo: TSHFileInfo;
  Icon: TIcon;
  Flags: UINT;
begin
  Flags := SHGFI_ICON or SHGFI_SMALLICON;
  if AByExtension then
    Flags := Flags or SHGFI_USEFILEATTRIBUTES;

  FillChar(SHFileInfo, SizeOf(SHFileInfo), 0);

  if AByExtension then
    SHGetFileInfo(PChar(AFilePath), FILE_ATTRIBUTE_NORMAL, SHFileInfo,
      SizeOf(SHFileInfo), Flags)
  else
    SHGetFileInfo(PChar(AFilePath), 0, SHFileInfo, SizeOf(SHFileInfo), Flags);

  if SHFileInfo.hIcon <> 0 then
  begin
    Icon := TIcon.Create;
    try
      Icon.Handle := SHFileInfo.hIcon;
      Result := ilFiles.AddIcon(Icon);
    finally
      Icon.Free;
    end;
  end
  else
    Result := -1;
end;

function TfrmMain.GetFolderIcon: Integer;
var
  SHFileInfo: TSHFileInfo;
  Icon: TIcon;
begin
  FillChar(SHFileInfo, SizeOf(SHFileInfo), 0);
  SHGetFileInfo(PChar('folder'), FILE_ATTRIBUTE_DIRECTORY, SHFileInfo,
    SizeOf(SHFileInfo), SHGFI_ICON or SHGFI_SMALLICON or SHGFI_USEFILEATTRIBUTES);

  if SHFileInfo.hIcon <> 0 then
  begin
    Icon := TIcon.Create;
    try
      Icon.Handle := SHFileInfo.hIcon;
      Result := ilFiles.AddIcon(Icon);
    finally
      Icon.Free;
    end;
  end
  else
    Result := -1;
end;

// Context menus

function TfrmMain.AddContextMenuItem(AMenu: TPopupMenu; const ACaption: string;
  const AArgs: TInsertArgs; ABreak: Boolean): TMenuItem;
var
  ArgsObj: TInsertArgsObject;
begin
  ArgsObj := TInsertArgsObject.Create(AArgs);
  FInsertArgsObjects.Add(ArgsObj);

  Result := TMenuItem.Create(AMenu);
  Result.Caption := ACaption;
  Result.Tag := NativeInt(ArgsObj);
  Result.OnClick := InsertRegexFragment;
  if ABreak then
    Result.Break := mbBarBreak;
  AMenu.Items.Add(Result);
end;

procedure TfrmMain.BuildRegexContextMenus;

  procedure AddSub(AParent: TMenuItem; const ACaption: string; const AArgs: TInsertArgs;
    ABreak: Boolean = False);
  var
    MI: TMenuItem;
    ArgsObj: TInsertArgsObject;
  begin
    ArgsObj := TInsertArgsObject.Create(AArgs);
    FInsertArgsObjects.Add(ArgsObj);
    MI := TMenuItem.Create(AParent);
    MI.Caption := ACaption;
    MI.Tag := NativeInt(ArgsObj);
    MI.OnClick := InsertRegexFragment;
    if ABreak then
      MI.Break := mbBarBreak;
    AParent.Add(MI);
  end;

var
  miMatch, miAnchor, miGroup, miQuant, miClass, miCapt, miLook, miLiteral: TMenuItem;
  miReplCapt, miReplOrig, miReplSpec: TMenuItem;
begin
  // --- REGEX MATCH CONTEXT MENU ---

  miMatch := TMenuItem.Create(pmRegexMatch);
  miMatch.Caption := 'Match';
  pmRegexMatch.Items.Add(miMatch);
  AddSub(miMatch, 'Single character (.)', TInsertArgs.Create('.'));
  AddSub(miMatch, 'Digit (\d)', TInsertArgs.Create('\d'));
  AddSub(miMatch, 'Alphanumeric (\w)', TInsertArgs.Create('\w'));
  AddSub(miMatch, 'Whitespace (\s)', TInsertArgs.Create('\s'));
  AddSub(miMatch, 'Multiple characters (.*)', TInsertArgs.Create('.*'), True);
  AddSub(miMatch, 'Non-digit (\D)', TInsertArgs.Create('\D'));
  AddSub(miMatch, 'Non-alphanumeric (\W)', TInsertArgs.Create('\W'));
  AddSub(miMatch, 'Non-whitespace (\S)', TInsertArgs.Create('\S'));

  miAnchor := TMenuItem.Create(pmRegexMatch);
  miAnchor.Caption := 'Anchor';
  pmRegexMatch.Items.Add(miAnchor);
  AddSub(miAnchor, 'Start of string (^)', TInsertArgs.Create('^', '', 'group'));
  AddSub(miAnchor, 'End of string ($)', TInsertArgs.Create('', '$', 'group'));
  AddSub(miAnchor, 'Start and End (^...$)', TInsertArgs.Create('^', '$', 'group'));
  AddSub(miAnchor, 'Word boundary (\b)', TInsertArgs.Create('\b', '', 'wrap'));
  AddSub(miAnchor, 'Non-word boundary (\B)', TInsertArgs.Create('\B', '', 'wrap'));

  miGroup := TMenuItem.Create(pmRegexMatch);
  miGroup.Caption := 'Group';
  pmRegexMatch.Items.Add(miGroup);
  AddSub(miGroup, 'Capturing group (())', TInsertArgs.Create('(', ')'));
  AddSub(miGroup, 'Non-capturing group ((?:))', TInsertArgs.Create('(?:', ')'));
  AddSub(miGroup, 'Alternation ((|))', TInsertArgs.Create('(', '|)', -1, 0));

  miQuant := TMenuItem.Create(pmRegexMatch);
  miQuant.Caption := 'Quantifier';
  pmRegexMatch.Items.Add(miQuant);
  AddSub(miQuant, 'Zero or one (?)', TInsertArgs.Create('', '?', 'group'));
  AddSub(miQuant, 'One or more (+)', TInsertArgs.Create('', '+', 'group'));
  AddSub(miQuant, 'Zero or more (*)', TInsertArgs.Create('', '*', 'group'));
  AddSub(miQuant, 'Exactly n ({n})', TInsertArgs.Create('', '{n}', -2, 1, 'group'));
  AddSub(miQuant, 'At least n ({n,})', TInsertArgs.Create('', '{n,}', -3, 1, 'group'));
  AddSub(miQuant, 'Between n and m ({n,m})', TInsertArgs.Create('', '{n,m}', -4, 3, 'group'));
  AddSub(miQuant, 'Zero or one - lazy (??)', TInsertArgs.Create('', '??', 'group'), True);
  AddSub(miQuant, 'One or more - lazy (+?)', TInsertArgs.Create('', '+?', 'group'));
  AddSub(miQuant, 'Zero or more - lazy (*?)', TInsertArgs.Create('', '*?', 'group'));
  AddSub(miQuant, 'Exactly n - lazy ({n}?)', TInsertArgs.Create('', '{n}?', -3, 1, 'group'));
  AddSub(miQuant, 'At least n - lazy ({n,}?)', TInsertArgs.Create('', '{n,}?', -4, 1, 'group'));
  AddSub(miQuant, 'Between n,m - lazy ({n,m}?)', TInsertArgs.Create('', '{n,m}?', -5, 3, 'group'));

  miClass := TMenuItem.Create(pmRegexMatch);
  miClass.Caption := 'Character Class';
  pmRegexMatch.Items.Add(miClass);
  AddSub(miClass, 'Positive class ([])', TInsertArgs.Create('[', ']'));
  AddSub(miClass, 'Negative class ([^])', TInsertArgs.Create('[^', ']'));
  AddSub(miClass, 'Lowercase range ([a-z])', TInsertArgs.Create('[a-z]'));
  AddSub(miClass, 'Uppercase range ([A-Z])', TInsertArgs.Create('[A-Z]'));

  miCapt := TMenuItem.Create(pmRegexMatch);
  miCapt.Caption := 'Capture';
  pmRegexMatch.Items.Add(miCapt);
  AddSub(miCapt, 'Create unnamed capture (())', TInsertArgs.Create('(', ')'));
  AddSub(miCapt, 'Match unnamed capture (\n)', TInsertArgs.Create('\n', '', 1, 1));
  AddSub(miCapt, 'Create named capture ((?<name>))', TInsertArgs.Create('(?<name>', ')', 3, 4));
  AddSub(miCapt, 'Match named capture (\<name>)', TInsertArgs.Create('\<name>', '', 2, 4));

  miLook := TMenuItem.Create(pmRegexMatch);
  miLook.Caption := 'Lookahead/Lookbehind';
  pmRegexMatch.Items.Add(miLook);
  AddSub(miLook, 'Positive lookahead ((?=))', TInsertArgs.Create('(?=', ')'));
  AddSub(miLook, 'Negative lookahead ((?!))', TInsertArgs.Create('(?!', ')'));
  AddSub(miLook, 'Positive lookbehind ((?<=))', TInsertArgs.Create('(?<=', ')'));
  AddSub(miLook, 'Negative lookbehind ((?<!))', TInsertArgs.Create('(?<!', ')'));

  miLiteral := TMenuItem.Create(pmRegexMatch);
  miLiteral.Caption := 'Literal';
  pmRegexMatch.Items.Add(miLiteral);
  AddSub(miLiteral, 'Dot (\.)', TInsertArgs.Create('\.'));
  AddSub(miLiteral, 'Question mark (\?)', TInsertArgs.Create('\?'));
  AddSub(miLiteral, 'Plus (\+)', TInsertArgs.Create('\+'));
  AddSub(miLiteral, 'Star (\*)', TInsertArgs.Create('\*'));
  AddSub(miLiteral, 'Caret (\^)', TInsertArgs.Create('\^'));
  AddSub(miLiteral, 'Dollar (\$)', TInsertArgs.Create('\$'));
  AddSub(miLiteral, 'Backslash (\\)', TInsertArgs.Create('\\'));
  AddSub(miLiteral, 'Open paren (\()', TInsertArgs.Create('\('), True);
  AddSub(miLiteral, 'Close paren (\))', TInsertArgs.Create('\)'));
  AddSub(miLiteral, 'Open bracket (\[)', TInsertArgs.Create('\['));
  AddSub(miLiteral, 'Close bracket (\])', TInsertArgs.Create('\]'));
  AddSub(miLiteral, 'Open brace (\{)', TInsertArgs.Create('\{'));
  AddSub(miLiteral, 'Close brace (\})', TInsertArgs.Create('\}'));
  AddSub(miLiteral, 'Pipe (\|)', TInsertArgs.Create('\|'));

  // --- REGEX REPLACE CONTEXT MENU ---

  miReplCapt := TMenuItem.Create(pmRegexReplace);
  miReplCapt.Caption := 'Capture';
  pmRegexReplace.Items.Add(miReplCapt);
  AddSub(miReplCapt, 'Unnamed capture ($n)', TInsertArgs.Create('$n', '', 1, 1));
  AddSub(miReplCapt, 'Named capture (${name})', TInsertArgs.Create('${name}', '', 2, 4));

  miReplOrig := TMenuItem.Create(pmRegexReplace);
  miReplOrig.Caption := 'Original';
  pmRegexReplace.Items.Add(miReplOrig);
  AddSub(miReplOrig, 'Matched string ($0)', TInsertArgs.Create('$0'));
  AddSub(miReplOrig, 'Before match ($`)', TInsertArgs.Create('$`'));
  AddSub(miReplOrig, 'After match ($'')', TInsertArgs.Create('$'''));
  AddSub(miReplOrig, 'Entire filename ($_)', TInsertArgs.Create('$_'));

  miReplSpec := TMenuItem.Create(pmRegexReplace);
  miReplSpec.Caption := 'Special';
  pmRegexReplace.Items.Add(miReplSpec);
  AddSub(miReplSpec, 'Number sequence ($#)', TInsertArgs.Create('$#'));
  AddSub(miReplSpec, 'Literal dollar ($$)', TInsertArgs.Create('$$'));

  // --- GLOB MATCH CONTEXT MENU ---

  AddContextMenuItem(pmGlobMatch, 'Single character (?)', TInsertArgs.Create('?'));
  AddContextMenuItem(pmGlobMatch, 'Multiple characters (*)', TInsertArgs.Create('*'));
end;

procedure TfrmMain.InsertRegexFragment(Sender: TObject);
var
  MI: TMenuItem;
  ArgsObj: TInsertArgsObject;
  IA: TInsertArgs;
  Edit: TCustomEdit;
  SelStart, SelLen: Integer;
  Text: string;
  Group: Integer;
begin
  MI := Sender as TMenuItem;
  ArgsObj := TInsertArgsObject(MI.Tag);
  if ArgsObj = nil then Exit;
  IA := ArgsObj.Args;

  // Determine target control
  if FLastControlRightClicked is TComboBox then
  begin
    SelStart := TComboBox(FLastControlRightClicked).SelStart;
    SelLen := TComboBox(FLastControlRightClicked).SelLength;
    Text := TComboBox(FLastControlRightClicked).Text;
  end
  else if FLastControlRightClicked is TEdit then
  begin
    Edit := TCustomEdit(FLastControlRightClicked);
    SelStart := Edit.SelStart;
    SelLen := Edit.SelLength;
    Text := TEdit(Edit).Text;
  end
  else
    Exit;

  // InsertBefore empty + no selection: swap with InsertAfter
  if (IA.InsertBefore = '') and (SelLen = 0) then
  begin
    IA.InsertBefore := IA.InsertAfter;
    IA.InsertAfter := '';
  end;

  // Wrap logic
  if IA.WrapIfSelection and (SelLen > 0) then
  begin
    if IA.InsertAfter = '' then
      IA.InsertAfter := IA.InsertBefore
    else
      IA.InsertBefore := IA.InsertAfter;
  end;

  Group := 0;
  if IA.GroupSelection and (SelLen > 0) then
  begin
    Insert('(', Text, SelStart + 1);
    Inc(SelStart);
    Insert(')', Text, SelStart + SelLen + 1);
    Group := 1;
  end;

  if (SelLen > 0) and ((IA.InsertBefore = '') or (IA.InsertAfter = '')) and not IA.GroupSelection then
  begin
    Delete(Text, SelStart + 1, SelLen);
    SelLen := 0;
  end;

  if IA.InsertBefore <> '' then
  begin
    Insert(IA.InsertBefore, Text, SelStart - Group + 1);
    SelStart := SelStart + Length(IA.InsertBefore);
  end;
  if IA.InsertAfter <> '' then
    Insert(IA.InsertAfter, Text, SelStart + SelLen + Group + 1);

  if IA.SelectionStartOffset > 0 then
    SelStart := SelStart - Group - Length(IA.InsertBefore) + IA.SelectionStartOffset;
  if IA.SelectionStartOffset < 0 then
    SelStart := SelStart + SelLen + Group + Length(IA.InsertAfter) + IA.SelectionStartOffset;
  if IA.SelectionLength <> -1 then
    SelLen := IA.SelectionLength;

  // Apply
  if FLastControlRightClicked is TComboBox then
  begin
    TComboBox(FLastControlRightClicked).Text := Text;
    TComboBox(FLastControlRightClicked).SelStart := SelStart;
    TComboBox(FLastControlRightClicked).SelLength := SelLen;
  end
  else if FLastControlRightClicked is TEdit then
  begin
    TEdit(FLastControlRightClicked).Text := Text;
    TEdit(FLastControlRightClicked).SelStart := SelStart;
    TEdit(FLastControlRightClicked).SelLength := SelLen;
  end;
end;

// ListView drawing

procedure TfrmMain.lvFilesDrawItem(Sender: TCustomListView; Item: TListItem;
  Rect: TRect; State: TOwnerDrawState);
var
  Afi: Integer;
  LV: TListView;
  ColRect: TRect;
  TextColor: TColor;
  S: string;
begin
  LV := TListView(Sender);
  Afi := Integer(Item.Data);
  if Afi >= FActiveFiles.Count then Exit;

  // Draw icon column
  ColRect := Rect;
  ColRect.Right := ColRect.Left + LV.Columns[0].Width;
  LV.Canvas.FillRect(ColRect);
  if (Item.ImageIndex >= 0) and Assigned(ilFiles) then
    ilFiles.Draw(LV.Canvas, ColRect.Left + 2, ColRect.Top, Item.ImageIndex);

  // Draw filename column
  ColRect.Left := ColRect.Right;
  ColRect.Right := ColRect.Left + LV.Columns[1].Width;

  if odSelected in State then
  begin
    LV.Canvas.Brush.Color := clHighlight;
    LV.Canvas.Font.Color := clHighlightText;
  end
  else
  begin
    LV.Canvas.Brush.Color := clWindow;
    if FActiveFiles[Afi].Matched then
      TextColor := clBlue
    else if FActiveFiles[Afi].Hidden then
      TextColor := clGrayText
    else
      TextColor := clWindowText;
    LV.Canvas.Font.Color := TextColor;
  end;
  LV.Canvas.FillRect(ColRect);
  S := Item.SubItems[0];
  LV.Canvas.TextRect(ColRect, ColRect.Left + 4, ColRect.Top + 1, S);

  // Draw preview column
  ColRect.Left := ColRect.Right;
  ColRect.Right := ColRect.Left + LV.Columns[2].Width;

  if odSelected in State then
  begin
    LV.Canvas.Brush.Color := clHighlight;
    LV.Canvas.Font.Color := clHighlightText;
  end
  else
  begin
    LV.Canvas.Brush.Color := clWindow;
    if FPreviewErrors.ContainsKey(Item.Index) then
      TextColor := clRed
    else if itmOutputRenameInPlace.Checked and (FActiveFiles[Afi].Name <> FActiveFiles[Afi].Preview) then
      TextColor := clBlue
    else if not itmOutputRenameInPlace.Checked and FActiveFiles[Afi].Matched then
      TextColor := clBlue
    else if FActiveFiles[Afi].Hidden then
      TextColor := clGrayText
    else
      TextColor := clWindowText;
    LV.Canvas.Font.Color := TextColor;
  end;
  LV.Canvas.FillRect(ColRect);
  if Item.SubItems.Count > 1 then
  begin
    S := Item.SubItems[1];
    LV.Canvas.TextRect(ColRect, ColRect.Left + 4, ColRect.Top + 1, S);
  end;

  // Fill remaining space
  ColRect.Left := ColRect.Right;
  ColRect.Right := Rect.Right;
  LV.Canvas.Brush.Color := clWindow;
  LV.Canvas.FillRect(ColRect);
end;

// Event handlers

procedure TfrmMain.ShellTreeChange(Sender: TObject; Node: TTreeNode);
begin
  if not FEnableUpdates then Exit;
  FActivePath := ShellTree.Path;
  UpdateFileList;
end;

procedure TfrmMain.cmbMatchChange(Sender: TObject);
begin
  if not FEnableUpdates then Exit;
  if (cmbMatch.Text <> '') and (cmbMatch.Text[1] = '/') then Exit;

  ValidateMatch;

  if itmOptionsRealtimePreview.Checked then
    UpdatePreview;
end;

procedure TfrmMain.cmbMatchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if cmbMatch.DroppedDown then Exit;

  if (Key = VK_RETURN) and not itmOptionsRealtimePreview.Checked then
  begin
    if FValidMatch and PreviewNeedsUpdate then
      UpdatePreview;
    Key := 0;
  end
  else if (Key = VK_DELETE) and (ssCtrl in Shift) then
  begin
    ResetFields;
    cmbMatch.Items.Clear;
    SaveRegexHistory;
    UpdateFileList;
    Key := 0;
  end
  else if (Key = VK_BACK) and (ssCtrl in Shift) then
  begin
    ResetFields;
    UpdateFileList;
    Key := 0;
  end
  else if (Key = VK_DOWN) and not (ssAlt in Shift) then
  begin
    txtReplace.SetFocus;
    Key := 0;
  end;
end;

procedure TfrmMain.cmbMatchSelect(Sender: TObject);
var
  RegexString: string;
  M: TMatch;
begin
  if cmbMatch.ItemIndex = -1 then Exit;

  RegexString := cmbMatch.Items[cmbMatch.ItemIndex];
  M := TRegEx.Match(RegexString, '^/(?P<match>[^/]+)/(?P<replace>[^/]*)/(?P<modifiers>[igx]*)$');

  if M.Success then
  begin
    FEnableUpdates := False;
    cmbMatch.Text := M.Groups['match'].Value;
    txtReplace.Text := M.Groups['replace'].Value;
    cbModifierI.Checked := M.Groups['modifiers'].Value.Contains('i');
    cbModifierG.Checked := M.Groups['modifiers'].Value.Contains('g');
    cbModifierX.Checked := M.Groups['modifiers'].Value.Contains('x');
    FEnableUpdates := True;
    ValidateMatch;
    UpdatePreview;
  end
  else
  begin
    cmbMatch.Items.Delete(cmbMatch.ItemIndex);
    SaveRegexHistory;
    ResetFields;
  end;
end;

procedure TfrmMain.CmbMatchWndProc(var Message: TMessage);
var
  P: TPoint;
begin
  if (Message.Msg = WM_RBUTTONDOWN) and (GetKeyState(VK_SHIFT) < 0) then
  begin
    P.X := TWMRButtonDown(Message).XPos;
    P.Y := TWMRButtonDown(Message).YPos;
    FLastControlRightClicked := cmbMatch;
    P := cmbMatch.ClientToScreen(P);
    pmRegexMatch.Popup(P.X, P.Y);
    Exit;
  end;
  FOldCmbMatchWndProc(Message);
end;

procedure TfrmMain.txtReplaceChange(Sender: TObject);
begin
  if not FEnableUpdates then Exit;
  if (cmbMatch.Text <> '') and (cmbMatch.Text[1] = '/') then Exit;

  if itmOptionsRealtimePreview.Checked then
    UpdatePreview;
end;

procedure TfrmMain.txtReplaceKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) and not itmOptionsRealtimePreview.Checked then
  begin
    if FValidMatch and PreviewNeedsUpdate then
      UpdatePreview;
    Key := 0;
  end
  else if (Key = VK_BACK) and (ssCtrl in Shift) then
  begin
    ResetFields;
    UpdateFileList;
    Key := 0;
  end
  else if Key = VK_UP then
  begin
    cmbMatch.SetFocus;
    Key := 0;
  end;
end;

procedure TfrmMain.TxtReplaceWndProc(var Message: TMessage);
var
  P: TPoint;
begin
  if (Message.Msg = WM_RBUTTONDOWN) and (GetKeyState(VK_SHIFT) < 0) then
  begin
    P.X := TWMRButtonDown(Message).XPos;
    P.Y := TWMRButtonDown(Message).YPos;
    FLastControlRightClicked := txtReplace;
    P := txtReplace.ClientToScreen(P);
    pmRegexReplace.Popup(P.X, P.Y);
    Exit;
  end;
  FOldTxtReplaceWndProc(Message);
end;

procedure TfrmMain.cbModifierClick(Sender: TObject);
begin
  UpdatePreview;
end;

procedure TfrmMain.txtFilterChange(Sender: TObject);
begin
  ValidateFilter;
end;

procedure TfrmMain.txtFilterKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    ApplyFilter;
    Key := 0;
  end
  else if Key = VK_ESCAPE then
  begin
    FEnableUpdates := False;
    txtFilter.Text := FActiveFilter;
    FEnableUpdates := True;
    FValidFilter := True;
    txtFilter.Color := clWindow;
    Key := 0;
  end;
end;

procedure TfrmMain.TxtFilterWndProc(var Message: TMessage);
var
  P: TPoint;
begin
  if (Message.Msg = WM_RBUTTONDOWN) and (GetKeyState(VK_SHIFT) < 0) then
  begin
    P.X := TWMRButtonDown(Message).XPos;
    P.Y := TWMRButtonDown(Message).YPos;
    FLastControlRightClicked := txtFilter;
    P := txtFilter.ClientToScreen(P);
    if rbFilterGlob.Checked then
      pmGlobMatch.Popup(P.X, P.Y)
    else
      pmRegexMatch.Popup(P.X, P.Y);
    Exit;
  end;
  FOldTxtFilterWndProc(Message);
end;

procedure TfrmMain.rbFilterTypeClick(Sender: TObject);
begin
  if rbFilterGlob.Checked and ((txtFilter.Text = '.*') or (txtFilter.Text = '.+')) then
  begin
    FEnableUpdates := False;
    txtFilter.Text := '*.*';
    FActiveFilter := '*.*';
    FEnableUpdates := True;
  end
  else if rbFilterRegex.Checked and ((txtFilter.Text = '*.*') or (txtFilter.Text = '*')) then
  begin
    FEnableUpdates := False;
    txtFilter.Text := '.*';
    FActiveFilter := '.*';
    FEnableUpdates := True;
  end
  else
  begin
    FActiveFilter := '';
    ValidateFilter;
  end;
end;

procedure TfrmMain.cbFilterExcludeClick(Sender: TObject);
begin
  if FValidFilter then
    ApplyFilter;
end;

procedure TfrmMain.txtPathKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if not FEnableUpdates then Exit;
    if TDirectory.Exists(txtPath.Text) then
    begin
      FActivePath := txtPath.Text;
      try
        ShellTree.Path := FActivePath;
      except
      end;
      UpdateFileList;
      Key := 0;
    end
    else
    begin
      txtPath.Color := $00C0C0FF;
    end;
  end
  else if Key = VK_ESCAPE then
  begin
    txtPath.Text := FActivePath;
    txtPath.Color := clWindow;
    Key := 0;
  end;
end;

procedure TfrmMain.btnNetworkClick(Sender: TObject);
var
  Dir: string;
begin
  if not FEnableUpdates then Exit;
  Dir := FActivePath;
  if SelectDirectory('Select network folder:', '', Dir, [sdNewUI, sdShowEdit]) then
  begin
    if TDirectory.Exists(Dir) then
    begin
      FActivePath := Dir;
      txtPath.Text := Dir;
      UpdateFileList;
    end;
  end;
end;

procedure TfrmMain.lvFilesColumnClick(Sender: TObject; Column: TListColumn);
begin
  if Column.Index = FSortColumn then
    FSortAscending := not FSortAscending
  else
  begin
    FSortColumn := Column.Index;
    FSortAscending := True;
  end;
  lvFiles.CustomSort(nil, FSortColumn);
end;

procedure TfrmMain.lvFilesCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var
  Afi1, Afi2: Integer;
  S1, S2: string;
begin
  Afi1 := Integer(Item1.Data);
  Afi2 := Integer(Item2.Data);

  if (Afi1 >= FActiveFiles.Count) or (Afi2 >= FActiveFiles.Count) then
  begin
    Compare := 0;
    Exit;
  end;

  case FSortColumn of
    0, 1: // Icon or Filename column
    begin
      S1 := FActiveFiles[Afi1].Filename;
      S2 := FActiveFiles[Afi2].Filename;
    end;
    2: // Preview column
    begin
      S1 := FActiveFiles[Afi1].Preview;
      S2 := FActiveFiles[Afi2].Preview;
    end;
  else
    S1 := '';
    S2 := '';
  end;

  Compare := CompareText(S1, S2);
  if not FSortAscending then
    Compare := -Compare;
end;

procedure TfrmMain.lvFilesDblClick(Sender: TObject);
var
  Afi: Integer;
begin
  if not FEnableUpdates then Exit;
  if lvFiles.Selected = nil then Exit;

  Afi := Integer(lvFiles.Selected.Data);
  if Afi < FActiveFiles.Count then
  begin
    try
      ShellExecute(Handle, 'open', PChar(FActiveFiles[Afi].Fullpath), nil, nil, SW_SHOWNORMAL);
    except
      on E: Exception do
        MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfrmMain.lvFilesKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if not FEnableUpdates then Exit;
  if Key = VK_F5 then
    UpdateFileList;
end;

procedure TfrmMain.lvFilesSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  UpdateSelection;
end;

procedure TfrmMain.lblStatsMouseEnter(Sender: TObject);
begin
  lblStats.Font.Color := clBlue;
  pnlStats.Visible := True;
end;

procedure TfrmMain.lblStatsMouseLeave(Sender: TObject);
begin
  lblStats.Font.Color := clGrayText;
  pnlStats.Visible := False;
end;

// Change case menu

procedure TfrmMain.itmChangeCaseClick(Sender: TObject);
begin
  if not FEnableUpdates then Exit;

  itmChangeCaseNoChange.Checked := (Sender = itmChangeCaseNoChange);
  itmChangeCaseUppercase.Checked := (Sender = itmChangeCaseUppercase);
  itmChangeCaseLowercase.Checked := (Sender = itmChangeCaseLowercase);
  itmChangeCaseTitlecase.Checked := (Sender = itmChangeCaseTitlecase);

  if itmChangeCaseUppercase.Checked then FChangeCaseMode := ccUppercase
  else if itmChangeCaseLowercase.Checked then FChangeCaseMode := ccLowercase
  else if itmChangeCaseTitlecase.Checked then FChangeCaseMode := ccTitlecase
  else FChangeCaseMode := ccNone;

  // Set default match/replace if selecting a case change
  if FChangeCaseMode <> ccNone then
  begin
    if cmbMatch.Text = '' then
    begin
      FEnableUpdates := False;
      cmbMatch.Text := '.*';
      FEnableUpdates := True;
    end;
    if txtReplace.Text = '' then
    begin
      FEnableUpdates := False;
      txtReplace.Text := '$0';
      FEnableUpdates := True;
    end;
  end;

  // Mark toolbar button if a case mode is active
  if FChangeCaseMode <> ccNone then
    tbnChangeCase.Caption := '* Change Case'
  else
    tbnChangeCase.Caption := 'Change Case';

  UpdatePreview;
end;

// Numbering menu

procedure TfrmMain.itmNumberingClick(Sender: TObject);
var
  MI: TMenuItem;
  Prompt, Value: string;
  Num: Integer;
begin
  MI := Sender as TMenuItem;
  if MI = itmNumberingStart then
  begin
    Prompt := 'Start value:';
    Value := FNumberingStart;
  end
  else if MI = itmNumberingPad then
  begin
    Prompt := 'Pad format (e.g. 000):';
    Value := FNumberingPad;
  end
  else if MI = itmNumberingInc then
  begin
    Prompt := 'Increment:';
    Value := FNumberingInc;
  end
  else if MI = itmNumberingReset then
  begin
    Prompt := 'Reset after (0=never):';
    Value := FNumberingReset;
  end
  else
    Exit;

  if InputQuery('Numbering', Prompt, Value) then
  begin
    if MI = itmNumberingStart then
    begin
      FNumberingStart := Value;
      itmNumberingStart.Caption := 'Start: ' + Value;
    end
    else if MI = itmNumberingPad then
    begin
      FNumberingPad := Value;
      itmNumberingPad.Caption := 'Pad: ' + Value;
    end
    else if MI = itmNumberingInc then
    begin
      FNumberingInc := Value;
      itmNumberingInc.Caption := 'Inc: ' + Value;
    end
    else if MI = itmNumberingReset then
    begin
      FNumberingReset := Value;
      itmNumberingReset.Caption := 'Reset: ' + Value;
    end;

    // Validate
    FValidNumber := True;
    Num := 0;
    if not TryStrToInt(FNumberingStart, Num) then
    begin
      // Check for letter sequence
      if not TRegEx.IsMatch(FNumberingStart, '^([a-z]+|[A-Z]+)$') then
        FValidNumber := False;
    end;
    if not TryStrToInt(FNumberingInc, Num) or (Num = 0) then
      FValidNumber := False;
    if not TryStrToInt(FNumberingReset, Num) or (Num < 0) then
      FValidNumber := False;

    if FValidNumber then
      UpdatePreview;
  end;
end;

// Move/Copy menu

procedure TfrmMain.itmOutputClick(Sender: TObject);
var
  MI: TMenuItem;
  Dir: string;
begin
  MI := Sender as TMenuItem;

  if MI <> itmOutputRenameInPlace then
  begin
    Dir := FMoveCopyPath;
    if not SelectDirectory('Select folder:', '', Dir, [sdNewUI, sdShowEdit]) then
      Exit;
    FMoveCopyPath := Dir;
  end;

  itmOutputRenameInPlace.Checked := (MI = itmOutputRenameInPlace);
  itmOutputMoveTo.Checked := (MI = itmOutputMoveTo);
  itmOutputCopyTo.Checked := (MI = itmOutputCopyTo);
  itmOutputBackupTo.Checked := (MI = itmOutputBackupTo);

  if not itmOutputRenameInPlace.Checked then
    tbnMoveCopy.Caption := '* Move / Copy'
  else
    tbnMoveCopy.Caption := 'Move / Copy';

  UpdateValidation;
end;

// Options

procedure TfrmMain.itmOptionsShowHiddenClick(Sender: TObject);
begin
  itmOptionsShowHidden.Checked := not itmOptionsShowHidden.Checked;
  UpdateFileList;
end;

procedure TfrmMain.itmOptionsPreserveExtClick(Sender: TObject);
var
  I, Afi: Integer;
begin
  itmOptionsPreserveExt.Checked := not itmOptionsPreserveExt.Checked;

  for I := 0 to FActiveFiles.Count - 1 do
    FActiveFiles[I].PreserveExt := itmOptionsPreserveExt.Checked;

  // Update filename column
  lvFiles.Items.BeginUpdate;
  try
    for I := 0 to lvFiles.Items.Count - 1 do
    begin
      Afi := Integer(lvFiles.Items[I].Data);
      if Afi < FActiveFiles.Count then
        lvFiles.Items[I].SubItems[0] := FActiveFiles[Afi].Name;
    end;
  finally
    lvFiles.Items.EndUpdate;
  end;

  UpdatePreview;
end;

procedure TfrmMain.itmOptionsRealtimePreviewClick(Sender: TObject);
begin
  itmOptionsRealtimePreview.Checked := not itmOptionsRealtimePreview.Checked;
end;

procedure TfrmMain.itmOptionsAllowRenSubClick(Sender: TObject);
begin
  itmOptionsAllowRenSub.Checked := not itmOptionsAllowRenSub.Checked;
  UpdateValidation;
end;

procedure TfrmMain.itmOptionsAddContextMenuClick(Sender: TObject);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_WRITE);
  try
    Reg.RootKey := HKEY_CLASSES_ROOT;
    if not itmOptionsAddContextMenu.Checked then
    begin
      if Reg.OpenKey('Folder\shell\RegexRenamer', True) then
      begin
        Reg.WriteString('', 'Rename using RegExRenamer');
        Reg.CloseKey;
      end;
      if Reg.OpenKey('Folder\shell\RegexRenamer\command', True) then
      begin
        Reg.WriteString('', Application.ExeName + ' "%L"');
        Reg.CloseKey;
      end;
      itmOptionsAddContextMenu.Checked := True;
    end
    else
    begin
      if Reg.KeyExists('Folder\shell\RegexRenamer') then
        Reg.DeleteKey('Folder\shell\RegexRenamer');
      itmOptionsAddContextMenu.Checked := False;
    end;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
  Reg.Free;
end;

// Help

procedure TfrmMain.itmHelpAboutClick(Sender: TObject);
var
  Dlg: TdlgAbout;
begin
  Dlg := TdlgAbout.Create(Self);
  try
    Dlg.SetStats(FCountProgLaunches, FCountFilesRenamed);
    Dlg.ShowModal;
  finally
    Dlg.Free;
  end;
end;

// Rename mode

procedure TfrmMain.itmRenameModeClick(Sender: TObject);
begin
  SetRenameFolders(Sender = itmRenameFolders);
  UpdateFileList;
end;

procedure TfrmMain.btnRenameDropClick(Sender: TObject);
var
  P: TPoint;
begin
  P := btnRenameDrop.ClientToScreen(Point(0, btnRenameDrop.Height));
  pmRenameMode.Popup(P.X, P.Y);
end;

// Rename

procedure TfrmMain.btnRenameClick(Sender: TObject);
var
  ErrorMessage: string;
  FilesToRename: Integer;
  I, Afi: Integer;
  RegexString: string;
  OutputPath: string;
begin
  ErrorMessage := '';

  // Validate
  if not FValidMatch then
    ErrorMessage := 'The match regular expression is invalid.';

  // Check for preview errors
  if ErrorMessage = '' then
  begin
    for I := 0 to lvFiles.Items.Count - 1 do
    begin
      Afi := Integer(lvFiles.Items[I].Data);
      if itmOptionsRenameSelectedRows.Checked and (Afi < FActiveFiles.Count) and
         not FActiveFiles[Afi].Selected then
        Continue;
      if FPreviewErrors.ContainsKey(I) then
      begin
        ErrorMessage := 'Can''t rename while errors exist (highlighted in red).';
        Break;
      end;
    end;
  end;

  // Count files to rename
  FilesToRename := 0;
  if ErrorMessage = '' then
  begin
    for I := 0 to FActiveFiles.Count - 1 do
    begin
      if (I >= MAX_FILES) then Break;
      if itmOptionsRenameSelectedRows.Checked and not FActiveFiles[I].Selected then
        Continue;
      if (itmOutputRenameInPlace.Checked and (FActiveFiles[I].Name <> FActiveFiles[I].Preview)) or
         (not itmOutputRenameInPlace.Checked and FActiveFiles[I].Matched) then
        Inc(FilesToRename);
    end;
    if FilesToRename = 0 then
      ErrorMessage := 'There are no ' + GetStrFile + 's to rename.';
  end;

  // Move/Copy path validation
  if (ErrorMessage = '') and not itmOutputRenameInPlace.Checked then
  begin
    if not TDirectory.Exists(FMoveCopyPath) then
      ErrorMessage := 'The output folder is not a valid path.'
    else if FMoveCopyPath = FActivePath then
      ErrorMessage := 'The output folder is the same as the current folder.';
  end;

  if ErrorMessage <> '' then
  begin
    MessageDlg(ErrorMessage, mtError, [mbOK], 0);
    Exit;
  end;

  // Build regex history string
  RegexString := '/' + cmbMatch.Text + '/' + txtReplace.Text + '/';
  if cbModifierI.Checked then RegexString := RegexString + 'i';
  if cbModifierG.Checked then RegexString := RegexString + 'g';
  if cbModifierX.Checked then RegexString := RegexString + 'x';

  // Swap buttons
  btnRename.Visible := False;
  btnRenameDrop.Visible := False;
  btnCancel.Visible := True;
  btnCancel.Enabled := True;
  btnRename.Enabled := False;

  // Show progress
  ProgressBar.Position := 0;
  ProgressBar.Visible := True;
  lblNumMatched.Visible := False;
  lblNumConflict.Visible := False;

  // Determine output path
  OutputPath := FActivePath;
  if itmOutputMoveTo.Checked or itmOutputCopyTo.Checked then
    OutputPath := FMoveCopyPath;

  // Disable form
  FEnableUpdates := False;
  ShellTree.Enabled := False;

  // Start rename thread
  FRenameThread := TRenameThread.Create(FActiveFiles, FActivePath, OutputPath, FMoveCopyPath,
    FRenameFolders, itmOptionsPreserveExt.Checked, itmOutputRenameInPlace.Checked,
    itmOutputMoveTo.Checked, itmOutputCopyTo.Checked, itmOutputBackupTo.Checked,
    itmOptionsRenameSelectedRows.Checked);
  FRenameThread.OnTerminate := OnRenameThreadTerminate;
  FRenameThread.Start;

  // Poll progress with a timer-like approach via Application.ProcessMessages
  while not FRenameThread.Finished do
  begin
    ProgressBar.Position := FRenameThread.Progress;
    Application.ProcessMessages;
    Sleep(50);
  end;
end;

procedure TfrmMain.btnCancelClick(Sender: TObject);
begin
  btnCancel.Enabled := False;
  btnCancel.Caption := 'Cancelling...';
  if Assigned(FRenameThread) then
    FRenameThread.Terminate;
end;

procedure TfrmMain.OnRenameProgress(Sender: TObject);
begin
  ProgressBar.Position := FRenameThread.Progress;
end;

procedure TfrmMain.OnRenameThreadTerminate(Sender: TObject);
var
  ErrDlg: TdlgRenameError;
  I: Integer;
  Pair: TPair<string, TPair<string, string>>;
  RegexString: string;
  CountTotal: Integer;
  sErr, sWas: string;
begin
  // Update stats
  FCountFilesRenamed := FCountFilesRenamed + FRenameThread.CountSuccess;

  // Swap buttons back
  btnCancel.Visible := False;
  btnCancel.Caption := '&Cancel';
  btnRename.Visible := True;
  btnRenameDrop.Visible := True;
  btnCancel.Enabled := False;
  btnRename.Enabled := True;

  // Hide progress
  ProgressBar.Visible := False;
  lblNumMatched.Visible := True;
  lblNumConflict.Visible := True;

  // Show errors if any
  if FRenameThread.CountErrors > 0 then
  begin
    ErrDlg := TdlgRenameError.Create(Self);
    try
      for Pair in FRenameThread.Errors do
        ErrDlg.AddEntry(Pair.Key, Pair.Value.Key, Pair.Value.Value);

      CountTotal := FRenameThread.CountSuccess + FRenameThread.CountErrors;
      if FRenameThread.CountErrors = 1 then sErr := 'error' else sErr := 'errors';
      if CountTotal = 1 then sWas := ' was' else sWas := 's were';

      ErrDlg.SetMessage(Format('The following %s occured during the batch rename.'#13#10 +
        '%d of %d %s%s renamed successfully.',
        [sErr, FRenameThread.CountSuccess, CountTotal, GetStrFile, sWas]));
      ErrDlg.AutoSizeColumns;
      ErrDlg.ShowModal;
    finally
      ErrDlg.Free;
    end;
  end;

  // Save history on success
  if (FRenameThread.CountErrors = 0) and not FRenameThread.Cancelled then
  begin
    RegexString := '/' + cmbMatch.Text + '/' + txtReplace.Text + '/';
    if cbModifierI.Checked then RegexString := RegexString + 'i';
    if cbModifierG.Checked then RegexString := RegexString + 'g';
    if cbModifierX.Checked then RegexString := RegexString + 'x';

    I := cmbMatch.Items.IndexOf(RegexString);
    if I >= 0 then
      cmbMatch.Items.Delete(I);
    cmbMatch.Items.Insert(0, RegexString);
    while cmbMatch.Items.Count > MAX_HISTORY do
      cmbMatch.Items.Delete(cmbMatch.Items.Count - 1);
    SaveRegexHistory;

    ResetFields;
  end;

  FreeAndNil(FRenameThread);

  // Re-enable form and refresh
  FEnableUpdates := True;
  ShellTree.Enabled := True;
  UpdateFileList;
  cmbMatch.SetFocus;
end;

end.
