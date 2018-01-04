-module(factorial_ser).
-author('AlekLisiecki').

%cd("C:/Users/sebac/Documents/Erlang/Programs/Erlang/gen_server/factorial/").

-behaviour(gen_server).
-export([start_link/0,stop/0,f/0,factorial/1]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {}).
-define(SERVER, ?MODULE).
%%====================================================================
%% API
%%====================================================================
%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

stop() -> 
    gen_server:stop(?SERVER).

factorial(Val) -> 
    gen_server:call(?SERVER,{factorial,Val}).

f() ->
gen_server:call(?SERVER,f).


%%====================================================================
%% gen_server callbacks
%%====================================================================
%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init([]) ->
    %process_flag(trap_exit,true),
    io:fwrite("Server started!!!\n",[]),
    {ok, #state{}}.
%%--------------------------------------------------------------------
%% Function: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
%%--------------------------------------------------------------------
handle_call({factorial,Val}, _From, State) ->
    io:fwrite("handle_call ~p before call factorial_logic:factorial!!!\n",[{factorial,Val}]),  
    Reply = factorial_logic:factorial(Val),
    io:fwrite("handle_call ~p after call factorial_logic:factorial!!!\n",[{factorial,Val}]),  
    {reply, Reply, State};

handle_call(f, _From, State) ->
    io:fwrite("handle_call ~p before call factorial_logic:f!!!\n",[f]),  
    Reply = factorial_logic:factorial(5),
    io:fwrite("handle_call ~p after call factorial_logic:f!!!\n",[f]),  
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    io:fwrite("handle_call empty!!!\n",[]),  
  Reply = unknownRequest,
  {reply, Reply, State}.
%%--------------------------------------------------------------------
%% Function: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
%%--------------------------------------------------------------------
handle_cast(_Msg, State) ->
  {noreply, State}.
%%--------------------------------------------------------------------
%% Function: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
%%--------------------------------------------------------------------
handle_info(_Info, State) ->
    io:fwrite("handle_info\n",[]),
    {noreply, State}.
%%--------------------------------------------------------------------
%% Function: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    io:fwrite("Server stopped!!!\n",[]),
    ok.
%%--------------------------------------------------------------------
%% Func: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.