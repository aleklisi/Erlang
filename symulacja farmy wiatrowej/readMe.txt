% Starting work instructions:

% Run your elrang envirement ("erl" comand in shell)

% Change directory to where all simulation files are (in my case):
cd("C:/Users/sebac/Documents/Erlang/Programs/Erlang/symulacja farmy wiatrowej").
% Compile all modules to get .beam files and LOAD them to  
c(turbine).
c(weather).
c(plant).
c(deploy).
c(exampleTurbine).
c(theoreticalTurbine).

% To run example simulation type in:
deploy:example_run().

% If you wish to run simulation with defferent parameters call:
% Fill parameters with follwoing:
% NumberOfWindTurbines is an integer grater than 0, 
% StepsLeft is an integer grater than 0,
% State = working | notworking
% Radius is an float grater than 0,
% Efficiency is an float grater than 0,
% ModelOfTurbine = "Endurance E-4160 Wind Turbine" |"theoreticalTurbine"

deploy:deploy_symulation(NumberOfWindTurbines,StepsLeft,{State,Radius,Efficiency},ModelOfTurbine).



