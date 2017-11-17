-module(plant).
-compile([export_all,debug_info]).

send_to_all_from_list([],_) -> done;
send_to_all_from_list(ListOfPIDs,Message) ->
    [H|T] = ListOfPIDs,
    H ! Message,
    send_to_all_from_list(T,Message).

gother_power(WindTurbinesPIDs,StatisticsCollector,Step) -> 
    send_to_all_from_list(WindTurbinesPIDs,{sendPowerToPlant,self(),Step}),
    SumedPower = sum_power(WindTurbinesPIDs,0,Step),
    StatisticsCollector ! {sumedPower, Step, SumedPower}.

sum_power([],Sum,_) -> Sum;
sum_power(WindTurbinesPIDs,Sum,Step) -> 
    receive
        {PowerFromTurbine,TurbinePID,Step} ->
        ShortendPIDsList = lists:delete(TurbinePID,WindTurbinesPIDs),
        NewSum = Sum + PowerFromTurbine
    end,
    sum_power(ShortendPIDsList,NewSum,Step).

start() -> 
    receive
    {windTurbinePIDs,WindTurbinesPIDs} -> 
        io:fwrite("Plant ~p starts working\n",[self()]),
        run_plant(WindTurbinesPIDs);
    Message -> 
        io:fwrite("Plant ~p start SPAM ~p\n", [self(),Message])
    end.

run_plant(WindTurbinesPIDs) ->
    receive
        {getPowerFromTurbines,Step} -> 
            spawn(plant,gother_power,[WindTurbinesPIDs,self(),Step]),
            io:fwrite("Send PlantPower to statistic saving.\n");
        {sumedPower, Step, Sum} -> 
            io:fwrite("Plant ~p: power gothered form all turbines in step ~p is ~p\n",[self(),Step,Sum]); 
        endOfSymulation ->
            io:fwrite("Plant ~p End of Symulation\n",[self()]),
            exit("End of Symulation\n");
        _ -> 
            io:fwrite("Plant ~p SPAM\n",[self()])
    end,
    run_plant(WindTurbinesPIDs).
