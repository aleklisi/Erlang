-module(weather).
-compile([export_all,debug_info]).

%TODO add accual implemantation
read_data_from_file(_FileName) -> [4,5,4,6,7].

add_randomness_element(Range) -> 
    {Min,Max} = Range,
    Diff = Max - Min,
    rand:uniform() * Diff + Min.

no_less_then_zero(Value) when Value > 0 -> Value;
no_less_then_zero(_) -> 0.

%Temprarure[C], result in kg/m^3
%based on real dependency from:
%https://en.wikipedia.org/wiki/Density_of_air
%tablename: Effect of temperature on properties of air
air_density_table(AirTemperature) when AirTemperature > 35 -> 1.1455;
air_density_table(AirTemperature) when AirTemperature > 30 -> 1.1644;
air_density_table(AirTemperature) when AirTemperature > 25 -> 1.1839;
air_density_table(AirTemperature) when AirTemperature > 20 -> 1.2041;
air_density_table(AirTemperature) when AirTemperature > 15 -> 1.2250;
air_density_table(AirTemperature) when AirTemperature > 10 -> 1.2466;
air_density_table(AirTemperature) when AirTemperature > 5 -> 1.2922;
air_density_table(AirTemperature) when AirTemperature > 0 -> 1.3163;
air_density_table(AirTemperature) when AirTemperature > -5 -> 1.3413;
air_density_table(AirTemperature) when AirTemperature > -10 -> 1.3673;
air_density_table(AirTemperature) when AirTemperature > -15 -> 1.3943;
air_density_table(_)-> 1.4224.

get_air_density(AirTemperature) ->
    Pom = AirTemperature + add_randomness_element({-4,4}),
    air_density_table(Pom).
%TODO add real data input from file 
%Windiness[%], result in [m/s]
get_wind_speed(_FileName) -> 
    Windiness = get_windiness(tODO),
    WindSpeed = 10,
    Diff = WindSpeed * Windiness / 100,
    no_less_then_zero(WindSpeed + add_randomness_element({-Diff, Diff})).

get_windiness(_FileName) -> 10.

%TODO add real data input from file 
%result in [C]
get_air_temperature(_FileName) -> 20.

