-module(eshop_db_mnesia).

-export([
  create_tables/1
  ,init_load_config/0
  ,init_basic_config/0
  ,get_setting/1
  ,select_table/1
  ,empty_table/1
]).

-include_lib("stdlib/include/qlc.hrl").
-include_lib("../include/mnesia_records.hrl").

create_tables(Nodes) ->
  application:load(mnesia),
  Config = eshop_utls:get_config(),
  %% Read config and set dir variable for mnesia
  BConfig = proplists:get_value(basic_config,Config),
  %% Set mnesia dir
  case proplists:get_value(mnesia_dir,BConfig) of
    undefined ->
      MnesiaDir = filename:join(eshop_utls:root_dir(), "db"),
      application:set_env(mnesia,dir,MnesiaDir);
    MnesiaDir ->
      application:set_env(mnesia,dir,MnesiaDir)
  end,
  %% Set CRM table persistance
  case proplists:get_value(mnesia_location,BConfig) of
    ram_copies -> 
      CrmCopy = ram_copies;
    disc_copies ->
      CrmCopy = disc_copies,
      create_schema(Nodes);
    undefined ->
      CrmCopy = ram_copies
  end,
  application:start(mnesia),
  %% Create tables
  BasicConfig = {'basic_config', [{attributes, 
    ['config_key','config_value']},{CrmCopy, Nodes}]},
  Session = {'session_cache', [{attributes,
    ['hash_key','is_valid']},{CrmCopy, Nodes}]},
  Specs = [BasicConfig,Session],
  create_mnesia_table(Specs,[]).

%% @private

create_schema([Node|Nodes]) ->
  case mnesia:create_schema(Node) of
    ok ->
      ok;
    {error, {_,{already_exists,Node}}} ->
      schema_already_exists;
    {error, Error} ->
      Error
  end,
  create_schema(Nodes);
create_schema([]) ->
  ok.

%% @private {@link create_tables/1}. helper. 

create_mnesia_table([{Name,Atts}|Specs],_Created) ->
  case mnesia:create_table(Name,Atts) of
    {aborted,Reason} ->
      eshop_log:print_term(info,[[Name,"Aborted",Reason]]);
    {atomic, ok} -> 
       eshop_log:print_term(info,[Name,"OK"])
  end,
  create_mnesia_table(Specs,_Created);
create_mnesia_table([],_Created) ->
  ok.

init_load_config() ->
  init_basic_config().

%% -----------------------------------------------------------------------------
%% ----------------------------- BASIC CONFIG ----------------------------------
%% -----------------------------------------------------------------------------

%% @doc Loads basic_config into mnesia in a transaction safe manner.

init_basic_config() ->
  Config = eshop_utls:get_config(),
  %% Read config and set dir variable for mnesia
  BasicConfig = proplists:get_value(basic_config,Config),
  Transaction = fun() ->
  lists:foreach(fun({ConfigKeyValue, ConfigValue}) ->
    commit_record(#'basic_config'{'config_key'=ConfigKeyValue,
      'config_value'=ConfigValue})
  end, BasicConfig) end,
  mnesia:transaction(Transaction).

%% @doc Selects a basic_config value by config key.

get_setting(ConfigKey) ->
  case mnesia:dirty_read(basic_config,ConfigKey) of
    [] -> [];
    [Val] -> element(3,Val)
  end.

%% -----------------------------------------------------------------------------
%% --------------------------- HELPER FUNCTIONS --------------------------------
%% -----------------------------------------------------------------------------

%% @doc Prints basic_config to console.

select_table(Table) ->
  F = fun() -> qlc:e(qlc:q([X || X <- mnesia:table(Table)])) end,
  {atomic, Val} = mnesia:transaction(F),
  Val.

%% @doc Empties a table completely.

empty_table(TableName) ->
  DeleteFunc = fun() ->
    TableRecords = qlc:e(qlc:q([X || X <- mnesia:table(TableName)])),
    lists:foreach(fun(TableRecord) ->
      mnesia:delete_object(TableRecord)
    end, TableRecords)
  end,
  mnesia:transaction(DeleteFunc).

%% @doc Writes a record. Infers the table to write to by element(1,Record).

commit_record(Record) ->
  F = fun() -> 
    mnesia:write(Record) end,
  mnesia:transaction(F).
