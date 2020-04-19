object F_IterationSettings: TF_IterationSettings
  Left = 441
  Top = 135
  BorderStyle = bsDialog
  Caption = 'Iterationseinstellungen'
  ClientHeight = 105
  ClientWidth = 237
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SB_Ok: TSpeedButton
    Left = 88
    Top = 72
    Width = 65
    Height = 25
    Caption = 'Ok'
    Flat = True
    OnClick = SB_OkClick
  end
  object SB_Cancel: TSpeedButton
    Left = 160
    Top = 72
    Width = 65
    Height = 25
    Caption = 'Abbrechen'
    Flat = True
    OnClick = SB_CancelClick
  end
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 97
    Height = 13
    Caption = 'Maximale Iterationen'
  end
  object SP_Iterations: TSpinEdit
    Left = 8
    Top = 26
    Width = 65
    Height = 22
    MaxValue = 1000000
    MinValue = 1
    TabOrder = 0
    Value = 1
    OnChange = SP_IterationsChange
  end
  object TB_Iterations: TTrackBar
    Left = 72
    Top = 24
    Width = 161
    Height = 33
    Max = 1000000
    Min = 1
    Frequency = 100000
    Position = 1
    TabOrder = 1
    OnChange = TB_IterationsChange
  end
  object LE_Limit: TLabeledEdit
    Left = 8
    Top = 75
    Width = 65
    Height = 21
    EditLabel.Width = 48
    EditLabel.Height = 13
    EditLabel.Caption = 'Grenzwert'
    TabOrder = 2
  end
end
