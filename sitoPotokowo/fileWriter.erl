-module(fileWriter).
-compile([export_all]).
-export([write_to_file/1]).

write_to_file(Prime) ->
	file:write_file("primes.txt", io_lib:fwrite("~p\n", [Prime]),[append]).