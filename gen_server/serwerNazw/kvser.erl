-module(kvser).
-author('AlekLisiecki').

%cd("C:/Users/sebac/Documents/Erlang/Programs/Erlang/gen_server/serwerNazw/").

-behaviour(gen_server).
-export([start_link/0, stop/0, add/1, del/1,val/1,hist/0,clr_hist/0,val_exists/1,error_call/0]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-define(SERVER, ?MODULE).
%%====================================================================
%% API
%%====================================================================
%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link() -> gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

stop() -> gen_server:stop(?SERVER).

%dodawanie rekordu (synchronicznie)
add({K,V}) -> gen_server:call(?SERVER,{add,{K,V}}).
%usuwanie rekordu (synchronicznie)
del(K) -> gen_server:call(?SERVER,{del,K}).
%pobieranie wartości skojarzonej z kluczem (synchronicznie)
val(K) -> gen_server:call(?SERVER,{val,K}).
%pobieranie historii wszystkich operacji wykonanych na serwerze (synchronicznie)
hist() -> gen_server:call(?SERVER,hist).
%kasowanie historii (asynchronicznie)
clr_hist() -> gen_server:call(?SERVER,clr_hist).
%sprawdzanie czy wartość występuje w bazie
val_exists(V) -> gen_server:call(?SERVER,{val_exists,V}).
%error call
error_call() ->  gen_server:call(?SERVER,error_call).
%%====================================================================
%% gen_server callbacks
%%====================================================================
init([]) ->
    process_flag(trap_exit,true),
    io:fwrite("Server started!!!\n",[]),
    {ok, {[],maps:new()}}.

handle_call({add,{K,V}},_From,{Hist,Dict}) ->
    NewHist = Hist ++ [{add,K,V}],
    NewDict = maps:put(K,V,Dict),
    {reply, ok, {NewHist,NewDict}};
    
handle_call({del,K},_From,{Hist,Dict}) ->
    NewHist = Hist ++ [{del,K}],
    NewDict = maps:remove(K,Dict),
    {reply, ok, {NewHist,NewDict}};
    
handle_call({val,K},_From,{Hist,Dict}) ->
    NewHist = Hist ++ [{val,K}],
    case maps:is_key(K,Dict) of
        true -> {reply, maps:get(K,Dict), {NewHist,Dict}};
        false -> {reply, no_such_key, {NewHist,Dict}}
    end;

handle_call(hist,_From,{Hist,Dict}) ->
    NewHist = Hist ++ [hist],
    Reply = Hist,
    {reply, Reply, {NewHist,Dict}};
    
handle_call(clr_hist,_From,{_Hist,Dict}) ->
    NewHist = [clr_hist],
    {noreply, ok, {NewHist,Dict}};

handle_call({val_exists,V},_From,{Hist,Dict}) ->
    NewHist = Hist ++ [{val_exists,V}],
    Reply = lists:any(fun({_K,Val}) -> Val == V end ,maps:to_list(Dict)),
    {reply, Reply, {NewHist,Dict}};

handle_call(error_call, _From, {Hist,Dict}) ->
    NewHist = Hist ++ [error_call],
    maps:get(1,#{}),
    {noreply, {NewHist,Dict}};

handle_call(_Request, _From, State) ->
    io:fwrite("handle_call!!!\n",[]),  
    Reply = unknownRequest,
    {reply, Reply, State}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
    io:fwrite("handle_info\n",[]),
    {noreply, State}.

terminate(_Reason, _State) ->
    io:fwrite("Server stopped!!!\n",[]),
    ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.