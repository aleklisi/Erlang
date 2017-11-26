-module(deploy).
-compile([export_all,debug_info]).
-import(turbine,[turbine/4]).
-import(plant,[start/0,send_to_all_from_list/2]).
-import(weather,[weather_module_start/3]).

deploy_turbine(TurbineParameters,WeatherModulePID) ->
    {State,Radius,Efficiency,PowerPlantPID} = TurbineParameters,
    NewTurbinePID = spawn(turbine,turbine,[State,Radius,Efficiency,PowerPlantPID,WeatherModulePID]),
    io:fwrite("Deploy ~p new turbine ~p was created\n", [self(),NewTurbinePID]),
    NewTurbinePID.

deploy_multiple_turbines(_,_,0) -> [];
deploy_multiple_turbines(TurbineParameters,WeatherModulePID,N) -> 
    [deploy_turbine(TurbineParameters,WeatherModulePID)] ++ deploy_multiple_turbines(TurbineParameters,WeatherModulePID,N - 1).


deploy_symulation(NumberOfWindTurbines,StepsLeft,TurbineParameters,TimeLimitInSeconds) ->
    WeatherModulePID = weather_module_start("airSpeed.txt","windiness.txt","airTemp.txt"),
    {State,Radius,Efficiency} = TurbineParameters,
    PlantPID = spawn(plant,start,[]),
    io:fwrite("Deploy ~p new plant ~p was created\n",[self(),PlantPID]),
    TurbinesPIDs = deploy_multiple_turbines({State,Radius,Efficiency,PlantPID},WeatherModulePID,NumberOfWindTurbines),
    PlantPID ! {windTurbinePIDs,TurbinesPIDs},
    run(StepsLeft,TimeLimitInSeconds,PlantPID,TurbinesPIDs,WeatherModulePID).

run(0,TimeLimitInSeconds,PlantPID,TurbinesPIDs,WeatherModulePID) -> 
    timer:sleep(TimeLimitInSeconds * 1000),
    PlantPID ! endOfSymulation,
    WeatherModulePID ! endOfSymulation,
    send_to_all_from_list(TurbinesPIDs,endOfSymulation);
run(StepsLeft,TimeLimitInSeconds,PlantPID,TurbinesPIDs,WeatherModulePID) ->
    timer:sleep(200),
    io:fwrite("Step ~p started\n",[StepsLeft]),
    Message = {getPowerFromTurbines,StepsLeft},
    PlantPID ! Message,
    run(StepsLeft - 1,TimeLimitInSeconds,PlantPID,TurbinesPIDs,WeatherModulePID).


example_run() -> deploy_symulation(2,2,{working,1,5},2).