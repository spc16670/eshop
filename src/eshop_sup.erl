
-module(eshop_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor

-define(LOG_CHILD(Name), {Name,{Name,start_link,[]},permanent,5000,worker,[Name]}).
-define(SESSION_CHILD(Name), {Name,{Name,start_link,[]},permanent,5000,supervisor,[Name]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->  
  {ok, { {one_for_one, 5, 10}, [
    ?LOG_CHILD(eshop_log)
    ,?SESSION_CHILD(eshop_session_sup)
    ]} 
  }.

