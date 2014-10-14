-module(eshop).

-export([
  new_registration/2
  ,authenticate/2
  ,categories/2
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
    Json = try
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
      json_reply({CbId,<<"register">>},<<"ok">>,[{<<"msg">>,<<"Registration complete">>}])
    catch Error:Reason ->
      Rollback = estore_pgsql:rollback(),
      io:fwrite("Rolling back ~p ~p ~p ~n",[Error,Reason,Rollback]),
      eshop_logging:log_term(debug,[Error,Rollback]),
      json_reply({CbId,<<"register">>},<<"error">>,[{<<"msg">>,<<"Registration unsuccessful">>}])
    end;
  true ->
    eshop_logging:log_term(debug,undefined),
    io:fwrite("Stop registration ~p ~p ~p ~n",[UserKV,ShopperAddressKV,ShopperKV]),
    Json = json_reply({CbId,<<"register">>},<<"error">>,[{<<"msg">>,<<"Incomplete data">>}])
  end,
  reply(Sid,Json).

%% ----------------------------------------------------------------------------

authenticate({Sid,CbId},Data) ->
  ReqUserRecord = estore:json_to_record(Data),
  ReqEmail = ReqUserRecord#'user'.'email',
  ReqPassword = ReqUserRecord#'user'.'password',
  UserRecord = estore:find(pgsql,user,[{'email','=',ReqEmail},'and',{'password','=',ReqPassword}]), 
  Email = UserRecord#'user'.'email',
  Password = UserRecord#'user'.'password',
  if ReqEmail =:= Email andalso ReqPassword =:= Password ->
    UserId = UserRecord#'user'.'id',
    %% Retrieve shopper and user
    ShopperRecord = estore:find(pgsql,shopper,[{'user_id','=',UserId}]),
    UserRecordNoPass = UserRecord#'user'{'password' = ""}, 
    ShopperKV = estore_json:record_to_kv(ShopperRecord),
    UserKV = estore_json:record_to_kv(UserRecordNoPass),   
    %% Store user id in JWT token 
    Payload = [{user_id,UserId}],
    SecretKey = eshop_utls:get_env(basic_config,jwt_secret),
    Token = ejwt:encode(Payload,SecretKey),
    Json = json_reply({CbId,<<"login">>},<<"ok">>,[
      {<<"token">>,Token}
      ,{<<"type">>,<<"authenticated">>}
      ,{<<"data">>,[ShopperKV,UserKV]}
    ]);
  true -> 
    io:fwrite("UNAUTHORISED: ~p ~p ~p ~p ~n",[ReqEmail,Email,ReqPassword,Password]),
    Json = json_reply({CbId,<<"login">>},<<"error">>,[{<<"msg">>,<<"Ivalid Credentials">>}])
  end,
  reply(Sid,Json).

%% ----------------------------------------------------------------------------

%% @doc This function requires a valid token to return Categories.
categories({Sid,CbId},Token) ->
  SecretKey = eshop_utls:get_env(basic_config,jwt_secret),
  Json = case ejwt:decode(Token,SecretKey) of
    [{<<"user_id">>,_UserId}] ->
      CatsKV = case estore:find(pgsql,department,[],[],all,0) of
        Dept when is_tuple(Dept) -> [estore_json:record_to_kv(Dept)];
        Depts when is_list(Depts) -> estore_json:record_to_kv(Depts)
      end,
      json_reply({CbId,<<"categories">>},<<"ok">>,[
        {<<"type">>,<<"categories">>}
        ,{<<"data">>,CatsKV}
      ]);  
    Decoded ->
      io:fwrite("DECODED: ~p ~n",[Decoded]),
      json_reply({CbId,<<"categories">>},<<"error">>,[
        {<<"type">>,<<"unauthorised">>}
        ,{<<"data">>,<<"Invalid Token">>}
      ])
  end,
  reply(Sid,Json).

  
%% ----------------------------------------------------------------------------

reply(Sid,Resp) ->
  gproc:send(?HANDLER_KEY(Sid),Resp).

json_reply({CbId,ReqType},RespResult,DataKV) ->
  Json = [
    {<<"type">>,ReqType}
    ,{<<"cbid">>,CbId}
    ,{<<"data">>,[
      {<<"result">>,RespResult}
    ] ++ DataKV }
  ],
  jsx:encode(Json).










