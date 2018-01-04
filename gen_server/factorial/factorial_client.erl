-module(factorial_client).
-author('AlekLisiecki').
-export([start/0,stop/0,f/0,factorial/1]).

start() -> factorial_ser:start_link().

stop() -> factorial_ser:stop().

factorial(X) -> factorial_ser:factorial(X). 

f() -> factorial_ser:f().