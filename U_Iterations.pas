unit U_Iterations;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Spin, Buttons, ExtCtrls;

type
  TF_IterationSettings = class(TForm)
    SP_Iterations: TSpinEdit;
    TB_Iterations: TTrackBar;
    SB_Ok: TSpeedButton;
    SB_Cancel: TSpeedButton;
    Label1: TLabel;
    LE_Limit: TLabeledEdit;
    procedure FormShow(Sender: TObject);
    procedure TB_IterationsChange(Sender: TObject);
    procedure SP_IterationsChange(Sender: TObject);
    procedure SB_OkClick(Sender: TObject);
    procedure SB_CancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_IterationSettings: TF_IterationSettings;

implementation

uses U_Main;

{$R *.dfm}

procedure TF_IterationSettings.TB_IterationsChange(Sender: TObject);
begin
  SP_Iterations.Value := TB_Iterations.Position;
end;

procedure TF_IterationSettings.SP_IterationsChange(Sender: TObject);
begin
  TB_Iterations.Position := SP_Iterations.Value;
end;

procedure TF_IterationSettings.SB_OkClick(Sender: TObject);
begin
  if (TB_Iterations.Position <> F_MainForm.MandelFract.Iterations) or (StrToFloat(LE_Limit.Text) <> F_MainForm.MandelFract.Limit) then
  begin
    with F_MainForm.MandelFract do
    begin
      Iterations := TB_Iterations.Position;
      Limit := StrToFloat(LE_Limit.Text);
      CalculateMandelbrotThreaded;
    end;
  end;
  F_IterationSettings.Close;
end;

procedure TF_IterationSettings.SB_CancelClick(Sender: TObject);
begin
  F_IterationSettings.Close;
end;

procedure TF_IterationSettings.FormShow(Sender: TObject);
begin
  SP_Iterations.Value := F_MainForm.MandelFract.Iterations;
  LE_Limit.Text := FloatToStr(F_MainForm.MandelFract.Limit);
end;

end.
