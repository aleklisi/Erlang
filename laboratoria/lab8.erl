-module(lab8).
-compile([export_all]).
%cd("C:/Users/sebac/Documents/Erlang/Programs/Erlang/laboratoria").

start(0) -> io:fwrite("Koniec wysyłania/n");
start(N) ->
    KonsumentPID = spawn(lab8, konsument,[]),
    PosrednikPID = spawn(lab8, posrednik,[KonsumentPID]),
    producent(N,PosrednikPID).

send_list([],_PID) -> ok;
send_list([H|T],PID) -> 
    PID ! {liczba,H},
    send_list(T,PID).

producent(N,PosrednikPID) ->  
    List = [rand:uniform() || _ <- lists:seq(1,N)],
    send_list(List,PosrednikPID),
    PosrednikPID ! koniec,
    io:fwrite("koniec producenta\n").

posrednik(KonsumentPID) -> 
    receive
        {liczba,H} -> KonsumentPID ! {liczba,H};
        koniec -> 
            KonsumentPID ! koniec,
            io:fwrite("koniec posrednika\n")
    end,
    posrednik(KonsumentPID).

konsument() -> 
    receive
        {liczba,H} -> 
        io:fwrite("Otrzymana liczba to: ~p\n",[H]),
        konsument();
        koniec -> io:fwrite("koniec konsumenta\n")
    end.
