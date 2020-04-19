unit U_Infos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type

  TPixels = Array [0..399] of TColor;

  PPixels = ^TPixels;

  TDirection = (dLeft = 0, dRight = 1, dUp = 2, dDown = 3);

  TWorm = record
    Positions: Array of TPoint;
    Direction: TDirection;
    Color: TColor;
  end;

  TF_Infos = class(TForm)
    T_MoveWorms: TTimer;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure T_MoveWormsTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    FWormCount: Integer;
    FMinWormLength: Integer;
    FWormLengthRange: Integer;
    FMouseX, FMouseY: Integer;
    FBitmap: TBitmap;
    FWorms: Array of TWorm;
  public
    { Public-Deklarationen }
    property Bmp: TBitmap read FBitmap write FBitmap;
  end;

var
  F_Infos: TF_Infos;

implementation

{$R *.dfm}

procedure TF_Infos.FormCreate(Sender: TObject);
var
  i, j: Integer;
begin
  FMouseX := 200;
  FMouseY := 200;
  DoubleBuffered := TRUE;
  FWormCount := 90;
  FMinWormLength := 5;
  FWormLengthRange := 25;
  SetLength(FWorms, FWormCount);
  for i := 0 to high(FWorms) do
  begin
    SetLength(FWorms[i].Positions, Random(FWormLengthRange + 1) + FMinWormLength);
    for j := 0 to high(FWorms[i].Positions) do
    begin
      FWorms[i].Positions[j].X := Random(Width);
      FWorms[i].Positions[j].Y := Random(Height);
    end;
    FWorms[i].Direction := TDirection(Random(4));
    FWorms[i].Color := clWhite;
  end;
  FBitmap := TBitmap.Create;
  FBitmap.Width := 400;
  FBitmap.Height := 400;
  FBitmap.PixelFormat := pf32Bit;
  FBitmap.Canvas.Brush.Color := clBlack;
  FBitmap.Canvas.Font.Color := clWhite;
  FBitmap.Canvas.Font.Name := 'System';
end;

procedure TF_Infos.T_MoveWormsTimer(Sender: TObject);
var
  i, j, lastindex, rnd, xdiff, ydiff: Integer;
  FPixels: Array [0..399] of PPixels;
begin
  for i := 0 to 399 do
  begin
    FPixels[i] := FBitmap.ScanLine[i];
    ZeroMemory(@FPixels[i][0], 400*4);
  end;
  FBitmap.Canvas.TextOut(40, 40, 'Mandelbrotmenge - Programmiert von Baran Öner');
  FBitmap.Canvas.TextOut(40, 60, 'Finale Version');
  FBitmap.Canvas.TextOut(40, 80, 'bcoe@haefft.de');
  for i := 0 to high(FWorms) do
  begin
    with FWorms[i] do
    begin
      lastindex := high(FWorms[i].Positions);
      for j := 0 to lastindex - 1 do
      begin
        Positions[j] := Positions[j + 1];
        FPixels[Positions[j].Y, Positions[j].X] := FWorms[i].Color;
      end;
      if Direction = dLeft then
        Positions[lastindex].X := Positions[lastindex].X - 1
      else if Direction = dRight then
        Positions[lastindex].X := Positions[lastindex].X + 1
      else if Direction = dUp then
        Positions[lastindex].Y := Positions[lastindex].Y - 1
      else if Direction = dDown then
        Positions[lastindex].Y := Positions[lastindex].Y + 1;
      if Positions[lastindex].X >= Width then
        Positions[lastindex].X := 0;
      if Positions[lastindex].Y >= Height then
        Positions[lastindex].Y := 0;
      if Positions[lastindex].X < 0 then
        Positions[lastindex].X := Width - 1;
      if Positions[lastindex].Y < 0 then
        Positions[lastindex].Y := Height - 1;
      rnd := Random(10);
      if (rnd = 0) then
        Direction := TDirection(Random(4))
      else if (rnd = 1) or (rnd = 2) then
      begin
        xdiff := FMouseX - Positions[lastindex].X;
        ydiff := FMouseY - Positions[lastindex].Y;
        rnd := Random(2);
        if (rnd = 0) or (ydiff = 0) then
        begin
          if xdiff > 0 then
            FWorms[i].Direction := dRight
          else if xdiff < 0 then
            FWorms[i].Direction := dLeft;
        end
        else
        begin
          if ydiff > 0 then
            FWorms[i].Direction := dDown
          else if ydiff < 0 then
            FWorms[i].Direction := dUp;
        end;
      end;
      FPixels[Positions[lastindex].Y, Positions[lastindex].X] := FWorms[i].Color;
    end;
  end;
  BitBlt(Canvas.Handle, 0, 0, Width, Height, FBitmap.Canvas.Handle,
    0, 0, srccopy);
end;

procedure TF_Infos.FormShow(Sender: TObject);
begin
  T_MoveWorms.Enabled := TRUE;
end;

procedure TF_Infos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  T_MoveWorms.Enabled := FALSE;
end;

procedure TF_Infos.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  FMouseX := X;
  FMouseY := Y;
end;

procedure TF_Infos.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
begin
  if (Button = mbMiddle) then
  begin
    for i := 0 to high(FWorms) do
      FWorms[i].Color := Random($FFFFFF + 1);
  end
  else if (Button = mbLeft) then
  begin
    inc(FWormCount);
    SetLength(FWorms, FWormCount);
    SetLength(FWorms[FWormCount-1].Positions, Random(FWormLengthRange + 1) + FMinWormLength);
    for i := 0 to high(FWorms[FWormCount-1].Positions) do
    begin
      FWorms[FWormCount-1].Positions[i].X := Random(Width);
      FWorms[FWormCount-1].Positions[i].Y := Random(Height);
    end;
    FWorms[FWormCount-1].Direction := TDirection(Random(4));
    FWorms[FWormCount-1].Color := clWhite;
  end
  else if (Button = mbRight) and (FWormCount > 1) then
  begin
    dec(FWormCount);
    SetLength(FWorms, FWormCount);
  end;
end;

end.
