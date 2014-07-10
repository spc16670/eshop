#!/usr/bin/escript

%% Erlang code

main(Args) ->
  io:fwrite("Extra params: ~p ~n",[Args]),
  create_db().

create_db() ->
  {ok,C} = pgsql:connect("localhost","postgres","postgres",[]),
  Role = pgsql:squery(C, "DO $$ BEGIN IF NOT EXISTS (SELECT * FROM pg_catalog.pg_user WHERE usename = 'lamazone') THEN CREATE ROLE lamazone LOGIN PASSWORD 'lamazone'; END IF; END $$"),
  
  io:fwrite("~p~n",[Role]),
  Db = pgsql:squery(C, "DO $$ BEGIN IF NOT EXISTS (SELECT datname FROM pg_catalog.pg_database WHERE datname = 'lamazone') THEN CREATE DATABASE lamazone WITH OWNER = lamazone ENCODING = 'UTF8'; END IF; END $$"),
  io:fwrite("~p~n",[Db]),
  ok = pgsql:close(C).
