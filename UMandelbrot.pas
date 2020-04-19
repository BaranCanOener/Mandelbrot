unit UMandelbrot;

{
************************************************************
**  Name des Projektes:         Mandelbrotberechner       **
**  Name der zugehörigen Unit:  UMandelbrot.pas           **
**  Erstellungsdatum:           02/03/2005                **
**  Datum der letzten Änderung: 28/09/2006                **
**  Autor:                      Baran Öner                **
**  Kontakt:                    bcoe@haefft.de            **
**  WWW:                        -                         **
************************************************************

Klassen:

  TMandelbrot:
      Diese  Klasse  ist von TPaintBox abgeleitet und   ermöglicht
      es,  die  Mandelbrotmenge   anhand   mehrerer  Parameter  zu
      zeichnen  und in  sie  hinein zu  zoomen.  Einstellbar  sind
      sowohl die Farbpalette als  auch die Anzahl der Iterationen.
      Die  Berechnung  erfolgt  mithilfe eines  separaten Threads,
      der in  der Klasse  TMandelbrotThread ausgelagert ist und am
      Anfang  der Berechnung  die Prozedur  FStartCallback und  am
      Ende  die  Prozedur  FEndCallback  aufruft. Die  eigentliche
      Zuordnung der Farbwerte  anhand  der Iterationsdaten, sprich
      der Zeichenvorgang,  muss durch den Aufruf  von der Prozedur
      RedrawDots  erfolgen. Danke  an guinnes (www.dsdt.info)  für
      den optimierten Algorithmus.

  TMandelbrotThread:
      In dieser Klasse erfolgt die Berechnung der Mandelbrotmenge.
      Diese ist nicht in der Klasse TMandelbrot ausgelagert um den
      Methodenaufruf  durch  Synchronize  zu ermöglichen,  wodurch
      Fehler, die  ihre Ursache in der Threadunsicherheit  der VCL
      haben, auszuschliessen.

  TMandelbrotSequence:
  *** UNFINISHED ***
}

interface

  uses
    SysUtils, Windows, Controls, Classes, Graphics, ExtCtrls,
    Messages, UColorPalette, Forms;

  type

    {Aufzählungstyp der die verschiedenen Zoomstufen beinhaltet}
    TZoomFactor = (zf2x, zf4x, zf8x, zf16x, zf32x, zf64x, zf128x);

    {Zweidimensionales Integer-Array zum Speichern der Iterationsdaten}
    TIterationData = Array of TIntArray;

    {Die drei Koordinaten, durch die der Ausschnitt der Mandelbrotmenge
     festgelegt wird}
    TCoord = record
      Real: Extended;
      Imaginary: Extended;
      UnitsOnAxis: Extended;
    end;

    TSequenceElement = record
      IterationData: TIterationData;
      Coord: TCoord;
      Magnification: Int64;
      Iterations: Integer;
    end;

    TSequence = Array of TSequenceElement;

    TMandelbrotSequence = class(TObject)
    private
      FSequence: TSequence;
      FElementIndex: Integer;
      FSubIndex: Integer;
      FSubIndices: Integer;
      FSubIndicesPerZoom: Integer;
      FCurrentData: TSequenceElement;
      function GetElementCount: Integer;
      function GetHighestIndex: Integer;
      function GetTotalIndices: Integer;
      function GetTotalIndex: Integer;
    public
      constructor Create;
      function GetElement(const AIndex: Integer): TSequenceElement;
      function DeleteElement(const AIndex: Integer): BOOLEAN;
      function InsertElement(const AIndex: Integer; const AElement: TSequenceElement): BOOLEAN;
      procedure SetElement(const AIndex: Integer; const AElement: TSequenceElement);
      procedure AddElement(const AElement: TSequenceElement);
      procedure Clear;
      procedure CalculateFrame(const AElementIndex, ASubIndex: Integer); overload;
      procedure CalculateFrame(const AIndex: Integer); overload;
      procedure NextFrame;
      procedure PreviousFrame;
      property ElementCount: Integer read GetElementCount;
      property HighestIndex: Integer read GetHighestIndex;
      property ElementIndex: Integer read FElementIndex write FElementIndex;
      property TotalIndices: Integer read GetTotalIndices;
      property TotalIndex: Integer read GetTotalIndex;
      property SubIndex: Integer read FSubIndex write FSubIndex;
      property SubIndices: Integer read FSubIndices;
      property SubIndicesPerZoom: Integer read FSubIndicesPerZoom write FSubIndicesPerZoom;
      property CurrentData: TSequenceElement read FCurrentData;
    end;

    {Die Hauptklasse - Siehe oben}
    TMandelbrot = class(TPaintBox)
    private
      FBitmap: TBitmap;
      FIterationData_Backup: TIterationData;
      FIterationData: TIterationData;
      FColorPalette: TIntArray;
      FMandelbrotSequence: TMandelbrotSequence;
      FRecordZooms: BOOLEAN;
      FIterations_Backup: Integer;
      FIterations: Integer;
      FReal: Extended;
      FImaginary: Extended;
      FUnitsOnAxis: Extended;
      FLimit: Extended;
      FDivisor: Integer;
      FZoomFactor: TZoomFactor;
      FZoomEnabled: BOOLEAN;
      FZoomWidth: Integer;
      FZoomHeight: Integer;
      FCursorPos: TPoint;
      FStartCallback: TProcedure;
      FEndCallback: TProcedure;
      FCalculating: BOOLEAN;
      FSequenceMode: BOOLEAN;
      FThreadPriority: TThreadPriority;
      FCurrentRow: Integer;
      function GetWidth: Integer;
      function GetHeight: Integer;
      function GetIterationsProcessed: Int64;
      procedure SetSequenceMode(const AMode: BOOLEAN);
      procedure OnBeginThread;
      procedure OnEndThread;
      procedure SetWidth(const AWidth: Integer);
      procedure SetHeight(const AHeight: Integer);
      procedure SetIterationDataArray;
      procedure SetZoomFactor(const AZoomFactor: TZoomFactor);
      procedure MsgMouseLButtonDown(var message: TWMLButtonDown); message WM_LBUTTONDOWN;
      procedure MsgMouseRButtonDown(var message: TWMRButtonDown); message WM_RBUTTONDOWN;
      procedure MsgMouseMove(var message: TWMMouseMove); message WM_MOUSEMOVE;
      procedure MsgPaint(var message: TWMPaint); message WM_PAINT;
    public
      constructor Create(AOwner: TComponent); Override;
      destructor Destroy; Override;
      function GetZoomCount: Int64;
      function GetCursorRealPos: Extended;
      function GetCursorImaginaryPos: Extended;
      function CTopLeftToCenter(const ACoord: TCoord): TCoord;
      function CCenterToTopLeft(const ACoord: TCoord): TCoord;
      function LoadIterationDataFromFile(const AFilename: String): BOOLEAN;
      procedure SaveIterationDataToFile(const AFilename: String);
      procedure SaveBitmapToFile(const AFilename: String);
      procedure RedrawDots;
      procedure SetColorPalette(const ARPalette, AGPalette, ABPalette: TColorPalette; const AColorCount: Integer);
      procedure SetStartPosition;
      procedure CalculateMandelbrotThreaded;
      procedure SetSequenceIterations;
      procedure DrawMandelbrotSequence;
      procedure DrawMandelbrotSequenceBackwards;
      property Width: Integer read GetWidth write SetWidth;
      property Height: Integer read GetHeight write SetHeight;
      property ColorPalette: TIntArray read FColorPalette write FColorPalette;
      property IterationData: TIterationData read FIterationData write FIterationData;
      property IterationsProcessed: Int64 read GetIterationsProcessed;
      property Iterations: Integer read FIterations write FIterations;
      property RealCoordinate: Extended read FReal write FReal;
      property ImaginaryCoordinate: Extended read FImaginary write FImaginary;
      property UnitsOnAxis: Extended read FUnitsOnAxis write FUnitsOnAxis;
      property Limit: Extended read FLimit write FLimit;
      property ZoomFactor: TZoomFactor read FZoomFactor write SetZoomFactor;
      property ZoomEnabled: BOOLEAN read FZoomEnabled write FZoomEnabled;
      property StartCallback: TProcedure read FStartCallback write FStartCallback;
      property EndCallback: TProcedure read FEndCallback write FEndCallback;
      property Calculating: BOOLEAN read FCalculating write FCalculating;
      property ThreadPriority: TThreadPriority read FThreadPriority write FThreadPriority;
      property CurrentRow: Integer read FCurrentRow;
      property MandelbrotSequence: TMandelbrotSequence read FMandelbrotSequence;
      property RecordZooms: BOOLEAN read FRecordZooms write FRecordZooms;
      property SequenceMode: BOOLEAN read FSequenceMode write SetSequenceMode;
    end;

    {Die die Berechnung ausführende Klasse - Siehe oben}
    TMandelbrotThread = class(TThread)
    private
      FMandelbrotInstance: TMandelbrot;
    protected
      constructor Create(const MandelbrotInstance: TMandelbrot);
      procedure Execute; override;
    end;

    {Die drei Konstanten, die die Startkoordinaten darstellen, mit
     denen die gesamte Mandelbrotmenge sichtbar ist}
    const
      STARTPOS_REAL      = -2.10;
      STARTPOS_IMAGINARY =  1.50;
      STARTPOS_UNITS     =  3.00;


implementation

{KLASSE: TMandelbrotSequence}

constructor TMandelbrotSequence.Create;
begin
  inherited;
  FSubIndicesPerZoom := 10;
end;

function TMandelbrotSequence.GetElementCount: Integer;
begin
  result := length(FSequence);
end;

function TMandelbrotSequence.GetHighestIndex: Integer;
begin
  result := high(FSequence);
end;

function TMandelbrotSequence.GetTotalIndices: Integer;
var i: Integer;
begin
  result := length(FSequence);
  for i := 0 to (high(FSequence)-1) do
    result := result + (FSequence[i + 1].Magnification div FSequence[i].Magnification) * FSubIndicesPerZoom;
end;

function TMandelbrotSequence.GetTotalIndex: Integer;
var ZoomDifference, SubIndices, i: Integer;
begin
  result := 0;
  i := 0;
  while i <> ElementIndex do
  begin
    if i <> HighestIndex then
    begin
      ZoomDifference := (FSequence[i + 1].Magnification div FSequence[i].Magnification);
      SubIndices := ZoomDifference * FSubIndicesPerZoom;
      inc(result, SubIndices + 1);
    end;
    inc(i);
  end;
  inc(result, SubIndex);
end;

function TMandelbrotSequence.GetElement(const AIndex: Integer): TSequenceElement;
begin
  if (AIndex >= 0) and (AIndex < ElementCount) and (ElementCount <> 0) then
    result := FSequence[AIndex];
end;

function TMandelbrotSequence.DeleteElement(const AIndex: Integer): BOOLEAN;
var
  i: Integer;
begin
  if (AIndex <= HighestIndex) and (AIndex >= 0) then
  begin
    for i := AIndex to HighestIndex - 1 do
      FSequence[i] := FSequence[i + 1];
    SetLength(FSequence, HighestIndex);
    result := TRUE;
  end
  else
    result := FALSE;
end;

function TMandelbrotSequence.InsertElement(const AIndex: Integer; const AElement: TSequenceElement): BOOLEAN;
var
  i: Integer;
begin
  if (AIndex <= HighestIndex) and (AIndex >= 0) then
  begin
    SetLength(FSequence, ElementCount + 1);
    for i := AIndex to HighestIndex do
      FSequence[i + 1] := FSequence[i];
    FSequence[AIndex] := AElement;
    result := TRUE;
  end
  else
    result := FALSE;
end;

procedure TMandelbrotSequence.SetElement(const AIndex: Integer; const AElement: TSequenceElement);
begin
  if (AIndex <= HighestIndex) and (AIndex >= 0) then
    FSequence[AIndex] := AElement;
end;

procedure TMandelbrotSequence.AddElement(const AElement: TSequenceElement);
var
  lx, ly, i, j, ZoomDifference: Integer;
begin
  SetLength(FSequence, ElementCount + 1);
  lx := length(AElement.IterationData);
  ly := length(AElement.IterationData[0]);
  SetLength(FSequence[HighestIndex].IterationData, lx);
  FSequence[HighestIndex].Magnification := AElement.Magnification;
  FSequence[HighestIndex].Coord := AElement.Coord;
  FSequence[HighestIndex].Iterations := AElement.Iterations;
  SetLength(FCurrentData.IterationData, lx);
  for i := 0 to (lx - 1) do
  begin
    SetLength(FSequence[HighestIndex].IterationData[i], ly);
    SetLength(FCurrentData.IterationData[i], ly);
    for j := 0 to (ly - 1) do
      FSequence[HighestIndex].IterationData[i, j] := AElement.IterationData[i, j];
  end;
  if FElementIndex <> GetHighestIndex then
  begin
    ZoomDifference := (FSequence[FElementIndex + 1].Magnification div FSequence[FElementIndex].Magnification);
    FSubIndices := ZoomDifference * FSubIndicesPerZoom;
  end;
end;

procedure TMandelbrotSequence.Clear;
begin
  SetLength(FSequence, 0);
  FElementIndex := 0;
  FSubIndex := 0;
  FSubIndices := 0;
end;

procedure TMandelbrotSequence.CalculateFrame(const AElementIndex, ASubIndex: Integer);
var
  ZoomDifference: Integer;
  i, j: Integer;
  UnitsOnYAxis, UnitsOnYAxis2: Extended;
  lx, ly: Integer;
  realProgress, imgProgress: Extended;
  XarrayIndex: Integer;
begin
  FElementIndex := AElementIndex;
  FSubIndex := ASubIndex;
  if (AElementIndex <= HighestIndex) and (FSubIndex <> 0) then
  begin
    ZoomDifference := (FSequence[FElementIndex + 1].Magnification div FSequence[FElementIndex].Magnification);
    FSubIndices := ZoomDifference * FSubIndicesPerZoom;
    if ((FSubIndex <= (FSubIndices)) and (FSubIndex > 0)) then
    begin
      lx := length(FSequence[FElementIndex].IterationData);
      ly := length(FSequence[FElementIndex].IterationData[0]);
      FCurrentData.Coord.Real := FSequence[FElementIndex].Coord.Real +
        ((FSequence[FElementIndex + 1].Coord.Real - FSequence[FElementIndex].Coord.Real) * ((FSubIndex/(FSubIndices + 1))));
      FCurrentData.Coord.Imaginary := FSequence[FElementIndex].Coord.Imaginary +
        ((FSequence[FElementIndex + 1].Coord.Imaginary - FSequence[FElementIndex].Coord.Imaginary) * ((FSubIndex/(FSubIndices + 1))));
      FCurrentData.Coord.UnitsOnAxis := FSequence[FElementIndex].Coord.UnitsOnAxis +
        ((FSequence[FElementIndex + 1].Coord.UnitsOnAxis - FSequence[FElementIndex].Coord.UnitsOnAxis) * (FSubIndex/(FSubIndices + 1)));
      FCurrentData.Iterations := FSequence[FElementIndex].Iterations;
      UnitsOnYAxis := FCurrentData.Coord.UnitsOnAxis * (ly/lx);
      UnitsOnYAxis2 := FSequence[FElementIndex].Coord.UnitsOnAxis * (ly/lx);
      for i := 0 to (lx - 1) do
      begin
        realProgress := ((i / lx) * FCurrentData.Coord.UnitsOnAxis)
          + (FCurrentData.Coord.Real - FSequence[ElementIndex].Coord.Real);
        XarrayIndex := Abs(Round((RealProgress/FSequence[FElementIndex].Coord.UnitsOnAxis) * lx));
        for j := 0 to (ly - 1) do
        begin
          imgProgress  := ((j / ly) * UnitsOnYAxis)
            + (-FCurrentData.Coord.Imaginary + FSequence[ElementIndex].Coord.Imaginary);
          FCurrentData.IterationData[i, j] := FSequence[FElementIndex].IterationData[XarrayIndex,
            Abs(Round((ImgProgress/UnitsOnYAxis2) * ly))];
        end;
      end;
    end;
  end
  else
  begin
    if (AElementIndex < HighestIndex) then
    begin
      ZoomDifference := (FSequence[FElementIndex + 1].Magnification div FSequence[FElementIndex].Magnification);
      FSubIndices := ZoomDifference * FSubIndicesPerZoom;
    end
    else
      FSubIndices := 0;
    FCurrentData.Coord := FSequence[FElementIndex].Coord;
    FCurrentData.Magnification := FSequence[FElementIndex].Magnification;
    FCurrentData.Iterations := FSequence[FElementIndex].Iterations;
    lx := length(FSequence[FElementIndex].IterationData);
    ly := length(FSequence[FElementIndex].IterationData[0]);
    for i := 0 to (lx - 1) do
      for j := 0 to (ly - 1) do
        FCurrentData.IterationData[i, j] := FSequence[FElementIndex].IterationData[i, j];
  end;
end;

procedure TMandelbrotSequence.CalculateFrame(const AIndex: Integer);
var ZoomDifference, SubIndices, i, CurrentIndex: Integer;
begin
  CurrentIndex := 0;
  for i := 0 to HighestIndex do
  begin
    if i <> HighestIndex then
    begin
      ZoomDifference := (FSequence[i + 1].Magnification div FSequence[i].Magnification);
        SubIndices := ZoomDifference * FSubIndicesPerZoom;
      if ((AIndex - CurrentIndex) <= SubIndices) then
      begin
        CalculateFrame(i, AIndex - CurrentIndex);
        exit;
      end;
      inc(CurrentIndex, SubIndices + 1);
    end
    else
    begin
      CalculateFrame(i, 0);
      exit;
    end;
  end;
end;

procedure TMandelbrotSequence.NextFrame;
var
  ZoomDifference: Integer;
begin
  ZoomDifference := (FSequence[FElementIndex + 1].Magnification div FSequence[FElementIndex].Magnification);
  FSubIndices := ZoomDifference * FSubIndicesPerZoom;
  if ((FSubIndex + 1) > FSubIndices) then
    CalculateFrame(FElementIndex + 1, 0)
  else
    CalculateFrame(FElementIndex, FSubIndex + 1);
end;

procedure TMandelbrotSequence.PreviousFrame;
var
  ZoomDifference: Integer;
begin
  if ((FSubIndex - 1) < 0) then
  begin
    ZoomDifference := (FSequence[FElementIndex].Magnification div FSequence[FElementIndex - 1].Magnification);
    FSubIndices := ZoomDifference * FSubIndicesPerZoom;
    CalculateFrame(FElementIndex - 1, FSubIndices);
  end
  else
    CalculateFrame(FElementIndex, FSubIndex - 1);
end;

{KLASSE: TMandelbrotThread}

{******************************
 *** Constructor/Destructor ***
 ******************************}

{Erzeugt die Instanz und setzt die Startwerte}
constructor TMandelbrotThread.Create(const MandelbrotInstance: TMandelbrot);
begin
  inherited Create(FALSE);
  FreeOnTerminate := TRUE;
  FMandelbrotInstance := MandelbrotInstance;
  Priority := MandelbrotInstance.ThreadPriority;
end;

{****************************
 *** Öffentliche Methoden ***
 ****************************}

{In dieser Funktion erfolgt die  Berechnung  der  Mandelbrotmenge,
 das   heisst,  dass  jedem  Pixels  des  Objekts  die  Anzahl  an
 Iterationen,  die  zur  Überschreitung  des  Grenzwertes  an  der
 entsprechenden Koordinate erforderlich ist, zugeordnet wird
 ASM-Optimierter Algorithmus geschrieben von guinnes}
procedure TMandelbrotThread.Execute;
var
  i, j,_iterations: Integer;
  _Real, _Imaginary, UnitsPerPixel, _Limit: Extended;
begin
  with FMandelbrotInstance do
  begin
    Synchronize(OnBeginThread);
    begin
      if (FBitmap.Width = 0) or (FBitmap.Height = 0) then
        exit;
      for i := 0 to FBitmap.Height - 1 do
        for j := 0 to FBitmap.Width - 1 do
          FIterationData[j ,i] := FIterations;
      UnitsPerPixel := FUnitsOnAxis / FBitmap.Width;
      _Imaginary := FImaginary;
      _Limit := FLimit;
      for i := 0 to FBitmap.Height - 1 do
      begin
        _Real := FReal;
        FCurrentRow := i;
        for j := 0 to FBitmap.Width - 1 do
        begin
          if (not FCalculating) then
            break;
          _iterations := FIterations;
          asm
            FLDZ        // Y-Init            // ST(4)
            FLDZ        // X-Init            // ST(3)
            fld    _Real                     // ST(2)
            fld    _Imaginary                // ST(1)
            mov    eax, [self]
            fld    _Limit                    // ST(0)

            @Weiter:
            dec    dword ptr [_iterations]   // Iterationen decrementieren
            jz     @Ende                     // Anzahl der Iterationen erreicht ?

            //x2 := sqr(x) - sqr(y) + _Real;
            fld    st(4)                     // Y
            fmul   st(0), st(0)              // Y^2
            fld    st(4)                     // X
            fmul   st(0), st(0)              // x^2
            fsubrp st(1), st(0)              // X^2 - y^2
            fadd   st(0), st(3)              //  + _Real

            //y := 2 * x * y + _Imaginary;
            fld    st(5)                     // Y
            fmul   st(0), st(5)              // Y * X
            fadd   st(0),st(0)               // Y * X * 2
            fadd   st(0), st(3)              // Y * X * 2 + _Imaginary
            fstp   st(6)                     // Ergebniss in Y speichern

            //x := x2;
            fst   st(4)                      // X2 in X Speichern

            //if sqrt(sqr(X) + sqr(Y)) > FLimit then
            fmul   st(0), st(0)              // X^2
            fld    st(5)                     // Y
            fmul   st(0), st(0)              // Y^2
            faddp  st(1), st(0)
            fsqrt
            fcomp                            // vergleichen mit
            fstsw  ax
            sahf
            jc     @Weiter
            @Ende:
            ffree  st(0)
            ffree  st(1)
            ffree  st(2)
            ffree  st(3)
            ffree  st(4)
          end;
          FIterationData[j, i] := FIterations - _iterations;
          _Real := _Real + UnitsPerPixel;
        end;
        _Imaginary := _Imaginary - UnitsPerPixel
      end;
    end;
    Synchronize(OnEndThread);
  end;
end;

{KLASSE: TMandelbrot}

{******************************
 *** Constructor/Destructor ***
 ******************************}

{Erzeugt die Instanz und setzt die Standartwerte}
constructor TMandelbrot.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBitmap := TBitmap.Create;
  FBitmap.PixelFormat := pf32Bit;
  SetZoomFactor(zf2x);
  Canvas.Pen.Mode := pmNot;
  FBitmap.Canvas.Brush.Color := clWhite;
  FZoomEnabled := TRUE;
  FCalculating := FALSE;
  FThreadPriority := tpNormal;
  FRecordZooms := FALSE;
  FSequenceMode := FALSE;
  FMandelbrotSequence := TMandelbrotSequence.Create;
  SetStartPosition;
end;

{Gibt FBitmap und die Instanz selbst frei}
destructor TMandelbrot.Destroy;
begin
  FBitmap.Free;
  FMandelbrotSequence.Free;
  inherited Destroy;
end;

{****************************
 ***   Private Methoden   ***
 ****************************}

{Liefert die Breite der Komponente bzw. des Bildes, welches
 berechnet wird, zurück}
function TMandelbrot.GetWidth: Integer;
begin
  result := inherited Width;
end;

{Liefert die Höhe der Komponente bzw. des Bildes, welches
 berechnet wird, zurück}
function TMandelbrot.GetHeight: Integer;
begin
  result := inherited Height;
end;

function TMandelbrot.GetIterationsProcessed: Int64;
var
  i, j: Integer;
begin
  result := 0;
  for i := 0 to FBitmap.Width - 1 do
    for j := 0 to FBitmap.Height - 1 do
      inc(result, FIterationData[i, j]);
end;

{Setzt die Höhe der Komponente bzw. des Bildes, welches
 berechnet wird}
procedure TMandelbrot.SetWidth(const AWidth: Integer);
begin
  FBitmap.Width := AWidth;
  inherited Width := AWidth;
  SetZoomFactor(FZoomFactor);
  SetIterationDataArray;
end;

{Setzt die Breite der Komponente bzw. des Bildes, welches
 berechnet wird}
procedure TMandelbrot.SetHeight(const AHeight: Integer);
begin
  FBitmap.Height := AHeight;
  inherited Height := AHeight;
  SetZoomFactor(FZoomFactor);
  SetIterationDataArray;
end;

{Setzt den Zoomfaktor (2, 4, 8, 16, 32, 64, 128) und setzt
 dementsprechend die Werte FZoomWidth und FZoomHeight,
 mit deren Hilfe der Ausschnitt, den man vergrößert,
 dargestellt werden kann}
procedure TMandelbrot.SetZoomFactor(const AZoomFactor: TZoomFactor);
begin
  FZoomFactor := AZoomFactor;
  case AZoomFactor of
    zf2x:  FDivisor  := 2;
    zf4x:  FDivisor  := 4;
    zf8x:  FDivisor  := 8;
    zf16x: FDivisor  := 16;
    zf32x: FDivisor  := 32;
    zf64x: FDivisor  := 64;
    zf128x: FDivisor := 128;
    else
      FDivisor := 1;
  end;
  FZoomWidth  := FBitmap.Width div FDivisor;
  FZoomHeight := FBitmap.Height div FDivisor;
end;

{Die Länge des Arrays FIterationData wird in Abhängigkeit
 der Größe des Bitmaps gesetzt}
procedure TMandelbrot.SetIterationDataArray;
var
  i: Integer;
begin
  SetLength(FIterationData, FBitmap.Width);
  for i := 0 to FBitmap.Width - 1 do
    SetLength(FIterationData[i], FBitmap.Height);
end;

procedure TMandelbrot.SetSequenceMode(const AMode: BOOLEAN);
begin
  if FSequenceMode <> AMode then
  begin
    FSequenceMode := AMode;
    if AMode then
    begin
      FIterationData_Backup := FIterationData;
      FIterations_Backup := FIterations;
    end
    else
    begin
      FIterationData := FIterationData_Backup;
      FIterations := FIterations_Backup;
    end;
    RedrawDots;
    Repaint;
  end;
end;

{Die Methode, die über Synchronize aufgerufen wird,
 sobald der Thread mit der  Berechnung  angefangen
 hat; Dadurch wird FStartCallback im Hauptthread
 ausgeführt, um keine Probleme aufgrund der Thread-
 unsicherheit der VCL zu verursachen}
procedure TMandelbrot.OnBeginThread;
begin
  if Assigned(FStartCallback) then
    FStartCallback;
end;

{Die  Methode,  die über  Synchronize  aufgerufen wird,
 sobald  der  Thread  mit  der  Berechnung  fertig ist;
 Dadurch wird FStartCallback im Hauptthread ausgeführt,
 um keine Probleme aufgrund der Threadunsicherheit der
 VCL zu verursachen}
procedure TMandelbrot.OnEndThread;
var
  Element: TSequenceElement;
  i, j: Integer;
begin
  FCalculating := FALSE;
  if RecordZooms then
  begin
    Element.Coord.Real := FReal;
    Element.Coord.Imaginary := FImaginary;
    Element.Coord.UnitsOnAxis := FUnitsOnAxis;
    Element.Magnification := GetZoomCount;
    Element.Iterations := FIterations;
    SetLength(Element.IterationData, length(FIterationData));
    for i := 0 to high(FIterationData) do
    begin
      SetLength(Element.IterationData[i], length(FIterationData[i]));
      for j := 0 to high(FIterationData[i]) do
        Element.IterationData[i, j] := FIterationData[i, j];
    end;
    FMandelbrotSequence.AddElement(Element);
  end;
  if Assigned(FEndCallback) then
    FEndCallback;
end;

{Der Message Handler des WM_LBUTTONDOWN-Events:
 Falls das Zoomen  erlaubt ist und gerade keine Berechnung erfolgt,
 werden die neuen  Koordinaten ermittelt, indem die Mauskoordinaten
 in Koordinaten auf der reelen/imaginären Achse umgerechnet werden,
 und die  Mandelbrotmenge wird berechnet}
procedure TMandelbrot.MsgMouseLButtonDown(var message: TWMLButtonDown);
var x, y: Integer;
begin
  if (not FZoomEnabled) or (FCalculating) or (FSequenceMode) then
    inherited
  else
  begin
    if (not FRecordZooms) then
    begin
      x := message.XPos;
      y := message.YPos;
    end
    else
    begin
      if ((message.XPos + FZoomWidth) >= GetWidth) then
        x := GetWidth - FZoomWidth
      else
        x := message.XPos;
      if ((message.YPos + FZoomHeight) >= GetHeight) then
        y := GetHeight - FZoomHeight
      else
        y := message.YPos;
    end;
    FReal      := FReal + ((x / FBitmap.Width) * FUnitsOnAxis);
    FImaginary := FImaginary - ((y / FBitmap.Width) * FUnitsOnAxis);
    FUnitsOnAxis := FUnitsOnAxis / FDivisor;
    CalculateMandelbrotThreaded;
    inherited;
  end;
end;

{Der Message Handler des WM_RBUTTONDOWN-Events:
 Falls das Zoomen erlaubt ist und gerade keine Berechnung erfolgt,
 werden die neuen  Koordinaten  ermittelt und die  Mandelbrotmenge
 wird  berechnet. Der  Mittelpunkt des  Ausschnitts  ist die  neue
 Reele/Imaginäre Koordinate}
procedure TMandelbrot.MsgMouseRButtonDown(var message: TWMRButtonDown);
begin
  if (not FZoomEnabled) or (FCalculating) or (FSequenceMode) or (FRecordZooms) then
    inherited
  else
  begin
    FReal      := FReal + ((message.XPos / FBitmap.Width) * FUnitsOnAxis);
    FImaginary := FImaginary - ((message.YPos / FBitmap.Width) * FUnitsOnAxis);
    FUnitsOnAxis := FUnitsOnAxis * FDivisor;
    FReal := FReal - (FUnitsOnAxis / 2);
    FImaginary := FImaginary + (FUnitsOnAxis / 2);
    CalculateMandelbrotThreaded;
    inherited;
  end;
end;

{Der Message Handler des WM_MOUSEMOVE-Events:
 Falls das Zoomen erlaubt ist und gerade keine Berechnung erfolgt,
 wird  der  Ausschnitt  gezeichnet,  in den  der Benutzer mit  den
 aktuellen Einstellungen zoomen kann}
procedure TMandelbrot.MsgMouseMove(var message: TWMMouseMove);
var
  X1, X2, Y1, Y2: Integer;
begin
  FCursorPos.X := message.XPos;
  FCursorPos.Y := message.YPos;
  if (FZoomEnabled) and (not FCalculating) and (not FSequenceMode) then
  begin
    if ((not FRecordZooms) or (FRecordZooms and (((message.XPos + FZoomWidth) < GetWidth)
      and ((message.YPos + FZoomHeight) < GetHeight)))) then
    begin
      X1 := message.XPos;
      X2 := message.XPos + FZoomWidth;
      Y1 := message.YPos;
      Y2 := message.YPos + FZoomHeight;
    end
    else
    begin
      if ((message.XPos + FZoomWidth) >= GetWidth) then
      begin
        X1 := GetWidth - FZoomWidth;
        X2 := GetWidth;
      end
      else
      begin
        X1 := message.XPos;
        X2 := message.XPos + FZoomWidth;
      end;
      if ((message.YPos + FZoomHeight) >= GetHeight) then
      begin
        Y1 := GetHeight - FZoomHeight;
        Y2 := GetHeight;
      end
      else
      begin
        Y1 := message.YPos;
        Y2 := message.YPos + FZoomHeight;
      end;
    end;
    Repaint;
    Canvas.MoveTo(X1, Y1);
    Canvas.LineTo(X2, Y1);
    Canvas.LineTo(X2, Y2);
    Canvas.LineTo(X1, Y2);
    Canvas.LineTo(X1, Y1);
  end;
  inherited;
end;

{Der Message Handler des WM_PAINT-Events:
 Der  Inhalt von  FBitmap wird auf die  Zeichenfläche des  Objekts
 kopiert}
procedure TMandelbrot.MsgPaint(var message: TWMPaint);
begin
  BitBlt(message.DC, 0, 0, FBitmap.Width, FBitmap.Height, FBitmap.Canvas.Handle, 0, 0, srccopy);
end;

{****************************
 *** Öffentliche Methoden ***
 ****************************}

 {Rechnet die Vergrößerung der Mandelbrotmenge anhand der zu
 berechnenden Koordinaten im Koordinatensystem sowie dem
 Startwert aus}
function TMandelbrot.GetZoomCount: Int64;
begin
  result := Trunc(STARTPOS_UNITS / FUnitsOnAxis);
end;

{Rechnet die x-Mauskoordinate auf der Komponente in die zugehörige,
 reele Koordinate im Koordinatensystem der Mandelbrotmenge um}
function TMandelbrot.GetCursorRealPos: Extended;
begin
  result := FReal + ((FCursorPos.X / FBitmap.Width) * FUnitsOnAxis);
end;

{Rechnet die y-Mauskoordinate auf der Komponente in die zugehörige,
 imaginäre Koordinate im Koordinatensystem der Mandelbrotmenge um}
function TMandelbrot.GetCursorImaginaryPos: Extended;
begin
  result := FImaginary - ((FCursorPos.Y / FBitmap.Height) * ((FUnitsOnAxis / Width) * Height));
end;

function TMandelbrot.CTopLeftToCenter(const ACoord: TCoord): TCoord;
begin
  result.Real := ACoord.Real + (ACoord.UnitsOnAxis / 2);
  result.Imaginary := ACoord.Imaginary - (((ACoord.UnitsOnAxis / Width) * Height) / 2);
  result.UnitsOnAxis := ACoord.UnitsOnAxis;
end;

function TMandelbrot.CCenterToTopLeft(const ACoord: TCoord): TCoord;
begin
  result.Real := ACoord.Real - (ACoord.UnitsOnAxis / 2);
  result.Imaginary := ACoord.Imaginary + (((ACoord.UnitsOnAxis / Width) * Height) / 2);
  result.UnitsOnAxis := ACoord.UnitsOnAxis;
end;

{Diese Methode lädt die Iterationsdaten mit den zugehörigen
 Koordinaten aus einer Datei; Sofern der Ladevorgang erfolgreich
 war, wird TRUE zurückgegeben, andernfalls FALSE}
function TMandelbrot.LoadIterationDataFromFile(const AFilename: String): BOOLEAN;
var
  fs: TFileStream;
  w, h, i: Integer;
begin
  result := TRUE;
  fs := TFileStream.Create(AFilename, fmOpenRead);
  try
    try
      fs.Position := 0;
      fs.Read(FIterations, SizeOf(FIterations));
      fs.Read(FReal, SizeOf(FReal));
      fs.Read(FImaginary, SizeOf(FImaginary));
      fs.Read(FUnitsOnAxis, SizeOf(FUnitsOnAxis));
      fs.Read(FLimit, SizeOf(FLimit));
      fs.Read(w, SizeOf(w));
      fs.Read(h, SizeOf(h));
      SetLength(FIterationData, w);
      for i := 0 to (w - 1) do
      begin
        SetLength(FIterationData[i], h);
        fs.Read(FIterationData[i, 0], SizeOf(Integer) * h);
      end;
      FBitmap.Width := w;
      FBitmap.Height := h;
      Self.Width := w;
      Self.Height := h;
    except
      result := FALSE;
    end;
  finally
    fs.Free;
  end;
end;

{Diese Methode speichert die Iterationsdaten mit den zugehörigen
 Koordinaten in eine Datei}
procedure TMandelbrot.SaveIterationDataToFile(const AFilename: String);
var
  fs: TFileStream;
  w, h, i: Integer;
begin
  fs := TFileStream.Create(AFilename, fmCreate);
  try
    w := FBitmap.Width;
    h := FBitmap.Height;
    fs.Position := 0;
    fs.Write(FIterations, SizeOf(FIterations));
    fs.Write(FReal, SizeOf(FReal));
    fs.Write(FImaginary, SizeOf(FImaginary));
    fs.Write(FUnitsOnAxis, SizeOf(FUnitsOnAxis));
    fs.Write(FLimit, SizeOf(FLimit));
    fs.Write(w, SizeOf(w));
    fs.Write(h, SizeOf(h));
    for i := 0 to (w - 1) do
        fs.Write(FIterationData[i, 0], SizeOf(Integer) * h);
  finally
    fs.Free;
  end;
end;

{Das Bitmap, welches sich aus den berechneten Iterationsdaten
 sowie den zugeordneten Farben ergibt, wird durch diese
 Methode in eine Datei gespeichert}
procedure TMandelbrot.SaveBitmapToFile(const AFilename: String);
begin
  FBitmap.SaveToFile(AFilename);
end;

{Diese  Prozedur  zeichnet  den Inhalt  von  FBitmap anhand
 der Daten von den Arrays FIterationData und FColorPalette;
 Wenn  ColorCount  nicht  mit  der  Anzahl  an  Iterationen
 übereinstimmt,  wiederholt  sich  die  Auswahl  der Farben
 aus der Palette}
procedure TMandelbrot.RedrawDots;
var
  x, y: Integer;
  p: ^TColor;
  ColorCount: Integer;
  RepeatColors: BOOLEAN;
begin
  FBitmap.Canvas.Rectangle(0, 0, FBitmap.Width, FBitmap.Height);
  ColorCount := length(FColorPalette);
  if ColorCount = FIterations then
    RepeatColors := FALSE
  else
    RepeatColors := TRUE;
  for y := 0 to FBitmap.Height - 1 do
  begin
    p := FBitmap.ScanLine[y];
    for x := 0 to FBitmap.Width - 1 do
    begin
      if (FIterationData[x, y] >= FIterations) or (ColorCount = 0) then
        p^ := clBlack
      else
      begin
        if RepeatColors then
          p^ := FColorPalette[FIterationData[x, y] mod ColorCount]
        else
          p^ := FColorPalette[FIterationData[x, y]];
      end;
      inc(p);
    end;
  end;
end;

{Aus dieser öffentlichen Methode heraus wird der Thread,
 in  dem die Berechnung  stattfindet, erzeugt und  somit
 gestartet}
procedure TMandelbrot.CalculateMandelbrotThreaded;
begin
  FCalculating := TRUE;
  TMandelbrotThread.Create(self);
end;

procedure TMandelbrot.SetSequenceIterations;
begin
  if (FSequenceMode) then
  begin
    FIterationData  := FMandelbrotSequence.CurrentData.IterationData;
    FIterations    :=  FMandelbrotSequence.CurrentData.Iterations;
  end;
end;

procedure TMandelbrot.DrawMandelbrotSequence;
var
  tmppoint: TIterationData;
begin
  tmppoint := FIterationData;
  FMandelbrotSequence.ElementIndex := 0;
  FMandelbrotSequence.SubIndex := 0;
  FIterationData := FMandelbrotSequence.FSequence[0].IterationData;
  RedrawDots;
  while FMandelbrotSequence.ElementIndex < FMandelbrotSequence.ElementCount-1 do
  begin
    FMandelbrotSequence.NextFrame;
    FIterationData := FMandelbrotSequence.CurrentData.IterationData;
    RedrawDots;
    Repaint;
    Application.ProcessMessages;
  end;
  FIterationData := tmppoint;
  RedrawDots;
  Repaint;
end;

procedure TMandelbrot.DrawMandelbrotSequenceBackwards;
var
  tmppoint: TIterationData;
begin
  tmppoint := FIterationData;
  FMandelbrotSequence.CalculateFrame(FMandelbrotSequence.HighestIndex,0);
  FIterationData := FMandelbrotSequence.CurrentData.IterationData;
  RedrawDots;
  while FMandelbrotSequence.ElementIndex >= 0 do
  begin
    FMandelbrotSequence.PreviousFrame;
    FIterationData := FMandelbrotSequence.CurrentData.IterationData;
    RedrawDots;
    Repaint;
    Application.ProcessMessages;
  end;
  FIterationData := tmppoint;
  RedrawDots;
  Repaint;
end;

{Setzt die Startkoordinaten, mit denen die gesamte
 Mandelbrotmenge sichtbar ist}
procedure TMandelbrot.SetStartPosition;
begin
  FUnitsOnAxis :=  STARTPOS_UNITS;
  FReal        :=  STARTPOS_REAL;
  FImaginary   :=  STARTPOS_IMAGINARY;
end;

{Fügt die Arrays aller drei Farbpaletten über MergeArrays zu einem
 zusammen und weist diesen Wert FColorPalette zu}
procedure TMandelbrot.SetColorPalette(const ARPalette, AGPalette, ABPalette: TColorPalette; const AColorCount: Integer);
begin
  FColorPalette := MergeArrays(ARPalette.GetColorValues(AColorCount),
    AGPalette.GetColorValues(AColorCount),
    ABPalette.GetColorValues(AColorCount));
end;

end.
