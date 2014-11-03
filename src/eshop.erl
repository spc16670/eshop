-module(eshop).

-export([
  new_registration/2
  ,partials/2
  ,authenticate/2
  ,categories/4
  ,items/4
]).

-export([
  json_reply/3
  ,error_reply/5
  ,reply/2
]).

-include("eshop.hrl").
-include("pgsql.hrl").

%% ----------------------------------------------------------------------------
%% ----------------------------------------------------------------------------
%% ----------------------------------------------------------------------------

partials({Sid,CbId},Data) ->
 io:fwrite("PARTIALS: ~p~n",[Data]),
  Json = json_reply(
    {CbId,<<"partials">>}
    ,{<<"fetch">>,<<"ok">>}
    ,[{<<"partial">>,<<"template:)">>}]), 
  reply(Sid,Json).


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
  Action = eshop_utls:get_value(<<"action">>,Data,undefined),
  ReqUserRecord = estore:json_to_record(Data),
  ReqEmail = ReqUserRecord#'user'.'email',
  ReqPassword = ReqUserRecord#'user'.'password',
  Where = [{'email','=',ReqEmail},'and',{'password','=',ReqPassword}],
  case estore:find(pgsql,user,Where) of
    [] -> 
      Json = json_reply({CbId,<<"login">>},{Action,<<"error">>},[{<<"msg">>,<<"Not Recognised">>}]);
    [UserRecord] ->
      Email = UserRecord#'user'.'email',
      Password = UserRecord#'user'.'password',
      if ReqEmail =:= Email andalso ReqPassword =:= Password ->
        UserId = UserRecord#'user'.'id',
        %% Retrieve shopper and user
        [ShopperRecord] = estore:find(pgsql,shopper,[{'user_id','=',UserId}]),
        UserRecordNoPass = UserRecord#'user'{'password' = ""}, 
        ShopperKV = estore_json:record_to_kv(ShopperRecord),
        UserKV = estore_json:record_to_kv(UserRecordNoPass),   
        %% Store user id in JWT token 
        Payload = [{user_id,UserId}],
        SecretKey = eshop_utls:get_env(basic_config,jwt_secret),
        Token = ejwt:encode(Payload,SecretKey),
        Json = json_reply(
	  {CbId,<<"login">>}
	  ,{Action,<<"ok">>}
	  ,[{<<"token">>,Token}
            ,{<<"type">>,<<"multiple">>}
            ,{<<"data">>,[ShopperKV,UserKV]}
          ]
        );
      true -> 
        io:fwrite("UNAUTHORISED: ~p ~p ~p ~p ~n",[ReqEmail,Email,ReqPassword,Password]),
        Json = json_reply({CbId,<<"login">>},{Action,<<"error">>},[{<<"msg">>,<<"Ivalid Credentials">>}])
      end;
    Multiple when is_list(Multiple) ->
      io:fwrite("Multiple: ~p ~p ~n",[ReqEmail,ReqPassword]),
      Json = json_reply({CbId,<<"login">>},{Action,<<"error">>},[{<<"msg">>,<<"Multiple">>}])
  end,   
  reply(Sid,Json).

%% ----------------------------------------------------------------------------

%% @doc This function requires a valid token to return Categories.

categories({Sid,CbId},<<"delete">>,Record,_TokenData) ->
  {Result,Msg} = case estore:delete(pgsql,Record) of
    {ok,_Count} -> {<<"ok">>,<<"Deleted">>};
    {error,Error} -> io:fwrite("Could not Delete: ~p~n",[Error]), {<<"error">>,<<"Could not delete">>}
  end,
  Json = json_reply(
    {CbId,<<"categories">>}
    ,{<<"delete">>,Result}
    ,[{<<"msg">>,Msg}]),
  reply(Sid,Json);

categories({Sid,CbId},<<"upsert">>,Record,_TokenData) ->
  categories({Sid,CbId},<<"add">>,Record,_TokenData);
categories({Sid,CbId},<<"add">>,Record,_TokenData) ->
  {Result,Msg} = case estore:save(pgsql,Record) of
    {ok,_Id} -> {<<"ok">>,<<"Saved">>};
    {error,_Error} -> {<<"error">>,<<"Could not save">>}
  end,
  Json = json_reply(
    {CbId,<<"categories">>}
    ,{<<"add">>,Result}
    ,[{<<"msg">>,Msg}]), 
  reply(Sid,Json);
 
categories({Sid,CbId},<<"fetch">>,_Data,_TokenData) ->
  {Result,Msg,Count,CatsKV} = case estore:find(pgsql,category,[],[],all,0) of
    [] -> 
      {<<"error">>,<<"No Categories">>,<<"0">>,[]};
    Dept when is_tuple(Dept) -> 
      {<<"ok">>,<<"ok">>,<<"1">>,[estore_json:record_to_kv(Dept)]};
    Depts when is_list(Depts) -> 
      {<<"ok">>,<<"multiple">>,eshop_utls:integer_to_binary(length(Depts))
        ,estore_json:record_to_kv(Depts)}
  end,
  Json = json_reply(
    {CbId,<<"categories">>}
    ,{<<"fetch">>,Result}
    ,[{<<"msg">>,Msg},{<<"count">>,Count},{<<"data">>,CatsKV}]
  ), 
  reply(Sid,Json).

%% ----------------------------------------------------------------------------

%% @doc This function requires a valid token to return Items.

items({Sid,CbId},<<"delete">>,Record,_TokenData) ->
  {Result,Msg} = case estore:delete(pgsql,Record) of
    {ok,_Count} -> {<<"ok">>,<<"Deleted">>};
    {error,_Error} -> {<<"error">>,<<"Could not delete">>}
  end,
  Json = json_reply(
    {CbId,<<"items">>}
    ,{<<"delete">>,Result}
    ,[{<<"msg">>,Msg}]),
  reply(Sid,Json);

items({Sid,CbId},<<"upsert">>,Record,_TokenData) ->
  items({Sid,CbId},<<"add">>,Record,_TokenData);
items({Sid,CbId},<<"add">>,Record,_TokenData) ->
  {Result,Msg} = case estore:save(pgsql,Record) of
    {ok,_Id} -> {<<"ok">>,<<"Saved">>};
    {error,_Error} -> {<<"error">>,<<"Could not save">>}
  end,
  Json = json_reply(
    {CbId,<<"items">>}
    ,{<<"add">>,Result}
    ,[{<<"msg">>,Msg}]), 
  reply(Sid,Json);
 
items({Sid,CbId},<<"fetch">>,Data,_TokenData) ->
  Offset = eshop_utls:get_value(<<"offset">>,Data,undefined), 
  Limit = eshop_utls:get_value(<<"limit">>,Data,undefined), 
  CategoryId = eshop_utls:get_value(<<"category_id">>,Data,undefined), 
  {Result,Msg,Count,CatsKV} = case estore:find(pgsql,item,
    [{'category_id','=',CategoryId}],[],Limit,Offset) of
    [] -> 
      {<<"error">>,<<"No Items">>,<<"0">>,[]};
    Dept when is_tuple(Dept) -> 
      {<<"ok">>,<<"ok">>,<<"1">>,[estore_json:record_to_kv(Dept)]};
    Depts when is_list(Depts) -> 
      {<<"ok">>,<<"multiple">>,eshop_utls:integer_to_binary(length(Depts))
        ,estore_json:record_to_kv(Depts)}
  end,
  Json = json_reply(
    {CbId,<<"items">>}
    ,{<<"fetch">>,Result}
    ,[{<<"msg">>,Msg},{<<"count">>,Count},{<<"data">>,CatsKV}]
  ), 
  reply(Sid,Json).
  
%% ----------------------------------------------------------------------------

reply(Sid,Resp) ->
  gproc:send(?HANDLER_KEY(Sid),Resp).

json_reply({CbId,Operation},{Action,OkError},DataKV) ->
  Json = [
    {<<"operation">>,Operation}
    ,{<<"cbid">>,CbId}
    ,{<<"data">>,[
      {<<"action">>,Action}
      ,{<<"result">>,OkError}
    ] ++ DataKV }
  ],
  jsx:encode(Json).

error_reply({Sid,CbId},Operation,Action,OkError,DataKV) ->
  Json = json_reply({CbId,Operation},{Action,OkError},DataKV),
  reply(Sid,Json).


