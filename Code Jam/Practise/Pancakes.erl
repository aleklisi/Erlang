-module(pancakes).
-author('AlekLisiecki').
-compile(export_all).

% cd("C:/Users/sebac/Documents/Erlang/Programs/Erlang/Code Jam/Practise").

run() ->
    InputString = get_input(),
    [_NumerOfCasesString|SeparatedCases] = separate_cases(InputString),
    GroupedCases = group_cases(SeparatedCases),
    SolvedCases = lists:map(fun(X) -> solve_case(X,15) end, GroupedCases),
    write_results_to_file(SolvedCases,1).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
get_input() ->
    {ok,Input} = file:read_file("A-small-practice.in"),
    binary:bin_to_list(Input).

separate_cases([]) -> [];
separate_cases(String) -> 
    ReplacendNewLines = string:replace(String,"\n"," ",all),
    string:split(ReplacendNewLines," ",all).

group_cases([]) -> [];
group_cases([[]]) -> [];
group_cases([H1,H2|T]) -> [{H1,list_to_integer(H2)}] ++ group_cases(T).

number_cases([],_) -> [];
number_cases([{Pancakes,FlipperSize}|T],CaseNumber) ->
    [{Pancakes,FlipperSize,CaseNumber}] ++ number_cases(T,CaseNumber + 1).

write_results_to_file([],_) -> ok;
write_results_to_file([H|T],CaseNumber) ->
    FileOutput = single_result(CaseNumber,H),
    file:write_file("out.txt", FileOutput, [append]),
    write_results_to_file(T,CaseNumber + 1).

single_result(CaseNumber,impossible) ->
    io_lib:format("Case #~p: IMPOSSIBLE\n",[CaseNumber]);
single_result(CaseNumber,CaseResult) -> 
    io_lib:format("Case #~p: ~p\n",[CaseNumber,CaseResult]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 timeout_solve([Pancakes],StepsLeftToSolve,0,FlipperSize)->
    YourTimeOut = 100 * 1000,
    Self = self(),
    _Pid = spawn(fun()-> 
                    Result = solve([Pancakes],StepsLeftToSolve,0,FlipperSize),
                    Self ! {self(), Result} end),
    receive
        {_PidSpawned, Result} -> Result
    after
        YourTimeOut -> timout
    end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
solve_case({Pancakes,FlipperSize},StepsLeftToSolve) ->
    Helper = dividability_condiotin(Pancakes,FlipperSize),
    case Helper of 
        impossible -> Result = impossible;
        ok -> Result = timeout_solve([Pancakes],StepsLeftToSolve,0,FlipperSize)
    end,
    io:fwrite("Case: ~p with flipper ~p result: ~p\n",[Pancakes,FlipperSize,Result]),
    Result.

solve(_,0,_,_) -> impossible;
solve(PancakesPlatesList,StepsLeftToSolve,StepsAlreadyMade,FlipperSize) -> 
    case lists:any(fun(X) -> all_fliped_correctly(X) end, PancakesPlatesList) of 
        true -> StepsAlreadyMade;
        _ -> 
            HelpPancakesPlatesList = lists:foldr(fun(Elem,Acc) -> 
                find_all_possible_next_step_positions(Elem,FlipperSize) ++ Acc end, [], PancakesPlatesList),
            NewPancakesPlatesList = remove_duplicates(HelpPancakesPlatesList),
            solve(NewPancakesPlatesList,StepsLeftToSolve - 1, StepsAlreadyMade + 1,FlipperSize)
    end.

find_all_possible_next_step_positions(Pancakes,FlipperSize) -> 
    PanSize = length(Pancakes),
    NumberOfPossibleFlips = PanSize - FlipperSize, 
    lists:map(fun(X) -> flip(Pancakes,X,FlipperSize) end, lists:seq(0,NumberOfPossibleFlips)).

flip(RemainingPancakes,0,0) -> RemainingPancakes;
flip(AllPancakes,0,SpadeSize) when length(AllPancakes) < SpadeSize -> cannot_flip;
flip([H|T],0,SpadeSize) -> [flip_one(H)] ++ flip(T, 0, SpadeSize - 1);
flip([H|T],StartingPosition,SpadeSize) -> [H] ++ flip(T, StartingPosition - 1, SpadeSize).

all_fliped_correctly(PancakesList) -> 
    lists:all(fun(Pancakes) -> Pancakes == 43 end,PancakesList).

flip_one(X) -> 
    case X of
        43 -> 45;
        45 -> 43;
        _ -> erlang:error("Wrong input")
    end.

dividability_condiotin(String, FlipperSize) ->
    NumberOfMinuses = count_minuses(String),
    case (NumberOfMinuses rem 2 /= 0) and (FlipperSize rem 2 == 0) of
        true -> impossible;
        _ -> ok
    end.

count_minuses(String) -> 
    lists:foldr(fun(Elem,Acc) -> f(Elem,Acc) end,0,String).

f(Elem,Acc) when Elem == 45 -> Acc + 1;
f(_Elem,Acc) -> Acc.

remove_duplicates(List) ->
    Set = sets:from_list(List),
    sets:to_list(Set).