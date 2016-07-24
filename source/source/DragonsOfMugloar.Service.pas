unit DragonsOfMugloar.Service;

interface

uses
  IdHttp,
  System.SysUtils,
  DragonsOfMugloar.Dragon,
  DragonsOfMugloar.GameResult,
  DragonsOfMugloar.Game,
  DragonsOfMugloar.Weather;

type
  EServiceException = Exception;

  TService = class
  private const
    ServerUrl = 'http://www.dragonsofmugloar.com/';
  private
    FHttp: TIdHTTP;
    function HttpGet(const Url: string): string;
  public
    constructor Create;
    destructor Destroy; override;

    function GetGame: TGame;
    function GetWeather(GameId: Int64): TWeather;
    function SendDragon(GameId: Int64; const Dragon: TDragon): TGameResult;
    function SendNothing(GameId: Int64): TGameResult;
  end;

implementation

uses
  System.Classes,
  Xml.XMLIntf,
  XmlDoc,
  superobject,
  DragonsOfMugloar.Knight;

{ TService }

constructor TService.Create;
begin
  FHttp := TIdHTTP.Create(nil);
end;

destructor TService.Destroy;
begin
  FHttp.Free;
  inherited;
end;

function TService.GetGame: TGame;
var
  Response: string;
  Obj: ISuperObject;
  Knight: TKnight;
begin
  Response := HttpGet(ServerUrl + 'api/game');
  Obj := SO(Response);
  Knight := TKnight.Create(
    Obj.I['knight.attack'],
    Obj.I['knight.armor'],
    Obj.I['knight.agility'],
    Obj.I['knight.endurance']);
  Result := TGame.Create(Obj.I['gameId'], Knight);
end;

function TService.GetWeather(GameId: Int64): TWeather;
var
  Response: string;
  Xml: IXmlDocument;
  Code: string;
begin
  Response := HttpGet(ServerUrl + 'weather/api/report/' + IntToStr(GameId));
  Xml := TXMLDocument.Create(nil);
  Xml.LoadFromXML(Response);
  Code := Xml.Node.ChildNodes['report'].ChildValues['code'];
  if Code = 'NMR' then
    Result := wNormal
  else if Code = 'SRO' then
    Result := wStorm
  else if Code = 'HVA' then
    Result := wRain
  else if Code = 'T E' then
    Result := wLongDry
  else if Code = 'FUNDEFINEDG' then
    Result := wFog
  else
    raise EServiceException.Create('Unknown weather code');
end;

function TService.HttpGet(const Url: string): string;
var
  Stream: TStringStream;
begin
  Stream := TStringStream.Create;
  try
    FHttp.Get(Url, Stream);
    Result := Stream.DataString;
  finally
    Stream.Free;
  end;
end;

function TService.SendDragon(GameId: Int64; const Dragon: TDragon): TGameResult;
var
  Stream: TStringStream;
  DragonJson: ISuperObject;
  ResponseJson: ISuperObject;
  Response: string;
begin
  Stream := TStringStream.Create;
  try
    DragonJson := SO;
    DragonJson.I['dragon.scaleThickness'] := Dragon.ScaleThickness;
    DragonJson.I['dragon.clawSharpness'] := Dragon.ClawSharpness;
    DragonJson.I['dragon.wingStrength'] := Dragon.WingStrength;
    DragonJson.I['dragon.fireBreath'] := Dragon.FireBreath;
    Stream.WriteString(DragonJson.AsJSon);
    FHttp.Request.ContentType := 'application/json';
    Response := FHttp.Put(ServerUrl + 'api/game/' + IntToStr(GameId) + '/solution', Stream);
    ResponseJson := SO(Response);
    Result := TGameResult.Create(ResponseJson.S['status'], ResponseJson.S['message']);
  finally
    Stream.Free;
  end;
end;

function TService.SendNothing(GameId: Int64): TGameResult;
var
  ResponseJson: ISuperObject;
  Response: string;
begin
  Response := FHttp.Put(ServerUrl + 'api/game/' + IntToStr(GameId) + '/solution', nil);
  ResponseJson := SO(Response);
  Result := TGameResult.Create(ResponseJson.S['status'], ResponseJson.S['message']);
end;

end.
