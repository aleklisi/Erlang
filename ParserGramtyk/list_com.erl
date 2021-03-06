-module(list_com).
-compile([export_all,debug_info]).
-export([list_devide_to_three/1,list_remove_empty/1,remove_duplicates/1,is_one_of/2]).

list_devide(0,_) -> [];
list_devide(N,List) -> [lists:split(N - 1,List)] ++ list_devide(N - 1,List).

list_devide_all_cominations([]) -> [];
list_devide_all_cominations(List) -> 
    Len = length(List) + 1,
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

list_remove_empty([]) -> [];
list_remove_empty([H|T]) when H =:= [] -> list_remove_empty(T);
list_remove_empty([H|T]) when H =/= [] -> [H] ++ list_remove_empty(T).

remove_duplicates(List) ->
        Set = sets:from_list(List),
        sets:to_list(Set).

compere_two_lists([],[]) -> true;
compere_two_lists([],_) -> false;
compere_two_lists(_,[]) -> false;
compere_two_lists([H1|T1],[H2|T2]) ->
    case H1 =:= H2 of
        true ->  compere_two_lists(T1,T2);
        false -> false
    end.

is_one_of(_,[]) -> false;
is_one_of(L,[H|T]) -> compere_two_lists(L,H) or is_one_of(L,T). 