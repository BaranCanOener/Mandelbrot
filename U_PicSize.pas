unit U_PicSize;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, Spin;

type
  TF_PicSize = class(TForm)
    SP_Width: TSpinEdit;
    SP_Height: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    SB_Ok: TSpeedButton;
    SB_Cancel: TSpeedButton;
    procedure SB_CancelClick(Sender: TObject);
    procedure SB_OkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  F_PicSize: TF_PicSize;

implementation

uses U_Main;

{$R *.dfm}

procedure TF_PicSize.FormShow(Sender: TObject);
begin
  SP_Width.Value  := F_MainForm.MandelFract.Width;
  SP_Height.Value := F_MainForm.MandelFract.Height;
end;

procedure TF_PicSize.SB_OkClick(Sender: TObject);
begin
  if (SP_Width.Value <> F_MainForm.MandelFract.Width) or (SP_Height.Value <> F_MainForm.MandelFract.Height) then
  begin
    with F_MainForm do
    begin
      MandelFract.Width := SP_Width.Value;
      MandelFract.Height := SP_Height.Value;
      MandelFract.CalculateMandelbrotThreaded;
    end;
  end;
  Close;
end;

procedure TF_PicSize.SB_CancelClick(Sender: TObject);
begin
  Close;
end;

end.
