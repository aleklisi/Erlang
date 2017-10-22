-module(writeToFile).
-compile([export_all]).

write_list_to_file(_,[]) -> io:fwrite("End");
write_list_to_file(Filename,[H|T]) ->
	file:write_file(Filename,H),
	file:write_file(Filename,"\n"),
	write_list_to_file(Filename,T).
	
