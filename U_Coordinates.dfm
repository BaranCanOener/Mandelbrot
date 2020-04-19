object F_Coordinates: TF_Coordinates
  Left = 441
  Top = 217
  BorderStyle = bsDialog
  Caption = 'Koordinaten'
  ClientHeight = 282
  ClientWidth = 342
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SB_Ok: TSpeedButton
    Left = 240
    Top = 160
    Width = 97
    Height = 33
    Caption = 'Ok'
    Flat = True
    OnClick = SB_OkClick
  end
  object SB_Cancel: TSpeedButton
    Left = 240
    Top = 200
    Width = 97
    Height = 33
    Caption = 'Abbrechen'
    Flat = True
    OnClick = SB_CancelClick
  end
  object SB_Reset: TSpeedButton
    Left = 239
    Top = 240
    Width = 97
    Height = 33
    Caption = 'Startkoordinaten'
    Flat = True
    OnClick = SB_ResetClick
  end
  object GB_Favorites: TGroupBox
    Left = 8
    Top = 160
    Width = 225
    Height = 113
    Caption = 'Favoriten'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 62
      Height = 13
      Caption = 'Bezeichnung'
    end
    object SB_AddToFavorites: TSpeedButton
      Left = 8
      Top = 64
      Width = 97
      Height = 33
      Caption = 'Daten hinzuf'#252'gen'
      Flat = True
      OnClick = SB_AddToFavoritesClick
    end
    object SB_DeleteFromFavorites: TSpeedButton
      Left = 120
      Top = 64
      Width = 97
      Height = 33
      Caption = 'Daten l'#246'schen'
      Flat = True
      OnClick = SB_DeleteFromFavoritesClick
    end
    object CB_Favorites: TComboBox
      Left = 8
      Top = 32
      Width = 209
      Height = 21
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      Text = '(nichts ausgew'#228'hlt)'
      OnSelect = CB_FavoritesSelect
      Items.Strings = (
        '(nichts ausgew'#228'hlt)')
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 161
    Height = 145
    Caption = 'Linke, obere Ecke'
    TabOrder = 1
    object LE_Real: TLabeledEdit
      Left = 8
      Top = 32
      Width = 145
      Height = 21
      EditLabel.Width = 82
      EditLabel.Height = 13
      EditLabel.Caption = 'Reele Koordinate'
      TabOrder = 0
      OnChange = LE_RealChange
    end
    object LE_Imaginary: TLabeledEdit
      Left = 8
      Top = 72
      Width = 145
      Height = 21
      EditLabel.Width = 100
      EditLabel.Height = 13
      EditLabel.Caption = 'Imagin'#228're Koordinate'
      TabOrder = 1
      OnChange = LE_RealChange
    end
    object LE_UnitsOnAxis: TLabeledEdit
      Left = 8
      Top = 116
      Width = 145
      Height = 21
      EditLabel.Width = 113
      EditLabel.Height = 13
      EditLabel.Caption = 'Einheiten auf der Achse'
      TabOrder = 2
      OnChange = LE_RealChange
    end
  end
  object GroupBox2: TGroupBox
    Left = 176
    Top = 8
    Width = 161
    Height = 145
    Caption = 'Zentrum'
    TabOrder = 2
    object LE_Real2: TLabeledEdit
      Left = 8
      Top = 32
      Width = 145
      Height = 21
      EditLabel.Width = 82
      EditLabel.Height = 13
      EditLabel.Caption = 'Reele Koordinate'
      TabOrder = 0
      OnChange = LE_Real2Change
    end
    object LE_Imaginary2: TLabeledEdit
      Left = 8
      Top = 72
      Width = 145
      Height = 21
      EditLabel.Width = 100
      EditLabel.Height = 13
      EditLabel.Caption = 'Imagin'#228're Koordinate'
      TabOrder = 1
      OnChange = LE_Real2Change
    end
    object LE_UnitsOnAxis2: TLabeledEdit
      Left = 8
      Top = 116
      Width = 145
      Height = 21
      EditLabel.Width = 113
      EditLabel.Height = 13
      EditLabel.Caption = 'Einheiten auf der Achse'
      TabOrder = 2
      OnChange = LE_Real2Change
    end
  end
end
