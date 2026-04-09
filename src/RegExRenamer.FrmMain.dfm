object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'RegExRenamer'
  ClientHeight = 600
  ClientWidth = 900
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 620
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poDefault
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  TextHeight = 13
  object splMain: TSplitter
    Left = 300
    Top = 26
    Width = 5
    Height = 574
    MinSize = 150
    ResizeStyle = rsUpdate
  end
  object tlbMain: TToolBar
    Left = 0
    Top = 0
    Width = 900
    Height = 26
    ButtonHeight = 29
    ButtonWidth = 77
    ShowCaptions = True
    TabOrder = 0
    object tbnChangeCase: TToolButton
      Left = 0
      Top = 0
      Caption = 'Change Case'
      Hint = 'Apply case change to renamed filenames (right-click to reset)'
      DropdownMenu = pmChangeCase
      Style = tbsDropDown
    end
    object tbnSep1: TToolButton
      Left = 92
      Top = 0
      Width = 8
      Style = tbsSeparator
    end
    object tbnNumbering: TToolButton
      Left = 100
      Top = 0
      Caption = 'Numbering'
      Hint = 'Configure auto-numbering ($# in replacement pattern)'
      DropdownMenu = pmNumbering
      Style = tbsDropDown
    end
    object tbnSep2: TToolButton
      Left = 192
      Top = 0
      Width = 8
      Style = tbsSeparator
    end
    object tbnMoveCopy: TToolButton
      Left = 200
      Top = 0
      Caption = 'Move / Copy'
      Hint = 'Rename in place, or move/copy/backup to another folder'
      DropdownMenu = pmMoveCopy
      Style = tbsDropDown
    end
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 26
    Width = 300
    Height = 574
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object ShellTree: TShellTreeView
      Left = 0
      Top = 0
      Width = 300
      Height = 530
      ObjectTypes = [otFolders]
      Root = 'rfDesktop'
      UseShellImages = True
      Align = alClient
      AutoRefresh = False
      Indent = 19
      ParentColor = False
      RightClickSelect = True
      ShowRoot = False
      TabOrder = 0
      OnChange = ShellTreeChange
    end
    object pnlPath: TPanel
      Left = 0
      Top = 530
      Width = 300
      Height = 44
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        300
        44)
      object txtPath: TEdit
        Left = 4
        Top = 4
        Width = 260
        Height = 21
        Hint = 'Type a path and press Enter to navigate'
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnKeyDown = txtPathKeyDown
      end
      object btnNetwork: TButton
        Left = 268
        Top = 3
        Width = 28
        Height = 23
        Anchors = [akTop, akRight]
        Caption = '...'
        Hint = 'Browse for folder'
        TabOrder = 1
        OnClick = btnNetworkClick
      end
    end
  end
  object pnlRight: TPanel
    Left = 305
    Top = 26
    Width = 595
    Height = 574
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object splRegex: TSplitter
      Left = 0
      Top = 120
      Width = 595
      Height = 5
      Cursor = crVSplit
      Align = alTop
      MinSize = 80
      ResizeStyle = rsUpdate
    end
    object pnlRegex: TPanel
      Left = 0
      Top = 0
      Width = 595
      Height = 120
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object lblMatch: TLabel
        Left = 8
        Top = 8
        Width = 33
        Height = 13
        Caption = '&Match:'
        FocusControl = cmbMatch
      end
      object lblReplace: TLabel
        Left = 8
        Top = 36
        Width = 42
        Height = 13
        Caption = '&Replace:'
        FocusControl = txtReplace
      end
      object lblStats: TLabel
        Left = 375
        Top = 62
        Width = 55
        Height = 13
        Cursor = crHandPoint
        Caption = 'File stats...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        OnMouseEnter = lblStatsMouseEnter
        OnMouseLeave = lblStatsMouseLeave
      end
      object cmbMatch: TComboBox
        Left = 60
        Top = 5
        Width = 305
        Height = 21
        Hint = 'Enter regex pattern (Shift+Right-click for helpers)'
        TabOrder = 0
        OnChange = cmbMatchChange
        OnKeyDown = cmbMatchKeyDown
        OnSelect = cmbMatchSelect
      end
      object txtReplace: TEdit
        Left = 60
        Top = 33
        Width = 305
        Height = 21
        Hint = 'Replacement pattern ($1, $#, etc.)'
        TabOrder = 1
        OnChange = txtReplaceChange
        OnKeyDown = txtReplaceKeyDown
      end
      object cbModifierI: TCheckBox
        Left = 375
        Top = 7
        Width = 30
        Height = 17
        Caption = '/i'
        Hint = 'Ignore case'
        TabOrder = 2
        OnClick = cbModifierClick
      end
      object cbModifierG: TCheckBox
        Left = 410
        Top = 7
        Width = 30
        Height = 17
        Caption = '/g'
        Hint = 'Global - replace all matches (not just the first)'
        TabOrder = 3
        OnClick = cbModifierClick
      end
      object cbModifierX: TCheckBox
        Left = 445
        Top = 7
        Width = 30
        Height = 17
        Caption = '/x'
        Hint = 'Extended - ignore whitespace in pattern'
        TabOrder = 4
        OnClick = cbModifierClick
      end
      object gbFilter: TGroupBox
        Left = 8
        Top = 62
        Width = 355
        Height = 52
        Caption = 'Filter'
        TabOrder = 5
        object txtFilter: TEdit
          Left = 8
          Top = 20
          Width = 140
          Height = 21
          Hint = 'Filter files by pattern (press Enter to apply)'
          TabOrder = 0
          Text = '*.*'
          OnChange = txtFilterChange
          OnKeyDown = txtFilterKeyDown
        end
        object rbFilterGlob: TRadioButton
          Left = 160
          Top = 22
          Width = 50
          Height = 17
          Caption = 'Glob'
          Hint = 'Use glob wildcards (* and ?)'
          Checked = True
          TabOrder = 1
          TabStop = True
          OnClick = rbFilterTypeClick
        end
        object rbFilterRegex: TRadioButton
          Left = 215
          Top = 22
          Width = 55
          Height = 17
          Caption = 'Regex'
          Hint = 'Use regular expression for filtering'
          TabOrder = 2
          OnClick = rbFilterTypeClick
        end
        object cbFilterExclude: TCheckBox
          Left = 285
          Top = 22
          Width = 60
          Height = 17
          Caption = 'Exclude'
          Hint = 'Invert filter - show files that do NOT match'
          TabOrder = 3
          OnClick = cbFilterExcludeClick
        end
      end
      object pnlStats: TPanel
        Left = 375
        Top = 78
        Width = 200
        Height = 38
        BevelOuter = bvNone
        TabOrder = 6
        Visible = False
        object lblStatsTotal: TLabel
          Left = 0
          Top = 0
          Width = 31
          Height = 13
          Caption = '0 total'
        end
        object lblStatsShown: TLabel
          Left = 0
          Top = 13
          Width = 40
          Height = 13
          Caption = '0 shown'
        end
        object lblStatsFiltered: TLabel
          Left = 70
          Top = 0
          Width = 43
          Height = 13
          Caption = '0 filtered'
        end
        object lblStatsHidden: TLabel
          Left = 70
          Top = 13
          Width = 41
          Height = 13
          Caption = '0 hidden'
        end
      end
    end
    object lvFiles: TListView
      Left = 0
      Top = 125
      Width = 595
      Height = 405
      Align = alClient
      Columns = <
        item
          Width = 24
        end
        item
          Caption = 'Filename'
          Width = 260
        end
        item
          Caption = 'Preview'
          Width = 260
        end>
      HideSelection = False
      MultiSelect = True
      OwnerDraw = True
      ReadOnly = True
      RowSelect = True
      SmallImages = ilFiles
      TabOrder = 1
      ViewStyle = vsReport
      OnColumnClick = lvFilesColumnClick
      OnCompare = lvFilesCompare
      OnDblClick = lvFilesDblClick
      OnDrawItem = lvFilesDrawItem
      OnKeyUp = lvFilesKeyUp
      OnSelectItem = lvFilesSelectItem
    end
    object pnlBottom: TPanel
      Left = 0
      Top = 530
      Width = 595
      Height = 44
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      DesignSize = (
        595
        44)
      object lblNumMatched: TLabel
        Left = 8
        Top = 4
        Width = 54
        Height = 13
        Caption = 'Matched: 0'
      end
      object lblNumConflict: TLabel
        Left = 8
        Top = 20
        Width = 54
        Height = 13
        Caption = 'Conflicts: 0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object btnRenameDrop: TSpeedButton
        Left = 520
        Top = 4
        Width = 16
        Height = 30
        Anchors = [akTop, akRight]
        Caption = #9660
        Hint = 'Switch between renaming files or folders'
        Flat = True
        OnClick = btnRenameDropClick
      end
      object btnRename: TButton
        Left = 440
        Top = 4
        Width = 80
        Height = 30
        Anchors = [akTop, akRight]
        Caption = '&Rename'
        Hint = 'Start rename operation (Ctrl+R)'
        TabOrder = 0
        OnClick = btnRenameClick
      end
      object btnCancel: TButton
        Left = 440
        Top = 4
        Width = 96
        Height = 30
        Anchors = [akTop, akRight]
        Caption = '&Cancel'
        Enabled = False
        TabOrder = 1
        Visible = False
        OnClick = btnCancelClick
      end
      object ProgressBar: TProgressBar
        Left = 100
        Top = 10
        Width = 330
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 2
        Visible = False
      end
      object btnOptions: TButton
        Left = 100
        Top = 4
        Width = 70
        Height = 22
        Caption = 'Options'
        DropDownMenu = pmOptions
        Style = bsSplitButton
        TabOrder = 3
      end
      object btnHelp: TButton
        Left = 175
        Top = 4
        Width = 55
        Height = 22
        Caption = 'Help'
        DropDownMenu = pmHelp
        Style = bsSplitButton
        TabOrder = 4
      end
    end
  end
  object ilFiles: TImageList
    Left = 460
    Top = 60
  end
  object pmChangeCase: TPopupMenu
    Left = 370
    Top = 120
    object itmChangeCaseNoChange: TMenuItem
      Caption = 'No change'
      Checked = True
      RadioItem = True
      OnClick = itmChangeCaseClick
    end
    object itmChangeCaseSep: TMenuItem
      Caption = '-'
    end
    object itmChangeCaseUppercase: TMenuItem
      Caption = 'UPPERCASE'
      RadioItem = True
      OnClick = itmChangeCaseClick
    end
    object itmChangeCaseLowercase: TMenuItem
      Caption = 'lowercase'
      RadioItem = True
      OnClick = itmChangeCaseClick
    end
    object itmChangeCaseTitlecase: TMenuItem
      Caption = 'Title Case'
      RadioItem = True
      OnClick = itmChangeCaseClick
    end
  end
  object pmNumbering: TPopupMenu
    Left = 400
    Top = 120
    object itmNumberingStart: TMenuItem
      Caption = 'Start: 1'
      OnClick = itmNumberingClick
    end
    object itmNumberingPad: TMenuItem
      Caption = 'Pad: 000'
      OnClick = itmNumberingClick
    end
    object itmNumberingInc: TMenuItem
      Caption = 'Inc: 1'
      OnClick = itmNumberingClick
    end
    object itmNumberingReset: TMenuItem
      Caption = 'Reset: 0'
      OnClick = itmNumberingClick
    end
  end
  object pmMoveCopy: TPopupMenu
    Left = 430
    Top = 120
    object itmOutputRenameInPlace: TMenuItem
      Caption = 'Rename in place'
      Checked = True
      RadioItem = True
      OnClick = itmOutputClick
    end
    object itmOutputSep: TMenuItem
      Caption = '-'
    end
    object itmOutputMoveTo: TMenuItem
      Caption = 'Move to...'
      RadioItem = True
      OnClick = itmOutputClick
    end
    object itmOutputCopyTo: TMenuItem
      Caption = 'Copy to...'
      RadioItem = True
      OnClick = itmOutputClick
    end
    object itmOutputBackupTo: TMenuItem
      Caption = 'Backup to...'
      RadioItem = True
      OnClick = itmOutputClick
    end
  end
  object pmOptions: TPopupMenu
    Left = 460
    Top = 120
    object itmOptionsShowHidden: TMenuItem
      Caption = 'Show hidden files'
      OnClick = itmOptionsShowHiddenClick
    end
    object itmOptionsPreserveExt: TMenuItem
      Caption = 'Preserve file extension'
      OnClick = itmOptionsPreserveExtClick
    end
    object itmOptionsRealtimePreview: TMenuItem
      Caption = 'Realtime preview'
      Checked = True
      OnClick = itmOptionsRealtimePreviewClick
    end
    object itmOptionsAllowRenSub: TMenuItem
      Caption = 'Allow rename into subfolders'
      OnClick = itmOptionsAllowRenSubClick
    end
    object itmOptionsSep1: TMenuItem
      Caption = '-'
    end
    object itmOptionsRememberWinPos: TMenuItem
      Caption = 'Remember window position'
      Checked = True
    end
    object itmOptionsRenameSelectedRows: TMenuItem
      Caption = 'Only rename selected rows'
    end
    object itmOptionsSep2: TMenuItem
      Caption = '-'
    end
    object itmOptionsAddContextMenu: TMenuItem
      Caption = 'Add to Explorer context menu'
      OnClick = itmOptionsAddContextMenuClick
    end
  end
  object pmHelp: TPopupMenu
    Left = 490
    Top = 120
    object itmHelpAbout: TMenuItem
      Caption = 'About...'
      OnClick = itmHelpAboutClick
    end
  end
  object pmRenameMode: TPopupMenu
    Left = 520
    Top = 120
    object itmRenameFiles: TMenuItem
      Caption = 'Rename files'
      Checked = True
      RadioItem = True
      OnClick = itmRenameModeClick
    end
    object itmRenameFolders: TMenuItem
      Caption = 'Rename folders'
      RadioItem = True
      OnClick = itmRenameModeClick
    end
  end
  object pmRegexMatch: TPopupMenu
    Left = 370
    Top = 160
  end
  object pmRegexReplace: TPopupMenu
    Left = 400
    Top = 160
  end
  object pmGlobMatch: TPopupMenu
    Left = 430
    Top = 160
  end
  object ActionList: TActionList
    Left = 460
    Top = 160
  end
end
