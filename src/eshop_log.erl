-module(eshop_log).

-behaviour(gen_server).

-export([
  init/1
  ,handle_call/3
  ,handle_cast/2
  ,handle_info/2
  ,terminate/2
  ,code_change/3
]).

-export([
  start_link/0
  ,stop/1
  ,stop/0
  ,state/0
  ,state/1
]).

-export([
  log_term/2
  ,print_term/2
]).

-compile([{parse_transform, lager_transform}]).

%% -----------------------------------------------------------------------------
%% -----------------------------------------------------------------------------
%% -----------------------------------------------------------------------------

log_term(Level,Term) when Level =:= error ->
  lager:error("~p",[Term]);
log_term(Level,Term) when Level =:= debug ->
  lager:debug("~p",[Term]);
log_term(Level,Term) when Level =:= info ->
  lager:info("~p",[Term]);
log_term(_Level,_Term) ->
  wrong_level.

print_term(Level,Term) when Level =:= info ->
  io:fwrite("~p~n",[Term]);
print_term(_Level,_Term) ->
  wrong_level.

%% @private

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% -----------------------------------------------------------------------------

%% @private

init([]) ->
  {ok, []}.

%% -----------------------------------------------------------------------------
%% @private

handle_call(stop, _From, State) ->
  {stop, normal, stopped, State};
handle_call(state, _From, State) ->
  {reply, State, State}.

%% -----------------------------------------------------------------------------
%% @private

handle_cast({_Where,_Level,_Msg}, State) ->
  {noreply, State}.

%% -----------------------------------------------------------------------------
%% @private

handle_info(_Unmatched, State) ->
  {noreply, State}.

%% -----------------------------------------------------------------------------
%% @private

stop(Module) ->
  gen_server:call(Module, stop).

%% -----------------------------------------------------------------------------
%% @private

stop() ->
  stop(?MODULE).

%% -----------------------------------------------------------------------------
%% @private

state(Module) ->
  gen_server:call(Module, state).

%% -----------------------------------------------------------------------------
%% @private

state() ->
  state(?MODULE).

%% -----------------------------------------------------------------------------
%% @private

terminate(_Reason, _State) ->
  ok.

%% -----------------------------------------------------------------------------
%% @private

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

