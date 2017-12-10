-module(turbine).
-compile([export_all,debug_info]).
-import(weather,[get_air_density/1,get_wind_speed/1,get_air_temperature/1]).
-import(exampleTurbine,[run/2]).
-import(theoreticalTurbine,[run/4]).

%TODO add implementation of real turbine 
run("Endurance E-4160 Wind Turbine",State,_,_,WeatherModulePID) -> 
    exampleTurbine:run(State,WeatherModulePID);
run("theoreticalTurbine",State,Radius,Efficiency,WeatherModulePID) -> 
    theoreticalTurbine:run(State,Radius,Efficiency,WeatherModulePID);
run(_,_,_,_,_) -> erlang:error("model of your Turbine is not implemented yet/n").


turbine(Model,State,Radius,Efficiency,PowerPlantPID,WeatherModulePID) ->
    receive
        {newState,NewState} -> 
            io:fwrite("Turbine ~p model ~p changed state from ~p to ~p\n",[self(),Model,State,NewState]),
            turbine(Model,NewState,Radius,Efficiency,PowerPlantPID,WeatherModulePID);
        {sendPowerToPlant,StatisticsCollector,Step} -> 
            Power = run(Model,State,Radius,Efficiency,WeatherModulePID),
            io:fwrite("Turbine ~p model ~p sends ~p of Power to ~p in Step ~p\n",[self(),Model,Power,PowerPlantPID,Step]),            
            StatisticsCollector ! {Power,self(),Step};
        endOfSymulation ->
            io:fwrite("Turbine ~p model ~p : End of Symulation\n",[self(),Model]),
            exit("End of Symulation\n");
        Message -> 
            io:fwrite("Turbine ~p model ~p SPAM ~p\n",[self(),Model,Message])
    end,
    turbine(Model,State,Radius,Efficiency,PowerPlantPID,WeatherModulePID).
