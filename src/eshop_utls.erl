-module(eshop_utls).

-export([
  generate_hash/0
  ,root_dir/0
  ,priv_dir/0
  ,etc_dir/0
  ,get_config/0
  ,read_config/1
  ,get_value/3
  ,pool_name/0
  ,database/0
  ,get_env/1
  ,get_env/2
  ,gen_rand_int/2
]).

-include("eshop.hrl").

%% -----------------------------------------------------------------------------
 
generate_hash() ->
  Now = {_, _, Micro} = now(),
  Nowish = calendar:now_to_universal_time(Now),
  Nowsecs = calendar:datetime_to_gregorian_seconds(Nowish),
  Then = calendar:datetime_to_gregorian_seconds({{1970, 1, 1}, {0, 0, 0}}),
  Prefix = io_lib:format("~14.16.0b", [(Nowsecs - Then) * 1000000 + Micro]),
  list_to_binary(Prefix ++ to_hex(crypto:rand_bytes(9))).
 
to_hex([]) ->
  [];
to_hex(Bin) when is_binary(Bin) ->
  to_hex(binary_to_list(Bin));
to_hex([H|T]) ->
  [to_digit(H div 16), to_digit(H rem 16) | to_hex(T)].
 
to_digit(N) when N < 10 -> $0 + N;
to_digit(N) -> $a + N-10.

%% @private Returns the working directory, work for development and production.

root_dir() ->
  {ok,Path} = file:get_cwd(),
  Path.

priv_dir() ->
  filename:join(?MODULE:root_dir(), "priv").

etc_dir() ->
  filename:join(?MODULE:root_dir(), "etc").

get_config() ->
  Path = filename:join(?MODULE:root_dir(), "eshop.config"),
  get_config(Path,filelib:is_file(Path)).

get_config(_Path,false) ->
  Path = filename:join(?MODULE:etc_dir(), "app.config"),
  get_config(Path,filelib:is_file(Path));
get_config(Path,true) ->
  read_config(Path).

read_config(ConfigPath) ->
  case file:consult(ConfigPath) of
    {ok, FileConfig} ->
      FlatConfig = lists:flatten(FileConfig),
      proplists:get_value(?APP,FlatConfig);
    {error, {Line, Mod, Term}} ->
      hub_logging:log_term(file,info,{Line,Mod,Term});
    {error, Reason} ->
      case Reason of
        enoent ->
          ReasonMsg = lists:concat(["File not found in: ",ConfigPath]);
        ReasonError ->
          ReasonMsg = lists:concat(["ERROR: ",Reason," ",ReasonError])
      end,
      io:fwrite("~p~n",[ReasonMsg])
  end.

get_value(Key, Opts, Default) ->
  case lists:keyfind(Key, 1, Opts) of
    {_, Value} -> Value;
    _ -> Default
  end.

pool_name() ->
  {ok, Pools} = application:get_env(?APP, pools),
  [{N,[_S,_O],[_H,_D,_U,_P]}] = Pools,
  N.

database() ->
  {ok, Pools} = application:get_env(?APP, pools),
  [{_N,[_S,_O],[_H,{_DK,DN},_U,_P]}] = Pools,
  DN.


get_env(Key) ->
  case application:get_env(?APP, Key) of
    {ok,Val} -> Val;
    _ -> undefined
  end.
  
get_env(Section,Key) ->
  SectionConf = get_env(Section),
  get_value(Key,SectionConf,undefined). 

gen_rand_int(LB,UB) ->
  {A1, A2, A3} = now(),
  random:seed(A1, A2, A3),
  LB + random:uniform(UB - LB).

