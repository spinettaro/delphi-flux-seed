program DelphiFluxSeed;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainFMX in 'Views\MainFMX.pas' {MainForm},
  Dispatcher.Flux in 'Dispatcher\Dispatcher.Flux.pas',
  DelphiFlux.ActionCreators in 'Actions\DelphiFlux.ActionCreators.pas',
  DelphiFlux.Actions in 'Actions\DelphiFlux.Actions.pas',
  DelphiFlux.Stores in 'Stores\DelphiFlux.Stores.pas',
  BOs in 'BOs\BOs.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;

end.
