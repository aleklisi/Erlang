-module(plant).
-author('AlekLisiecki').
-behaviour(supervisor).
-export([create_turbine_name/1, start_link/1, create_wind_turbines/1]).
-export([init/1]).
-define(SERVER, ?MODULE).

start_link(NumberOfTurbines) when NumberOfTurbines > 0 ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, [NumberOfTurbines]);

start_link(_) -> {error,"Wrong number of turbines."}.

init([NumberOfTurbines]) ->
    RestartStrategy = one_for_one,
    MaxRestarts = 0,
    MaxSecondsBetweenRestarts = 30,

    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    Children = create_wind_turbines(NumberOfTurbines),
    {ok, {SupFlags, Children}}.

%===========================================================================

create_wind_turbines(NumberOfTurbines) when NumberOfTurbines =< 0 -> [];

create_wind_turbines(NumberOfTurbines) ->
    NewNumberOfTurbines = NumberOfTurbines - 1,
    Restart = permanent,
    Shutdown = 2000,
    Type = worker,
    TurbineName = create_turbine_name(NumberOfTurbines),
    AChild = {TurbineName, {turbine, start_link, [TurbineName]},
              Restart, Shutdown, Type, [turbine]},
    [AChild] ++ create_wind_turbines(NewNumberOfTurbines).

create_turbine_name(Num) ->
    list_to_atom(lists:flatten(io_lib:format("turbine~p", [Num]))).