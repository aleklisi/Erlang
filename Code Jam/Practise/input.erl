-module(input).
-author('AlekLisiecki').
-export([get_input/1, separate_cases/1, group_cases/1]).

get_input(Filename) ->
    {ok,Input} = file:read_file(Filename),
    binary:bin_to_list(Input).

separate_cases([]) -> [];
separate_cases(String) -> 
    ReplacendNewLines = string:replace(String,"\n"," ",all),
    string:split(ReplacendNewLines," ",all).

group_cases([]) -> [];
group_cases([[]]) -> [];
group_cases([H1,H2|T]) -> [{H1,list_to_integer(H2)}] ++ group_cases(T).