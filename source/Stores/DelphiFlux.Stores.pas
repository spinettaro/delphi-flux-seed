unit DelphiFlux.Stores;

interface

uses
  Dispatcher.Flux, EventBus, BOs, DelphiFlux.Actions;

type

  TSeedStoreChanged = class(TObject)

  end;

  ISeedStore = interface
    ['{27BA124F-B6C3-48E5-BF7E-9C20603D377E}']
    function GetCurrentUser: TUserLogin;
  end;

  TBaseStore = class abstract(TInterfacedObject)
  protected
    FDispatcher: IFluxDispatcher;
    procedure EmitStoreChange; virtual; abstract;
  public
    constructor Create(const ADispatcher: IFluxDispatcher);
    [Subscribe(TThreadMode.Main)]
    procedure OnAction(const AAction: TFluxAction); virtual; abstract;
  end;

  TSeedStore = class(TBaseStore, ISeedStore)
  private
    FCurrentUser: TUserLogin;
  protected
    procedure EmitStoreChange; override;
  public
    destructor Destroy; override;
    function GetCurrentUser: TUserLogin;
    procedure OnAction(const AAction: TFluxAction); override;
  end;

function GetSeedStore(const ADispatcher: IFluxDispatcher): ISeedStore;

implementation

uses DelphiFlux.ActionCreators;

var
  SeedStore: TSeedStore;

  { TBaseStore }

constructor TBaseStore.Create(const ADispatcher: IFluxDispatcher);
begin
  inherited Create;
  FDispatcher := ADispatcher;
end;

{ TSeedStore }

function TSeedStore.GetCurrentUser: TUserLogin;
begin
  Result := FCurrentUser;
end;

procedure TSeedStore.OnAction(const AAction: TFluxAction);
begin

  try

    if (AAction.&Type = DelphiFlux.ActionCreators.ACTION_LOGIN) then
      FCurrentUser := (AAction.Data as TUserLogin);

    EmitStoreChange;

  finally
    AAction.Free;
  end;
end;

destructor TSeedStore.Destroy;
begin
  if Assigned(FCurrentUser) then
    FCurrentUser.Free;
  inherited;
end;

procedure TSeedStore.EmitStoreChange;
begin
  FDispatcher.DoDispatch(TSeedStoreChanged.Create());
end;

function GetSeedStore(const ADispatcher: IFluxDispatcher): ISeedStore;
begin
  if not Assigned(SeedStore) then
    SeedStore := TSeedStore.Create(ADispatcher);
  Result := SeedStore;
end;

end.
