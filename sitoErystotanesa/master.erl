-module(master).
-compile([export_all]).
-import(child,[start_children/1]).

find_problem_ranges(ProblemLen, NumberOfThreads) ->
	SubProblemLen = ProblemLen div NumberOfThreads,
	list_of_ranges(2, SubProblemLen, NumberOfThreads).
		
list_of_ranges(_,_,0) -> [];
list_of_ranges(Start,Len,N) ->
	End = Start + Len - 1,
	NewStart =  End + 1,	
	Sublist = [{Start, End}],
	Sublist ++ list_of_ranges(NewStart, Len, N - 1).

send_to_all([],_) -> io:fwrite("");
send_to_all([H|T],Message)->
	erlang:send(H,Message),
	send_to_all(T,Message).	
	
loop_master([],Primes) -> 
	Primes;
loop_master(ChildrenPids,Primes) ->
	[H|T] = ChildrenPids,
	erlang:send(H,you_are_the_smallest),
	receive
		{new_prime_is,NewPrime} ->
				%io:fwrite("~p at: ~p\n",[NewPrime,time()]),
			send_to_all(ChildrenPids,{cut_out,NewPrime}),
			NewPrimes = Primes ++ [NewPrime],
			NewChildrenPids = ChildrenPids;
		end_of_numbers -> 
			NewPrimes = Primes,
			NewChildrenPids = T;
		_ -> io:fwrite(""),
			NewPrimes = Primes,
			NewChildrenPids = ChildrenPids
	end,
	loop_master(NewChildrenPids,NewPrimes).

start_master(ProblemLen, NumberOfThreads) -> 
	Ranges = find_problem_ranges(ProblemLen, NumberOfThreads),
	ChildrenPids = start_children(Ranges),
	loop_master(ChildrenPids,[]).
	
test() -> 
	TaskTimeToCalculate = 1000 * 10,
	NumberOfThreads = 32,
	io:fwrite("Start time is ~p\n",[time()]),
	start_master(TaskTimeToCalculate,NumberOfThreads),
	io:fwrite("End time is ~p\n",[time()]). 