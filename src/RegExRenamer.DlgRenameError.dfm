object dlgRenameError: TdlgRenameError
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'RegexRenamer'
  ClientHeight = 350
  ClientWidth = 650
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  TextHeight = 13
  object imgError: TImage
    Left = 12
    Top = 12
    Width = 32
    Height = 32
  end
  object lblMessage: TLabel
    Left = 56
    Top = 12
    Width = 580
    Height = 40
    AutoSize = False
    WordWrap = True
  end
  object lvwErrors: TListView
    Left = 12
    Top = 60
    Width = 626
    Height = 240
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Old Name'
        Width = 180
      end
      item
        Caption = ''
        Width = 30
      end
      item
        Caption = 'New Name'
        Width = 180
      end
      item
        Caption = ''
        Width = 10
      end
      item
        Caption = 'Error'
        Width = 200
      end>
    ReadOnly = True
    RowSelect = True
    GridLines = True
    TabOrder = 0
    ViewStyle = vsReport
    OnEnter = lvwErrorsEnter
  end
  object btnOK: TButton
    Left = 287
    Top = 312
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = mrOk
    TabOrder = 1
    OnClick = btnOKClick
  end
end
