object CatchScreenShowFrm: TCatchScreenShowFrm
  Left = 221
  Top = 28
  Width = 544
  Height = 375
  Caption = #21306#22495#25235#22270#31383#21475
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object ChildImage: TImage
    Left = 0
    Top = 0
    Width = 536
    Height = 348
    Align = alClient
    OnMouseDown = ChildImageMouseDown
    OnMouseMove = ChildImageMouseMove
  end
  object ChildTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = ChildTimerTimer
    Left = 104
    Top = 56
  end
end
