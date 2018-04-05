-module(tidy).
-author('AlekLisiecki').
-compile(export_all).
-import(input, [get_input/1, separate_cases/1, group_cases/1]).
-import(output,[write_results_to_file/1, single_result/2]).

% cd("C:/Users/alekl/source/repos/Erlang/Code Jam/Practise").

run() ->
    InputString = get_input("B-small-practice.in"),
    [_NumerOfCasesString|SeparatedCasesString] = separate_cases(InputString),
    SeparatedCasesInt = lists:map(fun(X) -> list_to_integer(X) end, SeparatedCasesString),
    SolvedResults = lists:map(fun(X) -> solve(X) end,SeparatedCasesInt),
    write_results_to_file(SolvedResults).
    
solve(X) -> 
    CutInteger = cut_integer(X),
    case is_tidy(CutInteger) of
        true -> X;
        _ -> solve(X-1)
    end.

cut_integer(0) -> [];
cut_integer(X) -> cut_integer(X div 10) ++ [X rem 10].

is_tidy([]) -> true;
is_tidy([_]) -> true;
is_tidy([X,Y|T]) when X =< Y -> is_tidy([Y|T]);
is_tidy(_) -> false. 
