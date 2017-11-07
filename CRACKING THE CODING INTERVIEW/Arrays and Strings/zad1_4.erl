-module(zad1_4).
-compile([export_all]).
-export([are_anagrams/2]).

%Write a method to decide if two strings are anagrams or not.

are_anagrams([],[]) -> true;
are_anagrams(_,[]) -> false;
are_anagrams([],_) -> false;
are_anagrams(Stirng1,Stirng2) -> 
	[H|T1] = Stirng1,
	T2 = lists:delete(H, Stirng2),
	are_anagrams(T1,T2).
	
test() -> run_tests(6).

run_tests(0) -> io:fwrite("tests_ended");
run_tests(N) -> 
	TestResult = test_scenario(N),
	io:fwrite("test ~p result is ~p\n",[N,TestResult]),
	run_tests(N-1). 

test_scenario(1) -> are_anagrams("","") =:= true;
test_scenario(2) -> are_anagrams("asdf","fdsa") =:= true;
test_scenario(3) -> are_anagrams("asdd","sad") =:= false;
test_scenario(4) -> are_anagrams("gfd","") =:= false;
test_scenario(5) -> are_anagrams("gfd","dfg") =:= true;
test_scenario(6) -> are_anagrams("fgn","tntna") =:= false;
test_scenario(_) -> true.
