-module(factorial_logic).
-author('AlekLisiecki').
-export([factorial/1,fac_ac/2,fac_hanlder/0]).

factorial(X) when X < 0 -> erlang:error("Cant calculate factorial of negative number");
factorial(X) when not is_integer(X) -> erlang:error("Cant calculate factorial of non integer number");
factorial(X) -> fac_ac(X,1).


fac_ac(0,Ac) -> Ac;
fac_ac(X,Ac) -> fac_ac(X-1,Ac * X).

fac_hanlder() -> 
    receive
        {fac,Int} -> 
            Result = factorial(Int),
            io:fwrite("Factorial of ~p is ~p \n",[Int,Result]);
        SPAM -> 
            io:fwrite("Factorial received SPAM: ~p \n",[SPAM])
    end,
    fac_hanlder().