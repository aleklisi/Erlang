-module(child).
-compile([export_all]).

child_thread_loop([],MasterPid) -> 
	erlang:send(MasterPid,nothing_is_left),
	io:fwrite("Child finished its task.\n");
child_thread_loop([H|T],MasterPid) -> 
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