-module(zad1_5).
-compile([export_all]).
-export([replace/1]).

%Write a method to replace all spaces in a string with ‘%20’.
change_space($ ) -> "%20";
change_space(Char) -> [Char]. 

replace([]) -> [];
replace(String) -> 
	[H|T] = String,
	change_space(H) ++ replace(T).