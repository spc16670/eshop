-module(eshop_db_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-include("eshop.hrl").

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
  {ok, Pools} = application:get_env(?APP, pools),
  PoolSpecs = lists:map(fun({Name, SizeArgs, WorkerArgs}) ->
    PoolArgs = [{name, {local, Name}},{worker_module, eshop_db_worker}] ++ SizeArgs,
    poolboy:child_spec(Name, PoolArgs, WorkerArgs)
  end, Pools),
  {ok, {{one_for_one, 10, 10}, PoolSpecs}}.


