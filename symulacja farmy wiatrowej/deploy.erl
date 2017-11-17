-module(deploy).
-compile([export_all,debug_info]).
-import(turbine,[turbine/4]).
-import(plant,[start/0,send_to_all_from_list/2]).

deploy_turbine(TurbineParameters) ->
    {State,Radius,Efficiency,PowerPlantPID} = TurbineParameters,
    NewTurbinePID = spawn(turbine,turbine,[State,Radius,Efficiency,PowerPlantPID]),
    io:fwrite("Deploy ~p new turbine ~p was created\n", [self(),NewTurbinePID]),
    NewTurbinePID.

deploy_multiple_turbines(_,0) -> [];
deploy_multiple_turbines(TurbineParameters,N) -> 
    [deploy_turbine(TurbineParameters)] ++ deploy_multiple_turbines(TurbineParameters,N - 1).


deploy_symulation(NumberOfWindTurbines,StepsLeft,TurbineParameters) ->
    {State,Radius,Efficiency} = TurbineParameters,
    PlantPID = spawn(plant,start,[]),
    io:fwrite("Deploy ~p new plant ~p was created\n",[self(),PlantPID]),
    TurbinesPIDs = deploy_multiple_turbines({State,Radius,Efficiency,PlantPID},NumberOfWindTurbines),
    PlantPID ! {windTurbinePIDs,TurbinesPIDs},
    run(StepsLeft,PlantPID,TurbinesPIDs).

run(0,PlantPID,TurbinesPIDs) -> 
    PlantPID ! endOfSymulation,
    timer:sleep(1000),
    send_to_all_from_list(TurbinesPIDs,endOfSymulation);
run(StepsLeft,PlantPID,TurbinesPIDs) ->
    Message = {getPowerFromTurbines,StepsLeft},
    PlantPID ! Message,
    run(StepsLeft - 1, PlantPID,TurbinesPIDs).


example_run() -> deploy_symulation(3,3,{working,1,5}).