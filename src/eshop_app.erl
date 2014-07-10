-module(eshop_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
  application:start(syntax_tools),
  application:start(compiler),
  application:start(merl),
  application:start(erlydtl),
  application:start(goldrush),
  application:start(lager),
  application:start(crypto),
  application:start(cowlib),
  application:start(ranch),
  application:start(cowboy),
  application:start(erlsha2),
  application:start(jsx),
  application:start(ejwt),
  application:start(gproc),
  
  eshop_db_mnesia:create_tables([node()]),
  mnesia:wait_for_tables([basic_config,session_cache], 5000),
  eshop_db_mnesia:init_load_config(),
  
  PrivDir = eshop_utls:priv_dir(),

  Dispatch = cowboy_router:compile([
    {'_', [
      {"/static/[...]", cowboy_static, {dir,PrivDir ++ "/static",[
	{mimetypes, cow_mimetypes, all}]}}
      ,{"/", eshop_rest, []}
      ,{"/bullet/[...]",bullet_handler,[{handler,eshop_bullet_handler}]}
    ]}
  ]),

  cowboy:start_http(http_listener, 100,
    [{port, 8080}],
    [{env, [{dispatch, Dispatch}]}]
  ),

  io:fwrite("Priv dir: ~p~n",[PrivDir]),
  %% Name, NbAcceptors, TransOpts, ProtoOpts
  cowboy:start_https(https_listener, 100,
    [{port, 8443}
     ,{cacertfile, PrivDir ++ "/ssl/ca.eshop.in.crt"}
     ,{certfile, PrivDir ++ "/ssl/eshop.in.crt"}
     ,{keyfile, PrivDir ++ "/ssl/eshop.in.key"}
    ],
    [{env, [{dispatch, Dispatch}]}]
  ),

  R = eshop_sup:start_link(),
  eshop_db:init(),
  R.

stop(_State) ->
  ok.
