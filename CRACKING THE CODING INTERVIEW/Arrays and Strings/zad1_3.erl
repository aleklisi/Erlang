-module(zad1_3).
-compile([export_all]).
-export([remove_duplicate_characters/1, run_tests/1]).

%Design an algorithm and write code to remove the duplicate characters in a string without using any additional buffer. NOTE: One or two additional variables are fine. An extra copy of the array is not.
remove_form_list(_,[]) -> [];
remove_form_list(Elem,[Elem|T]) ->	remove_form_list(Elem,T);
remove_form_list(Elem,[H|T]) -> [H] ++ remove_form_list(Elem,T).

remove_duplicate_characters([]) -> [];
remove_duplicate_characters(String) -> 
	[H|T] = String,
	[H] ++ remove_duplicate_characters(remove_form_list(H,T))	.


%Write the test cases for this method.
test() -> run_tests(9).

run_tests(0) -> io:fwrite("tests_ended");
run_tests(N) -> 
	TestResult = test_scenario(N),
	io:fwrite("test ~p result is ~p\n",[N,TestResult]),
	run_tests(N-1). 

test_scenario(1) -> remove_duplicate_characters("") =:= "";
test_scenario(2) -> remove_duplicate_characters("a") =:= "a";
test_scenario(3) -> remove_duplicate_characters("aaa") =:= "a";
test_scenario(4) -> remove_duplicate_characters("ymca") =:= "ymca";
test_scenario(5) -> remove_duplicate_characters("yymca") =:= "ymca";
test_scenario(6) -> remove_duplicate_characters("ymmca") =:= "ymca";
test_scenario(7) -> remove_duplicate_characters("ymcaa") =:= "ymca";
test_scenario(8) -> remove_duplicate_characters("ymcccca") =:= "ymca";
test_scenario(9) -> remove_duplicate_characters("yyyymmmmmmmmmmmccccaaaaa") =:= "ymca";
test_scenario(_) -> true.