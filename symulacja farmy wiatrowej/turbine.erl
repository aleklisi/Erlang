-module(turbine).
-compile([export_all,debug_info]).

%cd("C:/Users/sebac/Documents/Erlang/Programs/Erlang/symulacja farmy wiatrowej").

%Radius[m], result in m^2
get_wind_turbine_area(Radius) -> math:pi() * Radius * Radius.

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

%WindSpeed[m/s],TurbineArea[m^2],AirDencity[kg/m^3],Efficiency[%], result in W
get_teoretical_power(notworking,_,_,_) -> 0;
get_teoretical_power(working,WindSpeed,TurbineArea,AirDencity) ->
    0.5 * TurbineArea * AirDencity * WindSpeed * WindSpeed * WindSpeed.

%WindSpeed[m/s],Power[W],TurbineArea[m^2],AirDencity[kg/m^3],Efficiency[%] result is in W
get_accual_power(notworking,_,_,_,_) -> 0;
get_accual_power(State,WindSpeed,TurbineArea,AirDencity,Efficiency) -> 
    TurbinePower = get_teoretical_power(State,WindSpeed,TurbineArea,AirDencity),
    TurbinePower * Efficiency / 100.

run(State,Radius,Efficiency) ->
    AirTemperature = get_air_temperature(airtempfile),
    AirDencity = get_air_density(AirTemperature),
    WindSpeed = get_wind_speed(windspeedfile),
    TurbineArea = get_wind_turbine_area(Radius),
    get_accual_power(State,WindSpeed,TurbineArea,AirDencity,Efficiency).

turbine(State,Radius,Efficiency,PowerPlantPID) ->
    receive
        {newState,NewState} -> 
            turbine(NewState,Radius,Efficiency,PowerPlantPID);
        {sendPowerToPlant,Step} -> 
            Power = run(State,Radius,Efficiency),
            PowerPlantPID ! {Power,self(),Step};
        endOfSymulation ->
            exit("End of Symulation");
        _ -> ok
    end,
    turbine(State,Radius,Efficiency,PowerPlantPID).
