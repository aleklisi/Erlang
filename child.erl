-module(child).
-compile([export_all]).
-export([start_children/1, test/0]).

remove_all_devidable_by_elem([H|T],Elem) ->
		case (H rem Elem) == 0 of
			true ->
				remove_all_devidable_by_elem(T,Elem);
			false ->
				[H] ++ remove_all_devidable_by_elem(T,Elem)
		end.
	
child_thread_loop([],MasterPid) -> 
	erlang:send(MasterPid,false),
	io:fwrite("Child finished its task.\n");
child_thread_loop([H|T],MasterPid) -> 
	receive
		you_are_the_smallest ->
			erlang:send(MasterPid,{new_prime_is,H}),
			NewList = remove_all_devidable_by_elem(T,H);
		{cut_out,Prime} ->
			NewList = remove_all_devidable_by_elem([H|T],Prime);
		_ -> io:fwrite(""),
			NewList = [H|T]
	end,
	child_thread_loop(NewList,MasterPid),
	io:fwrite("Child is in loop.\n").
	
child_thread_start({Start,Stop},MasterPid) ->
	List = lists:seq(Start,Stop,1),
	child_thread_loop(List,MasterPid).

start_children([]) -> 
	io:fwrite("All childen started working.\n");
start_children([H|T]) ->
	ChildPid = spawn(child, child_thread_start, [H,self()]),
	[ChildPid] ++ start_children(T).
	
test() -> 
	start_children([{2,10},{11,20},{3,30}]). 