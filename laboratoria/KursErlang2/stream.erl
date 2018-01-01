-module(stream).
-compile([export_all]).

deploy_start(N) -> 
    OutputPID = spawn(stream,output,[]),
    deploy(N,OutputPID).

deploy(0,ThroughputPID) -> spawn(stream,input,[ThroughputPID]); 
deploy(N,ThroughputPID) -> 
    NextThroughputPID = spawn(stream,throughput,[ThroughputPID]),
    deploy(N - 1, NextThroughputPID).

deploy() -> 
    OutputPID = spawn(stream,output,[]),
    Throughput3PID = spawn(stream,throughput,[OutputPID]),
    Throughput2PID = spawn(stream,throughput,[OutputPID]),
    Throughput1PID = spawn(stream,throughput,[OutputPID]),
    spawn(stream,input,[Throughput1PID]).

input(NextPIDs) ->
    [H|T] = NextPIDs;
    receive
        koniec ->
            NextPID ! koniec,
            exit("koniec input\n");
        Data -> 
            NextPID ! Data,
            input(NextPID)
    end.

throughput(NextPID) ->
    receive
        koniec ->
            NextPID ! koniec,
            exit("koniec throughput\n");
        Data -> 
        NewData = calc(Data),
        NextPID ! NewData,
        throughput(NextPID)
    end.

calc(Data) -> Data.

output() -> 
    receive
        koniec -> exit("koniec output\n");
        Data -> 
        io:fwrite("Data is:~p\n",[Data]),
        output()
    end.
    
