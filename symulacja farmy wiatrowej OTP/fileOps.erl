-module(fileOps).
-author('AlekLisiecki').
-export([read_file/2]).

read_file(FileName,Separator) ->
    {ok, Binary} = file:read_file(FileName),
    List = string:tokens(erlang:binary_to_list(Binary),Separator),
    ListPom = lists:seq(1,length(List)),
    ReadInList = lists:zipwith(fun(X,_) -> string:to_float(X) end,List,ListPom),
    {Floats,_} = lists:unzip(ReadInList),
    Floats.