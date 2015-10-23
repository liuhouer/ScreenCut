object AutoScreenFrm: TAutoScreenFrm
  Left = 301
  Top = 246
  Width = 285
  Height = 89
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #33258#21160#25235#22270#35774#32622
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 11
    Top = 29
    Width = 39
    Height = 13
    Caption = #27599#38388#38548
    Font.Charset = GB2312_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 104
    Top = 30
    Width = 78
    Height = 13
    Caption = #31186#38047#25235#22270#19968#27425
    Font.Charset = GB2312_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object SetSpinEdit: TSpinEdit
    Left = 56
    Top = 24
    Width = 41
    Height = 22
    Font.Charset = GB2312_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = []
    MaxValue = 0
    MinValue = 0
    ParentFont = False
    TabOrder = 0
    Value = 5
  end
  object AppBitBtn: TBitBtn
    Left = 192
    Top = 20
    Width = 75
    Height = 25
    Caption = #24212#29992
    TabOrder = 1
    OnClick = AppBitBtnClick
  end
  object AutoScreenTimer: TTimer
    Enabled = False
    OnTimer = AutoScreenTimerTimer
    Left = 120
  end
end
