object F_ZoomRecord: TF_ZoomRecord
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Zoomfahrt'
  ClientHeight = 402
  ClientWidth = 344
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 248
    Width = 77
    Height = 13
    Caption = 'Gesamter Index'
  end
  object Label2: TLabel
    Left = 16
    Top = 296
    Width = 64
    Height = 13
    Caption = 'Elementindex'
  end
  object Label3: TLabel
    Left = 16
    Top = 352
    Width = 44
    Height = 13
    Caption = 'Subindex'
  end
  object GB_Coords: TGroupBox
    Left = 168
    Top = 96
    Width = 161
    Height = 153
    Caption = 'Aktuelle Koordinaten'
    TabOrder = 0
    object LE_Real: TLabeledEdit
      Left = 8
      Top = 40
      Width = 145
      Height = 21
      EditLabel.Width = 82
      EditLabel.Height = 13
      EditLabel.Caption = 'Reale Koordinate'
      ReadOnly = True
      TabOrder = 0
    end
    object LE_Imaginary: TLabeledEdit
      Left = 8
      Top = 80
      Width = 145
      Height = 21
      EditLabel.Width = 103
      EditLabel.Height = 13
      EditLabel.Caption = 'Imagin'#228're Koordinate'
      ReadOnly = True
      TabOrder = 1
    end
    object LE_UnitsOnAxis: TLabeledEdit
      Left = 8
      Top = 120
      Width = 145
      Height = 21
      EditLabel.Width = 124
      EditLabel.Height = 13
      EditLabel.Caption = 'Einheiten auf der X-Achse'
      ReadOnly = True
      TabOrder = 2
    end
  end
  object TB_TotalIndex: TTrackBar
    Left = 8
    Top = 264
    Width = 329
    Height = 33
    Enabled = False
    Max = 0
    TabOrder = 1
    OnChange = TB_TotalIndexChange
  end
  object TB_ElementIndex: TTrackBar
    Left = 8
    Top = 312
    Width = 329
    Height = 33
    Enabled = False
    Max = 0
    TabOrder = 2
    OnChange = TB_ElementIndexChange
  end
  object TB_SubIndex: TTrackBar
    Left = 8
    Top = 368
    Width = 329
    Height = 33
    Enabled = False
    Max = 0
    TabOrder = 3
    OnChange = TB_SubIndexChange
  end
  object B_Save: TButton
    Left = 8
    Top = 8
    Width = 105
    Height = 33
    Caption = 'Speichern'
    TabOrder = 4
  end
  object B_Load: TButton
    Left = 8
    Top = 48
    Width = 105
    Height = 33
    Caption = 'Laden'
    TabOrder = 5
  end
  object B_Delete: TButton
    Left = 232
    Top = 8
    Width = 105
    Height = 33
    Caption = 'Alles l'#246'schen'
    TabOrder = 6
    OnClick = B_DeleteClick
  end
  object B_Draw: TButton
    Left = 120
    Top = 8
    Width = 105
    Height = 33
    Caption = 'Abspielen'
    Enabled = False
    TabOrder = 7
  end
  object B_DrawBackwards: TButton
    Left = 120
    Top = 48
    Width = 105
    Height = 33
    Caption = 'R'#252'ckw'#228'rts abspielen'
    Enabled = False
    TabOrder = 8
  end
  object GB_Mode: TGroupBox
    Left = 16
    Top = 96
    Width = 145
    Height = 89
    Caption = 'Modus'
    TabOrder = 9
    object RB_Standard: TRadioButton
      Left = 8
      Top = 16
      Width = 113
      Height = 17
      Caption = 'Standart'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = RB_StandardClick
    end
    object RB_Record: TRadioButton
      Left = 8
      Top = 40
      Width = 113
      Height = 17
      Caption = 'Aufzeichnen'
      TabOrder = 1
      OnClick = RB_RecordClick
    end
    object RB_Draw: TRadioButton
      Left = 8
      Top = 64
      Width = 113
      Height = 17
      Caption = 'Darstellen'
      TabOrder = 2
      OnClick = RB_DrawClick
    end
  end
end
