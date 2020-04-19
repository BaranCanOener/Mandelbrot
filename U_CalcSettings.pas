unit U_CalcSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, Spin;

type
  TF_CalcSettings = class(TForm)
    SP_Interval: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    CB_ThreadPriority: TComboBox;
    SB_Ok: TSpeedButton;
    SB_Cancel: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure SB_CancelClick(Sender: TObject);
    procedure SB_OkClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  F_CalcSettings: TF_CalcSettings;

implementation

uses U_Main;

{$R *.dfm}

procedure TF_CalcSettings.SB_OkClick(Sender: TObject);
begin
  F_MainForm.Timer1.Interval := SP_Interval.Value;
  case CB_ThreadPriority.ItemIndex of
    0: F_MainForm.MandelFract.ThreadPriority := tpIdle;
    1: F_MainForm.MandelFract.ThreadPriority := tpLowest;
    2: F_MainForm.MandelFract.ThreadPriority := tpLower;
    3: F_MainForm.MandelFract.ThreadPriority := tpNormal;
    4: F_MainForm.MandelFract.ThreadPriority := tpHigher;
    5: F_MainForm.MandelFract.ThreadPriority := tpHighest;
    6: F_MainForm.MandelFract.ThreadPriority := tpTimeCritical;
  end;
  Close;
end;

procedure TF_CalcSettings.SB_CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TF_CalcSettings.FormShow(Sender: TObject);
begin
  SP_Interval.Value := F_MainForm.Timer1.Interval;
  case F_MainForm.MandelFract.ThreadPriority of
    tpIdle:         CB_ThreadPriority.ItemIndex := 0;
    tpLowest:       CB_ThreadPriority.ItemIndex := 1;
    tpLower:        CB_ThreadPriority.ItemIndex := 2;
    tpNormal:       CB_ThreadPriority.ItemIndex := 3;
    tpHigher:       CB_ThreadPriority.ItemIndex := 4;
    tpHighest:      CB_ThreadPriority.ItemIndex := 5;
    tpTimeCritical: CB_ThreadPriority.ItemIndex := 6;
  end;
end;

end.
