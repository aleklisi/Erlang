-module(crazyTest).
-compile([export_all]).

%cd("C:/Users/sebac/Documents/Erlang/Programs/Erlang/ErlangDemo/src").

start() -> [spawn(crazyTest,loop,[])].

stop(PID) ->   
    exit(PID,kill).

compile() -> compile:file(crazyTest).

load() -> 
    code:soft_purge(crazyTest),
    code:load_file(crazyTest).

loop() -> 
    io:fwrite("b\n",[]),
    timer:sleep(1000),
    crazyTest:loop().

list(0) -> lists:seq(0,7);
list(1) -> lists:seq(1,7).

gen_numbers_all() -> [100*X + 10*Y +Z || 
            X <- list(1), Y <- list(0), Z <- list(0),
                X /= Y, Y /= Z, X /= Z].

dot(F,G) -> fun(X) -> F(G(X)) end.
% DOT = fun(A,B) -> fun(X) -> A(B(X)) end end.

map_update(Map,Key,Value) -> 
    case maps:is_key(Key,Map) of
        false -> erlang:error("Key not found in map\n");
        true -> maps:put(Key,Value,Map)
    end.

map_update_better(Map,Key,Value) -> 
    try
        maps:update(Key,Value,Map)
    catch
        _:_ -> erlang:error("Key not found in map\n")
    end.
    
%Napisz kod w języku Erlang, który uruchomi 3 procesy A,B i C.
%Proces A będzie wysyłał do B wiadomości co 1sek,
%B po otrzymaniu wiadomości od A będzie ją przesyłał natychmiast do C,
%C będzie ją natychmiast przesyłał do A.
%Jeśli A nie otrzyma odpowiedzi od C w max 500ms to wyświetli komunikat i zakończy działanie wszystkich procesów.

start_all() -> 
    PIDC = spawn(?MODULE, c, []),
    PIDB = spawn(?MODULE, b, [PIDC]),
    _PIDA = spawn(?MODULE, a, [PIDB]).

 a(PIDB) -> 
    io:fwrite("A ~p sends message to B ~p\n",[self(),PIDB]),
    PIDB ! {self(), message},
    receive 
        message -> 
            io:fwrite("A ~p received message and waits\n",[self()]),
            timer:sleep(1000),
            a(PIDB)
    after
        500 ->
            io:fwrite("A ~p reached timeout\n",[self()]),
            PIDB ! shutdown    
    end.

b(PIDC) -> 
    io:fwrite("B ~pentered\n",[self()]),
    receive
        shutdown ->
            PIDC ! shutdown,
            io:fwrite("shutdown received by ~p B\n",[self()]),
            ok;
        {PIDA,message} -> 
           %timer:sleep(2000), to show timeout scenario
            io:fwrite("B ~p sends message to C ~p\n",[self(),PIDC]),
            PIDC ! {PIDA,message},
            b(PIDC)
    end.
        
c() -> 
    receive
        shutdown -> 
            io:fwrite("shutdown received by ~p C\n",[self()]),
            ok;
        {PIDA, message} ->
            io:fwrite("C ~p sends message to A ~p\n",[self(),PIDA]),            
            PIDA ! message,
            c()
    end.

%Napisz funkcję w j. erlang, która 
%podaną listę skróci o połowę uśredniając sąsiednie elementy. 
%Funkcja ma obsługiwać też listy nieparzyste.
% Napisz wersje gdzie ostatni element jest pomijany i doklejany.
% dest(0) = (src(0)+src(1))/2

avg_cut([]) -> [];
avg_cut([_X]) -> [];
avg_cut([X,Y|T]) -> 
    NewElem = (X + Y) /2,
    [NewElem] ++ avg_cut(T).

avg_append([]) -> [];
avg_append([X]) -> [X];
avg_append([X,Y|T]) -> 
    NewElem = (X + Y) /2,
    [NewElem] ++ avg_append(T).

%Napisz w Erlangu funkcję generującą liczby Fibonacciego na dwa sposoby: rekurencyjnie i iteracyjnie.

fib_rek(0) -> 0;
fib_rek(1) -> 1;
fib_rek(X) -> fib_rek(X - 1) + fib_rek(X - 2).

fib_iter(X) -> fib_acc_iter(X,0,1).

fib_acc_iter(0,Result,_) -> Result;
fib_acc_iter(X,A,B) -> fib_acc_iter(X - 1, B, A + B).    


%Napisz program w jezyku erlang, który uruchomi N procesów w konfiguracji gwiazdy 
%i prześle do każdego z nich M komunikatów będących liczbami naturalnymi w zakresie 1-M.
%Procesy mają odsyłać podwojoną wartośc otrzymanego argumentu


boss(N,M) -> 
    KidsPIDs = lists:map(fun(X) -> spawn(?MODULE,kid,[]) end, lists:seq(1,N)),
    MessagesPairedKids = [{X,Y} || X <-KidsPIDs, Y <- lists:seq(1,M)],
    lists:map(fun({PID,Number}) -> PID ! Number end, MessagesPairedKids).    
%nie ma mowy o odbieraniu tych komunikatów nic wiec nie dopisuje


kid() ->
    receive 
        {FromPID,Number} ->
            NewValue = Number * 2,
            FromPID ! NewValue,
            kid();
        shutdown -> ok
    end.

%napisz rownoległą implementacje map w erlangu pmap(Fun,[Items]). Funkcja ma uwzględniać bledne dzialanie Fun na elementach listy.
map_paralel(Fun,List) -> 
    ThreadsPIDS = lists:map(fun(X) -> spawn(?MODULE,thread,[Fun,X,self()]) end, List),
    gother_results(ThreadsPIDS,[]).

gother_results([],Results) -> Results;
gother_results(ThreadsPIDS,Results) -> 
    receive
        {error,X,Y,Elem,Fun} -> {error,X,Y,Elem,Fun};
         {PID,Result} -> gother_results(lists:delete(PID,ThreadsPIDS), Results ++ [Result])
    end.

thread(Fun,Elem,ParentPID) ->
    try
        ParentPID ! {self(),Fun(Elem)}
    catch
        X:Y -> ParentPID ! {error,X,Y,Elem,Fun}
    end.
