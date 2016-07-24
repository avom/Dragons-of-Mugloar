unit DragonsOfMugloar.Player;

interface

uses
  DragonsOfMugloar.Service,
  DragonsOfMugloar.Solver;

type
  TPlayer = class
  private
    FService: TService;
    FSolver: TSolver;
  public
    constructor Create(const Service: TService; const Solver: TSolver);

    function Play(const NumOfPlays: Integer): Double;
  end;

implementation

uses
  DragonsOfMugloar.Game,
  DragonsOfMugloar.Dragon,
  DragonsOfMugloar.Weather,
  DragonsOfMugloar.GameResult;

{ TPlayer }

constructor TPlayer.Create(const Service: TService; const Solver: TSolver);
begin
  FService := Service;
  FSolver := Solver;
end;

function TPlayer.Play(const NumOfPlays: Integer): Double;
var
  i: Integer;
  Game: TGame;
  Weather: TWeather;
  Solution: TSolver.TSolution;
  GameResult: TGameResult;
  NumOfWins: Integer;
begin
  NumOfWins := 0;
  for i := 1 to NumOfPlays do
  begin
    Game := FService.GetGame;
    Weather := FService.GetWeather(Game.Id);
    Solution := FSolver.Solve(Game.Knight, Weather);
    if Solution.SendDragon then
      GameResult := FService.SendDragon(Game.Id, Solution.Dragon)
    else
      GameResult := FService.SendNothing(Game.Id);

    if GameResult.IsVictory then
      Inc(NumOfWins);

    Write('Game ', Game.Id, '. Knight ', Game.Knight.ToString, '. Weather ',
      WeatherToStr(Weather), '. ');
    if Solution.SendDragon then
      Write('Dragon ', Solution.Dragon.ToString, '. ')
    else
      Write('No dragon sent. ');
    Writeln(GameResult.Msg, '. ', GameResult.Status);
  end;
  Result := NumOfWins / NumOfPlays;
end;

end.
