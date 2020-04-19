unit U_Coordinates;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, UMandelbrot, IniFiles;

type

  TCoordinate = record
    Description: String;
    Real: Extended;
    Imaginary: Extended;
    UnitsOnAxis: Extended;
  end;

  TCoordArray = Array of TCoordinate;

  TF_Coordinates = class(TForm)
    LE_Real: TLabeledEdit;
    LE_Imaginary: TLabeledEdit;
    LE_UnitsOnAxis: TLabeledEdit;
    SB_Ok: TSpeedButton;
    SB_Cancel: TSpeedButton;
    SB_Reset: TSpeedButton;
    GB_Favorites: TGroupBox;
    CB_Favorites: TComboBox;
    Label1: TLabel;
    SB_AddToFavorites: TSpeedButton;
    SB_DeleteFromFavorites: TSpeedButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    LE_Real2: TLabeledEdit;
    LE_Imaginary2: TLabeledEdit;
    LE_UnitsOnAxis2: TLabeledEdit;
    procedure LE_Real2Change(Sender: TObject);
    procedure SB_DeleteFromFavoritesClick(Sender: TObject);
    procedure SB_AddToFavoritesClick(Sender: TObject);
    procedure LE_RealChange(Sender: TObject);
    procedure CB_FavoritesSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SB_ResetClick(Sender: TObject);
    procedure SB_OkClick(Sender: TObject);
    procedure SB_CancelClick(Sender: TObject);
  private
    { Private declarations }
    FCoordinates: TCoordArray;
  public
    { Public declarations }
    property Coordinates: TCoordArray read FCoordinates write FCoordinates;
  end;

var
  F_Coordinates: TF_Coordinates;

implementation

uses U_Main;

{$R *.dfm}


procedure TF_Coordinates.SB_OkClick(Sender: TObject);
begin
  try
    with F_MainForm.MandelFract do
    begin
      if (RealCoordinate <> StrToFloat(LE_Real.Text)) or
         (ImaginaryCoordinate <> StrToFloat(LE_Imaginary.Text)) or
         (UnitsOnAxis <> StrToFloat(LE_UnitsOnAxis.Text)) then
      begin
        RealCoordinate := StrToFloat(LE_Real.Text);
        ImaginaryCoordinate := StrToFloat(LE_Imaginary.Text);
        UnitsOnAxis := StrToFloat(LE_UnitsOnAxis.Text);
        CalculateMandelbrotThreaded;
      end;
    end;
    F_Coordinates.Close;
  except
    ShowMessage('Es liegt ein Eingabefehler bei den Koordinaten vor!');
  end;
end;

procedure TF_Coordinates.SB_CancelClick(Sender: TObject);
begin
  F_Coordinates.Close;
end;

procedure TF_Coordinates.SB_ResetClick(Sender: TObject);
begin
  LE_Real.Text        := FloatToStr(STARTPOS_REAL);
  LE_Imaginary.Text   := FloatToStr(STARTPOS_IMAGINARY);
  LE_UnitsOnAxis.Text := FloatToStr(STARTPOS_UNITS);
end;

procedure TF_Coordinates.FormShow(Sender: TObject);
begin
  LE_Real.OnChange := nil;
  LE_Imaginary.OnChange := nil;
  LE_UnitsOnAxis.OnChange := nil;
  LE_Real.Text        := FloatToStr(F_MainForm.MandelFract.RealCoordinate);
  LE_Imaginary.Text   := FloatToStr(F_MainForm.MandelFract.ImaginaryCoordinate);
  LE_UnitsOnAxis.Text := FloatToStr(F_MainForm.MandelFract.UnitsOnAxis);
  LE_Real.OnChange := LE_RealChange;
  LE_Imaginary.OnChange := LE_RealChange;
  LE_UnitsOnAxis.OnChange := LE_RealChange;
  LE_RealChange(Sender);
end;

procedure TF_Coordinates.FormCreate(Sender: TObject);
var
  Coords: TStringList;
  i: Integer;
  s: String;
begin
  if FileExists(ExtractFilePath(ParamStr(0)) + DEF_COORDFILENAME) then
  begin
    Coords := TStringList.Create;
    Coords.LoadFromFile(ExtractFilePath(ParamStr(0)) + DEF_COORDFILENAME);
    SetLength(FCoordinates, Coords.Count);
    for i := 0 to Coords.Count - 1 do
    begin
      s := Coords.Strings[i];
      FCoordinates[i].Description        := Copy(s, 1, Pos(';', s) - 1);
      s := Copy(s, Pos(';', s) + 1, length(s) - Pos(';', s));
      FCoordinates[i].Real               := StrToFloat(Copy(s, 1, Pos(';', s) - 1));
      s := Copy(s, Pos(';', s) + 1, length(s) - Pos(';', s));
      FCoordinates[i].Imaginary          := StrToFloat(Copy(s, 1, Pos(';', s) - 1));
      s := Copy(s, Pos(';', s) + 1, length(s) - Pos(';', s));
      FCoordinates[i].UnitsOnAxis        := StrToFloat(s);
      CB_Favorites.Items.Add(FCoordinates[i].Description);
    end;
    Coords.Free;
  end;
end;

procedure TF_Coordinates.CB_FavoritesSelect(Sender: TObject);
begin
  if CB_Favorites.ItemIndex <> 0 then
  begin
    LE_Real.OnChange        := nil;
    LE_Imaginary.OnChange   := nil;
    LE_UnitsOnAxis.OnChange := nil;
    LE_Real2.OnChange        := nil;
    LE_Imaginary2.OnChange   := nil;
    LE_UnitsOnAxis2.OnChange := nil;
    LE_Real.Text            := FloatToStr(FCoordinates[CB_Favorites.ItemIndex - 1].Real);
    LE_Imaginary.Text       := FloatToStr(FCoordinates[CB_Favorites.ItemIndex - 1].Imaginary);
    LE_UnitsOnAxis.Text     := FloatToStr(FCoordinates[CB_Favorites.ItemIndex - 1].UnitsOnAxis);
    LE_Real.OnChange        := LE_RealChange;
    LE_Imaginary.OnChange   := LE_RealChange;
    LE_UnitsOnAxis.OnChange := LE_RealChange;
    LE_Real2.OnChange        := LE_Real2Change;
    LE_Imaginary2.OnChange   := LE_Real2Change;
    LE_UnitsOnAxis2.OnChange := LE_Real2Change;
    LE_RealChange(Sender);
  end;
end;

procedure TF_Coordinates.LE_RealChange(Sender: TObject);
var
  C: TCoord;
begin
  if Sender <> CB_Favorites then
    CB_Favorites.ItemIndex := 0;
  LE_Real2.OnChange        := nil;
  LE_Imaginary2.OnChange   := nil;
  LE_UnitsOnAxis2.OnChange := nil;
  try
  try
    C.Real := StrToFloat(LE_Real.Text);
    C.Imaginary := StrToFloat(LE_Imaginary.Text);
    C.UnitsOnAxis := StrToFloat(LE_UnitsOnAxis.Text);
    C := F_MainForm.MandelFract.CTopLeftToCenter(C);
    LE_Real2.Text := FloatToStr(C.Real);
    LE_Imaginary2.Text := FloatToStr(C.Imaginary);
    LE_UnitsOnAxis2.Text := FloatToStr(C.UnitsOnAxis);
  except
    LE_Real2.Text := 'Erwarte korrekte Eingabe...';
    LE_Imaginary2.Text := 'Erwarte korrekte Eingabe...';
    LE_UnitsOnAxis2.Text := 'Erwarte korrekte Eingabe...';
  end;
  finally
    LE_Real2.OnChange        := LE_Real2Change;
    LE_Imaginary2.OnChange   := LE_Real2Change;
    LE_UnitsOnAxis2.OnChange := LE_Real2Change;
  end;
end;

procedure TF_Coordinates.SB_AddToFavoritesClick(Sender: TObject);
var
  s: String;
begin
  s := InputBox('Koordinatenbezeichnung', 'Bitte geben sie eine Bezeichnung für die Koordinaten an, die hinzugefügt werden sollen', '');
  if (s <> '') then
  begin
    CB_Favorites.Items.Add(s);
    SetLength(FCoordinates, length(FCoordinates) + 1);
    FCoordinates[high(FCoordinates)].Description := s;
    FCoordinates[high(FCoordinates)].Real        := StrToFloat(LE_Real.Text);
    FCoordinates[high(FCoordinates)].Imaginary   := StrToFloat(LE_Imaginary.Text);
    FCoordinates[high(FCoordinates)].UnitsOnAxis := StrToFloat(LE_UnitsOnAxis.Text);
    CB_Favorites.ItemIndex := CB_Favorites.Items.Count - 1;
  end;
end;

procedure TF_Coordinates.SB_DeleteFromFavoritesClick(Sender: TObject);
var
  i: Integer;
begin
  if CB_Favorites.ItemIndex > 0 then
  begin
    for i := CB_Favorites.ItemIndex to high(FCoordinates) do
      FCoordinates[i - 1] := FCoordinates[i];
    CB_Favorites.DeleteSelected;
    CB_Favorites.ItemIndex := 0;
    SetLength(FCoordinates, length(FCoordinates) - 1);
  end;
end;

procedure TF_Coordinates.LE_Real2Change(Sender: TObject);
var
  C: TCoord;
begin
  CB_Favorites.ItemIndex := 0;
  LE_Real.OnChange        := nil;
  LE_Imaginary.OnChange   := nil;
  LE_UnitsOnAxis.OnChange := nil;
  try
    try
      C.Real := StrToFloat(LE_Real2.Text);
      C.Imaginary := StrToFloat(LE_Imaginary2.Text);
      C.UnitsOnAxis := StrToFloat(LE_UnitsOnAxis2.Text);
      C := F_MainForm.MandelFract.CCenterToTopLeft(C);
      LE_Real.Text := FloatToStr(C.Real);
      LE_Imaginary.Text := FloatToStr(C.Imaginary);
      LE_UnitsOnAxis.Text := FloatToStr(C.UnitsOnAxis);
    except
      LE_Real.Text := 'Erwarte korrekte Eingabe...';
      LE_Imaginary.Text := 'Erwarte korrekte Eingabe...';
      LE_UnitsOnAxis.Text := 'Erwarte korrekte Eingabe...';
    end;
  finally
    LE_Real.OnChange        := LE_RealChange;
    LE_Imaginary.OnChange   := LE_RealChange;
    LE_UnitsOnAxis.OnChange := LE_RealChange;
  end;
end;

end.
