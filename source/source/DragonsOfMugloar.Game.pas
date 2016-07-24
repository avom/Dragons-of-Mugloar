unit DragonsOfMugloar.Game;

interface

uses
  DragonsOfMugloar.Knight;

type
  TGame = record
  private
    FKnight: TKnight;
    FId: Int64;
  public
    constructor Create(Id: Int64; Knight: TKnight);

    property Id: Int64 read FId;
    property Knight: TKnight read FKnight;
  end;

implementation

{ TGame }

constructor TGame.Create(Id: Int64; Knight: TKnight);
begin
  FId := Id;
  FKnight := Knight;
end;

end.
