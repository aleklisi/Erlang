-module(turbine).
-compile([export_all]).

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
            {Power,WindSpeed} = run(Model,State,Radius,Efficiency,WeatherModulePID,Timebase),
            io:fwrite("Turbine ~p model ~p sends ~p of kWh to ~p in Step ~p\n",
                [self(),Model,Power,PowerPlantPID,Step]),
                write_to_file(pom(Step,Power,self(),WindSpeed)),
            StatisticsCollector ! {Power,self(),Step};
        endOfSymulation ->
            io:fwrite("Turbine ~p model ~p : End of Symulation\n",[self(),Model]),
            exit("End of Symulation\n");
        Message -> 
            io:fwrite("Turbine ~p model ~p SPAM ~p\n",[self(),Model,Message])
    end,
    turbine(Model,State,Radius,Efficiency,Timebase,PowerPlantPID,WeatherModulePID).


write_to_file(Data) -> file:write_file("./out/turbine", io_lib:fwrite("~p.\n", [Data]),[append]).

pom (Step,Power,PowerPlantPID,WindS) -> 
WindSpeed = round(WindS * 100)/100, 
lists:flatten(
    io_lib:format(
        "Godzina: ~p:00, moc: ~p kWh, predkosc wiatru: ~p [m/s] turbina PID ~p",
        [Step,Power,WindSpeed,PowerPlantPID])).