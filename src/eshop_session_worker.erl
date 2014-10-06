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
-include("pgsql.hrl").

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

handle_info(Req, #state{sid=Sid} = State)  ->
  Parsed = jsx:decode(Req),
  Type = eshop_utls:get_value(<<"type">>,Parsed,undefined),
  Data = eshop_utls:get_value(<<"data">>,Parsed,undefined),
  Result = dispatch_request({Type,Data},Sid),
  gproc:send(?HANDLER_KEY(Sid),[{<<"result">>,[{Mid,Resp}]},Cid]),
  {noreply, State, ?SESSION_TIMEOUT}.

terminate(_Reason, #state{sid=Sid} = _State) ->
  gproc:unreg(?WORKER_KEY(Sid)),
  ok.
 
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%% ----------------------------------------------------------------------------

dispatch_request({<<"register">>,Data},Sid) ->
  DataTuples = lists:foldl(fun(JsonKV,Acc) -> 
    Type = eshop_utls:get_value(<<"type">>,JsonKV,undefined),
    Acc ++ [{binary_to_atom(Type,'utf8'),JsonKV}]
  end,[],Data),
  UserKV = eshop_utls:get_value(user,DataTuples,undefined),
  ShopperAddressKV = eshop_utls:get_value(shopper_address,DataTuples,undefined),
  ShopperKV = eshop_utls:get_value(shopper,DataTuples,undefined),
  if UserKV /= undefined andalso 
      ShopperAddressKV /= undefined andalso 
      ShopperKV /= undefined ->
    try 
      estore_pgsql:transaction(),
      UserRecord = estore:json_to_record(UserKV),
      {ok,UserId} = estore:save(pgsql,UserRecord),
      ShopperRecord = estore:json_to_record(ShopperKV),
      ShopperIdRecord = ShopperRecord#'shopper'{ 'user_id' = UserId},
      {ok,ShopperId} = estore:save(pgsql,ShopperIdRecord),
      ShopperAddressRecord = estore:json_to_record(ShopperAddressKV),
      ShopperAddressTypedRecord = 
        ShopperAddressRecord#'shopper_address'{'shopper_id'=ShopperId,'type'=1},
      {ok,ShopperAddressId} = estore:save(pgsql,ShopperAddressTypedRecord),
      estore_pgsql:commit()
    catch Error:Reason -> 
      Rollback = estore_pgsql:rollback(),
      eshop_logging:log_term(debug,Rollback)
    end;
  true ->
    eshop_logging:log_term(debug,Rollback),
    io:fwrite("Stop registration ~p ~p ~p ~n",[UserKV,ShopperAddressKV,ShopperKV]),
    ok
  end;

dispatch_request({Type,Data},Sid) -> 
  io:fwrite("UNHANDLED::: ~p~n",[Data]).


