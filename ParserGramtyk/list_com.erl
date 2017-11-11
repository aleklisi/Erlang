-module(list_com).
-compile([export_all]).
-export([list_devide_to_three/1]).

list_devide(0,_) -> [];
list_devide(N,List) -> [lists:split(N,List)] ++ list_devide(N - 1,List).

list_devide_all_cominations([]) -> [];
list_devide_all_cominations(List) -> 
    Len = length(List),
    list_devide(Len,List).

add_to_all(_,[]) -> [];
add_to_all(LP,[{LS,LK}|T]) -> 
   [{LP,LS,LK}] ++ add_to_all(LP,T).

list_redevide([]) -> [];
list_redevide([{L1,L2}|T]) -> 
    AllSubLists = list_devide_all_cominations(L2),
    add_to_all(L1,AllSubLists) ++ list_redevide(T).

list_devide_to_three(List) ->
    ListsToTwo = list_devide_all_cominations(List),
    list_redevide(ListsToTwo).