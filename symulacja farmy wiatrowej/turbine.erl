-module(turbine).
-compile([export_all,debug_info]).
-import(weather,[get_air_density/1,get_wind_speed/1,get_air_temperature/1]).

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

run(State,Radius,Efficiency,WeatherModulePID) ->
    AirTemperature = weather:get_air_temperature(WeatherModulePID),
    AirDencity = weather:get_air_density(AirTemperature),
    WindSpeed = weather:get_wind_speed(WeatherModulePID),
    TurbineArea = get_wind_turbine_area(Radius),
    get_accual_power(State,WindSpeed,TurbineArea,AirDencity,Efficiency).

turbine(State,Radius,Efficiency,PowerPlantPID,WeatherModulePID) ->
    receive
        {newState,NewState} -> 
            io:fwrite("Turbine ~p changed state from ~p to ~p\n",[self(),State,NewState]),
            turbine(NewState,Radius,Efficiency,PowerPlantPID,WeatherModulePID);
        {sendPowerToPlant,StatisticsCollector,Step} -> 
            Power = run(State,Radius,Efficiency,WeatherModulePID),
            io:fwrite("Turbine ~p sends ~p of Power to ~p in Step ~p\n",[self(),Power,PowerPlantPID,Step]),            
            StatisticsCollector ! {Power,self(),Step};
        endOfSymulation ->
            io:fwrite("Turbine: End of Symulation ~p\n",[self()]),
            exit("End of Symulation\n");
        Message -> 
            io:fwrite("Turbine ~p SPAM ~p\n",[self(),Message])
    end,
    turbine(State,Radius,Efficiency,PowerPlantPID,WeatherModulePID).
