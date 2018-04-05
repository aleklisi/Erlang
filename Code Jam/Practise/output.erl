-module(output).
-author('AlekLisiecki').
-export([write_results_to_file/1, single_result/2]).

write_results_to_file(List) -> write_results_to_file(List,1).

write_results_to_file([],_) -> ok;
write_results_to_file([H|T],CaseNumber) ->
    FileOutput = single_result(CaseNumber,H),
    file:write_file("out.txt", FileOutput, [append]),
    write_results_to_file(T,CaseNumber + 1).

%for pancakes
%single_result(CaseNumber,impossible) ->
%    io_lib:format("Case #~p: IMPOSSIBLE\n",[CaseNumber]);
single_result(CaseNumber,CaseResult) -> 
    io_lib:format("Case #~p: ~p\n",[CaseNumber,CaseResult]).