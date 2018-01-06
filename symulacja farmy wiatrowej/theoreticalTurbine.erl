-module(theoreticalTurbine).
-compile([export_all,debug_info]).

run(State,Radius,Efficiency,WeatherModulePID,Timebase) ->
    AirTemperature = weather:get_air_temperature(WeatherModulePID),
    AirDencity = weather:get_air_density(AirTemperature),
    WindSpeed = weather:get_wind_speed(WeatherModulePID),
    TurbineArea = get_wind_turbine_area(Radius),
    Timebase * get_accual_power(State,WindSpeed,TurbineArea,AirDencity,Efficiency).

%Radius[m], result in m^2
get_wind_turbine_area(Radius) -> math:pi() * Radius * Radius.

%WindSpeed[m/s],TurbineArea[m^2],AirDencity[kg/m^3],Efficiency[%], result in W
get_teoretical_power(notworking,_,_,_) -> 0;
get_teoretical_power(working,WindSpeed,TurbineArea,AirDencity) ->
    0.5 * TurbineArea * AirDencity * WindSpeed * WindSpeed * WindSpeed.

%WindSpeed[m/s],Power[W],TurbineArea[m^2],AirDencity[kg/m^3],Efficiency[%] result is in W
get_accual_power(notworking,_,_,_,_) -> 0;
get_accual_power(State,WindSpeed,TurbineArea,AirDencity,Efficiency) -> 
    TurbinePower = get_teoretical_power(State,WindSpeed,TurbineArea,AirDencity),
    TurbinePower * Efficiency / 100.
