-module(turbine).
-compile([export_all,debug_info]).

run("Endurance E-4160 Wind Turbine",State,_,_,WeatherModulePID,Timebase) -> 
    exampleTurbine:run(State,WeatherModulePID,Timebase);
run("theoreticalTurbine",State,Radius,Efficiency,WeatherModulePID,Timebase) -> 
    theoreticalTurbine:run(State,Radius,Efficiency,WeatherModulePID,Timebase);
run(_,_,_,_,_,_) -> erlang:error("model of your Turbine is not implemented yet/n").

turbine(Model,State,Radius,Efficiency,Timebase,PowerPlantPID,WeatherModulePID) ->
    receive
        {newState,NewState} -> 
            io:fwrite("Turbine ~p model ~p changed state from ~p to ~p\n",[self(),Model,State,NewState]),
            turbine(Model,NewState,Radius,Efficiency,Timebase,PowerPlantPID,WeatherModulePID);
        {sendPowerToPlant,StatisticsCollector,Step} -> 
            Power = run(Model,State,Radius,Efficiency,WeatherModulePID,Timebase),
            io:fwrite("Turbine ~p model ~p sends ~p of kWh to ~p in Step ~p\n",
                [self(),Model,Power,PowerPlantPID,Step]),            
            StatisticsCollector ! {Power,self(),Step};
        endOfSymulation ->
            io:fwrite("Turbine ~p model ~p : End of Symulation\n",[self(),Model]),
            exit("End of Symulation\n");
        Message -> 
            io:fwrite("Turbine ~p model ~p SPAM ~p\n",[self(),Model,Message])
    end,
    turbine(Model,State,Radius,Efficiency,Timebase,PowerPlantPID,WeatherModulePID).
