-module(plant).
-compile([export_all,debug_info]).

send_to_all_from_list([],_) -> done;
send_to_all_from_list(ListOfPIDs,Message) ->
    [H|T] = ListOfPIDs,
    H ! Message,
    send_to_all_from_list(T,Message).

gother_power(WindTurbinesPIDs,Step) -> 
    send_to_all_from_list(WindTurbinesPIDs,{sendPowerToPlant,Step}),
    sum_power(WindTurbinesPIDs,0,Step).

sum_power([],Sum,_) -> Sum;
sum_power(WindTurbinesPIDs,Sum,Step) -> 
    receive
        {PowerFromTurbine,TurbinePID,Step} ->
        ShortendPIDsList = lists:delete(TurbinePID,WindTurbinesPIDs),
        NewSum = Sum + PowerFromTurbine
    end,
    sum_power(ShortendPIDsList,NewSum,Step).

run(WindTurbinesPIDs) ->
    receive
        {getPowerFromTurbines,Step} -> 
            PlantPower = gother_power(WindTurbinesPIDs,Step);
        endOfSymulation ->
            exit("End of Symulation");
        _ -> ok
    end,
    run(WindTurbinesPIDs).
