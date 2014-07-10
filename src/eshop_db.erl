-module(eshop_db).

-export([
  squery/2
  ,equery/3
  ,init/0
  ,drop_schema/0
  ,insert_address/5
  ,insert_shopper/10
  ,select_shopper/1
  ,select_shopper_address/1
]).

-include("eshop_sql.hrl").

%% -----------------------------------------------------------------------------
%% -----------------------------------------------------------------------------
%% -----------------------------------------------------------------------------

squery(PoolName, Sql) ->
  poolboy:transaction(PoolName, fun(Worker) ->
    gen_server:call(Worker, {squery, Sql}) 
  end).

equery(PoolName, Stmt, Params) ->
  poolboy:transaction(PoolName, fun(Worker) ->
    gen_server:call(Worker, {equery, Stmt, Params})
  end).

init() ->
  run_sql_macro(?CREATE_SCHEMA),
  run_sql_macro(?CREATE_SHOPPER_ADDRESS),
  create_index("shopper_address_ix"),
  run_sql_macro(?CREATE_SHOPPER),
  create_index("shopper_ix").
    
create_index(Name) when Name =:= "shopper_ix" ->
  create_index(Name,?CREATE_SHOPPER_IX);
create_index(Name) when Name =:= "shopper_address_ix" ->
  create_index(Name,?CREATE_SHOPPER_ADDRESS_IX).

create_index(Name,Macro) ->
  case squery(?POOL,?INDEX_EXISTS(Name)) of
    {ok,_Diag,[{<<"1">>}]} -> ok;
    {ok,_Diag,[]} -> squery(?POOL,Macro);
    {error,Error} -> io:fwrite("~p ~p ~p ~n",[?LINE,?MODULE, Error])
  end.

run_sql_macro(Macro) ->
  case squery(?POOL,Macro) of
    {ok,[],[]} -> {ok,[]};
    {ok,_D,[]} -> {ok,[]};
    {ok,No} when is_number(No) -> {ok,No};
    {ok,_No,_Col,[{Id}]} when is_binary(Id) -> {ok,Id};
    {ok,D,R} when is_list(R) -> 
      {ok,proplistify(R,lists:map(fun({_C,N,_,_,_,_}) -> N end,D),[])};
    Error -> io:fwrite("~p ~p ~p ~n",[?LINE,?MODULE, Error])
  end.

proplistify([R|Rs],Cols,Result) ->
  RL = tuple_to_list(R),
  PropList = lists:zipwith(fun(X, Y) -> {X,Y} end,Cols,RL),
  proplistify(Rs,Cols,Result ++ PropList);
proplistify([],_Cols,Result) ->
  Result.

drop_schema() ->
  run_sql_macro(?DROP_SCHEMA).

insert_address(L1,L2,PS,CT,CO) ->
  L1S = binary_to_list(L1),
  L2S = binary_to_list(L2),
  PSS = binary_to_list(PS),
  CTS = binary_to_list(CT),
  COS = binary_to_list(CO),
  run_sql_macro(?INSERT_ADDRESS(L1S,L2S,PSS,CTS,COS)).

insert_shopper(E,P,F,L,G,A) ->
  ES = binary_to_list(E),
  PS = binary_to_list(P),
  FS = binary_to_list(F),
  LS = binary_to_list(L),
  GS = binary_to_list(G),
  AS = binary_to_list(A),
  run_sql_macro(?INSERT_SHOPPER(ES,PS,FS,LS,GS,AS)).  

insert_shopper(E,PS,F,L,G,L1,L2,P,CT,CO) -> 
  try_insert_address(insert_address(L1,L2,P,CT,CO),{E,PS,F,L,G}).

try_insert_address({ok,A},{E,P,F,L,G}) ->
  try_insert_shopper(insert_shopper(E,P,F,L,G,A));
try_insert_address(_,{_E,_P,_F,_L,_G}) ->
  error.

try_insert_shopper({ok,_No}) ->
  ok;
try_insert_shopper({error,_Error}) ->
  error.

select_shopper(E) ->
  ES = binary_to_list(E),
  run_sql_macro(?SELECT_SHOPPER(ES)).

select_shopper_address(E) ->
  ES = binary_to_list(E),
  run_sql_macro(?SELECT_SHOPPER_ADDRESS(ES)).







  
