unit DragonsOfMugloar.DatabasebGenerator;

interface

uses
  System.Classes,
  System.Generics.Collections,
  DragonsOfMugloar.Service,
  DragonsOfMugloar.Game,
  DragonsOfMugloar.Weather,
  DragonsOfMugloar.Dragon,
  DragonsOfMugloar.Knight;

type
  TDatabaseGenerator = class
  private
    FService: TService;
    FLog: TStringList;
    FSet: TDictionary<string, TDragon>;
    FDb: TStringList;
    function FindVictory(const Game: TGame; const Weather: TWeather): TDragon;
    function GetOrderedKey(const Knight: TKnight): string;
    procedure LoadDb(const FileName: string);
  public
    constructor Create(const Service: TService);
    destructor Destroy; override;

    procedure Generate(const Weather: TWeather; const DbFileName, LogFileName: string);
  end;

implementation

uses
  System.StrUtils,
  System.SysUtils,
  System.Types,
  DragonsOfMugloar.GameResult;

{ TDatabaseGenerator }

constructor TDatabaseGenerator.Create(const Service: TService);
begin
  FService := Service;
  FSet := TDictionary<string, TDragon>.Create;
  FDb := TStringList.Create;
  FLog := TStringList.Create;
end;

destructor TDatabaseGenerator.Destroy;
begin
  FSet.Free;
  FLog.Free;
  FDb.Free;
  inherited;
end;

procedure TDatabaseGenerator.Generate(const Weather: TWeather;
  const DbFileName, LogFileName: string);
var
  Key: string;
  Game: TGame;
  GameWeather: TWeather;
  WinningDragon: TDragon;
  OrderedKey: string;
begin
  if FileExists(LogFileName) then
    FLog.LoadFromFile(LogFileName)
  else
    FLog.Clear;

  LoadDb(DbFileName);

  // There's 381 different possible combinations of knights
  // If we remove permutations of same attributes, then there are only 27 distinct sets of attributes
  while FSet.Count < 27 do
  begin
    Game := FService.GetGame;
    GameWeather := FService.GetWeather(Game.Id);
    if GameWeather <> Weather then
      Continue;

    OrderedKey := GetOrderedKey(Game.Knight);
    if FSet.ContainsKey(OrderedKey) then
      Continue;

    Key := Format('%d_%d_%d_%d', [Game.Knight.Attack, Game.Knight.Armor,
      Game.Knight.Agility, Game.Knight.Endurance, Integer(Weather)]);

    Writeln('Processing game: ', Key);
    WinningDragon := FindVictory(Game, Weather);
    FSet.Add(OrderedKey, WinningDragon);
    FDb.Add(Key + '=' + Format('%d_%d_%d_%d', [WinningDragon.ScaleThickness,
      WinningDragon.ClawSharpness, WinningDragon.WingStrength, WinningDragon.FireBreath]));

    // wasteful, but 891 http requests take far longer as size of the log will be at most 10MB
    FLog.SaveToFile(LogFileName);
    FDb.SaveToFile(DbFileName);
    Writeln('Total of ', FSet.Count, ' processed');
  end;
end;

function TDatabaseGenerator.GetOrderedKey(const Knight: TKnight): string;
var
  Attributes: TArray<Integer>;
begin
  Attributes := Knight.GetAttributesArray;
  TArray.Sort<Integer>(Attributes);
  Result := Format('%d_%d_%d_%d', [Attributes[3], Attributes[2], Attributes[1], Attributes[0]]);
end;

procedure TDatabaseGenerator.LoadDb(const FileName: string);
var
  Line: string;
  i: Integer;
  Key, Value: string;
  Attributes: TStringDynArray;
  Scale, Claw, Wing, Fire: Integer;
  Dragon: TDragon;
begin
  if not FileExists(FileName) then
  begin
    FSet.Clear;
    FDb.Clear;
    Exit;
  end;

  FDb.LoadFromFile(FileName);
  for Line in FDb do
  begin
    i := Pos('=', Line);
    Key := Copy(Line, 1, i - 1);
    Value := Copy(Line, i + 1);

    Attributes := SplitString(Value, '_');
    Scale := StrToInt(Attributes[0]);
    Claw := StrToInt(Attributes[1]);
    Wing := StrToInt(Attributes[2]);
    Fire := StrToInt(Attributes[3]);
    Dragon := TDragon.Create(Scale, Claw, Wing, Fire);
    FSet.Add(Key, Dragon);
  end;
end;

function TDatabaseGenerator.FindVictory(const Game: TGame; const Weather: TWeather): TDragon;
const
  AttributeMax = 10;
  AttributesTotal = 20;
var
  Scale, Claw, Wing, Fire: Integer;
  Dragon: TDragon;
  GameResult: TGameResult;
  StrBuilder: TStringBuilder;
begin
  StrBuilder := TStringBuilder.Create;
  try
    for Scale := 0 to AttributeMax do
    begin
      for Claw := 0 to AttributeMax do
      begin
        for Wing := 0 to AttributeMax do
        begin
          Fire := AttributesTotal - Scale - Claw - Wing;
          if (Fire < 0) or (Fire > AttributeMax) then
            Continue;

          Dragon := TDragon.Create(Scale, Claw, Wing, Fire);
          GameResult := FService.SendDragon(Game.Id, Dragon);

          StrBuilder.Clear;
          StrBuilder
            .Append(Game.Id).Append(#9)
            .Append(Game.Knight.Attack).Append(#9)
            .Append(Game.Knight.Armor).Append(#9)
            .Append(Game.Knight.Agility).Append(#9)
            .Append(Game.Knight.Endurance).Append(#9)
            .Append(Integer(Weather)).Append(#9)
            .Append(Scale).Append(#9)
            .Append(Claw).Append(#9)
            .Append(Wing).Append(#9)
            .Append(Fire).Append(#9)
            .Append(IfThen(GameResult.IsVictory, 'Victory', 'Defeat')).Append(#9)
            .Append(GameResult.Msg).Append(#9);
          FLog.Add(StrBuilder.ToString);

          if GameResult.IsVictory then
            Result := Dragon; // Don't stop because I want all combinations to be in the log
        end;
      end;
    end;
  finally
    StrBuilder.Free;
  end;
end;

end.
