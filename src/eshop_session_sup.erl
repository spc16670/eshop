-module(eshop_session_sup).

-behaviour(supervisor).

%% API
-export([
  start_link/0
  ,start_session/1
]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
%% {ChildId, StartFunc, Restart, Shutdown, Type, Modules}.
-define(SESSION_CHILD(N), {N, {eshop_session_worker, start_link, []}, transient, 5000, worker, [eshop_session_worker]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
  {ok, {{simple_one_for_one, 10, 10}, [?SESSION_CHILD(eshop_session_worker)]}}.

start_session(SessionId) ->
  supervisor:start_child(?MODULE,[SessionId]).


