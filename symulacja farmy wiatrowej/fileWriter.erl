-module(fileWriter).
-compile([export_all,debug_info]).

%cd("C:/Users/sebac/Documents/Erlang/Programs/Erlang/symulacja farmy wiatrowej/").

make_symulation_resoults_directory(DirName) -> file:make_dir(DirName).

make_symulation_turbine_file([],_) -> ok;
make_symulation_turbine_file([H|T],DirName) -> 
    Filename = io_lib:fwrite("./" ++ DirName ++ "/Turbine" ++ "~p"++ ".csv",[H]),
    file:open(Filename,[write]),
    file:write_file(Filename, io_lib:fwrite("~p\r\n", [H])),
    make_symulation_turbine_file(T,DirName).

make_symulation_plant_file(DirName) ->
    Filename = "./" ++ DirName ++ "/Plant" ++ ".csv",
    file:open(Filename,[write]),
    ok.
    
make_all_files(NumberOfTurbines,DirName) ->
    make_symulation_resoults_directory(DirName),
    make_symulation_plant_file(DirName),
    make_symulation_turbine_file(NumberOfTurbines,DirName).

