-module(deploy).
-compile([export_all,debug_info]).
-import(turbine,[turbine/6]).
-import(plant,[start/0,send_to_all_from_list/2]).
-import(weather,[weather_module_start/3]).

deploy_turbine(Model,TurbineParameters,WeatherModulePID) ->
    {State,Radius,Efficiency,PowerPlantPID} = TurbineParameters,
    NewTurbinePID = spawn(turbine,turbine,[Model,State,Radius,Efficiency,PowerPlantPID,WeatherModulePID]),
    io:fwrite("Deploy ~p new turbine ~p was created\n", [self(),NewTurbinePID]),
    NewTurbinePID.

deploy_multiple_turbines(_,_,0,_) -> [];
deploy_multiple_turbines(TurbineParameters,WeatherModulePID,N,Model) -> 
    [deploy_turbine(Model,TurbineParameters,WeatherModulePID)] ++ deploy_multiple_turbines(TurbineParameters,WeatherModulePID,N - 1,Model).


deploy_symulation(NumberOfWindTurbines,StepsLeft,TurbineParameters,ModelOfTurbine) ->
    WeatherModulePID = weather_module_start("airSpeed.txt","windiness.txt","airTemp.txt"),
    {State,Radius,Efficiency} = TurbineParameters,
    PlantPID = spawn(plant,start,[]),
    io:fwrite("Deploy ~p new plant ~p was created\n",[self(),PlantPID]),
    TurbinesPIDs = deploy_multiple_turbines({State,Radius,Efficiency,PlantPID},WeatherModulePID,NumberOfWindTurbines,ModelOfTurbine),
    PlantPID ! {windTurbinePIDs,TurbinesPIDs},
    run(StepsLeft,PlantPID,TurbinesPIDs,WeatherModulePID).

run(0,PlantPID,TurbinesPIDs,WeatherModulePID) -> 
    timer:sleep(200),
    PlantPID ! endOfSymulation,
    WeatherModulePID ! endOfSymulation,
    send_to_all_from_list(TurbinesPIDs,endOfSymulation);
run(StepsLeft,PlantPID,TurbinesPIDs,WeatherModulePID) ->
    timer:sleep(200),
    io:fwrite("Step ~p started\n",[StepsLeft]),
    Message = {getPowerFromTurbines,StepsLeft},
    PlantPID ! Message,
    run(StepsLeft - 1,PlantPID,TurbinesPIDs,WeatherModulePID).


example_run() -> deploy_symulation(2,2,{working,1,5},"theoreticalTurbine").