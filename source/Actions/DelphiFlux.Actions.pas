unit DelphiFlux.Actions;

interface

uses
  System.SysUtils, Dispatcher.Flux;

type

  TFluxAction = class(TObject)
  private
    FType: String;
    FData: TObject;
    FDataOwner: Boolean;
    procedure SetData(const Value: TObject);
    procedure SetType(const Value: String);
    procedure SetDataOwner(const Value: Boolean);
  public
    constructor Create; overload;
    constructor Create(const AType: String; const AData: TObject;
      const ADataOwner: Boolean = false); overload;
    destructor Destroy; override;
    property &Type: String read FType write SetType;
    property Data: TObject read FData write SetData;
    property DataOwner: Boolean read FDataOwner write SetDataOwner;
  end;

implementation

{ TFluxAction }

constructor TFluxAction.Create(const AType: String; const AData: TObject;
  const ADataOwner: Boolean);
begin
  inherited Create;
  FType := AType;
  FData := AData;
  FDataOwner := ADataOwner;
end;

destructor TFluxAction.Destroy;
begin
  if FDataOwner and Assigned(FData) then
    FData.Free;
  inherited;
end;

constructor TFluxAction.Create;
begin
  Create('', nil);
end;

procedure TFluxAction.SetData(const Value: TObject);
begin
  FData := Value;
end;

procedure TFluxAction.SetDataOwner(const Value: Boolean);
begin
  FDataOwner := Value;
end;

procedure TFluxAction.SetType(const Value: String);
begin
  FType := Value;
end;

end.
