-module(potok).
-compile([export_all]).

last_or_not(null,Candydate) -> 
	io:fwrite("~p at: ~p\n",[Candydate,time()]),
	spawn(potok, middle_man, [null,Candydate]);
last_or_not(Next_Pid,Candydate) ->
	erlang:send(Next_Pid,{check,Candydate}),
	Next_Pid.
	
eliminating_divadable(Prime,Candydate,Next_Pid)->
	case (Candydate rem Prime) == 0 of
		false -> New_Pid = last_or_not(Next_Pid,Candydate);
		_ -> New_Pid = Next_Pid
	end,
	middle_man(New_Pid,Prime).

middle_man(Next_Pid,Prime) ->
	receive
		{check,Candydate} -> eliminating_divadable(Prime,Candydate,Next_Pid);
		_ -> middle_man(Next_Pid,Prime)
	end.
	
loop(N, N, _) -> doNothing;
loop(N, Limit, ChainBeginningPid) ->
	erlang:send(ChainBeginningPid, {check,N}),
	loop(N + 1, Limit, ChainBeginningPid).	
	
input_element(Limit) -> 
	ChainBeginningPid = spawn(potok, middle_man, [null,2]),
	loop(3,Limit,ChainBeginningPid).