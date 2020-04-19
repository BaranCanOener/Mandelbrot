object F_CalcSettings: TF_CalcSettings
  Left = 0
  Top = 0
  Width = 281
  Height = 136
  Caption = 'Berechnungseinstellungen'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 134
    Height = 13
    Caption = 'Aktualisierungsintervall (ms)'
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 72
    Height = 13
    Caption = 'Threadpriorit'#228't'
  end
  object SB_Ok: TSpeedButton
    Left = 152
    Top = 24
    Width = 113
    Height = 33
    Caption = 'Ok'
    Flat = True
    OnClick = SB_OkClick
  end
  object SB_Cancel: TSpeedButton
    Left = 152
    Top = 64
    Width = 113
    Height = 33
    Caption = 'Abbrechen'
    Flat = True
    OnClick = SB_CancelClick
  end
  object SP_Interval: TSpinEdit
    Left = 8
    Top = 24
    Width = 137
    Height = 22
    MaxValue = 10000
    MinValue = 50
    TabOrder = 0
    Value = 500
  end
  object CB_ThreadPriority: TComboBox
    Left = 8
    Top = 72
    Width = 137
    Height = 21
    ItemHeight = 13
    ItemIndex = 3
    TabOrder = 1
    Text = 'Normal'
    Items.Strings = (
      'Idle'
      'Sehr Niedrig'
      'Niedrig'
      'Normal'
      'Hoch'
      'Sehr Hoch'
      'Echtzeit')
  end
end
