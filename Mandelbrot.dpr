program Mandelbrot;

uses
  Forms,
  U_Main in 'U_Main.pas' {F_Main},
  U_Iterations in 'U_Iterations.pas' {F_IterationSettings},
  U_Coordinates in 'U_Coordinates.pas' {F_Coordinates},
  U_Colors in 'U_Colors.pas' {F_ColorSettings},
  U_PicSize in 'U_PicSize.pas' {F_PicSize},
  U_CalcSettings in 'U_CalcSettings.pas' {F_CalcSettings},
  U_Infos in 'U_Infos.pas' {F_Infos},
  U_Protocol in 'U_Protocol.pas' {F_Protocol},
  U_ZoomRecord in 'U_ZoomRecord.pas' {F_ZoomRecord};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Mandelbrotberechner';
  Application.CreateForm(TF_MainForm, F_MainForm);
  Application.CreateForm(TF_IterationSettings, F_IterationSettings);
  Application.CreateForm(TF_Coordinates, F_Coordinates);
  Application.CreateForm(TF_ColorSettings, F_ColorSettings);
  Application.CreateForm(TF_PicSize, F_PicSize);
  Application.CreateForm(TF_CalcSettings, F_CalcSettings);
  Application.CreateForm(TF_Infos, F_Infos);
  Application.CreateForm(TF_Protocol, F_Protocol);
  Application.CreateForm(TF_ZoomRecord, F_ZoomRecord);
  Application.Run;
end.
