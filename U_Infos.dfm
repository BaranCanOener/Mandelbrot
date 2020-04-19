object F_Infos: TF_Infos
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Informationen'
  ClientHeight = 368
  ClientWidth = 394
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object T_MoveWorms: TTimer
    Enabled = False
    Interval = 50
    OnTimer = T_MoveWormsTimer
  end
end
