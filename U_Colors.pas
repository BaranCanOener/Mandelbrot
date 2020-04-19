unit U_Colors;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UColorPalette, UMandelbrot, Buttons, StdCtrls, ExtCtrls, Spin, IniFiles;

type

  TColorPaletteData = record
    Positions: TIntArray;
    Values: TByteArray;
  end;

  TF_ColorSettings = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    SB_LoadPalette: TSpeedButton;
    SP_SavePalette: TSpeedButton;
    SB_Ok: TSpeedButton;
    SB_Cancel: TSpeedButton;
    SB_Reset: TSpeedButton;
    SB_Randomize: TSpeedButton;
    SP_ColorCount: TSpinEdit;
    Label2: TLabel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    CB_MainWNDPreview: TCheckBox;
    SP_PaletteIndices: TSpinEdit;
    Label3: TLabel;
    SB_Equalize: TSpeedButton;
    procedure SB_EqualizeClick(Sender: TObject);
    procedure SP_PaletteIndicesChange(Sender: TObject);
    procedure CB_MainWNDPreviewClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SB_CancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SB_OkClick(Sender: TObject);
    procedure SP_SavePaletteClick(Sender: TObject);
    procedure SB_LoadPaletteClick(Sender: TObject);
    procedure SB_ResetClick(Sender: TObject);
    procedure SP_ColorCountChange(Sender: TObject);
    procedure SB_RandomizeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ColPaletteMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
  private
    { Private-Deklarationen }
    FRedPalette: TColorPalette;
    FGreenPalette: TColorPalette;
    FBluePalette: TColorPalette;
    FMandelPreview: TMandelbrot;
    FTempColorPalettes: Array [0..2] of TColorPaletteData;
    FTempIndexCount: Integer;
    FTempColorCount: Integer;
    FConfirmed: BOOLEAN;
  public
    { Public-Deklarationen }
    procedure DrawPreview;
    procedure DrawPreviewMainWindow;
    property RedPalette: TColorPalette read FRedPalette write FRedPalette;
    property GreenPalette: TColorPalette read FGreenPalette write FGreenPalette;
    property BluePalette: TColorPalette read FBluePalette write FBluePalette;
    property MandelPreview: TMandelbrot read FMandelPreview write FMandelPreview;
  end;

var
  F_ColorSettings: TF_ColorSettings;

implementation

uses U_Main;

{$R *.dfm}

procedure PreviewCallback;
begin
  F_ColorSettings.FMandelPreview.RedrawDots;
  F_ColorSettings.FMandelPreview.Repaint;
end;

{In dieser Methode werden die drei  Farbpaletten erzeugt  und
 mit bestimmten Werten initialisiert. Zudem wird eine weitere
 Instanz von TMandelbrot  erzeugt, die zur Darstellung  einer
 Vorschau  verwendet werden  kann,  sofern  der Benutzer  die
 Farben ändert.}
procedure TF_ColorSettings.FormCreate(Sender: TObject);
var
  Settings: TIniFile;
begin
  DoubleBuffered := TRUE;
  GroupBox1.DoubleBuffered := TRUE;
  FRedPalette := TColorPalette.Create(self);
  with FRedPalette do
  begin
    Parent := GroupBox1;
    PaletteColor := clRed;
    DrawGrid := TRUE;
    ShowValues := TRUE;
    Left := GroupBox1.Left;
    Top := GroupBox1.Top + 8;
    Width := GroupBox1.Width - 20;
    Height := 80;
    OnMouseMove := ColPaletteMouseMove;
  end;
  FGreenPalette := TColorPalette.Create(self);
  with FGreenPalette do
  begin
    Parent := GroupBox1;
    PaletteColor := clGreen;
    DrawGrid := TRUE;
    ShowValues := TRUE;
    Left := GroupBox1.Left;
    Top := FRedPalette.Top + FRedPalette.Height + 5;
    Width := GroupBox1.Width - 20;
    Height := 80;
    OnMouseMove := ColPaletteMouseMove;
  end;
  FBluePalette := TColorPalette.Create(self);
  with FBluePalette do
  begin
    Parent := GroupBox1;
    PaletteColor := clBlue;
    DrawGrid := TRUE;
    ShowValues := TRUE;
    Left := GroupBox1.Left;
    Top := FGreenPalette.Top + FGreenPalette.Height + 5;
    Width := GroupBox1.Width - 20;
    Height := 80;
    OnMouseMove := ColPaletteMouseMove;
  end;
  if LoadPalettes(FRedPalette, FGreenPalette, FBluePalette,
    ExtractFilePath(ParamStr(0)) + DEF_PALETTEFILENAME) then
  begin
    SP_PaletteIndices.OnChange := nil;
    SP_PaletteIndices.Value := FRedPalette.IndexCount;
    SP_PaletteIndices.OnChange := SP_PaletteIndicesChange;
  end
  else
  begin
    FRedPalette.ResetAll(100);
    FGreenPalette.ResetAll(100);
    FBluePalette.ResetAll(100);
  end;
  FRedPalette.Redraw;
  FGreenPalette.Redraw;
  FBluePalette.Redraw;
  FMandelPreview := TMandelbrot.Create(self);
  with FMandelPreview do
  begin
    Parent := self;
    Left := 264;
    Top := 24;
    Width := 95;
    Height := 95;
    RealCoordinate := F_MainForm.MandelFract.RealCoordinate;
    ImaginaryCoordinate := F_MainForm.MandelFract.ImaginaryCoordinate;
    Iterations := F_MainForm.MandelFract.Iterations;
    Limit := F_MainForm.MandelFract.Limit;
    ZoomEnabled := FALSE;
    EndCallback := PreviewCallback;
    SetColorPalette(FRedPalette, FGreenPalette, FBluePalette, 100);
  end;
  Settings := TIniFile.Create(ExtractFilePath(ParamStr(0)) + DEF_INIFILENAME);
  {Farbeinstellungen}
  SP_ColorCount.OnChange := nil;
  SP_ColorCount.Value := Settings.ReadInteger('ColorSettings', 'ColorCount', 100);
  SP_ColorCount.OnChange := SP_ColorCountChange;
  Settings.Free;
  F_MainForm.MandelFract.SetColorPalette(FRedPalette, FGreenPalette, FBluePalette, SP_ColorCount.Value);
  F_MainForm.MandelFract.CalculateMandelbrotThreaded;
end;

{Es werden zufällige Positionen und Farbwerte in den 3 Paletten
 erzeugt und das Vorschaubild wird gezeichnet.}
procedure TF_ColorSettings.SB_RandomizeClick(Sender: TObject);
begin
  FRedPalette.RandomPositions;
  FGreenPalette.RandomPositions;
  FBluePalette.RandomPositions;
  FRedPalette.Redraw;
  FGreenPalette.Redraw;
  FBluePalette.Redraw;
  DrawPreview;
  if CB_MainWNDPreview.Checked then
    DrawPreviewMainWindow;
end;

{Das Vorschaubild wird gezeichnet sobald der Benutzer ein Index
 auf einer der Farbpaletten verschiebt.}
procedure TF_ColorSettings.ColPaletteMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if TColorPalette(sender).IndexClicked <> -1 then
  begin
    DrawPreview;
    if CB_MainWNDPreview.Checked then
      DrawPreviewMainWindow;
  end;
end;

procedure TF_ColorSettings.SP_ColorCountChange(Sender: TObject);
begin
  if (SP_ColorCount.Value <= SP_ColorCount.MaxValue) and (SP_ColorCount.Value > 0) then
  begin
    DrawPreview;
    if CB_MainWNDPreview.Checked then
      DrawPreviewMainWindow;
  end;
end;

procedure TF_ColorSettings.SB_ResetClick(Sender: TObject);
var
  val: Integer;
begin
  try
    val := StrToInt(InputBox('Bitte Wert angeben', 'Geben sie den Wert an, auf den die Farbpalette ' +
    'zurückgesetzt werden soll.', ''));
  except
    ShowMessage('Sie müssen eine gültige Ganzzahl angeben!');
    val := -1;
  end;
  if val <> -1 then
  begin
    FRedPalette.ResetAll(val);
    FGreenPalette.ResetAll(val);
    FBluePalette.ResetAll(val);
    FRedPalette.Redraw;
    FGreenPalette.Redraw;
    FBluePalette.Redraw;
    DrawPreview;
    if CB_MainWNDPreview.Checked then
      DrawPreviewMainWindow;
  end;
end;

procedure TF_ColorSettings.DrawPreview;
begin
  FMandelPreview.SetColorPalette(FRedPalette, FGreenPalette, FBluePalette, SP_ColorCount.Value);
  FMandelPreview.RedrawDots;
  FMandelPreview.Repaint;
end;

procedure TF_ColorSettings.DrawPreviewMainWindow;
begin
  F_MainForm.MandelFract.SetColorPalette(FRedPalette, FGreenPalette, FBluePalette, SP_ColorCount.Value);
  F_MainForm.MandelFract.RedrawDots;
  F_MainForm.MandelFract.Repaint;
end;

procedure TF_ColorSettings.SB_LoadPaletteClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    LoadPalettes(FRedPalette, FGreenPalette, FBluePalette, OpenDialog1.FileName);
  SP_PaletteIndices.OnChange := nil;
  SP_PaletteIndices.Value := FRedPalette.IndexCount;
  SP_PaletteIndices.OnChange := SP_PaletteIndicesChange;
  FRedPalette.Redraw;
  FGreenPalette.Redraw;
  FBluePalette.Redraw;
  DrawPreview;
  if CB_MainWNDPreview.Checked then
    DrawPreviewMainWindow;
end;

procedure TF_ColorSettings.SP_SavePaletteClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
    SavePalettes(FRedPalette, FGreenPalette, FBluePalette, SaveDialog1.FileName);
end;

procedure TF_ColorSettings.SB_OkClick(Sender: TObject);
begin
  FConfirmed := TRUE;
  Close;
end;

procedure TF_ColorSettings.FormShow(Sender: TObject);
var
  i: Integer;
begin
  FConfirmed := FALSE;
  FTempIndexCount := SP_PaletteIndices.Value;
  FTempColorCount := SP_ColorCount.Value;
  SetLength(FTempColorPalettes[0].Positions, FRedPalette.IndexCount);
  SetLength(FTempColorPalettes[0].Values, FRedPalette.IndexCount);
  SetLength(FTempColorPalettes[1].Positions, FRedPalette.IndexCount);
  SetLength(FTempColorPalettes[1].Values, FRedPalette.IndexCount);
  SetLength(FTempColorPalettes[2].Positions, FRedPalette.IndexCount);
  SetLength(FTempColorPalettes[2].Values, FRedPalette.IndexCount);
  with F_MainForm.MandelFract do
  begin
    MandelPreview.RealCoordinate := RealCoordinate;
    MandelPreview.ImaginaryCoordinate := ImaginaryCoordinate;
    MandelPreview.UnitsOnAxis := UnitsOnAxis;
    MandelPreview.Iterations := Iterations;
    MandelPreview.Limit := Limit;
    MandelPreview.CalculateMandelbrotThreaded;
    DrawPreview;
  end;
  for i := 0 to FRedPalette.IndexCount - 1 do
  begin
    FTempColorPalettes[0].Positions[i] := FRedPalette.GetPosition(i);
    FTempColorPalettes[0].Values[i]    := FRedPalette.GetValue(i);
    FTempColorPalettes[1].Positions[i] := FGreenPalette.GetPosition(i);
    FTempColorPalettes[1].Values[i]    := FGreenPalette.GetValue(i);
    FTempColorPalettes[2].Positions[i] := FBluePalette.GetPosition(i);
    FTempColorPalettes[2].Values[i]    := FBluePalette.GetValue(i);
  end;
end;

procedure TF_ColorSettings.SB_CancelClick(Sender: TObject);
begin
  FConfirmed := FALSE;
  Close;
end;

procedure TF_ColorSettings.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Integer;
begin
  if (not FConfirmed) then
  begin
    SP_PaletteIndices.OnChange := nil;
    SP_PaletteIndices.Value := FTempIndexCount;
    SP_PaletteIndices.OnChange := SP_PaletteIndicesChange;
    SP_ColorCount.OnChange := nil;
    SP_ColorCount.Value := FTempColorCount;
    SP_ColorCount.OnChange := SP_ColorCountChange;
    FRedPalette.IndexCount := SP_PaletteIndices.Value;
    FGreenPalette.IndexCount := SP_PaletteIndices.Value;
    FBluePalette.IndexCount := SP_PaletteIndices.Value;
    for i := 0 to FRedPalette.IndexCount - 1 do
    begin
      FRedPalette.SetPosition(i, FTempColorPalettes[0].Positions[i]);
      FRedPalette.SetValue(i, FTempColorPalettes[0].Values[i]);
      FGreenPalette.SetPosition(i, FTempColorPalettes[1].Positions[i]);
      FGreenPalette.SetValue(i, FTempColorPalettes[1].Values[i]);
      FBluePalette.SetPosition(i, FTempColorPalettes[2].Positions[i]);
      FBluePalette.SetValue(i, FTempColorPalettes[2].Values[i]);
    end;
    FRedPalette.Redraw;
    FGreenPalette.Redraw;
    FBluePalette.Redraw;
  end;
  DrawPreviewMainWindow;
  FMandelPreview.Calculating := FALSE;
end;

procedure TF_ColorSettings.CB_MainWNDPreviewClick(Sender: TObject);
begin
  if CB_MainWNDPreview.Checked then
    DrawPreviewMainWindow;
end;

procedure TF_ColorSettings.SP_PaletteIndicesChange(Sender: TObject);
begin
  if (SP_PaletteIndices.Value > SP_PaletteIndices.MaxValue) then
    SP_PaletteIndices.Value := SP_PaletteIndices.MaxValue
  else if (SP_PaletteIndices.Value < SP_PaletteIndices.MinValue) then
    SP_PaletteIndices.Value := SP_PaletteIndices.MinValue;
  FRedPalette.IndexCount := SP_PaletteIndices.Value;
  FGreenPalette.IndexCount := SP_PaletteIndices.Value;
  FBluePalette.IndexCount := SP_PaletteIndices.Value;
  FRedPalette.Redraw;
  FGreenPalette.Redraw;
  FBluePalette.Redraw;
  DrawPreview;
  if CB_MainWNDPreview.Checked then
    DrawPreviewMainWindow;
end;

procedure TF_ColorSettings.SB_EqualizeClick(Sender: TObject);
begin
  FRedPalette.Equalize;
  FGreenPalette.Equalize;
  FBluePalette.Equalize;
  FRedPalette.Redraw;
  FGreenPalette.Redraw;
  FBluePalette.Redraw;
  DrawPreview;
  if CB_MainWNDPreview.Checked then
    DrawPreviewMainWindow;
end;

end.
