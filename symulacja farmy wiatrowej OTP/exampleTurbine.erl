-module(exampleTurbine).
-author('AlekLisiecki').
-export([power_table/0,find_division/2,get_power/1,run/2]).
%data form  https://rf2.tthtesting.co.uk/windpower/wind-turbines/endurance-e-4660-85-kw-wind-turbine/
%by reimplemeting powertable one can validate real models :D
power_table() -> 
    [
    {0,3,0},
    {3,4,2 * 1000},
    {4,5,8 * 1000},
    {5,6,16 * 1000},
    {6,7,30 * 1000},
    {7,8,44 * 1000},
    {8,9,55 * 1000},
    {9,10,65 * 1000},
    {10,11,73 * 1000},
    {11,12,78 * 1000},
    {12,13,82 * 1000},
    {13,14,84 * 1000},
    {14,15,85 * 1000},
    {15,16,84 * 1000},
    {16,17,84 * 1000},
    {17,18,85 * 1000}
    ].

find_division(_,X) when X < 0 -> erlang:error("Wind speed is less then 0\n");
find_division([{_,_,Value}],_) -> Value;
find_division([{Min,Max,Value}|_],X) when Min < X andalso X < Max -> Value;
find_division([_|T],X) -> find_division(T,X).

get_power(WindSpeed) ->
    PowerTable = power_table(),
    find_division(PowerTable,WindSpeed).

run(working,WindSpeed) ->
    get_power(WindSpeed);
run(notworking,_) -> 0;
run(_,_) ->  erlang:error("Wind turbine rached unreachable state!!!\n").

