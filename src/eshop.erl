-module(eshop).

-export([
  new_registration/2
]).

-export([
  reply/2
]).

-include("eshop.hrl").
-include("pgsql.hrl").

%% ----------------------------------------------------------------------------
%% ----------------------------------------------------------------------------
%% ----------------------------------------------------------------------------

new_registration({Sid,CbId},Data) ->
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
      {ok,committed} = estore_pgsql:commit(),
      Json = json_reply({CbId,<<"register">>},{<<"ok">>,<<"Registration complete">>}),
      reply(Sid,Json)
    catch Error:Reason ->
      Rollback = estore_pgsql:rollback(),
      io:fwrite("Rolling back ~p ~p ~p ~n",[Error,Reason,Rollback]),
      eshop_logging:log_term(debug,[Error,Rollback])
    end;
  true ->
    eshop_logging:log_term(debug,undefined),
    io:fwrite("Stop registration ~p ~p ~p ~n",[UserKV,ShopperAddressKV,ShopperKV]),
    ok
  end.

%% ----------------------------------------------------------------------------

reply(Sid,Resp) ->
  gproc:send(?HANDLER_KEY(Sid),Resp).

json_reply({CbId,RequestType},{ResponseResult,ResponseMsg}) ->
  Json = [
    {<<"type">>,RequestType}
    ,{<<"cbid">>,CbId}
    ,{<<"data">>,[
      {<<"result">>,ResponseResult}
      ,{<<"msg">>,ResponseMsg}
    ]}
  ],
  jsx:encode(Json).










