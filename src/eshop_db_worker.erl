-module(eshop_db_worker).

-behaviour(gen_server).

-behaviour(poolboy_worker).

-export([start_link/1]).
-export([init/1
  ,handle_call/3
  ,handle_cast/2
  ,handle_info/2
  ,terminate/2
  ,code_change/3
]).

-record(state, {conn}).

%% -----------------------------------------------------------------------------

start_link(Args) ->
  gen_server:start_link(?MODULE, Args, []).

init(Args) ->
  process_flag(trap_exit, true),
  Host = proplists:get_value(hostname, Args),
  Db = proplists:get_value(database, Args),
  Uname = proplists:get_value(username, Args),
  Pass = proplists:get_value(password, Args),
  case pgsql:connect(Host, Uname, Pass, [{database, Db}]) of
    {ok,Conn} -> ok;
    {error,Error} -> io:fwrite("~p~n",[Error]), Conn = []
  end,
  {ok, #state{conn=Conn}}.

handle_call({squery, Sql}, _From, #state{conn=Conn}=State) ->
  {reply, pgsql:squery(Conn, Sql), State};
handle_call({equery, Stmt, Params}, _From, #state{conn=Conn}=State) ->
  {reply, pgsql:equery(Conn, Stmt, Params), State};
handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, #state{conn=Conn}) ->
  ok = pgsql:close(Conn),
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
