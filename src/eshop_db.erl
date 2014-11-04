-module(eshop_db).

-export([
  init/0
  ,insert_test_user/0
  ,insert_test_categories/0
  ,insert_test_items/0
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
  insert_test_categories(),
  insert_test_items(),
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
    UserRecord = User#'user'{'email'="asdf@asdf.asdf",'password'="asdfqwer",'access'=4},
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

insert_test_categories() ->
  insert_test_categories(test_categories()).

%% @private

insert_test_categories(Categories) ->
  lists:foldl(fun(E,Acc) -> 
    Acc ++ [insert_test_record(category,E)]
  end,[],Categories).

%% @private

test_categories() ->
  CatTuples = [
    {"Starters","Try our delicious starters"}
    ,{"Mains","Try our delicious mains"}
  ],
  lists:foldl(fun({Name,Desc},Acc) -> 
    Model = estore:new(pgsql,category),
    Acc ++ [Model#'category'{'name'=Name,'description'=Desc}]
  end,[],CatTuples).

%% @private

insert_test_items() ->
  insert_test_items(test_items()).

%% @private

insert_test_items(Items) ->
  lists:foldl(fun(E,Acc) -> 
    Acc ++ [insert_test_record(item,E)]
  end,[],Items).

%% @private

test_items() ->
  ItemTuples = [
    {"Soup",1,0.75,20,"Brocolli",250,1.235}
    ,{"Curry",2,2.95,20,"Hot",500,1.234}
    ,{"Pasta",2,1.95,20,"Aldente",500,1.234}
    ,{"Steak",2,4.95,20,"Medium",500,1.234}
  ],
  lists:foldl(fun({Name,CatId,Price,Quantity,Desc,Dim,Weight},Acc) -> 
    Model = estore:new(pgsql,item),
    Acc ++ [Model#'item'{'name'=Name,'category_id'=CatId
      ,'price'=Price,'quantity'=Quantity,'description'=Desc
      ,'dimensions'=Dim,'weight'=Weight}]
  end,[],ItemTuples).

%% @private

insert_test_record(_Type,Rec) ->
  try
    estore_pgsql:transaction(),
    {ok,_Id} = estore:save(pgsql,Rec),
    estore_pgsql:commit()
  catch Error:Reason ->
    io:fwrite("Rolling back ~p ~p ~n",[Error,Reason]),
    eshop_logging:log_term(debug,[Error]),
    estore_pgsql:rollback()
  end.


