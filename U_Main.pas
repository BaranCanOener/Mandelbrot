unit U_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Menus, UMandelbrot, UColorPalette, ExtDlgs,
  IniFiles;

type
  TF_MainForm = class(TForm)
    MainMenu1: TMainMenu;
    StatusBar1: TStatusBar;
    Datei1: TMenuItem;
    Einstellungen1: TMenuItem;
    Bitmapspeichern1: TMenuItem;
    Iterationsdatenladen1: TMenuItem;
    Iterationsdatenspeichern1: TMenuItem;
    Iterationen1: TMenuItem;
    Koordinaten1: TMenuItem;
    Farbpalette1: TMenuItem;
    Bildgre1: TMenuItem;
    SavePictureDialog1: TSavePictureDialog;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Zoomfaktor1: TMenuItem;
    N2x1: TMenuItem;
    N4x1: TMenuItem;
    N8x1: TMenuItem;
    N16x1: TMenuItem;
    N32x1: TMenuItem;
    N64x1: TMenuItem;
    Hilfe1: TMenuItem;
    ber1: TMenuItem;
    Berechnungabbrechen1: TMenuItem;
    Timer1: TTimer;
    Berechnung1: TMenuItem;
    ScrollBox1: TScrollBox;
    Zoomerlauben1: TMenuItem;
    Protokoll1: TMenuItem;
    Cursoranzeigen1: TMenuItem;
    N128x1: TMenuItem;
    Neuberechnen1: TMenuItem;
    Zoomfahrt1: TMenuItem;
    procedure Zoomfahrt1Click(Sender: TObject);
    procedure Neuberechnen1Click(Sender: TObject);
    procedure Cursoranzeigen1Click(Sender: TObject);
    procedure Protokoll1Click(Sender: TObject);
    procedure Zoomerlauben1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Berechnung1Click(Sender: TObject);
    procedure Berechnungabbrechen1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ber1Click(Sender: TObject);
    procedure N2x1Click(Sender: TObject);
    procedure Bildgre1Click(Sender: TObject);
    procedure Farbpalette1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MandelMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
    procedure MandelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MandelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Bitmapspeichern1Click(Sender: TObject);
    procedure Iterationsdatenladen1Click(Sender: TObject);
    procedure Iterationsdatenspeichern1Click(Sender: TObject);
    procedure Iterationen1Click(Sender: TObject);
    procedure Koordinaten1Click(Sender: TObject);
  private
    { Private declarations }
    FMandelFract: TMandelbrot;
    FStartTime, FEndTime, FPFreq: Int64;
    FMiddleButton: BOOLEAN;
    FPositionClicked: TPoint;
    FProtocol: TStringList;
  public
    { Public declarations }
    procedure SetComponents(const calculating: BOOLEAN);
    property MandelFract: TMandelbrot read FMandelFract write FMandelfract;
  end;

const
  DEF_PALETTEFILENAME = 'default.cols';
  DEF_INIFILENAME     = 'settings.ini';
  DEF_COORDFILENAME   = 'coords.dat';

var
  F_MainForm: TF_MainForm;

implementation

uses
  U_Coordinates, U_Iterations, U_Colors, U_PicSize, U_CalcSettings, U_Infos,
  U_Protocol, U_ZoomRecord;

{$R *.dfm}

{Dies  sind  die  vom  Hauptthread  auszuführenden Befehle, sobald
 die  Berechnung startet. Es werden  die ersten  Protokolleinträge
 gemacht  und  die  Komponenten werden aktiviert bzw. deaktiviert,
 sodass die Aktualisierung durch den Timer  vonstatten gehen  kann
 und der Benutzer keine Optionen ändern kann welche die Berechnung
 beeinträchtigen könnten.}
procedure MainStartCallback;
var
  t: TDateTime;
begin
  t := Now;
  with F_MainForm do
  begin
    F_MainForm.FProtocol.Clear;
    FProtocol.Add('*** Protokolleintrag: ' + DateToStr(t) + ', ' + TimeToStr(t) + ' ***');
    FProtocol.Add('Zu berechnende Koordinaten:');
    FProtocol.Add('R: ' + FloatToStr(FMandelFract.RealCoordinate));
    FProtocol.Add('I: ' + FloatToStr(FMandelFract.ImaginaryCoordinate));
    FProtocol.Add('Einheiten: ' + FloatToStr(FMandelFract.UnitsOnAxis));
    FProtocol.Add('Grenze: ' + FloatToStr(FMandelFract.Limit));
    FProtocol.Add('Max. Iterationen: ' + IntToStr(FMandelFract.Iterations));
    FProtocol.Add('Bildgröße: ' + IntToStr(FMandelFract.Width) + 'x' +
      IntToStr(FMandelFract.Height) + ' (' + IntToStr(FMandelFract.Width * FMandelFract.Height) +
      ' Pixel)');
    FProtocol.Add('Starte Berechnung, Uhrzeit: ' + TimeToStr(t));
    SetComponents(TRUE);
    Caption := 'Mandelbrotberechner - 0%';
  end;
end;

{Dies  sind  die  vom  Hauptthread  auszuführenden   Befehle,  sobald
 die Berechnung beendet ist. Es w erden die letzten Protokolleinträge
 gemacht und die Komponenten werden auf ihren Anfangszustand gesetzt.}
procedure MainEndCallback;
var
  FTmpTime: Int64;
  IterationsProcessed: Int64;
begin
  with F_MainForm do
  begin
    QueryPerformanceCounter(FTmpTime);
    IterationsProcessed := FMandelFract.IterationsProcessed;
    FProtocol.Add('Berechnung beendet, Uhrzeit: ' + TimeToStr(Now));
    FProtocol.Add('Berechnungszeit: ' + FloatToStr((FTmpTime - FStartTime) / FPFreq) + ' Sekunden');
    FProtocol.Add('Anzahl der durchgeführten Iterationen: ' + IntToStr(IterationsProcessed));
    FProtocol.Add('Iterationen/s: ' + FloatToStr(IterationsProcessed / ((FTmpTime - FStartTime) / FPFreq)));
    FProtocol.Add('*** Ende des Protokolleintrags ***');
    F_Protocol.M_Protocol.Lines.AddStrings(FProtocol);
    F_Protocol.M_Protocol.Lines.Add('');
    SetComponents(FALSE);
    Timer1Timer(nil);
    Caption := 'Mandelbrotberechner';
    if FMandelFract.RecordZooms then
      F_ZoomRecord.Actualize;
  end;
end;


{Aktiviert die Komponenten je nach dem ob calculating TRUE oder
 FALSE ist, also eine Berechnung erfolgt oder nicht}
procedure TF_MainForm.SetComponents(const calculating: BOOLEAN);
begin
  if calculating then
    QueryPerformanceCounter(FStartTime);
  with MainMenu1.Items do
  begin
    Items[0].Enabled := not calculating;
    Items[1].Enabled := not calculating;
    Items[2].Enabled := not calculating;
    Items[3].Enabled := not calculating;
    Items[5].Enabled := calculating;
    Items[6].Enabled := not calculating;
  end;
  Timer1.Enabled := calculating;
  F_Protocol.G_Progress.Enabled := calculating;
  F_Protocol.GB_Status.Enabled := calculating;
end;

{Der Zufallsgenerator wird initialisiert, die TMandelbrot-Instanz
 erzeugt und es werden  deren Startwerte gesetzt. Zudem  wird die
 die Programmeinstellungen beinhaltende Ini-Datei ausgelesen}
procedure TF_MainForm.FormCreate(Sender: TObject);
var
  FSettings: TIniFile;
begin
  Randomize;
  QueryPerformanceFrequency(FPFreq);
  ScrollBox1.Cursor := crNone;
  FProtocol := TStringList.Create;
  FMiddleButton := FALSE;
  FMandelFract := TMandelbrot.Create(self);
  FMandelFract.Parent := ScrollBox1;
  FMandelFract.EndCallback := MainEndCallback;
  FMandelFract.StartCallback := MainStartCallback;
  FMandelFract.OnMouseMove := MandelMouseMove;
  FMandelFract.OnMouseDown := MandelMouseDown;
  FMandelFract.OnMouseUp := MandelMouseUp;
  FMandelFract.Left := 0;
  FMandelFract.Top := 0;
  FMandelFract.SetStartPosition;
  FMandelFract.Iterations := 100;
  FMandelFract.Limit := 2.0;
  ScrollBox1.DoubleBuffered := TRUE;
  FSettings := TIniFile.Create(ExtractFilePath(ParamStr(0)) + DEF_INIFILENAME);
  with FSettings do
  begin
    {Das Layout der Anwendung}
    Left   := ReadInteger('Layout', 'Left', 0);
    Top    := ReadInteger('Layout', 'Top', 0);
    Width  := ReadInteger('Layout', 'Width', 310);
    Height := ReadInteger('Layout', 'Height', 364);

    {Die Berechnungseinstellungen}
    Timer1.Interval := ReadInteger('Calculation', 'RefreshInterval', 500);
    FMandelFract.ThreadPriority := TThreadPriority(ReadInteger('Calculation', 'ThreadPriority', Integer(tpNormal)));

    {Die Maße des zu berechnen Bitmaps}
    FMandelFract.Width  := ReadInteger('BitmapSettings', 'Width', 256);
    FMandelFract.Height := ReadInteger('BitmapSettings', 'Height', 256);

    {Zoomeinstellungen}
    FMandelFract.ZoomFactor := TZoomFactor(ReadInteger('ZoomSettings', 'ZoomFactor', Integer(zf2x)));
    FMandelFract.ZoomEnabled := ReadBool('ZoomSettings', 'ZoomEnabled', TRUE);

    CursorAnzeigen1.Checked := ReadBool('General', 'ShowCursor', TRUE);
  end;
  FSettings.Free;
  if CursorAnzeigen1.Checked then
    ScrollBox1.Cursor := crDefault
  else
    ScrollBox1.Cursor := crNone;
  Zoomerlauben1.Checked := FMandelFract.ZoomEnabled;
  with MainMenu1.Items.Items[2] do
  begin
    case FMandelFract.ZoomFactor of
      zf2x:   Items[0].Checked := TRUE;
      zf4x:   Items[1].Checked := TRUE;
      zf8x:   Items[2].Checked := TRUE;
      zf16x:  Items[3].Checked := TRUE;
      zf32x:  Items[4].Checked := TRUE;
      zf64x:  Items[5].Checked := TRUE;
      zf128x: Items[6].Checked := TRUE;
    end;
  end;
end;

{Die  TMandelbrot-Instanz  und die  TColorPalette-Instanzen werden frei-
 gegeben sowie das Info-Bitmap. Zudem wird die die Programmeinstellungen
 beinhaltende Ini-Datei mit aktualisierten Inhalten gefüllt}
procedure TF_MainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  FSettings: TIniFile;
  Coords: TStringList;
  i: Integer;
  s: String;
begin
  FSettings := TIniFile.Create(ExtractFilePath(ParamStr(0)) + DEF_INIFILENAME);
  try
    try
      with FSettings do
      begin
        {Das Layout der Anwendung}
        WriteInteger('Layout', 'Left', Left);
        WriteInteger('Layout', 'Top', Top);
        WriteInteger('Layout', 'Width', Width);
        WriteInteger('Layout', 'Height', Height);

        {Die Berechnungseinstellungen}
        WriteInteger('Calculation', 'RefreshInterval', Timer1.Interval);
        WriteInteger('Calculation', 'ThreadPriority', Integer(FMandelFract.ThreadPriority));

        {Die Maße des zu berechnen Bitmaps}
        WriteInteger('BitmapSettings', 'Width', FMandelFract.Width);
        WriteInteger('BitmapSettings', 'Height', FMandelFract.Height);

        {Zoomeinstellungen}
        WriteInteger('ZoomSettings', 'ZoomFactor', Integer(FMandelFract.ZoomFactor));
        WriteBool('ZoomSettings', 'ZoomEnabled', FMandelFract.ZoomEnabled);

        {Farbeinstellungen}
        WriteInteger('ColorSettings', 'ColorCount', F_ColorSettings.SP_ColorCount.Value);

        WriteBool('General', 'ShowCursor', Cursoranzeigen1.Checked);
      end;
      SavePalettes(F_ColorSettings.RedPalette, F_ColorSettings.GreenPalette,
      F_ColorSettings.BluePalette, ExtractFilePath(ParamStr(0)) + DEF_PALETTEFILENAME);
      Coords := TStringList.Create;
      for i := 0 to length(F_Coordinates.Coordinates) - 1 do
      begin
        s := F_Coordinates.Coordinates[i].Description             + ';' +
        FloatToStr(F_Coordinates.Coordinates[i].Real)        + ';' +
        FloatToStr(F_Coordinates.Coordinates[i].Imaginary)   + ';' +
        FloatToStr(F_Coordinates.Coordinates[i].UnitsOnAxis);
        Coords.Add(s);
      end;
      Coords.SaveToFile(ExtractFilePath(ParamStr(0)) + DEF_COORDFILENAME);
      Coords.Free;
    except
      ShowMessage('Datenspeicherung nicht möglich! Programm wird ohne Sicherung der Daten beendet.');
    end;
  finally
    FSettings.Free;
    FMandelFract.Free;
    F_ColorSettings.RedPalette.Free;
    F_ColorSettings.GreenPalette.Free;
    F_ColorSettings.BluePalette.Free;
    F_ColorSettings.MandelPreview.Free;
    F_Infos.Bmp.Free;
    FProtocol.Free;
  end;
end;

{Falls gerade keine  Berechnung  erfolgt  wird geprüft, ob der mittlere
 Mausbutton  gedrückt  ist. Ist  dies  der Fall,  wird  der  angezeigte
 Bildausschnitt der Mandelbrotmenge anhand der Mausbewegung verschoben.
 Zudem  werden,  ebenfalls  sofern   keine    Berechnung  erfolgt,  die
 Koordinaten der Mausposition mitsamt des Zoomfaktors angezeigt}
procedure TF_MainForm.MandelMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  xDifference, yDifference: Integer;
begin
  if (FMiddleButton) and ((FPositionClicked.X <> X) or
    (FPositionClicked.Y <> Y)) then
  begin
    xDifference := X - FPositionClicked.X;
    yDifference := Y - FPositionClicked.Y;
    ScrollBox1.HorzScrollBar.Position := ScrollBox1.HorzScrollBar.Position + Round((xDifference / 1.5));
    ScrollBox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Position + Round((yDifference / 1.5));
    FPositionClicked.X := X;
    FPositionClicked.Y := Y;
  end;
  if (not FMandelFract.Calculating) then
  begin
    StatusBar1.SimpleText := 'Reel: ' + FloatToStrF(FMandelFract.GetCursorRealPos, ffFixed, 18, 14) +
      ' Imaginär: ' + FloatToStrF(FMandelFract.GetCursorImaginaryPos, ffFixed, 18, 14) +
      ' Zoomfaktor: ' + IntToStr(FMandelFract.GetZoomCount);
  end;
end;

{Dies ist die Methode zum Speichern des berechnet Bildes}
procedure TF_MainForm.Bitmapspeichern1Click(Sender: TObject);
begin
  FMandelFract.Repaint;
  if SavePictureDialog1.Execute then
    FMandelFract.SaveBitmapToFile(SavePictureDialog1.FileName);
end;

{Dies ist die Methode zum laden der Iterationsdaten}
procedure TF_MainForm.Iterationsdatenladen1Click(Sender: TObject);
var
  Loaded: BOOLEAN;
begin
  FMandelFract.Repaint;
  if OpenDialog1.Execute then
  begin
    Loaded := FMandelFract.LoadIterationDataFromFile(OpenDialog1.FileName);
    if Loaded then
    begin
      FMandelFract.RedrawDots;
      FMandelFract.Repaint;
    end
    else
    begin
      ShowMessage('Ladevorgang fehlgeschlagen!');
      Close;
    end;
  end;
end;

{Die Iterationsdaten werden durch diese Methode gespeichert}
procedure TF_MainForm.Iterationsdatenspeichern1Click(Sender: TObject);
begin
  FMandelFract.Repaint;
  if SaveDialog1.Execute then
    FMandelFract.SaveIterationDataToFile(SaveDialog1.FileName);
end;

procedure TF_MainForm.Iterationen1Click(Sender: TObject);
begin
  FMandelFract.Repaint;
  F_IterationSettings.ShowModal;
end;

procedure TF_MainForm.Koordinaten1Click(Sender: TObject);
begin
  FMandelFract.Repaint;
  F_Coordinates.ShowModal;
end;

procedure TF_MainForm.Farbpalette1Click(Sender: TObject);
begin
  FMandelFract.Repaint;
  F_ColorSettings.ShowModal;
end;

procedure TF_MainForm.Bildgre1Click(Sender: TObject);
begin
  FMandelFract.Repaint;
  F_PicSize.ShowModal;
end;

procedure TF_MainForm.N2x1Click(Sender: TObject);
begin
  case ZoomFaktor1.IndexOf(TMenuItem(Sender)) of
    0: FMandelFract.ZoomFactor := zf2x;
    1: FMandelFract.ZoomFactor := zf4x;
    2: FMandelFract.ZoomFactor := zf8x;
    3: FMandelFract.ZoomFactor := zf16x;
    4: FMandelFract.ZoomFactor := zf32x;
    5: FMandelFract.ZoomFactor := zf64x;
    6: FMandelFract.ZoomFactor := zf128x;
  end;
  TMenuItem(Sender).Checked := TRUE;
end;

procedure TF_MainForm.ber1Click(Sender: TObject);
begin
  FMandelFract.Repaint;
  F_Infos.ShowModal;
end;

{Dies ist  das Ereignis,  welches von einem Timer  in vom Benutzer
 festgelegten Zeitabständen  aufgerufen wird. Durch diese  Methode
 wird  Aufschluss  über  den  Fortschritt der  Berechnung  gegeben
 und anhand der bisherigen, berechneten Daten wird die Mandelbrot-
 menge gezeichnet.}
procedure TF_MainForm.Timer1Timer(Sender: TObject);
var
  Percent, t, remaining: Extended;
  PercentRounded: Integer;
begin
  QueryPerformanceCounter(FEndTime);
  FMandelFract.RedrawDots;
  FMandelFract.Repaint;
  Percent := (((FMandelFract.CurrentRow + 1)) / FMandelFract.Height) * 100;
  PercentRounded := Round(Percent);
  t := (FEndTime - FStartTime) / FPFreq;
  if (Percent <> 0) then
    remaining := ((t / Percent) * 100) - t
  else
    remaining := 0;
  StatusBar1.SimpleText := IntToStr(PercentRounded) + '% ' +
    IntToStr(Round(t)) + ' Sekunden';
  Caption := 'Mandelbrotberechner - ' + IntToStr(PercentRounded) + '%';
  F_Protocol.Label3.Caption := IntToStr(FMandelFract.CurrentRow + 1) + ' / ' + IntToStr(FMandelFract.Height);
  F_Protocol.Label4.Caption := FloatToStr(t) + ' s';
  F_Protocol.Label6.Caption := FloatToStr(remaining) + ' s';
  F_Protocol.G_Progress.Progress := PercentRounded;
end;

procedure TF_MainForm.Berechnungabbrechen1Click(Sender: TObject);
begin
  FMandelFract.Calculating := FALSE;
end;

procedure TF_MainForm.Berechnung1Click(Sender: TObject);
begin
  FMandelFract.Repaint;
  F_CalcSettings.ShowModal;
end;

procedure TF_MainForm.FormResize(Sender: TObject);
begin
  ScrollBox1.Width := Width - 40;
  ScrollBox1.Height := Height - 100;
end;

procedure TF_MainForm.Zoomerlauben1Click(Sender: TObject);
begin
  TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked;
  FMandelFract.ZoomEnabled := TMenuItem(Sender).Checked;
  FMandelFract.Repaint;
end;

procedure TF_MainForm.MandelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbMiddle then
  begin
    FMiddleButton := TRUE;
    FPositionClicked.X := X;
    FPositionClicked.Y := Y;
  end;
end;

procedure TF_MainForm.MandelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbMiddle then
    FMiddleButton := FALSE;
end;

procedure TF_MainForm.Protokoll1Click(Sender: TObject);
begin
  FMandelFract.Repaint;
  if (not F_Protocol.Visible) then
  begin
    F_Protocol.Show;
    F_MainForm.SetFocus;
  end
  else
    F_Protocol.Close;
end;

procedure TF_MainForm.Cursoranzeigen1Click(Sender: TObject);
begin
  TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked;
  if TMenuItem(Sender).Checked then
    ScrollBox1.Cursor := crDefault
  else
    ScrollBox1.Cursor := crNone;
end;

procedure TF_MainForm.Neuberechnen1Click(Sender: TObject);
begin
  FMandelFract.CalculateMandelbrotThreaded;
end;

procedure TF_MainForm.Zoomfahrt1Click(Sender: TObject);
begin
  F_ZoomRecord.Show;
end;

end.
