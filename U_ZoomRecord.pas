unit U_ZoomRecord;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TF_ZoomRecord = class(TForm)
    GB_Coords: TGroupBox;
    LE_Real: TLabeledEdit;
    LE_Imaginary: TLabeledEdit;
    LE_UnitsOnAxis: TLabeledEdit;
    TB_TotalIndex: TTrackBar;
    TB_ElementIndex: TTrackBar;
    TB_SubIndex: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    B_Save: TButton;
    B_Load: TButton;
    B_Delete: TButton;
    B_Draw: TButton;
    B_DrawBackwards: TButton;
    GB_Mode: TGroupBox;
    RB_Standard: TRadioButton;
    RB_Record: TRadioButton;
    RB_Draw: TRadioButton;
    procedure B_DeleteClick(Sender: TObject);
    procedure RB_StandardClick(Sender: TObject);
    procedure RB_DrawClick(Sender: TObject);
    procedure RB_RecordClick(Sender: TObject);
    procedure TB_SubIndexChange(Sender: TObject);
    procedure TB_ElementIndexChange(Sender: TObject);
    procedure TB_TotalIndexChange(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure SetElements(const AState: BOOLEAN);
  public
    { Public-Deklarationen }
    procedure Actualize;
  end;

var
  F_ZoomRecord: TF_ZoomRecord;

implementation

uses U_Main;

{$R *.dfm}

procedure TF_ZoomRecord.SetElements(const AState: BOOLEAN);
begin
  B_Draw.Enabled := AState;
  B_DrawBackwards.Enabled := AState;
  TB_TotalIndex.Enabled := AState;
  TB_ElementIndex.Enabled := AState;
  TB_SubIndex.Enabled := AState;
end;

procedure TF_ZoomRecord.Actualize;
begin
  if (F_MainForm.MandelFract.MandelbrotSequence.TotalIndices = 0) then
    TB_TotalIndex.Max := 0
  else
    TB_TotalIndex.Max := F_MainForm.MandelFract.MandelbrotSequence.TotalIndices - 1;
  Label1.Caption := 'Gesamter Index (' + IntToStr(TB_TotalIndex.Position) + '/' +
    IntToStr(TB_TotalIndex.Max) + ')';
  if (F_MainForm.MandelFract.MandelbrotSequence.ElementCount = 0) then
    TB_ElementIndex.Max := 0
  else
    TB_ElementIndex.Max := F_MainForm.MandelFract.MandelbrotSequence.ElementCount - 1;
  Label2.Caption := 'Elementindex (' + IntToStr(TB_ElementIndex.Position) + '/' +
    IntToStr(TB_ElementIndex.Max) + ')';
  if (F_MainForm.MandelFract.MandelbrotSequence.SubIndices = 0) then
    TB_SubIndex.Max := 0
  else
    TB_SubIndex.Max := F_MainForm.MandelFract.MandelbrotSequence.SubIndices;
  Label3.Caption := 'Subindex (' + IntToStr(TB_SubIndex.Position) + '/' +
    IntToStr(TB_SubIndex.Max) + ')';
  LE_Real.Text := FloatToStr(F_MainForm.MandelFract.MandelbrotSequence.CurrentData.Coord.Real);
  LE_Imaginary.Text := FloatToStr(F_MainForm.MandelFract.MandelbrotSequence.CurrentData.Coord.Imaginary);
  LE_UnitsOnAxis.Text := FloatToStr(F_MainForm.MandelFract.MandelbrotSequence.CurrentData.Coord.UnitsOnAxis);
end;

procedure TF_ZoomRecord.TB_TotalIndexChange(Sender: TObject);
begin
  if F_MainForm.MandelFract.MandelbrotSequence.ElementCount = 0 then
    exit;
  TB_ElementIndex.OnChange := nil;
  TB_SubIndex.OnChange := nil;
  F_MainForm.MandelFract.MandelbrotSequence.CalculateFrame(TB_TotalIndex.Position);
  TB_ElementIndex.Position := F_MainForm.MandelFract.MandelbrotSequence.ElementIndex;
  TB_SubIndex.Position := F_MainForm.MandelFract.MandelbrotSequence.SubIndex;
  Actualize;
  F_MainForm.MandelFract.SetSequenceIterations;
  F_MainForm.MandelFract.RedrawDots;
  F_MainForm.MandelFract.Repaint;
  TB_ElementIndex.OnChange := TB_ElementIndexChange;
  TB_SubIndex.OnChange := TB_SubIndexChange;
end;

procedure TF_ZoomRecord.TB_ElementIndexChange(Sender: TObject);
begin
  if F_MainForm.MandelFract.MandelbrotSequence.ElementCount = 0 then
    exit;
  TB_TotalIndex.OnChange := nil;
  TB_SubIndex.OnChange := nil;
  F_MainForm.MandelFract.MandelbrotSequence.CalculateFrame(TB_ElementIndex.Position, 0);
  TB_TotalIndex.Position := F_MainForm.MandelFract.MandelbrotSequence.TotalIndex;
  TB_SubIndex.Position := F_MainForm.MandelFract.MandelbrotSequence.SubIndex;
  Actualize;
  F_MainForm.MandelFract.SetSequenceIterations;
  F_MainForm.MandelFract.RedrawDots;
  F_MainForm.MandelFract.Repaint;
  TB_TotalIndex.OnChange := TB_TotalIndexChange;
  TB_SubIndex.OnChange := TB_SubIndexChange;
end;

procedure TF_ZoomRecord.TB_SubIndexChange(Sender: TObject);
begin
  if F_MainForm.MandelFract.MandelbrotSequence.ElementCount = 0 then
    exit;
  TB_TotalIndex.OnChange := nil;
  F_MainForm.MandelFract.MandelbrotSequence.CalculateFrame(TB_ElementIndex.Position, TB_SubIndex.Position);
  TB_TotalIndex.Position := F_MainForm.MandelFract.MandelbrotSequence.TotalIndex;
  Actualize;
  F_MainForm.MandelFract.SetSequenceIterations;
  F_MainForm.MandelFract.RedrawDots;
  F_MainForm.MandelFract.Repaint;
  TB_TotalIndex.OnChange := TB_TotalIndexChange;
end;

procedure TF_ZoomRecord.RB_RecordClick(Sender: TObject);
begin
  F_MainForm.MandelFract.SequenceMode := FALSE;
  F_MainForm.MandelFract.RecordZooms := TRUE;
  SetElements(FALSE);
end;

procedure TF_ZoomRecord.RB_DrawClick(Sender: TObject);
begin
  F_MainForm.MandelFract.SequenceMode := TRUE;
  F_MainForm.MandelFract.RecordZooms := FALSE;
  SetElements(TRUE);
end;

procedure TF_ZoomRecord.RB_StandardClick(Sender: TObject);
begin
  F_MainForm.MandelFract.SequenceMode := FALSE;
  F_MainForm.MandelFract.RecordZooms := FALSE;
  SetElements(FALSE);
end;

procedure TF_ZoomRecord.B_DeleteClick(Sender: TObject);
begin
  F_MainForm.MandelFract.MandelbrotSequence.Clear;
  RB_Standard.Checked := TRUE;
  Actualize;
end;

end.
