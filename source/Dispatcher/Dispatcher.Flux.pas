unit Dispatcher.Flux;

interface

type

  IFluxDispatcher = interface
    ['{3F774806-34B6-4DA7-9F15-9A50B724CB66}']
    procedure &Register(const ASubscriber: TObject);
    procedure UnRegister(const ASubscriber: TObject);
    // AObj could be an event (store changed) or an action (user-view interaction)
    procedure DoDispatch(const AObj: TObject);
  end;

function GetDispatcher(): IFluxDispatcher;

implementation

uses
  EventBus, DelphiFlux.Actions;

var
  Dispatcher: IFluxDispatcher;

type

  TDispatcher = class(TInterfacedObject, IFluxDispatcher)
  private
    FBus: IEventBus;
  public
    constructor Create;
    procedure &Register(const ASubscriber: TObject);
    procedure UnRegister(const ASubscriber: TObject);
    procedure DoDispatch(const AObj: TObject);
  end;

  { TDispatcher }

constructor TDispatcher.Create;
begin
  inherited Create;
  FBus := GlobalEventBus;
end;

procedure TDispatcher.DoDispatch(const AObj: TObject);
begin
  FBus.Post(AObj);
end;

procedure TDispatcher.Register(const ASubscriber: TObject);
begin
  FBus.RegisterSubscriber(ASubscriber);
end;

procedure TDispatcher.UnRegister(const ASubscriber: TObject);
begin
  FBus.UnRegister(ASubscriber);
end;

function GetDispatcher(): IFluxDispatcher;
begin
  Result := Dispatcher;
end;

initialization

Dispatcher := TDispatcher.Create;

end.
