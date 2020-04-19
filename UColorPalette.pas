unit UColorPalette;

{
************************************************************
**  Name des Projektes:         Mandelbrotberechner       **
**  Name der zugehörigen Unit:  UColorPalette.pas         **
**  Erstellungsdatum:           25/02/2005                **
**  Datum der letzten Änderung: 23/05/2006                **
**  Autor:                      Baran Öner                **
**  Kontakt:                    bcoe@haefft.de            **
**  WWW:                        -                         **
************************************************************

Klassen:

  TColorPalette:
      Diese  Klasse  ist von TPaintBox abgeleitet und  ermöglicht
      es, eine individuelle  Palette einer bestimmten  Farbe frei
      zu bestimmen und eine beliebig gewählte Anzahl an Zwischen-
      werten dieser Palette zu berechnen.

}

interface

  uses
    Windows, SysUtils, Controls, Classes, Graphics, ExtCtrls,
    Messages;

  type

    {Dyn. Array, welches Werte vom Datentyp "Byte" speichert}
    TByteArray = Array of Byte;

    {Dyn. Array, welches Werte vom Datentyp "Integer" speichert}
    TIntArray = Array of Integer;

    {Die Klasse, die die Verwendung einer Farbpalette ermöglicht}
    TColorPalette = class(TPaintBox)
    private
      FBitmap: TBitmap;
      FColor: TColor;
      FPositions: TIntArray;
      FValues: TByteArray;
      FPixelsPerArea: Extended;
      FPixelsPerVal: Extended;
      FIndexClicked: Integer;
      FPaletteMaxIndex: Integer;
      FPaletteIndexCount: Integer;
      FShowValues: BOOLEAN;
      FDrawGrid: BOOLEAN;
      function GetWidth: Integer;
      function GetHeight: Integer;
      procedure PaintPalette;
      procedure SetPaletteColor(const AColor: TColor);
      procedure SetWidth(const AWidth: Integer);
      procedure SetHeight(const AHeight: Integer);
      procedure SetIndexCount(const AIndexCount: Integer);
      procedure MMouseDown(var message: TWMLButtonDown); message WM_LBUTTONDOWN;
      procedure MMouseUp(var message: TWMLButtonUp); message WM_LBUTTONUP;
      procedure MMouseMove(var message: TWMMouseMove); message WM_MOUSEMOVE;
      procedure MPaint(var message: TWMPaint); message WM_PAINT;
    public
      constructor Create(AOwner: TComponent); Override;
      destructor Destroy; Override;
      function SetPosition(const AIndex, AValue: Integer): BOOLEAN;
      function GetPosition(const AIndex: Integer): Integer;
      function GetValue(const AIndex: Integer): Byte;
      function GetColorValues(const ACount: Integer): TByteArray;
      function SaveToMemoryStream: TMemoryStream;
      procedure LoadFromMemoryStream(const AMemStream: TMemoryStream);
      procedure SetValue(const AIndex: Integer; const AValue: Byte);
      procedure ResetAll(const AValue: Byte);
      procedure RandomPositions;
      procedure Equalize;
      procedure Redraw;
      procedure SaveToFile(const AFileName: String);
      procedure LoadFromFile(const AFileName: String);
      property Width: Integer read GetWidth write SetWidth;
      property Height: Integer read GetHeight write SetHeight;
      property PaletteColor: TColor read FColor write SetPaletteColor;
      property IndexClicked: Integer read FIndexClicked write FIndexClicked;
      property IndexCount: Integer read FPaletteIndexCount write SetIndexCount;
      property ShowValues: BOOLEAN read FShowValues write FShowValues;
      property DrawGrid: BOOLEAN read FDrawGrid write FDrawGrid;
    end;

function MergeArrays(const arr1, arr2, arr3: TByteArray): TIntArray;
procedure SavePalettes(const R, G, B: TColorPalette; AFileName: String);
function LoadPalettes(const R, G, B: TColorPalette; AFileName: String): BOOLEAN;

implementation

{******************************
 *** Constructor/Destructor ***
 ******************************}

{Erzeugt die Instanz und setzt die Startwerte}
constructor TColorPalette.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBitmap := TBitmap.Create;
  FColor  := clBlack;
  FPixelsPerArea := 0;
  FPixelsPerVal := 0;
  FIndexClicked := -1;
  FPaletteIndexCount := 6;
  FPaletteMaxIndex   := FPaletteIndexCount - 1;
  SetLength(FPositions, FPaletteIndexCount);
  SetLength(FValues, FPaletteIndexCount);
  FShowValues := FALSE;
  FDrawGrid := FALSE;
  ResetAll(0);
end;

{Gibt FBitmap und die Instanz selbst frei}
destructor TColorPalette.Destroy;
begin
  FBitmap.Free;
  inherited Destroy;
end;

{****************************
 ***   Private Methoden   ***
 ****************************}

{Liefert die Breite der Komponente bzw. des Bildes, welches
 berechnet wird, zurück}
function TColorPalette.GetWidth: Integer;
begin
  result := inherited Width;
end;

{Liefert die Höhe der Komponente bzw. des Bildes, welches
 berechnet wird, zurück}
function TColorPalette.GetHeight: Integer;
begin
  result := inherited Height;
end;

{Die Palette wird auf das Bitmap gezeichnet. Ist FDrawGrid TRUE, so
 wird zudem ein Raster gezeichnet}
procedure TColorPalette.PaintPalette;
var
  rect: TRect;
  i, gridsizeX, gridsizeY, gridremainX, gridremainY: Integer;
  tempYPos: Integer;
begin
  rect.Left := 0;
  rect.Top := 0;
  rect.Right := FBitmap.Width;
  rect.Bottom := FBitmap.Height;
  FBitmap.Canvas.Brush.Color := FColor;
  FBitmap.Canvas.FillRect(rect);
  if FDrawGrid then
  begin
    FBitmap.Canvas.Pen.Color := clBlack;
    gridsizeX := FBitmap.Width div FPaletteIndexCount;
    gridremainX := FBitmap.Width mod FPaletteIndexCount;
    i := 0;
    while (i <= FBitmap.Width) and (gridsizeX <> 0) do
    begin
      inc(i, gridsizeX);
      if gridremainX <> 0 then
      begin
        dec(gridremainX);
        inc(i);
      end;
      FBitmap.Canvas.MoveTo(i, 0);
      FBitmap.Canvas.LineTo(i, FBitmap.Height);
    end;
    gridsizeY := FBitmap.Height div FPaletteIndexCount;
    gridremainY := FBitmap.Height mod FPaletteIndexCount;
    i := 0;
    while (i <= FBitmap.Height) and (gridsizeY <> 0) do
    begin
      inc(i, gridsizeY);
      if gridremainY <> 0 then
      begin
        dec(gridremainY);
        inc(i);
      end;
      FBitmap.Canvas.MoveTo(0, i);
      FBitmap.Canvas.LineTo(FBitmap.Width, i);
    end;
  end;
  FBitmap.Canvas.Pen.Color := clWhite;
  FBitmap.Canvas.Brush.Color := clWhite;
  FBitmap.Canvas.MoveTo(0, Trunc((255 - FValues[0]) * FPixelsPerVal));
  for i := 0 to FPaletteMaxIndex do
  begin
    tempYPos := Trunc((255 - FValues[i]) * FPixelsPerVal);
    FBitmap.Canvas.LineTo(FPositions[i], tempYPos);
    FBitmap.Canvas.Pen.Color := clBlack;
    FBitmap.Canvas.Rectangle(FPositions[i] - 5, tempYPos - 5, FPositions[i] + 5, tempYPos + 5);
    FBitmap.Canvas.Pen.Color := clWhite;
  end;
end;

{Legt die Farbe, die diese Palette haben soll, fest}
procedure TColorPalette.SetPaletteColor(const AColor: TColor);
begin
  FColor := AColor;
end;

{Setzt die Breite des Bitmaps; In Abhängigkeit dieses Wertes
 werden zudem die Positionen der Punkte auf der Farbpalette
 skaliert}
procedure TColorPalette.SetWidth(const AWidth: Integer);
var
  i: Integer;
begin
  if AWidth < 0 then
    exit;
  FBitmap.Width := AWidth;
  inherited Width := AWidth;
  FPixelsPerArea := AWidth div (FPaletteIndexCount - 1);
  FPositions[high(FPositions)] := AWidth;
  if FBitmap.Width <> 0 then
  begin
    for i := 0 to FPaletteMaxIndex do
      FPositions[i] := Round((FPositions[i] / FBitmap.Width) * AWidth);
  end;
end;

{Setzt die Höhe des Bitmaps und anhand dieses Wertes wird berechnet,
 wie viele Pixel auf einen Farbwert (0..255) kommen}
procedure TColorPalette.SetHeight(const AHeight: Integer);
begin
  if AHeight < 0 then
    exit;
  FBitmap.Height := AHeight;
  inherited Height := AHeight;
  FPixelsPerVal := AHeight / 255;
end;

{Setzt  die  Anzahl  der  auf  der  Farbpalette  vorhandenen Indizes
 anhand  des  vom  Benutzer  gewünschten  Wertes,  was  eine erneute
 Berechnung des  Wertes FPixelsPerArea  und eine erneute  Festlegung
 der Größe der Arrays FPositions und FValues vorraussetzt}
procedure TColorPalette.SetIndexCount(const AIndexCount: Integer);
begin
  FPaletteIndexCount := AIndexCount;
  FPaletteMaxIndex   := FPaletteIndexCount - 1;
  SetLength(FPositions, FPaletteIndexCount);
  SetLength(FValues, FPaletteIndexCount);
  FPixelsPerArea := (inherited Width) / (FPaletteIndexCount - 1);
  ResetAll(100);
end;

{Eventhandler  für das LButtonDown-Event: Es wird ermittelt, ob  die
 x/y-Position des Mauscursors auf einer der 6 Positionen der Palette
 liegt}
procedure TColorPalette.MMouseDown(var message: TWMLButtonDown);
var
  i: Integer;
begin
  inherited;
  for i := 0 to FPaletteMaxIndex do
  begin
    if (message.XPos > (FPositions[i] - 5)) and (message.XPos < (FPositions[i] + 5)) and
       (message.YPos > (((255 - FValues[i]) * FPixelsPerVal) - 5)) and (message.YPos < (((255 - FValues[i]) * FPixelsPerVal) + 5)) then
    begin
      FIndexClicked := i;
      exit;
    end;
  end;
end;

{Eventhandler für das LButtonUp-Event: Geht der linke Mausknopf hoch,
 so  ist ab  sofort keine  der 6 Positionen  der  Palette  ausgewählt
 (FIndexClicked ist in diesem Fall auf -1 gesetzt)}
procedure TColorPalette.MMouseUp(var message: TWMLButtonUp);
begin
  inherited;
  FIndexClicked := -1;
  PaintPalette;
  Repaint;
end;

{Eventhandler  für das  MouseMove-Event: Ist eine der 6 Positionen der
 Farbpalette ausgewählt, so wird dessen neue Position anhand der Maus-
 koordinaten bestimmt}
procedure TColorPalette.MMouseMove(var message: TWMMouseMove);
begin
  inherited;
  if (FIndexClicked = -1) then
    exit;
  if (FIndexClicked > 0) and (message.XPos <= FPositions[FIndexClicked - 1]) then
    SetPosition(FIndexClicked, FPositions[FIndexClicked - 1] + 1)
  else if (FIndexClicked < FPaletteIndexCount) and (message.XPos >= FPositions[FIndexClicked + 1]) then
    SetPosition(FIndexClicked, FPositions[FIndexClicked + 1] - 1)
  else
    SetPosition(FIndexClicked, message.XPos);
  if (message.YPos >= FBitmap.Height + 1) then
    SetValue(FIndexClicked, 0)
  else if (message.YPos <= -1) then
    SetValue(FIndexClicked, 255)
  else
    SetValue(FIndexClicked, 255 - Trunc(message.YPos / FPixelsPerVal));
  PaintPalette;
  if FShowValues then
  begin
    FBitmap.Canvas.TextOut(message.XPos + 6, message.YPos, IntToStr(FValues[FIndexClicked]));
    FBitmap.Canvas.TextOut(message.XPos + 6, message.YPos + 15, IntToStr(message.XPos));
  end;
  Repaint;
end;

{Eventhandler für das Paint-Event: Der Inhalt des Bitmaps wird auf die
 Oberfläche der Komponente kopiert}
procedure TColorPalette.MPaint(var message: TWMPaint);
begin
  BitBlt(message.DC, 0, 0, Width, Height, FBitmap.Canvas.Handle, 0, 0, srccopy);
end;

{****************************
 *** Öffentliche Methoden ***
 ****************************}

{Über diese Funktion kann der Benutzer jedem verfügbaren Index (ausser
 dem  ersten  und  dem letzten) einen die Position auf der Farbpalette
 bestimmenden Wert zuordnen, sofern dieser im zulässigen Bereich liegt}
function TColorPalette.SetPosition(const AIndex, AValue: Integer): BOOLEAN;
begin
  if (AIndex > 0) and (AIndex < FPaletteMaxIndex) then
  begin
    if (FPositions[AIndex - 1] < AValue) and (FPositions[AIndex + 1] > AValue) then
    begin
      FPositions[AIndex] := AValue;
      result := TRUE;
    end
    else
      result := FALSE;
  end
  else
    result := FALSE;
end;

{Über diese Funktion kann der Benutzer den jedem verfügbaren Index
 (ausser dem  ersten  und  dem letzten) zugeordneten, die Position
 beinhaltenden Wert abfragen}
function TColorPalette.GetPosition(const AIndex: Integer): Integer;
begin
  if (AIndex < 0) or (AIndex > FPaletteMaxIndex) then
    result := -1
  else
    result := FPositions[AIndex];
end;

{Über diese Funktion kann der Benutzer den jedem verfügbaren Index
 (ausser  dem  ersten  und  dem  letzten)  zugeordneten   Farbwert
 abfragen}
function TColorPalette.GetValue(const AIndex: Integer): Byte;
begin
  result := FValues[AIndex];
end;

{Diese Funktion  ist das  Kernstück der Klasse - Durch sie  ist es
 möglich, eine  beliebige Zahl  an Farben aus der Farbpalette aus-
 zulesen. Da in den meisten Fällen mehr Farben  angefordert werden
 als es  Indizes gibt, werden  anhand der  Abstände  der einzelnen
 Punkte auf der Farbpalette Zwischenwerte berechnet, die sich  aus
 dem Vorigen Wert und dem Folgenden ergeben}
function TColorPalette.GetColorValues(const ACount: Integer): TByteArray;
var
  i, j, remainder, difference, sum, index: Integer;
  ValuesPerArea: TIntArray;
  increment, tempvalue, factor: Single;
begin
  SetLength(result, ACount);
  SetLength(ValuesPerArea, FPaletteMaxIndex);
  sum := 0;
  factor := ACount / FBitmap.Width;
  for i := 0 to FPaletteMaxIndex - 1 do
  begin
    difference := FPositions[i + 1] - FPositions[i];
    j := Trunc(difference * Factor);
    ValuesPerArea[i] := j;
    inc(sum, j);
  end;
  remainder := ACount - sum;
  i := 0;
  while remainder > 0 do
  begin
    dec(remainder);
    inc(ValuesPerArea[i]);
    inc(i);
    if (i > (FPaletteMaxIndex - 1)) then
      i := 0;
  end;
  index := -1;
  for i := 0 to FPaletteMaxIndex - 1 do
  begin
    if (ValuesPerArea[i] <> 0) then
    begin
      difference := FValues[i + 1] - FValues[i];
      increment := difference / (ValuesPerArea[i]);
      tempvalue := FValues[i];
      for j := 1 to (ValuesPerArea[i]) do
      begin
        inc(index);
        result[index] := Round(tempvalue);
        tempvalue := tempvalue + increment;
      end;
    end;
  end;
end;

{Diese Methode speichert die Anzahl an Indizes sowie die jeweilige
 Position und den Wert in einen MemoryStream}
function TColorPalette.SaveToMemoryStream: TMemoryStream;
var
  i: Integer;
  buf: Extended;
begin
  result := TMemoryStream.Create;
  result.Position := 0;
  result.Write(FPaletteIndexCount, SizeOf(Integer));
  for i := 0 to FPaletteMaxIndex do
  begin
    buf := (FBitmap.Width / 100) * FPositions[i];
    result.Write(buf, SizeOf(buf));
    result.Write(FValues[i], SizeOf(Byte));
  end;
  result.Position := 0;
end;

{Diese Methode lädt die Anzahl an Indizes sowie die jeweilige
 Position und den Wert aus einem MemoryStream}
procedure TColorPalette.LoadFromMemoryStream(const AMemStream: TMemoryStream);
var
  i: Integer;
  buf: Extended;
begin
  AMemStream.Position := 0;
  AMemStream.Read(FPaletteIndexCount, SizeOf(Integer));
  FPaletteMaxIndex := FPaletteIndexCount - 1;
  FPixelsPerArea := (inherited Width) / (FPaletteIndexCount - 1);
  SetLength(FValues, FPaletteIndexCount);
  SetLength(FPositions, FPaletteIndexCount);
  for i := 0 to FPaletteMaxIndex do
  begin
    AMemStream.Read(buf, SizeOf(buf));
    AMemStream.Read(FValues[i], SizeOf(Byte));
    FPositions[i] := Round((buf * 100) / FBitmap.Width);
  end;
end;

{Diese Prozedur setzt den Farbwert des übergebenen Indizes anhand
 des Wertes von AValue}
procedure TColorPalette.SetValue(const AIndex: Integer; const AValue: Byte);
begin
  FValues[AIndex] := AValue;
end;

{Diese Prozedur setzt den Farbwert aller Indizes auf den Wert von AValue}
procedure TColorPalette.ResetAll(const AValue: Byte);
var
  i: Integer;
begin
  for i := 0 to FPaletteMaxIndex do
  begin
    FPositions[i] := Trunc(i * FPixelsPerArea);
    FValues   [i] := AValue;
  end;
end;

{Diese Prozedur setzt die Position und den Farbwert jedes Indizes auf
 einen Zufallswert, wobei  Fehler, wie z.B. die Situation dass Index1
 eigentlich  vor  Index2  liegt  jedoch  eine weiter  hinten liegende
 Position hat, ausgeschlossen werden}
procedure TColorPalette.RandomPositions;
var
  i: Integer;
  PositionValid: BOOLEAN;
begin
  if FPixelsPerArea = 0 then
    exit;
  for i := 0 to FPaletteMaxIndex do
  begin
    if (i <> 0) and (i <> FPaletteMaxIndex) then
    begin
      FPositions[i + 1] := Trunc((i + 1) * FPixelsPerArea);
      PositionValid := FALSE;
      while not PositionValid do
        PositionValid := SetPosition(i, Trunc((i * FPixelsPerArea) + (Random(Trunc((FPixelsPerArea * 2) + 1)) - FPixelsPerArea)));
    end
    else
      FPositions[i] := Trunc(i * FPixelsPerArea);
    FValues[i]    := Random(256);
  end;
end;

procedure TColorPalette.Equalize;
var
  NewValue: Integer;
begin
  NewValue := Round((((FPositions[1] - FPositions[0]) * FValues[0]) +
    ((FPositions[FPaletteMaxIndex] - FPositions[FPaletteMaxIndex - 1]) * FValues[FPaletteMaxIndex])) /
    ((FPositions[1] - FPositions[0]) + (FPositions[FPaletteMaxIndex] - FPositions[FPaletteMaxIndex - 1])));
  FValues[0] := NewValue;
  FValues[FPaletteMaxIndex] := NewValue;
end;

{Diese Prozedur zeichnet das die Farbpalette verbildlichende Bitmap
 neu und kopiert dessen Inhalt auf die Komponente}
procedure TColorPalette.Redraw;
begin
  PaintPalette;
  Repaint;
end;

{Diese Prozedur speichert alle relevanten Daten der Farbpalette
 (Indexzahl,  Positionen, Farbwerte)  in  eine  Datei  mit  dem
 übergebenen Namen}
procedure TColorPalette.SaveToFile(const AFileName: String);
var
  fs: TFileStream;
  i: Integer;
  buf: Extended;
begin
  fs := TFileStream.Create(AFileName, fmCreate);
  try
    fs.Position := 0;
    fs.Write(FPaletteIndexCount, SizeOf(Integer));
    for i := 0 to FPaletteMaxIndex do
    begin
      buf := (FBitmap.Width / 100) * FPositions[i];
      fs.Write(buf, SizeOf(buf));
      fs.Write(FValues[i], SizeOf(Byte));
    end;
  finally
    fs.Free;
  end;
end;

{Diese Prozedur lädt alle relevanten Daten  der Farbpalette
 (Indexzahl, Positionen, Farbwerte) aus einer Datei mit dem
 übergebenen Namen}
procedure TColorPalette.LoadFromFile(const AFileName: String);
var
  fs: TFileStream;
  i: Integer;
  buf: Extended;
begin
  fs := TFileStream.Create(AFileName, fmOpenRead);
  try
    fs.Position := 0;
    fs.Read(FPaletteIndexCount, SizeOf(Integer));
    FPaletteMaxIndex := FPaletteIndexCount - 1;
    FPixelsPerArea := (inherited Width) / (FPaletteIndexCount - 1);
    SetLength(FValues, FPaletteIndexCount);
    SetLength(FPositions, FPaletteIndexCount);
    for i := 0 to FPaletteMaxIndex do
    begin
      fs.Read(buf, SizeOf(buf));
      fs.Read(FValues[i], SizeOf(Byte));
      FPositions[i] := Round((buf * 100) / FBitmap.Width);
    end;
  finally
    fs.Free;
  end;
end;

{Diese von der Klasse losgelöste Funktion setzt 3 übergebene Bytearrays
 in ein Integerarray zusammen, oder in anderen Worten, alle  Farbkanäle
 der 3  Paletten  werden  zusammengesetzt. Dies ist  notwendig, da  die
 Klasse TMandelbrot vollständige Farbwerte erwartet}
function MergeArrays(const arr1, arr2, arr3: TByteArray): TIntArray;
var
  i: Integer;
begin
  if (length(arr1) = length(arr2)) and (length(arr1) = length(arr3)) then
  begin
    SetLength(result, length(arr1));
    for i := 0 to high(arr1) do
      result[i] := arr3[i] or (arr2[i] shl 8) or (arr1[i] shl 16);
  end;
end;

{Diese von der Klasse losgelöste Prozedur speichert alle relevanten
 Daten  der  3  übergebenen  Farbpaletten  (Indexzahl,  Positionen,
 Farbwerte) in eine Datei mit dem übergebenen Namen}
procedure SavePalettes(const R, G, B: TColorPalette; AFileName: String);
var
  fs: TFileStream;
  tempMemoryStream: TMemoryStream;
  buf: Array of Byte;
begin
  fs := TFileStream.Create(AFileName, fmCreate);
  fs.Position := 0;
  {Die rote Farbpalette in den FileStream speichern}
  tempMemoryStream := R.SaveToMemoryStream;
  tempMemoryStream.Position := 0;
  SetLength(buf, tempMemoryStream.Size);
  tempMemoryStream.Read(buf[0], tempMemoryStream.Size);
  fs.Write(buf[0], length(buf));
  tempMemoryStream.Free;
  {Die grüne Farbpalette in den FileStream speichern}
  tempMemoryStream := G.SaveToMemoryStream;
  tempMemoryStream.Position := 0;
  SetLength(buf, tempMemoryStream.Size);
  tempMemoryStream.Read(buf[0], tempMemoryStream.Size);
  fs.Write(buf[0], length(buf));
  tempMemoryStream.Free;
  {Die blaue Farbpalette in den FileStream speichern}
  tempMemoryStream := B.SaveToMemoryStream;
  tempMemoryStream.Position := 0;
  SetLength(buf, tempMemoryStream.Size);
  tempMemoryStream.Read(buf[0], tempMemoryStream.Size);
  fs.Write(buf[0], length(buf));
  tempMemoryStream.Free;
  {Den FileStream freigeben}
  fs.Free;
end;

{Diese von der Klasse losgelöste Prozedur lädt alle relevanten
 Daten der 3 übergebenen Farbpaletten (Indexzahl,  Positionen,
 Farbwerte) aus einer Datei mit dem übergebenen Namen}
function LoadPalettes(const R, G, B: TColorPalette; AFileName: String): BOOLEAN;
var
  fs: TFileStream;
  tempMemoryStream: TMemoryStream;
  buf: Array of Byte;
  _IndexCount: Integer;
begin
  result := TRUE;
  if (not FileExists(AFileName)) then
  begin
    result := FALSE;
  end
  else
  begin
    fs := TFileStream.Create(AFileName, fmOpenRead);
    try
      try
        fs.Position := 0;
        tempMemoryStream := TMemoryStream.Create;
        fs.Read(_IndexCount, SizeOf(Integer));
        fs.Position := 0;
        SetLength(buf, _IndexCount + _IndexCount * SizeOf(Extended) + SizeOf(Integer));
        {Die rote Farbpalette aus dem FileStream auslesen}
        tempMemoryStream.Position := 0;
        fs.Read(buf[0], length(buf));
        tempMemoryStream.Write(buf[0], length(buf));
        R.LoadFromMemoryStream(tempMemoryStream);
        fs.Read(_IndexCount, SizeOf(Integer));
        fs.Position := fs.Position - SizeOf(Integer);
        SetLength(buf, _IndexCount + _IndexCount * SizeOf(Extended) + SizeOf(Integer));
        {Die grüne Farbpalette aus dem FileStream auslesen}
        tempMemoryStream.Position := 0;
        fs.Read(buf[0], length(buf));
        tempMemoryStream.Write(buf[0], length(buf));
        G.LoadFromMemoryStream(tempMemoryStream);
        fs.Read(_IndexCount, SizeOf(Integer));
        fs.Position := fs.Position - SizeOf(Integer);
        SetLength(buf, _IndexCount + _IndexCount * SizeOf(Extended) + SizeOf(Integer));
        {Die blaue Farbpalette aus dem FileStream auslesen}
        tempMemoryStream.Position := 0;
        fs.Read(buf[0], length(buf));
        tempMemoryStream.Write(buf[0], length(buf));
        B.LoadFromMemoryStream(tempMemoryStream);
        tempMemoryStream.Free;
        {Den FileStream freigeben}
      except
        result := FALSE;
      end;
    finally
      fs.Free;
    end;
  end;
end;

end.
