unit DragonsOfMugloarTests.Knight;

interface

uses
  TestFramework;

type
  TTestKnight = class(TTestCase)
  published
    procedure GetAttributesArray;
    procedure GetOrderAttributeIndices;
    procedure GetOrderedAttributes;
    procedure GetAttributeValueByRank_Distinct;
    procedure GetAttributeValueByRank_Duplicates;
  end;

implementation

uses
  DragonsOfMugloar.Knight;

{ TestKnight }

procedure TTestKnight.GetOrderAttributeIndices;
var
  Sut: TKnight;
  ReturnValue: TArray<Integer>;
begin
  Sut := TKnight.Create(1, 3, 10, 7);
  ReturnValue := Sut.GetOrderAttributeIndices;
  CheckEquals(2, ReturnValue[0], 'Invalid index for 10');
  CheckEquals(3, ReturnValue[1], 'Invalid rank for 7');
  CheckEquals(1, ReturnValue[2], 'Invalid rank for 3');
  CheckEquals(0, ReturnValue[3], 'Invalid rank for 1');
end;

procedure TTestKnight.GetOrderedAttributes;
var
  Sut: TKnight;
  ReturnValue: TArray<Integer>;
begin
  Sut := TKnight.Create(1, 3, 10, 7);
  ReturnValue := Sut.GetOrderedAttributes;
  CheckEquals(10, ReturnValue[0], 'Invalid max attribute');
  CheckEquals(7, ReturnValue[1], 'Invalid second highest attribute');
  CheckEquals(3, ReturnValue[2], 'Invalid third highest attribute');
  CheckEquals(1, ReturnValue[3], 'Invalid lowest attribute');
end;

procedure TTestKnight.GetAttributesArray;
var
  Sut: TKnight;
  ReturnValue: TArray<Integer>;
begin
  Sut := TKnight.Create(1, 2, 3, 4);
  ReturnValue := Sut.GetAttributesArray;
  CheckEquals(1, ReturnValue[0], 'Invalid attack');
  CheckEquals(2, ReturnValue[1], 'Invalid armor');
  CheckEquals(3, ReturnValue[2], 'Invalid agility');
  CheckEquals(4, ReturnValue[3], 'Invalid endurance');
end;

procedure TTestKnight.GetAttributeValueByRank_Distinct;
var
  Sut: TKnight;
  ReturnValue: Integer;
begin
  Sut := TKnight.Create(1, 4, 10, 7);
  ReturnValue := Sut.GetAttributeValueByRank(2);
  CheckEquals(4, ReturnValue);
end;

procedure TTestKnight.GetAttributeValueByRank_Duplicates;
var
  Sut: TKnight;
  ReturnValue1, ReturnValue2: Integer;
begin
  Sut := TKnight.Create(1, 4, 10, 4);
  ReturnValue1 := Sut.GetAttributeValueByRank(1);
  CheckEquals(4, ReturnValue1, 'Wrong value for rank 1');
  ReturnValue2 := Sut.GetAttributeValueByRank(2);
  CheckEquals(4, ReturnValue2, 'Wrong value for rank 2');
end;

initialization

RegisterTest(TTestKnight.Suite);

end.
