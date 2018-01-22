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

