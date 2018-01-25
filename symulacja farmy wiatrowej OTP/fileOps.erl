-module(fileOps).
-export([read_file/2, file_to_list_of_floats/2]).

read_file(FileName,Separator) ->
    try
        {ok, Binary} = file:read_file(FileName),
        file_to_list_of_floats(Binary,Separator)        
    catch
        _:_ -> erlang:error("File opening went wrong. Problaby you try to open not existing file.")
    end.

file_to_list_of_floats(Binary,Separator) ->
    List = string:tokens(erlang:binary_to_list(Binary),Separator),
    ListPom = lists:seq(1,length(List)),
    ReadInList = lists:zipwith(fun(X,_) -> string:to_float(X) end,List,ListPom),
    {Floats,_} = lists:unzip(ReadInList),
    Floats.