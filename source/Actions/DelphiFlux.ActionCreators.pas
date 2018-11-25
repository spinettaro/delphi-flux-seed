unit DelphiFlux.ActionCreators;

interface

uses
  Dispatcher.Flux, System.Threading, System.SysUtils, BOs;

const

  ACTION_LOGIN: String = 'DO_LOGIN';

type

  ISeedActionsCreators = interface
    ['{FC5FE0F1-352A-49D9-AFD7-68BF081C0ABD}']
    procedure DoLogin(const AUsername, APassword: String);
  end;

  TBaseActionsCreators = class abstract(TInterfacedObject)
  private
    FThreadPool: TThreadPool;
  protected
    FDispatcher: IFluxDispatcher;
  public
    constructor Create(const ADispatcher: IFluxDispatcher);
    destructor Destroy; override;
    procedure DoInBackground(AJob: TProc;
      const ASendLoadingEvent: Boolean = true);
  end;

  TLoadingEvent = class(TObject)
  private
    FWait: Boolean;
    procedure SetWait(const Value: Boolean);
  public
    constructor Create(const AWait: Boolean);
    property Wait: Boolean read FWait write SetWait;
  end;

function GetSeedActionsCreators(const ADispatcher: IFluxDispatcher)
  : ISeedActionsCreators;

implementation

uses
  DelphiFlux.Actions, System.Classes;

var
  SeedActionsCreators: ISeedActionsCreators;

type

  TSeedActionsCreators = class(TBaseActionsCreators, ISeedActionsCreators)
  public
    procedure DoLogin(const AUsername, APassword: String);
  end;

  { TSeedActionsCreators }

procedure TSeedActionsCreators.DoLogin(const AUsername, APassword: String);
begin
  DoInBackground(
    procedure
    var
      LUserLogin: TUserLogin;
    begin
      TThread.Sleep(3000);
      // SIMULATE A LOGIN
      LUserLogin := TUserLogin.Create(AUsername, APassword);
      try
        FDispatcher.DoDispatch(TFluxAction.Create(ACTION_LOGIN, LUserLogin));
      finally
        LUserLogin.Free;
      end;

    end);
end;

function GetSeedActionsCreators(const ADispatcher: IFluxDispatcher)
  : ISeedActionsCreators;
begin
  if not Assigned(SeedActionsCreators) then
    SeedActionsCreators := TSeedActionsCreators.Create(ADispatcher);
  Result := SeedActionsCreators;
end;

constructor TBaseActionsCreators.Create(const ADispatcher: IFluxDispatcher);
begin
  inherited Create;
  FThreadPool := TThreadPool.Create;
  FDispatcher := ADispatcher;
end;

destructor TBaseActionsCreators.Destroy;
begin
  FThreadPool.Free;
  inherited;
end;

procedure TBaseActionsCreators.DoInBackground(AJob: TProc;
const ASendLoadingEvent: Boolean);
begin
  FThreadPool.QueueWorkItem(
    procedure
    begin
      if ASendLoadingEvent then
        FDispatcher.DoDispatch(TLoadingEvent.Create(true));
      try
        AJob();
      finally
        if ASendLoadingEvent then
          FDispatcher.DoDispatch(TLoadingEvent.Create(false));
      end;
    end);
end;

constructor TLoadingEvent.Create(const AWait: Boolean);
begin
  inherited Create;
  FWait := AWait;
end;

procedure TLoadingEvent.SetWait(const Value: Boolean);
begin
  FWait := Value;
end;

end.
