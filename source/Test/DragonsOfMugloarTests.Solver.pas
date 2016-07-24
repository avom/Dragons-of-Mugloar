unit DragonsOfMugloarTests.Solver;

interface

uses
  TestFramework,
  DragonsOfMugloar.Solver,
  DragonsOfMugloar.Dragon;

type
  TTestSolver = class(TTestCase)
  private
    FSut: TSolver;
    procedure CheckDragon(const ExpectedScale, ExpectedClaw, ExpectedWing, ExpectedFire: Integer;
      const ActualDragon: TDragon);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure Solve_NormalWeather_SendsDragon;
    procedure Solve_Storm_NoDragon;
    procedure Solve_Rain_DragonWithMaxScalesAndClaws;
    procedure Solve_LongDry_DragonWithEqualAttributes;
    procedure Solve_Fog_DragonWithEqualAttributes;
    procedure Solve_NormalWeatherForUnknownKnight_ExceptionRaised;
  end;

implementation

uses
  DragonsOfMugloar.Knight,
  DragonsOfMugloar.Weather;

{ TTestSolver }

procedure TTestSolver.CheckDragon(const ExpectedScale, ExpectedClaw, ExpectedWing,
  ExpectedFire: Integer; const ActualDragon: TDragon);
begin
  CheckEquals(ExpectedScale, ActualDragon.ScaleThickness, 'Wrong scale thickness');
  CheckEquals(ExpectedClaw, ActualDragon.ClawSharpness, 'Wrong claw sharpness');
  CheckEquals(ExpectedWing, ActualDragon.WingStrength, 'Wrong wing strength');
  CheckEquals(ExpectedFire, ActualDragon.FireBreath, 'Wrong fire breath');
end;

procedure TTestSolver.SetUp;
begin
  inherited;
  FSut := TSolver.Create;
end;

procedure TTestSolver.Solve_Fog_DragonWithEqualAttributes;
var
  Knight: TKnight;
  ReturnValue: TSolver.TSolution;
begin
  Knight := TKnight.Create(5, 6, 1, 8);

  ReturnValue := FSut.Solve(Knight, wFog);
  CheckTrue(ReturnValue.SendDragon, 'A dragon should be sent');
  CheckDragon(5, 5, 5, 5, ReturnValue.Dragon);
end;

procedure TTestSolver.Solve_LongDry_DragonWithEqualAttributes;
var
  Knight: TKnight;
  ReturnValue: TSolver.TSolution;
begin
  Knight := TKnight.Create(5, 6, 1, 8);

  ReturnValue := FSut.Solve(Knight, wLongDry);
  CheckTrue(ReturnValue.SendDragon, 'A dragon should be sent');
  CheckDragon(5, 5, 5, 5, ReturnValue.Dragon);
end;

procedure TTestSolver.Solve_NormalWeatherForUnknownKnight_ExceptionRaised;
var
  Knight: TKnight;
begin
  Knight := TKnight.Create(9, 0, 5, 6); // 9 is unexpected

  StartExpectingException(EUnknownKnightException);
  FSut.Solve(Knight, wNormal);
  StopExpectingException('Knight with attribute 9 should not be handled');
end;

procedure TTestSolver.Solve_NormalWeather_SendsDragon;
var
  Knight: TKnight;
  ReturnValue: TSolver.TSolution;
begin
  Knight := TKnight.Create(5, 6, 1, 8);

  ReturnValue := FSut.Solve(Knight, wNormal);
  CheckTrue(ReturnValue.SendDragon, 'A dragon should be sent');
  CheckDragon(4, 6, 0, 10, ReturnValue.Dragon);
end;

procedure TTestSolver.Solve_Rain_DragonWithMaxScalesAndClaws;
var
  Knight: TKnight;
  ReturnValue: TSolver.TSolution;
begin
  Knight := TKnight.Create(5, 6, 1, 8);

  ReturnValue := FSut.Solve(Knight, wRain);
  CheckTrue(ReturnValue.SendDragon, 'A dragon should be sent');
  CheckDragon(10, 10, 0, 0, ReturnValue.Dragon);
end;

procedure TTestSolver.Solve_Storm_NoDragon;
var
  Knight: TKnight;
  ReturnValue: TSolver.TSolution;
begin
  Knight := TKnight.Create(5, 6, 1, 8);
  ReturnValue := FSut.Solve(Knight, wStorm);
  CheckFalse(ReturnValue.SendDragon, 'A dragon should be sent');
end;

procedure TTestSolver.TearDown;
begin
  FSut.Free;
  inherited;
end;

initialization

RegisterTest(TTestSolver.Suite);

end.
