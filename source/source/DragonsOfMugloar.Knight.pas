unit DragonsOfMugloar.Knight;

interface

type
  TKnight = record
  private
    FArmor: Integer;
    FAgility: Integer;
    FEndurance: Integer;
    FAttack: Integer;
  public
    constructor Create(Attack, Armor, Agility, Endurance: Integer);

    function GetAttributesArray: TArray<Integer>;
    function GetOrderAttributeIndices: TArray<Integer>;
    function GetOrderedAttributes: TArray<Integer>;
    function GetAttributeValueByRank(const Rank: Integer): Integer;

    function ToString: string;

    property Attack: Integer read FAttack;
    property Armor: Integer read FArmor;
    property Agility: Integer read FAgility;
    property Endurance: Integer read FEndurance;
  end;

implementation

uses
  System.Generics.Collections,
  System.Generics.Defaults,
  System.SysUtils;

{ TKnight }

function TKnight.GetOrderAttributeIndices: TArray<Integer>;
var
  i: Integer;
  Attributes: TArray<Integer>;
  Index: TArray<Integer>;
begin
  SetLength(Index, 4);
  for i := 0 to High(Index) do
    Index[i] := i;

  Attributes := GetAttributesArray;
  TArray.Sort<Integer>(Index, TComparer<Integer>.Construct(
    function (const Item1, Item2: Integer): Integer
    begin
      Result := Attributes[Item2] - Attributes[Item1];
    end
  ));

  Result := Index;
end;

function TKnight.GetOrderedAttributes: TArray<Integer>;
var
  Attributes: TArray<Integer>;
  Indices: TArray<Integer>;
  i: Integer;
begin
  Attributes := GetAttributesArray;
  Indices := GetOrderAttributeIndices;
  SetLength(Result, Length(Attributes));
  for i := Low(Attributes) to High(Attributes) do
    Result[i] := Attributes[Indices[i]];
end;

function TKnight.ToString: string;
begin
  Result := Format('Attack = %d, Armor = %d, Agility = %d, Endurance = %d',
    [Attack, Armor, Agility, Endurance]);
end;

function TKnight.GetAttributesArray: TArray<Integer>;
begin
  // Array is very small and is easy cheap to build so we don'tvto cache it
  SetLength(Result, 4);
  Result[0] := Attack;
  Result[1] := Armor;
  Result[2] := Agility;
  Result[3] := Endurance;
end;

function TKnight.GetAttributeValueByRank(const Rank: Integer): Integer;
var
  Attributes: TArray<Integer>;
begin
  Attributes := GetAttributesArray;
  TArray.Sort<Integer>(Attributes); // can only sort ascendingly
  Result := Attributes[High(Attributes) - Rank];
end;

constructor TKnight.Create(Attack, Armor, Agility, Endurance: Integer);
begin
  FAttack := Attack;
  FArmor := Armor;
  FAgility := Agility;
  FEndurance := Endurance;
end;

end.
