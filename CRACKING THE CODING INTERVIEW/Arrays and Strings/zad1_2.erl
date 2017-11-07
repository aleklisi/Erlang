-module(zad1_2).
-compile([export_all]).
-export([reverse_all_but_last/1]).

%Write code to reverse a C-Style String. (C-String means that “abcd” is represented as five characters, including the null character.)
%null character is repesented by last charakter 
reverse_all_but_last(String) ->
	LastElem = lists:last(String),
	RemainingString = lists:droplast(String),
	reverse(RemainingString) ++ [LastElem].

reverse([]) -> [];
reverse([H|T]) -> reverse(T) ++ [H].