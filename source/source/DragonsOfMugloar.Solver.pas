unit DragonsOfMugloar.Solver;

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  DragonsOfMugloar.Dragon,
  DragonsOfMugloar.Knight,
  DragonsOfMugloar.Weather;

type
  EUnknownKnightException = class(Exception);

  TSolver = class
  public type
    TSolution = record
    private
      FDragon: TDragon;
      FSendDragon: Boolean;
    public
      property SendDragon: Boolean read FSendDragon;
      property Dragon: TDragon read FDragon;
    end;
  private
    function SameArray(const Array1, Array2: array of Integer): Boolean;

    function SolveForNormalWeather(const Knight: TKnight): TSolution;
    function SolveForStorm(const Knight: TKnight): TSolution;
    function SolveForRain(const Knight: TKnight): TSolution;
    function SolveForLongDry(const Knight: TKnight): TSolution;
    function SolveForFog(const Knight: TKnight): TSolution;
  public
    function Solve(const Knight: TKnight; const Weather: TWeather): TSolution;
  end;

implementation

{ TSolver }

function TSolver.SameArray(const Array1, Array2: array of Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  if Length(Array1) <> Length(Array2) then
    Exit;

  for i := Low(Array1) to High(Array2) do
  begin
    if Array1[i] <> Array2[i] then
      Exit;
  end;

  Result := True;
end;

function TSolver.Solve(const Knight: TKnight; const Weather: TWeather): TSolution;
begin
  case Weather of
    wNormal: Result := SolveForNormalWeather(Knight);
    wStorm: Result := SolveForStorm(Knight);
    wRain: Result := SolveForRain(Knight);
    wLongDry: Result := SolveForLongDry(Knight);
    wFog: Result := SolveForFog(Knight);
    else
      raise EArgumentOutOfRangeException.CreateFmt('Unknown value for weather', [Integer(Weather)]);
  end;
end;

function TSolver.SolveForFog(const Knight: TKnight): TSolution;
begin
  Result.FSendDragon := True;
  Result.FDragon := TDragon.Create(5, 5, 5, 5);
end;

function TSolver.SolveForLongDry(const Knight: TKnight): TSolution;
begin
  Result.FSendDragon := True;
  Result.FDragon := TDragon.Create(5, 5, 5, 5);
end;

function TSolver.SolveForNormalWeather(const Knight: TKnight): TSolution;
const
  Mappings: array [0 .. 26, 0 .. 1, 0 .. 3] of Integer = (
    ((5, 5, 5, 5), (10, 6, 2, 2)),
    ((6, 5, 5, 4), (10, 5, 3, 2)),
    ((6, 6, 4, 4), (10, 6, 2, 2)),
    ((6, 6, 5, 3), (10, 3, 3, 4)),
    ((6, 6, 6, 2), (10, 6, 3, 1)),
    ((7, 5, 4, 4), (10, 6, 2, 2)),
    ((7, 5, 5, 3), (9, 3, 3, 5)),
    ((7, 6, 4, 3), (9, 6, 3, 2)),
    ((7, 6, 5, 2), (9, 4, 6, 1)),
    ((7, 6, 6, 1), (9, 7, 4, 0)),
    ((7, 7, 3, 3), (10, 6, 2, 2)),
    ((7, 7, 4, 2), (10, 7, 2, 1)),
    ((7, 7, 5, 1), (10, 4, 6, 0)),
    ((7, 7, 6, 0), (10, 6, 4, 0)),
    ((8, 4, 4, 4), (10, 4, 3, 3)),
    ((8, 5, 4, 3), (10, 4, 4, 2)),
    ((8, 5, 5, 2), (10, 4, 4, 2)),
    ((8, 6, 3, 3), (10, 6, 2, 2)),
    ((8, 6, 4, 2), (10, 4, 5, 1)),
    ((8, 6, 5, 1), (10, 6, 4, 0)),
    ((8, 6, 6, 0), (10, 6, 4, 0)),
    ((8, 7, 3, 2), (10, 5, 4, 1)),
    ((8, 7, 4, 1), (10, 7, 3, 0)),
    ((8, 7, 5, 0), (10, 5, 5, 0)),
    ((8, 8, 2, 2), (10, 8, 1, 1)),
    ((8, 8, 3, 1), (10, 6, 4, 0)),
    ((8, 8, 4, 0), (10, 7, 3, 0)));
var
  Attributes: TArray<Integer>;
  Indices: TArray<Integer>;
  i, j: Integer;
  Dragon: TArray<Integer>;
begin
  Result.FSendDragon := True;
  Attributes := Knight.GetOrderedAttributes;
  for i := Low(Mappings) to High(Mappings) do
  begin
    if SameArray(Attributes, Mappings[i, 0]) then
    begin
      Indices := Knight.GetOrderAttributeIndices;
      SetLength(Dragon, Length(Attributes));
      for j := Low(Dragon) to High(Dragon) do
        Dragon[Indices[j]] := Mappings[i, 1, j];
      Result.FDragon := TDragon.Create(Dragon[0], Dragon[1], Dragon[2], Dragon[3]);
      Exit;
    end;
  end;

  raise EUnknownKnightException.Create('Unrecognized knight');
end;

function TSolver.SolveForRain(const Knight: TKnight): TSolution;
begin
  Result.FSendDragon := True;
  Result.FDragon := TDragon.Create(10, 10, 0, 0);
end;

function TSolver.SolveForStorm(const Knight: TKnight): TSolution;
begin
  Result.FSendDragon := False;
end;

end.
