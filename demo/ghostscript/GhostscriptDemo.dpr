program GhostscriptDemo;

uses
  Vcl.Forms,
  MainFORM in 'MainFORM.pas' {frmMain},
  ghostscriptHelpers in 'units\ghostscriptHelpers.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
