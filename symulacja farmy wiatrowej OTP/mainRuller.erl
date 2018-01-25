-module(mainRuller).
-behaviour(application).
-export([start/2, stop/1]).
-export([run_simulation/2, loop/3, create_turbine_names/1, write_output/2, insert_gathered_data/3]).

start(_Type, NumberOfTurbines) ->
    plant:start_link(NumberOfTurbines).

stop(Turbines) ->
    [H|_T] = Turbines,
    turbine:stop(H),
    ok.

%==============================================================

run_simulation(NumberOfTurbines,NumberOfSteps) ->
    try
        start(a,NumberOfTurbines),
        Turbines = create_turbine_names(NumberOfTurbines),
        GotheredData = initailize_gothered_data(Turbines),
        loop(NumberOfSteps, Turbines,GotheredData),
        stop(Turbines)
    catch
        _:_ -> {error,"catch caught error during simulation"}
    end.

%==============================================================

loop(X,_,GotheredData) when X =< 0 -> GotheredData;
loop(0,_,GotheredData) -> GotheredData;
loop(X,Turbines,GotheredData) ->
    OutPut = lists:map(fun(Turbine) -> turbine:get_power(Turbine) end,Turbines),
    write_output(OutPut,Turbines),
    NewGatheredData =
        lists:foldr(fun({Res,Tur},Pred) ->
            insert_gathered_data(Res,Tur,Pred)end,
            GotheredData,
            lists:zip(OutPut,Turbines)),
    loop(X - 1,Turbines,NewGatheredData).

create_turbine_names(Num) ->
    lists:map(fun(X) -> plant:create_turbine_name(X) end, lists:seq(1,Num)).

write_output([],_) -> ok;
write_output(Results,Turbines) ->
    [HR|TR] = Results,
    [HT|TT] = Turbines,
    io:fwrite("~p produced: ~p W\n",[HT,HR]),
    write_output(TR,TT).

initailize_gothered_data([]) -> [];
initailize_gothered_data([H|T]) ->
    [{H,[]}] ++ initailize_gothered_data(T).

insert_gathered_data(_,_,[]) -> erlang:error("cant save data, turbine not found");
insert_gathered_data(NewData,Turbine,[{Turbine,List}|T]) -> [{Turbine,List ++ [NewData]}] ++ T;
insert_gathered_data(NewData,Turbine,[H|T]) -> [H] ++ insert_gathered_data(NewData,Turbine,T).

present_data(X) -> io:fwrite("data is ~p \n",[X]).