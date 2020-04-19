object F_MainForm: TF_MainForm
  Left = 201
  Top = 121
  Width = 297
  Height = 576
  Caption = 'Mandelbrotmenge'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDefault
  ScreenSnap = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 502
    Width = 289
    Height = 20
    Panels = <>
    SimplePanel = True
  end
  object ScrollBox1: TScrollBox
    Left = 8
    Top = 8
    Width = 256
    Height = 258
    TabOrder = 1
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 8
    object Datei1: TMenuItem
      Caption = '&Datei'
      object Bitmapspeichern1: TMenuItem
        Caption = 'Bitmap speichern'
        OnClick = Bitmapspeichern1Click
      end
      object Iterationsdatenladen1: TMenuItem
        Caption = 'Iterationsdaten laden'
        OnClick = Iterationsdatenladen1Click
      end
      object Iterationsdatenspeichern1: TMenuItem
        Caption = 'Iterationsdaten speichern'
        OnClick = Iterationsdatenspeichern1Click
      end
    end
    object Einstellungen1: TMenuItem
      Caption = '&Einstellungen'
      object Iterationen1: TMenuItem
        Caption = 'Iterationen'
        OnClick = Iterationen1Click
      end
      object Koordinaten1: TMenuItem
        Caption = 'Koordinaten'
        OnClick = Koordinaten1Click
      end
      object Farbpalette1: TMenuItem
        Caption = 'Farbpalette'
        OnClick = Farbpalette1Click
      end
      object Bildgre1: TMenuItem
        Caption = 'Bildgr'#246#223'e'
        OnClick = Bildgre1Click
      end
      object Berechnung1: TMenuItem
        Caption = 'Berechnung'
        OnClick = Berechnung1Click
      end
      object Zoomerlauben1: TMenuItem
        Caption = 'Zoom erlauben'
        Checked = True
        OnClick = Zoomerlauben1Click
      end
      object Cursoranzeigen1: TMenuItem
        Caption = 'Cursor anzeigen'
        OnClick = Cursoranzeigen1Click
      end
    end
    object Zoomfaktor1: TMenuItem
      Caption = '&Zoomfaktor'
      object N2x1: TMenuItem
        AutoCheck = True
        Caption = '2x'
        Checked = True
        RadioItem = True
        OnClick = N2x1Click
      end
      object N4x1: TMenuItem
        AutoCheck = True
        Caption = '4x'
        RadioItem = True
        OnClick = N2x1Click
      end
      object N8x1: TMenuItem
        AutoCheck = True
        Caption = '8x'
        RadioItem = True
        OnClick = N2x1Click
      end
      object N16x1: TMenuItem
        AutoCheck = True
        Caption = '16x'
        RadioItem = True
        OnClick = N2x1Click
      end
      object N32x1: TMenuItem
        AutoCheck = True
        Caption = '32x'
        RadioItem = True
        OnClick = N2x1Click
      end
      object N64x1: TMenuItem
        AutoCheck = True
        Caption = '64x'
        RadioItem = True
        OnClick = N2x1Click
      end
      object N128x1: TMenuItem
        Caption = '128x'
        RadioItem = True
        OnClick = N2x1Click
      end
    end
    object Hilfe1: TMenuItem
      Caption = '&Hilfe'
      object ber1: TMenuItem
        Caption = #220'ber das Programm'
        OnClick = ber1Click
      end
    end
    object Protokoll1: TMenuItem
      Caption = '&Protokoll'
      OnClick = Protokoll1Click
    end
    object Berechnungabbrechen1: TMenuItem
      Caption = '&Abbrechen'
      Enabled = False
      OnClick = Berechnungabbrechen1Click
    end
    object Neuberechnen1: TMenuItem
      Caption = 'Neu berechnen'
      OnClick = Neuberechnen1Click
    end
    object Zoomfahrt1: TMenuItem
      Caption = 'Zoomfahrt'
      OnClick = Zoomfahrt1Click
    end
  end
  object SavePictureDialog1: TSavePictureDialog
    DefaultExt = 'bmp'
    FileName = 'mandel'
    Left = 40
    Top = 8
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'itdata'
    Filter = 'Iterationsdaten|*.itdata'
    Left = 72
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'itdata'
    Filter = 'Iterationsdaten|*.itdata'
    Left = 104
    Top = 8
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 136
    Top = 8
  end
end
