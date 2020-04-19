object F_PicSize: TF_PicSize
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Bildgr'#246#223'e'
  ClientHeight = 109
  ClientWidth = 200
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
    Width = 72
    Height = 13
    Caption = 'Breite (in Pixel)'
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 69
    Height = 13
    Caption = 'H'#246'he (in Pixel)'
  end
  object SB_Ok: TSpeedButton
    Left = 112
    Top = 24
    Width = 81
    Height = 33
    Caption = 'Ok'
    Flat = True
    OnClick = SB_OkClick
  end
  object SB_Cancel: TSpeedButton
    Left = 111
    Top = 64
    Width = 81
    Height = 33
    Caption = 'Abbrechen'
    Flat = True
    OnClick = SB_CancelClick
  end
  object SP_Width: TSpinEdit
    Left = 8
    Top = 24
    Width = 97
    Height = 22
    MaxValue = 5000
    MinValue = 1
    TabOrder = 0
    Value = 1
  end
  object SP_Height: TSpinEdit
    Left = 8
    Top = 72
    Width = 97
    Height = 22
    MaxValue = 5000
    MinValue = 1
    TabOrder = 1
    Value = 1
  end
end
