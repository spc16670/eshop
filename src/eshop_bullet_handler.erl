-module(eshop_bullet_handler).

-export([init/4]).
-export([stream/3]).
-export([info/3]).
-export([terminate/2]).

-include("eshop.hrl").

-record(state,{sid}).


%% ------------------------------------------------------------------
%% @private API
%%

init(_Transport, Req, _Opts, _Active) ->
  {[Sid], Req1} = cowboy_req:path_info(Req),
  ensure_worker_running(Sid),
  ensure_registered(Sid),
  {ok, Req1, #state{sid=Sid}}.

stream(Data, Req, #state{sid=Sid}=State) ->  
  send(Sid,Data),
  {ok, Req, State}.

info(Json, Req, State) ->
  io:fwrite("RESPONSE JSON IN BULLET HANDLER: ~p ~n",[Json]),
  {reply, Json, Req, State}.

terminate(_Req,#state{sid=Sid}=_State) ->
  %% GProc manages the unregistering when process dies
  send(Sid,{conn_terminate}),
  ok.

%% ------------------------------------------------------------------
%% @doc Sends a message to the session process in an asynchronous manner.
%%

send(Sid,Msg) ->
  case ensure_worker_running(Sid) of
    ok ->
      gproc:send(?WORKER_KEY(Sid),Msg);
    Other -> eshop_log:log_term(error,{?MODULE,?LINE,Other})
  end.

%% ------------------------------------------------------------------
%% @doc Ensures the session process is available for this handler
%%

ensure_worker_running(Sid) ->
  case gproc:where(?WORKER_KEY(Sid)) of
    undefined -> 
      eshop_session_sup:start_session(Sid),
      case gproc:await(?WORKER_KEY(Sid), 1000) of
	{Pid,_Val} when is_pid(Pid) -> ok;
	Else -> eshop_log:log_term(debug,{?MODULE,?LINE,Else}), error 
      end;
    Pid when is_pid(Pid) -> ok;
    Other -> eshop_log:log_term(debug,{?MODULE,?LINE,Other}), error
  end.

%% ------------------------------------------------------------------
%% @doc Ensures this bullet handler process is registered with Gproc.
%%

ensure_registered(Sid) ->
  case gproc:where(?HANDLER_KEY(Sid)) of
    undefined ->
      gproc:reg(?HANDLER_KEY(Sid),self());
    _ -> ok
  end.

