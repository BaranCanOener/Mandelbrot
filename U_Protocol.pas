unit U_Protocol;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Gauges;

type
  TF_Protocol = class(TForm)
    M_Protocol: TMemo;
    B_Save: TButton;
    B_Clear: TButton;
    B_Close: TButton;
    SaveDialog1: TSaveDialog;
    GB_Status: TGroupBox;
    G_Progress: TGauge;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure B_CloseClick(Sender: TObject);
    procedure B_ClearClick(Sender: TObject);
    procedure B_SaveClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  F_Protocol: TF_Protocol;

implementation

uses U_Main;

{$R *.dfm}

procedure TF_Protocol.B_SaveClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
    M_Protocol.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TF_Protocol.B_ClearClick(Sender: TObject);
begin
  M_Protocol.Clear;
end;

procedure TF_Protocol.B_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TF_Protocol.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  F_MainForm.MandelFract.Repaint;
end;

procedure TF_Protocol.FormCreate(Sender: TObject);
begin
  M_Protocol.OnMouseMove := OnMouseMove;
  B_Save.OnMouseMove := OnMouseMove;
  B_Clear.OnMouseMove := OnMouseMove;
  B_Close.OnMouseMove := OnMouseMove;
end;

end.
