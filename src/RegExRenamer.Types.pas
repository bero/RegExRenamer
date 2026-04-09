unit RegExRenamer.Types;

interface

uses
  System.SysUtils, System.IOUtils, System.Generics.Collections;

type
  TInactiveReason = (irHidden, irFiltered);

  TRRItem = class
  public
    Filename: string;   // [subdir\]filename.txt
    Basename: string;   // [subdir\]filename
    Extension: string;  // .txt
    Fullpath: string;   // c:\..\[subdir\]filename.txt
    Preview: string;    // [subdir\]newfilename[.txt]
    Hidden: Boolean;    // true if hidden file
    Matched: Boolean;   // true if matches current regex
    PreserveExt: Boolean; // true if 'Preserve file extension' checked
    Selected: Boolean;  // true if row is currently selected

    constructor CreateFromFile(const ASearchRec: TSearchRec; const APath: string;
      AHidden, APreserveExt: Boolean);
    constructor CreateFromDir(const AName, AFullPath: string;
      AHidden, APreserveExt: Boolean);

    function Name: string;
    function PreviewExt: string;
  end;

  TInsertArgs = record
    InsertBefore: string;
    InsertAfter: string;
    SelectionStartOffset: Integer;
    SelectionLength: Integer;
    GroupSelection: Boolean;
    WrapIfSelection: Boolean;

    class function Create(const AIB: string): TInsertArgs; overload; static;
    class function Create(const AIB, AIA: string): TInsertArgs; overload; static;
    class function Create(const AIB, AIA, AFlags: string): TInsertArgs; overload; static;
    class function Create(const AIB, AIA: string; ASSO, ASL: Integer): TInsertArgs; overload; static;
    class function Create(const AIB, AIA: string; ASSO, ASL: Integer; const AFlags: string): TInsertArgs; overload; static;
  end;

  // Wrapper to store TInsertArgs in TMenuItem.Tag (which is NativeInt)
  TInsertArgsObject = class
  public
    Args: TInsertArgs;
    constructor Create(const AArgs: TInsertArgs);
  end;

  TFileCount = record
    Total: Integer;
    Shown: Integer;
    Filtered: Integer;
    Hidden: Integer;
    procedure Reset;
  end;

  TRRItemList = TObjectList<TRRItem>;
  TInactiveFileDict = TDictionary<string, TInactiveReason>;

implementation

{ TRRItem }

constructor TRRItem.CreateFromFile(const ASearchRec: TSearchRec; const APath: string;
  AHidden, APreserveExt: Boolean);
begin
  inherited Create;
  Filename := ASearchRec.Name;
  Extension := TPath.GetExtension(ASearchRec.Name);
  Basename := Copy(Filename, 1, Length(Filename) - Length(Extension));
  Fullpath := TPath.Combine(APath, ASearchRec.Name);
  Preview := ASearchRec.Name;
  Hidden := AHidden;
  Matched := False;
  PreserveExt := APreserveExt;
  Selected := False;
end;

constructor TRRItem.CreateFromDir(const AName, AFullPath: string;
  AHidden, APreserveExt: Boolean);
begin
  inherited Create;
  Filename := AName;
  Basename := AName;
  Extension := '';
  Fullpath := AFullPath;
  Preview := AName;
  Hidden := AHidden;
  Matched := False;
  PreserveExt := APreserveExt;
  Selected := False;
end;

function TRRItem.Name: string;
begin
  if PreserveExt then
    Result := Basename
  else
    Result := Filename;
end;

function TRRItem.PreviewExt: string;
begin
  if PreserveExt then
    Result := Preview + Extension
  else
    Result := Preview;
end;

{ TInsertArgs }

class function TInsertArgs.Create(const AIB: string): TInsertArgs;
begin
  Result := Default(TInsertArgs);
  Result.InsertBefore := AIB;
  Result.SelectionLength := -1;
end;

class function TInsertArgs.Create(const AIB, AIA: string): TInsertArgs;
begin
  Result := Default(TInsertArgs);
  Result.InsertBefore := AIB;
  Result.InsertAfter := AIA;
  Result.SelectionLength := -1;
end;

class function TInsertArgs.Create(const AIB, AIA, AFlags: string): TInsertArgs;
begin
  Result := Default(TInsertArgs);
  Result.InsertBefore := AIB;
  Result.InsertAfter := AIA;
  Result.SelectionLength := -1;
  Result.GroupSelection := AFlags.Contains('group');
  Result.WrapIfSelection := AFlags.Contains('wrap');
end;

class function TInsertArgs.Create(const AIB, AIA: string; ASSO, ASL: Integer): TInsertArgs;
begin
  Result := Default(TInsertArgs);
  Result.InsertBefore := AIB;
  Result.InsertAfter := AIA;
  Result.SelectionStartOffset := ASSO;
  Result.SelectionLength := ASL;
end;

class function TInsertArgs.Create(const AIB, AIA: string; ASSO, ASL: Integer;
  const AFlags: string): TInsertArgs;
begin
  Result := Default(TInsertArgs);
  Result.InsertBefore := AIB;
  Result.InsertAfter := AIA;
  Result.SelectionStartOffset := ASSO;
  Result.SelectionLength := ASL;
  Result.GroupSelection := AFlags.Contains('group');
  Result.WrapIfSelection := AFlags.Contains('wrap');
end;

{ TInsertArgsObject }

constructor TInsertArgsObject.Create(const AArgs: TInsertArgs);
begin
  inherited Create;
  Args := AArgs;
end;

{ TFileCount }

procedure TFileCount.Reset;
begin
  Total := 0;
  Shown := 0;
  Filtered := 0;
  Hidden := 0;
end;

end.
