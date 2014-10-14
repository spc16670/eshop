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

%% ---------------------------------------------------------------------------- 
%% ---------------------------------------------------------------------------- 
%% ---------------------------------------------------------------------------- 

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

handle_info(Req, #state{sid=Sid} = State)  ->
  Parsed = jsx:decode(Req),
  Type = eshop_utls:get_value(<<"type">>,Parsed,undefined),
  Data = eshop_utls:get_value(<<"data">>,Parsed,undefined),
  CbId = eshop_utls:get_value(<<"cbid">>,Parsed,undefined),
  dispatch_request({Type,Data,CbId},Sid),
  {noreply, State, ?SESSION_TIMEOUT}.

terminate(_Reason, #state{sid=Sid} = _State) ->
  gproc:unreg(?WORKER_KEY(Sid)),
  ok.
 
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%% ----------------------------------------------------------------------------

dispatch_request({<<"register">>,Data,CbId},Sid) ->
  eshop:new_registration({Sid,CbId},Data);

dispatch_request({<<"login">>,Data,CbId},Sid) ->
  eshop:authenticate({Sid,CbId},Data);

dispatch_request({<<"categories">>,Data,CbId},Sid) ->
  eshop:categories({Sid,CbId},Data);

dispatch_request({Type,Data,_CbId},_Sid) -> 
  io:fwrite("UNHANDLED::: ~p ~p ~n",[Type,Data]).


