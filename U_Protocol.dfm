object F_Protocol: TF_Protocol
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Berechnungsprotokoll'
  ClientHeight = 392
  ClientWidth = 302
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnMouseMove = FormMouseMove
  PixelsPerInch = 96
  TextHeight = 13
  object M_Protocol: TMemo
    Left = 8
    Top = 8
    Width = 281
    Height = 217
    Color = clSilver
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object B_Save: TButton
    Left = 8
    Top = 232
    Width = 89
    Height = 33
    Caption = 'Speichern'
    TabOrder = 1
    OnClick = B_SaveClick
  end
  object B_Clear: TButton
    Left = 104
    Top = 232
    Width = 89
    Height = 33
    Caption = 'Leeren'
    TabOrder = 2
    OnClick = B_ClearClick
  end
  object B_Close: TButton
    Left = 200
    Top = 232
    Width = 89
    Height = 33
    Caption = 'Schliessen'
    TabOrder = 3
    OnClick = B_CloseClick
  end
  object GB_Status: TGroupBox
    Left = 8
    Top = 272
    Width = 281
    Height = 113
    Caption = 'Berechnungsstatus'
    Enabled = False
    TabOrder = 4
    object G_Progress: TGauge
      Left = 8
      Top = 72
      Width = 265
      Height = 33
      Enabled = False
      Progress = 0
    end
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 90
      Height = 13
      Caption = 'Berechnete Zeilen:'
    end
    object Label2: TLabel
      Left = 8
      Top = 40
      Width = 85
      Height = 13
      Caption = 'Verstrichene Zeit:'
    end
    object Label3: TLabel
      Left = 104
      Top = 24
      Width = 4
      Height = 13
      Caption = '/'
    end
    object Label4: TLabel
      Left = 96
      Top = 40
      Width = 4
      Height = 13
      Caption = '/'
    end
    object Label5: TLabel
      Left = 8
      Top = 56
      Width = 135
      Height = 13
      Caption = 'Ungef'#228'hr verbleibende Zeit:'
    end
    object Label6: TLabel
      Left = 144
      Top = 56
      Width = 4
      Height = 13
      Caption = '/'
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Textdateien|*.txt'
    Left = 16
    Top = 16
  end
end
