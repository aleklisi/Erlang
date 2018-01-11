-module(turbine).
-author('AlekLisiecki').
-behaviour(gen_server).
-export([start_link/1, stop/1, get_power/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%-export([stop/0,get_state/1, change_state/2,start_link/0]).
%%====================================================================



start_link(ServerName) -> gen_server:start_link({local, ServerName}, ?MODULE, [ServerName], []).

stop(ServerName) -> gen_server:stop(ServerName).

get_power(ServerName) -> gen_server:call(ServerName, get_power).


%%====================================================================
%currently unused
%start_link() -> gen_server:start_link({local,turbine}, ?MODULE, [], []).

%stop() -> gen_server:stop(turbine).

%get_state(ServerName) -> gen_server:call(ServerName, get_state).

%change_state(NewState, ServerName) -> gen_server:call(ServerName, {change_state,NewState}).

%%====================================================================

init([]) ->
    io:fwrite("Turbine started!!!\n",[]),
    {ok, {working,[8.0]}};

init([ServerName]) ->
    FileName = atom_to_list(ServerName) ++ ".txt",
    WindsList = fileOps:read_file(FileName,"\r\n"),
    io:fwrite("Turbine ~p started!!!\n",[ServerName]),
    {ok, {working,WindsList}}.


handle_call(get_power,_From,State) ->
    {TurbineState,[H|T]} = State,
    Reply = exampleTurbine:run(TurbineState,H),
    {reply, Reply,{working, T ++ [H]}};
    
%handle_call(get_state,_From,State) ->
%    Reply = State,
%    {reply, Reply, State};
    
%handle_call({change_state,NewState},_From,_State) ->
%    Reply = ok,
%    {reply, Reply, NewState};
    
handle_call(_Request, _From, State) ->
    io:fwrite("handle_call!!!\n",[]),  
    Reply = unknownRequest,
    {reply, Reply, State}.

%%====================================================================

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
    io:fwrite("handle_info\n",[]),
    {noreply, State}.

terminate(_Reason, _State) ->
    io:fwrite("Turbine stopped!!!\n",[]),
    ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.