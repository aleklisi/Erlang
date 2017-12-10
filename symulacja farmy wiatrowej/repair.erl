-module(repair).
-compile([export_all,debug_info]).

deploy_repair_module(NumberOfTeams) ->
    Teams = deploy_repair_teams(NumberOfTeams),
    spawn(repair,repair_teams_destribiutor,[Teams,[]]).

deploy_repair_teams(NumberOfTeams) ->
    TeamsPIDS = lists:map(
        fun(X) -> spawn(repair,repair_team,[]) end,
        [X || X <- lists:seq(1,NumberOfTeams)]
    ).

repair_teams_destribiutor(RepairTeams,TurbinesToRepair) -> 
    receive
        endOfSymulation -> io:fwrite("repair_teams_destribiutor: End of Symulation ~p\n",[self()]);
        tryFixing -> 
            RemainingTurbinesToRepair = try_fixing(RepairTeams,TurbinesToRepair),
            repair_teams_destribiutor(RepairTeams, RemainingTurbinesToRepair);
        {TurbinePID,needsFixing} -> 
            repair_teams_destribiutor(RepairTeams,TurbinesToRepair ++ [TurbinePID])
        end.

try_fixing(RepairTeams,TurbinesToRepair) -> 
    NumberOfTeams = length(RepairTeams),
    

repair_team(State) ->
    receive
        endOfSymulation -> io:fwrite("repair_team: End of Symulation ~p\n",[self()]);
        {TurbinePID,needsFixing} -> fix(TurbinePID)
    end.

%add some prpability maybe
fix(TurbinePID) -> TurbinePID ! {newState,working}.