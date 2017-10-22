-module(sitoM).
-import(child,[start_children/1]).
-compile([export_all]).

real_value() -> 1000 * 1000 * 1000 * 1000.

find_problem_ranges(ProblemLen, NumberOfThreads) ->
	SubProblemLen = ProblemLen div NumberOfThreads,
	list_of_ranges(2, SubProblemLen, NumberOfThreads).
		
list_of_ranges(_,_,0) -> [];
list_of_ranges(Start,Len,N) ->
	End = Start + Len - 1,
	NewStart =  End + 1,	
	Sublist = [{Start, End}],
	Sublist ++ list_of_ranges(NewStart, Len, N - 1).


	
loop_master([],Primes) -> 
	Primes;
loop_master(ChildrenPids,Primes) ->
	%%List = read_message_from_all_children,
	%%NewPrime = lists:min(List),
	NewPrimes = [15] ++ Primes,%%todo zamien 15 na NewPrime
	loop_master(ChildrenPids,NewPrimes).
	
start_master(ProblemLen, NumberOfThreads) -> 
	Ranges = find_problem_ranges(ProblemLen, NumberOfThreads),
	ChildrenPids = start_children(Ranges),
	loop_master(ChildrenPids,[]).
