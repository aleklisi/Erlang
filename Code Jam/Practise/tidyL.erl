-module(tidyL).
-author('AlekLisiecki').
-compile(export_all).
-compile(debug_info).
-import(input, [get_input/1, separate_cases/1, group_cases/1]).
-import(output,[write_results_to_file/1, single_result/2]).

run() ->
    InputString = get_input("B-large-practice.in"),
    [_NumerOfCasesString|SeparatedCasesString] = separate_cases(InputString),
    SeparatedCasesInt = lists:map(fun(X) -> cut_integer(X) end, SeparatedCasesString),
    SolvedResults = lists:map(
        fun(X) -> 
            io:fwrite("Case ~p started, and ",[X]),
            Result = solve(X),
            io:fwrite("solution is ~p\n",[Result]),
            Result
        end,SeparatedCasesInt),
    write_results_to_file(SolvedResults).
    
solve(X) -> 
    case is_tidy(X) of
        true -> 
            X;
        _ -> 
            DecrementedX = trick(X),
            solve(DecrementedX)
    end.

cut_integer(List) -> [X - 48 || X <- List].

is_tidy([]) -> true;
is_tidy([_]) -> true;
is_tidy([X,Y|T]) when X =< Y -> is_tidy([Y|T]);
is_tidy(_) -> false. 

decrement([0]) -> error("0 reached");
decrement([0|T]) ->  
    HelperList = [10] ++ move_zeros(T),
    decrement(HelperList);
decrement([X|T]) -> [X-1|T].

move_zeros([0|T]) -> [9] ++ move_zeros(T);
move_zeros([X|T]) -> [X-1|T].

trick([X]) -> [X];
trick([X,Y|T]) when X > Y -> [X-1,9] ++ nines(T);
trick([H|T]) -> [H] ++ trick(T).

nines(List) -> [ 9 || _ <- List].