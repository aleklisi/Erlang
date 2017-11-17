-module(weather).
-compile([export_all,debug_info]).

%Temprarure[C], result in kg/m^3
%TODO: add real dependency from:
%https://en.wikipedia.org/wiki/Density_of_air
%tablename: Effect of temperature on properties of air
get_air_density(AirTemperature) when AirTemperature > 35 -> 1.1455;
get_air_density(AirTemperature) when AirTemperature > 30 -> 1.1644;
get_air_density(AirTemperature) when AirTemperature > 25 -> 1.1839;
get_air_density(AirTemperature) when AirTemperature > 20 -> 1.2041;
get_air_density(AirTemperature) when AirTemperature > 15 -> 1.2250;
get_air_density(AirTemperature) when AirTemperature > 10 -> 1.2466;
get_air_density(AirTemperature) when AirTemperature > 5 -> 1.2922;
get_air_density(AirTemperature) when AirTemperature > 0 -> 1.3163;
get_air_density(AirTemperature) when AirTemperature > -5 -> 1.3413;
get_air_density(AirTemperature) when AirTemperature > -10 -> 1.3673;
get_air_density(AirTemperature) when AirTemperature > -15 -> 1.3943;
get_air_density(AirTemperature)-> 1.4224.
%TODO add real data input from file 
%result in [m/s]
get_wind_speed(_FileName) -> 10.

no_less_then_zero(Value) when Value > 0 -> Value;
no_less_then_zero(_) -> 0.
%TODO add real data input from file 
%result in [C]
get_air_temperature(_FileName) -> 20.

