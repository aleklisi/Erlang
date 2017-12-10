%  sort1.erl
%cd("C:/Users/sebac/Documents/Erlang/Programs/Erlang/laboratoria/KursErlang2").
-module(sort1).
-compile([export_all]).

get_mstimestamp() ->
  {Mega, Sec, Micro} = os:timestamp(),
  (Mega*1000000 + Sec)*1000 + round(Micro/1000).

sorts(L) -> lists:sort(L).
  
sorts2([]) -> [];
sorts2([X]) -> [X];
sorts2([H|T]) ->
  sorts2([X || X <- T, X < H]) ++ [H] ++ sorts2([X || X <- T, X >= H]).
  
sortw(L) -> 
  PID = spawn(sort1,sort_paralel,[L,self()]),
  my_receive(PID).

sort_paralel([],ParentPID) -> 
  ParentPID ! {self(),[]};
sort_paralel([H|T],ParentPID) ->
	Smaller = [X || X <- T, X < H],
	Bigger =  [X || X <- T, X >= H],
  SmallerPID = spawn(sort1,sort_paralel,[Smaller,self()]),
  BiggerPID = spawn(sort1,sort_paralel,[Bigger,self()]),
  BiggerSorted = my_receive(BiggerPID),
  SmallerSorted = my_receive(SmallerPID),
  ParentPID ! {self(),SmallerSorted ++ [H] ++ BiggerSorted}.

my_receive(Message) -> 
  receive
    {Message,L} -> L
  end.

gensort() ->
 L=[rand:uniform(5000)+100 || _ <- lists:seq(1, 100000)],	
 Lw=L,
 io:format("Liczba elementów = ~p ~n",[length(L)]),
 
 io:format("Sortuję sekwencyjnie~n"),	
 TS1=get_mstimestamp(),
 sorts2(L),
 DS=get_mstimestamp()-TS1,	
 io:format("Czas sortowania ~p [ms]~n",[DS]),
 io:format("Sortuję sekwencyjnie wbudowane~n"),	
 TS3=get_mstimestamp(),
 sorts(L),
 DS3=get_mstimestamp()-TS3,	
 io:format("Czas sortowania ~p [ms]~n",[DS3]),
 io:format("Sortuję współbieżnie~n"),	
 TS2=get_mstimestamp(),
 sortw(Lw),
 DS2=get_mstimestamp()-TS2,	
 io:format("Czas sortowania ~p [ms]~n",[DS2]).
 
 