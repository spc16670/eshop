-module(eshop_db).

-export([
  init/0
]).

-include("$RECORDS_PATH/estore.hrl").

%% -----------------------------------------------------------------------------
%% -----------------------------------------------------------------------------
%% -----------------------------------------------------------------------------

init() ->
  init_mnesia()
  ,init_pgsql().


%% -----------------------------------------------------------------------------
%% ----------------------------- BASIC CONFIG ----------------------------------
%% -----------------------------------------------------------------------------

%% @doc Loads basic_config into mnesia in a transaction safe manner.

init_mnesia() ->
  estore:init(mnesia),
  init_mnesia_config().

init_mnesia_config() ->
  BasicConfig = eshop_utls:get_env(basic_config),
  lists:foldl(fun({Key,Val},Acc) -> 
    Acc ++ [estore:save(mnesia,
      #'basic_config'{'key'=Key,'value'=Val})]
  end,[],BasicConfig).  

init_pgsql() ->
  estore_pgsql:drop_schema(lamazone),
  estore:init(pgsql),
  insert_test_user(),
%  insert_test_category(),
  ok.

%% @private

insert_test_user() ->
  try
    estore_pgsql:transaction(),
    case estore:find(pgsql,address_type,[{'id','=',1}]) of
      [] ->
        AddTypeModel = estore:new(pgsql,address_type),
        AddTypeRec = AddTypeModel#'address_type'{'type' = "Home"},
        estore:save(pgsql,AddTypeRec);
      _ -> ok
    end,
    User = estore:new(pgsql,user),
    UserRecord = User#'user'{'email'="asdf@asdf.asdf", 'password'="asdfqwer"},
    {ok,UserId} = estore:save(pgsql,UserRecord),
    Shopper = estore:new(pgsql,shopper),
    ShopperRecord = Shopper#'shopper'{'fname'="szymon",'mname'="piotr"},
    ShopperIdRecord = ShopperRecord#'shopper'{ 'user_id' = UserId},
    {ok,ShopperId} = estore:save(pgsql,ShopperIdRecord),
    ShopperAddress = estore:new(pgsql,shopper_address),
    ShopperAddressRecord = ShopperAddress#'shopper_address'{'line1'="56 Cecil St",'city'="Glasgow"},
    ShopperAddressTypedRecord =
    ShopperAddressRecord#'shopper_address'{'shopper_id'=ShopperId,'type'=1},
    {ok,ShopperAddressId} = estore:save(pgsql,ShopperAddressTypedRecord),
    estore_pgsql:commit()
  catch Error:Reason ->
    io:fwrite("Rolling back ~p ~p ~n",[Error,Reason]),
    eshop_logging:log_term(debug,[Error]),
    estore_pgsql:rollback()
  end.

%% @private

insert_test_category() ->
  try
    estore_pgsql:transaction(),
    case estore:find(pgsql,department,[{'id','=',1}]) of
      [] ->
        Model = estore:new(pgsql,department),
        Record = Model#'department'{'name' = "Starters",'description'="Try our delicious starters"},
        estore:save(pgsql,Record);
      _ -> ok
    end,
    estore_pgsql:commit()
  catch Error:Reason ->
    io:fwrite("Rolling back ~p ~p ~n",[Error,Reason]),
    eshop_logging:log_term(debug,[Error]),
    estore_pgsql:rollback()
  end.



