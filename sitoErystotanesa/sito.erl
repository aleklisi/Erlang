-module(sito).
-compile([export_all]).

remove_all_devidable_by_elem([],_) ->
	[];
remove_all_devidable_by_elem([H|T],Elem) ->
		case (H rem Elem) == 0 of
			true ->
				remove_all_devidable_by_elem(T,Elem);
			false ->
				[H] ++ remove_all_devidable_by_elem(T,Elem)
		end.
	
act([],Result) ->
	Result;
act([H|T],Primes) ->
	NewPrimes = Primes ++ [H],
	ShortedList = remove_all_devidable_by_elem(T,H),
	act(ShortedList,NewPrimes).
	
solve(Len) -> 
	List = lists:seq(2,Len,1),
	act(List,[]).	