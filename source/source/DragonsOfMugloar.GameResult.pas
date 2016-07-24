unit DragonsOfMugloar.GameResult;

interface

type
  TGameResult = record
  private
    FMsg: string;
    FStatus: string;
    function GetIsVictory: Boolean;
  public
    constructor Create(const Status, Msg: string);

    property IsVictory: Boolean read GetIsVictory;
    property Msg: string read FMsg;
    property Status: string read FStatus;
  end;

implementation

{ TGameResult }

constructor TGameResult.Create(const Status, Msg: string);
begin
  FStatus := Status;
  FMsg := Msg;
end;

function TGameResult.GetIsVictory: Boolean;
begin
  Result := FStatus = 'Victory';
end;

end.
