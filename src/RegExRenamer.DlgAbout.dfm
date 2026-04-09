object dlgAbout: TdlgAbout
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'About RegExRenamer'
  ClientHeight = 260
  ClientWidth = 350
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  TextHeight = 13
  object imgLogo: TImage
    Left = 12
    Top = 12
    Width = 48
    Height = 48
  end
  object lblHeader: TLabel
    Left = 72
    Top = 12
    Width = 265
    Height = 52
    AutoSize = False
    WordWrap = True
  end
  object Bevel1: TBevel
    Left = 12
    Top = 72
    Width = 326
    Height = 2
    Shape = bsTopLine
  end
  object lblHomepage: TLabel
    Left = 12
    Top = 84
    Width = 186
    Height = 13
    Cursor = crHandPoint
    Caption = 'http://regexrenamer.sourceforge.net/'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblHomepageClick
  end
  object lblEmail: TLabel
    Left = 12
    Top = 104
    Width = 105
    Height = 13
    Cursor = crHandPoint
    Caption = 'xiperware@gmail.com'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblEmailClick
  end
  object lblGitHub: TLabel
    Left = 12
    Top = 124
    Width = 230
    Height = 13
    Cursor = crHandPoint
    Caption = 'https://github.com/bero/RegExRenamer'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblGitHubClick
  end
  object lblStats: TLabel
    Left = 12
    Top = 148
    Width = 326
    Height = 40
    AutoSize = False
    WordWrap = True
  end
  object btnOK: TButton
    Left = 137
    Top = 220
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
end
