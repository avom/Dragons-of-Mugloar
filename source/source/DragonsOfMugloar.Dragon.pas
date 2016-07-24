unit DragonsOfMugloar.Dragon;

interface

type
  TDragon = record
  private
    FFireBreath: Integer;
    FScaleThickness: Integer;
    FClawSharpness: Integer;
    FWingStrength: Integer;
  public
    constructor Create(ScaleThickness, ClawSharpness, WingStrength,
      FireBreath: Integer);

    function ToString: string;

    property ScaleThickness: Integer read FScaleThickness;
    property ClawSharpness: Integer read FClawSharpness;
    property WingStrength: Integer read FWingStrength;
    property FireBreath: Integer read FFireBreath;
  end;

implementation

uses
  System.SysUtils;

{ TDragon }

constructor TDragon.Create(ScaleThickness, ClawSharpness, WingStrength,
  FireBreath: Integer);
begin
  FScaleThickness := ScaleThickness;
  FClawSharpness := ClawSharpness;
  FWingStrength := WingStrength;
  FFireBreath := FireBreath;
end;

function TDragon.ToString: string;
begin
  Result := Format('Scale = %d, Claw = %d, Wing = %d, Fire = %d',
    [ScaleThickness, ClawSharpness, WingStrength, FireBreath]);
end;

end.
