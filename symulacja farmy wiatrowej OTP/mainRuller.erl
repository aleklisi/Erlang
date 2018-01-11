-module(mainRuller).
-behaviour(application).
-author('AlekLisiecki').

-export([start/2, stop/1]).
-export([run_simulation/2, loop/2, create_turbine_names/1, write_output/2]).

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
        loop(NumberOfSteps, Turbines),
        stop(Turbines)
    catch
        _:_ -> error_executing_simulation
    end.

%==============================================================

loop(X,_) when X =< 0 -> endOfSimulation;
loop(0,_) -> endOfSimulation;
loop(X,Turbines) ->
    OutPut = lists:map(fun(Turbine) -> turbine:get_power(Turbine) end,Turbines),
    write_output(OutPut,Turbines),
    loop(X - 1,Turbines).

create_turbine_names(Num) ->
    lists:map(fun(X) -> plant:create_turbine_name(X) end, lists:seq(1,Num)).


write_output([],_) -> ok;
write_output(Results,Turbines) ->
    [HR|TR] = Results,
    [HT|TT] = Turbines,
    io:fwrite("~p produced: ~p W\n",[HT,HR]),
    write_output(TR,TT).