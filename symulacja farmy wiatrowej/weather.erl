-module(weather).
-compile([export_all,debug_info]).


%TODO extract weather conditions to separate file

%Temprarure[C], result in kg/m^3
%TODO: add real dependency from:
%https://en.wikipedia.org/wiki/Density_of_air
%tablename: Effect of temperature on properties of air
get_air_density(_AirTemperature) -> 1.2250. 

%TODO add real data input from file 
%result in [m/s]
get_wind_speed(_FileName) -> 10.
%TODO add real data input from file 
%result in [C]
get_air_temperature(_FileName) -> 20.

