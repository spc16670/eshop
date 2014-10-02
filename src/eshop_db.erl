-module(eshop_db).

-export([
  init/0
]).


-include("$RECORDS_PATH/estore.hrl").

%% -----------------------------------------------------------------------------
%% -----------------------------------------------------------------------------
%% -----------------------------------------------------------------------------

init() ->
  init_mnesia().


%% -----------------------------------------------------------------------------
%% ----------------------------- BASIC CONFIG ----------------------------------
%% -----------------------------------------------------------------------------

%% @doc Loads basic_config into mnesia in a transaction safe manner.

init_mnesia() ->
  estore:init(mnesia),
  init_mnesia_config().

init_mnesia_config() ->
  Config = eshop_utls:get_config(),
  BasicConfig = proplists:get_value(basic_config,Config),
  lists:foldl(fun({Key,Val},Acc) -> 
    Acc ++ [estore:save(mnesia,
      #'basic_config'{'config_key'=Key,'config_value'=Val})]
  end,[],BasicConfig).  

