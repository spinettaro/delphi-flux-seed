unit BOs;

interface

type

  TUserLogin = class(TObject)
  private
    FPassword: String;
    FUsername: String;
    procedure SetPassword(const Value: String);
    procedure SetUsername(const Value: String);
  public
    constructor Create(const AUsername, APassword: String);
    property Username: String read FUsername write SetUsername;
    property Password: String read FPassword write SetPassword;

  end;

implementation

{ TUserLogin }

constructor TUserLogin.Create(const AUsername, APassword: String);
begin
  inherited Create;
  FUsername := AUsername;
  FPassword := APassword;
end;

procedure TUserLogin.SetPassword(const Value: String);
begin
  FPassword := Value;
end;

procedure TUserLogin.SetUsername(const Value: String);
begin
  FUsername := Value;
end;

end.
