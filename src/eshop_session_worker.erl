-module(eshop_session_worker).

-behaviour(gen_server).
 
-export([start_link/1]).
 
%% gen_server callbacks
-export([
  init/1
  ,handle_call/3
  ,handle_cast/2
  ,handle_info/2
  ,terminate/2
  ,code_change/3
]).

-include("eshop.hrl").

-define(SESSION_TIMEOUT,10000). 
-define(EXIT_TIMEOUT,1000).
-record(state, {sid}).
 
start_link(Args) ->
  gen_server:start_link(?MODULE, Args, []).


init(Args) ->
  gproc:reg(?WORKER_KEY(Args),ignore),
  {ok, #state{sid=Args}, ?SESSION_TIMEOUT}.
 
handle_call(Msg, _From, State) ->
  io:fwrite("call ~p~n",[Msg]),
  {reply, ignored, State, ?SESSION_TIMEOUT}.

handle_cast(stop, State) ->
  {stop, normal, State};
handle_cast(Msg, State) ->
  io:fwrite("cast ~p~n",[Msg]),
  {noreply, State, ?SESSION_TIMEOUT}.

%% -- termination 
handle_info({conn_terminate}, State) ->
  {noreply, State,?EXIT_TIMEOUT};

%% -- timeout
handle_info(timeout, State) ->
  gen_server:cast(self(),stop),
  {noreply, State};

%% -- login
handle_info([{Mid,Msg},Cid], #state{sid=Sid} = State) when Mid =:= <<"login">> ->
  io:fwrite("Info: ~p~n",[Msg]),
  Resp = eshop_session:authenticate(Msg),
  io:fwrite("Resp: ~p~n",[Resp]),
  gproc:send(?HANDLER_KEY(Sid),[{<<"data">>,[{Mid,Resp}]},Cid]),  
  {noreply, State,?SESSION_TIMEOUT};

%% -- registration
handle_info([{Mid,Msg},Cid], #state{sid=Sid} = State) when Mid =:= <<"register">> ->
  io:fwrite("Register: ~p~n",[Msg]),
  Result = eshop_db:insert_shopper(
    eshop_utls:get_value(<<"email">>,Msg,<<"">>)
    ,eshop_utls:get_value(<<"password">>,Msg,<<"">>)
    ,eshop_utls:get_value(<<"fname">>,Msg,<<"">>)
    ,eshop_utls:get_value(<<"lname">>,Msg,<<"">>)
    ,eshop_utls:get_value(<<"gender">>,Msg,<<"">>)
    ,eshop_utls:get_value(<<"addressline1">>,Msg,<<"">>)
    ,eshop_utls:get_value(<<"addressline2">>,Msg,<<"">>)
    ,eshop_utls:get_value(<<"postcode">>,Msg,<<"">>)
    ,eshop_utls:get_value(<<"city">>,Msg,<<"">>) 
    ,eshop_utls:get_value(<<"country">>,Msg,<<"UK">>)
  ), Resp = atom_to_binary(Result,latin1),
  gproc:send(?HANDLER_KEY(Sid),[{<<"data">>,[{Mid,Resp}]},Cid]),
  {noreply, State,?SESSION_TIMEOUT}.

terminate(_Reason, #state{sid=Sid} = _State) ->
  gproc:unreg(?WORKER_KEY(Sid)),
  ok.
 
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

