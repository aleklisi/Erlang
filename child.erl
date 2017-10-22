-module(child).
-compile([export_all]).
-export([start_children/1]).

remove_all_devidable_by_elem([],_) -> [];
remove_all_devidable_by_elem([H|T],Elem) ->
		case (H rem Elem) == 0 of
			true ->
				remove_all_devidable_by_elem(T,Elem);
			false ->
				[H] ++ remove_all_devidable_by_elem(T,Elem)
		end.
	
child_thread_loop([],MasterPid) -> 
	erlang:send(MasterPid,end_of_numbers),
	io:fwrite("Child ~p finished its task on ~p.\n",[self(),time()]);
child_thread_loop([H|T],MasterPid) -> 
	receive
		you_are_the_smallest ->
			erlang:send(MasterPid,{new_prime_is,H}),
			NewList = remove_all_devidable_by_elem(T,H);
		{cut_out,Prime} ->
			NewList = remove_all_devidable_by_elem([H|T],Prime);
		_ -> io:fwrite("SPAM"),
			NewList = [H|T]
	end,
	child_thread_loop(NewList,MasterPid).
	
child_thread_start({Start,Stop},MasterPid) ->
	List = lists:seq(Start,Stop,1),
	child_thread_loop(List,MasterPid).

remove_all([],_) -> [];
remove_all([H|T],Elem) ->
	case H == Elem of
			true -> remove_all(T,Elem);
			false -> [H] ++ remove_all(T,Elem)
		end.	
	
start_children([]) -> [];
start_children([H|T]) ->
	ChildPid = spawn(child, child_thread_start, [H,self()]),
	[ChildPid] ++ start_children(T). 