unit DragonsOfMugloar.Weather;

interface

type
  TWeather = (wNormal, wStorm, wRain, wLongDry, wFog);

function WeatherToStr(const Weather: TWeather): string;

implementation

uses
  System.SysUtils;

function WeatherToStr(const Weather: TWeather): string;
begin
  case Weather of
    wNormal: Result := 'Normal';
    wStorm: Result := 'Storm';
    wRain: Result := 'Rain';
    wLongDry: Result := 'Long try';
    wFog: Result := 'Fog';
    else
      raise EArgumentOutOfRangeException.CreateFmt('Unknown weather: ', [Integer(Weather)]);
  end;
end;

end.
