object F_ColorSettings: TF_ColorSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Farbpalette'
  ClientHeight = 422
  ClientWidth = 370
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 264
    Top = 8
    Width = 44
    Height = 13
    Caption = 'Vorschau'
  end
  object SB_Ok: TSpeedButton
    Left = 264
    Top = 208
    Width = 97
    Height = 33
    Caption = 'OK'
    Flat = True
    OnClick = SB_OkClick
  end
  object SB_Cancel: TSpeedButton
    Left = 264
    Top = 248
    Width = 97
    Height = 33
    Caption = 'Abbrechen'
    Flat = True
    OnClick = SB_CancelClick
  end
  object Label2: TLabel
    Left = 264
    Top = 160
    Width = 53
    Height = 13
    Caption = 'Farbanzahl'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 249
    Height = 409
    Caption = 'Paletteneinstellung'
    TabOrder = 0
    object SB_LoadPalette: TSpeedButton
      Left = 8
      Top = 280
      Width = 113
      Height = 33
      Caption = 'Farbpaletten laden'
      Flat = True
      OnClick = SB_LoadPaletteClick
    end
    object SP_SavePalette: TSpeedButton
      Left = 6
      Top = 320
      Width = 115
      Height = 33
      Caption = 'Farbpaletten speichern'
      Flat = True
      OnClick = SP_SavePaletteClick
    end
    object SB_Reset: TSpeedButton
      Left = 128
      Top = 280
      Width = 113
      Height = 33
      Caption = 'Zur'#252'cksetzen'
      Flat = True
      OnClick = SB_ResetClick
    end
    object SB_Randomize: TSpeedButton
      Left = 128
      Top = 320
      Width = 113
      Height = 33
      Caption = 'Zufallsgenerator'
      Flat = True
      OnClick = SB_RandomizeClick
    end
    object Label3: TLabel
      Left = 128
      Top = 360
      Width = 72
      Height = 13
      Caption = 'Palettenindizes'
    end
    object SB_Equalize: TSpeedButton
      Left = 8
      Top = 360
      Width = 115
      Height = 33
      Caption = 'Angleichen'
      Flat = True
      OnClick = SB_EqualizeClick
    end
    object SP_PaletteIndices: TSpinEdit
      Left = 128
      Top = 376
      Width = 73
      Height = 22
      MaxValue = 40
      MinValue = 2
      TabOrder = 0
      Value = 6
      OnChange = SP_PaletteIndicesChange
    end
  end
  object SP_ColorCount: TSpinEdit
    Left = 264
    Top = 176
    Width = 97
    Height = 22
    MaxValue = 20000
    MinValue = 1
    TabOrder = 1
    Value = 100
    OnChange = SP_ColorCountChange
  end
  object CB_MainWNDPreview: TCheckBox
    Left = 264
    Top = 120
    Width = 97
    Height = 33
    Caption = 'Vorschau im Hauptfenster'
    TabOrder = 2
    WordWrap = True
    OnClick = CB_MainWNDPreviewClick
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.cols'
    Filter = 'Farbpaletten|*.cols'
    Left = 264
    Top = 288
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.cols'
    Filter = 'Farbpaletten|*.cols'
    Left = 296
    Top = 288
  end
end
