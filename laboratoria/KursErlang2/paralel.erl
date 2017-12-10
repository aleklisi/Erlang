-module(paralel).
-compile([export_all]).

deploy_workers(0,L,_InPID,_OutPID) -> L;
deploy_workers(N,L,InPID,OutPID) -> 
    NewPid = spawn(paralel,through,[InPID,OutPID]),
    deploy_workers(N-1,[NewPid] ++ L).

in() -> 
    receive
        {givetask,PID} -> 
            PID ! task,
            in();
        _ -> koniecIN
    end.

th