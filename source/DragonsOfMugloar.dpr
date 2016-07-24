program DragonsOfMugloar;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  DragonsOfMugloar.Knight in 'source\DragonsOfMugloar.Knight.pas',
  DragonsOfMugloar.Weather in 'source\DragonsOfMugloar.Weather.pas',
  DragonsOfMugloar.Service in 'source\DragonsOfMugloar.Service.pas',
  DragonsOfMugloar.Game in 'source\DragonsOfMugloar.Game.pas',
  Winapi.ActiveX,
  DragonsOfMugloar.Dragon in 'source\DragonsOfMugloar.Dragon.pas',
  DragonsOfMugloar.DatabasebGenerator in 'source\DragonsOfMugloar.DatabasebGenerator.pas',
  DragonsOfMugloar.GameResult in 'source\DragonsOfMugloar.GameResult.pas',
  DragonsOfMugloar.Solver in 'source\DragonsOfMugloar.Solver.pas',
  DragonsOfMugloar.Player in 'source\DragonsOfMugloar.Player.pas';

function ParseCmdLineArgs(out NumOfPlays: Integer): Boolean;
begin
  NumOfPlays := StrToIntDef(ParamStr(1), 0);
  Result := NumOfPlays > 0;
  if not Result then
    Writeln('USAGE: ', ParamStr(0), ' <Number of plays>');
end;

var
  Service: TService;
  Solver: TSolver;
  Player: TPlayer;
  NumOfPlays: Integer;
  WinRate: Double;
begin
  if not ParseCmdLineArgs({ out } NumOfPlays) then
    Exit;

  CoInitialize(nil);
  Service := nil;
  Solver := nil;
  Player := nil;
  try
    Service := TService.Create;
    Solver := TSolver.Create;
    Player := TPlayer.Create(Service, Solver);

    WinRate := Player.Play(NumOfPlays);
    Writeln('Win rate: ', WinRate * 100:0:1, ' %');
  finally
    Player.Free;
    Solver.Free;
    Service.Free;
    CoUninitialize;
  end;

end.
