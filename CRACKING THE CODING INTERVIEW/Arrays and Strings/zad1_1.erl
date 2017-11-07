-module(zad1_1).
-compile([export_all]).
-export([all_unique_characters/1, all_unique_characters_no_extra_datatype/1]).

% Implement an algorithm to determine if a string has all unique characters.
all_unique_characters(String) -> 
	all_unique_characters(String, #{}).

all_unique_characters([],_) -> true;
all_unique_characters([H|T], Map) -> 
	MapExistanceElement = maps:get(H, Map, 0),
	case MapExistanceElement of 
		0 -> 
			NewMap = maps:put(H,1,Map),
			all_unique_characters(T,NewMap);
		_ ->  false
	end.
	
% What if you can not use additional data structures?

all_unique_characters_no_extra_datatype([]) -> true;
all_unique_characters_no_extra_datatype(String) ->
	[CurrentChar|RemainingString] = String,
	CurrentCheck = compare_remaining(CurrentChar, RemainingString),
	case CurrentCheck of 
		false -> false;
		true -> all_unique_characters_no_extra_datatype(RemainingString);
		_ -> erlang:error("unexpected behavior")
	end.
	
compare_remaining(_,[]) -> true;
compare_remaining(Elem,[H|T]) ->
	(Elem =/= H) and compare_remaining(Elem,T).