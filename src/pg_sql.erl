-module(pg_sql).

-export([
  model/0
  ,create_schema/1
  ,create_schema/2
  ,create_table/2
  ,create_table/3
  ,create_table/4
  ,select/1
  ,select/2
  ,select/3
  ,select/4
  ,create_sample/0
  ,select_index/1
  ,select_index/2
  ,tuples_to_fields/2
  ,transaction/1
  ,rollback/0
  ,drop_table/1
  ,drop_table/2
  ,drop_table/3
  ,table_info/3
  ,get_model/3
  ,where/1
  ,where_to_string/1
]).

-record(model,{name,schema,fields}).
-record(field,{name,type,length,null,position}).
-record(unique,{id,fields}).
-record(pk,{id,fields}).
-record(fk,{id,on_delete_cascade,fields,r_schema,r_table,r_fields}).
-record(table,{name,schema,fields,constraints}).


%% -----------------------------------------------------------------------------

model() ->
  io:fwrite("~p~n",[#table{}]).

create_sample() ->
  Name = sample,   
  Schema = lamazone, 
  %Fields = [{id,bigserial,undefined},{name,varchar,50},{age,integer,25}],
  Fields = [
    #field{name=id,type=bigserial,null=no}
    ,#field{name=name,type=varchar,length=50,null=yes}
    ,#field{name=age,type=integer,null=no}
    ,#field{name=price,type=money,null=no}
    ,#field{name=weight,type=numeric,length={14,2},null=no}
  ],
  Constraints = [
    #pk{id=undefined,fields=[id]}
    ,#unique{id=undefined,fields=[name]}
    %,#fk{id=some_name_fk,on_delete_cascade=yes,fields=[age],r_schema=Schema,r_table=sample2,r_fields=[year]}
  ],
  R = create_table(Name,Schema,Fields,Constraints),
  io:fwrite("~s~n",[R]),
  R.

create_schema(S) ->
  create_schema(S,undefined).
create_schema(S,E) ->
  "CREATE SCHEMA " ++ has_value(ifexists,E) ++ " " ++ has_value(schema,S) ++ ";".

drop_table(T) ->
  drop_table(undefined,T).
drop_table(S,T) ->
  drop_table(S,T,[]).
drop_table(S,T,Op) ->
  if lists:member(ifexists,Op) =:= true -> IE = yes; true -> IE = undefined end,
  if lists:member(cascade,Op) =:= true -> C = yes; true -> C = undefined end,
  "DROP TABLE " ++ has_value(ifexists,IE) ++ " " 
  ++ table_to_string({S,T,undefined}) ++ " " ++ has_value(cascade,C) ++ ";".

select({S,T,A}) ->
  select([{S,T,A}]);
select({S,T}) ->
  select({S,T,undefined});
select(T) when is_atom(T) ->
  select({undefined,T,undefined});
select(Ts) when is_list(Ts) ->
  select(Ts,['*']).

select({S,T,A},Fs) when is_atom(T) ->
  select({S,T,A},Fs,undefined);
select({S,T},Fs) when is_atom(T) ->
  select({S,T,undefined},Fs,undefined);
select(T,Fs) when is_atom(T) ->
  select({undefined,T,undefined},Fs,undefined);
select(Ts,Fs) when is_list(Ts) ->
  select(Ts,Fs,undefined).
  
select({S,T,A},Fs,W) when is_atom(T) -> 
  select([{S,T,A}],Fs,undefined,W);
select({S,T},Fs,W) when is_atom(T) -> 
  select({S,T,undefined},Fs,undefined,W);
select(T,Fs,W) when is_atom(T) -> 
  select({undefined,T,undefined},Fs,undefined,W);
select(Ts,Fs,W) when is_list(Ts) -> 
  select(Ts,Fs,undefined,W).

select({S,T,A},Fs,J,W) ->
  select([{S,T,A}],Fs,J,W);
select({S,T},Fs,J,W) when is_atom(T) ->
  select({S,T,undefined},Fs,J,W);
select(T,Fs,J,W) when is_atom(T) ->
  select({undefined,T,T},Fs,J,W);
select(Ts,Fs,J,W) when is_list(Ts) ->
  "SELECT " ++ field_to_string(Fs) ++ " FROM " ++ table_to_string(Ts) 
  ++ " " ++ join(J) ++ "" ++ where(W) ++ ";".
 
create_table(Name,Fields) ->
  create_table(undefined,Name,Fields).
create_table(Schema,Name,Fields) ->
  create_table(Schema,Name,Fields,undefined).
create_table(Schema,Name,Fields,Constraints) ->
  Stmt = create_table(#table{name=Name,schema=Schema,fields=Fields}) 
  ++ "\n" ++ add_constraint(Schema,Name,Constraints),
  transaction(Stmt).

create_table(#table{name=N,schema=S,fields=Fs} = _T) -> 
  "CREATE TABLE " ++ has_value(schema,S) ++ value_to_string(N) 
  ++ " (" ++ field_to_string(Fs) ++ "\n);".

select_index(I) ->
  select_index(undefined,I).
select_index(S,I) ->
  Tables = [{undefined,pg_class,t},{undefined,pg_class,i},{undefined,pg_index,ix}
    ,{undefined,pg_attribute,a},{undefined,pg_namespace,n}],
  Fields = [{n,nspname},{i,relname}],
  Where = [{{t,oid},'=',{ix,indexrelid}}
    ,'AND',{{t,relnamespace},'=',{n,oid}}
    ,'AND',{{i,oid},'=',{ix,indexrelid}}
    ,'AND',{{n,nspname},'LIKE',value_to_string(S) ++ "%"}
    ,'AND',{{t,relname},'LIKE',value_to_string(I) ++ "%"}],
  select(Tables,Fields,Where).

transaction(Stmt) ->
  "BEGIN;\n " ++ Stmt ++ "COMMIT;\n".

rollback() ->
  "ROLLBACK;".

get_model(Name,Schema,Fs) ->
  Fields = lists:foldl(fun({I,O,T,N,M,P,S},Acc) -> 
    Acc ++ [#field{name=result_to_value({atom,I})
      ,type=result_to_value({atom,T})
      ,length=result_to_value({T,M,P,S})
      ,null=result_to_value({atom,N})
      ,position=result_to_value({integer,O})}]
    end,[],Fs),
  #model{name=Name,schema=Schema,fields=Fields}.

table_info(D,S,T) ->
  select({information_schema,columns},[column_name,ordinal_position,data_type
    ,is_nullable,character_maximum_length,numeric_precision,numeric_scale]
    ,[{table_catalog,'=',value_to_string(D)},'AND',{table_schema,'=',value_to_string(S)}
    ,'AND',{table_name,'=',value_to_string(T)}]).

%% ------------------------------------------------------------------------------

table_to_string(Ts) when is_list(Ts) ->
  table_to_string(Ts,hd(Ts));
table_to_string({S,T,A}) ->
  has_value(schema,S) ++ value_to_string(T) ++ " " ++ value_to_string(A).

table_to_string(Ts,T1) when is_atom(T1) ->
  field_to_string(Ts);
table_to_string(Ts,T1) when is_tuple(T1) ->
  string:strip(lists:foldl(fun(E,Acc) -> Acc ++ "," ++ table_to_string(E) end,[],Ts),left,$,).

%% JOIN
%% [{{'LEFT OUTER JOIN',{schema,othertable,o}},'ON',{{'T',name},'=',{'O',name}}}]

join(undefined) ->
  [];
join(J) when is_list(J) ->
  lists:foldl(fun(E,Acc) -> Acc ++ " " ++ join_to_string(E) end,[],J).

join_to_string(V) when is_atom(V) ->
  value_to_string(V);
join_to_string({J,{T,A}}) when is_atom(J) ->
  join_to_string({J,{undefined,T,A}});
join_to_string({J,{S,T,A}}) when is_atom(J) ->
  value_to_string(J) ++ " " ++ table_to_string({S,T,A});
join_to_string({J,C}) when is_atom(J) andalso is_atom(C) ->
  where_to_string({J,C});
join_to_string({F1,T,F2}) ->
  where_to_string({F1,T,F2}).

%% WHERE
%% [{{'C',gender},'=',"M"},'AND',[{{'C',age},'=',20},'OR',{{'C',age},'=',25}],'AND',{{'C',name},'LIKE',{'S',name}}]

where(undefined) ->
  [];
where(W) when is_list(W) -> 
  " WHERE " ++ lists:foldl(fun(E,Acc) -> Acc ++ " " ++ where_to_string(E) end,[],W).

where_to_string(V) when is_atom(V) ->
  value_to_string(V);
where_to_string({J,C}) when is_atom(J) ->
  value_to_string(J) ++ "." ++ value_to_string(C);
where_to_string(V) when is_integer(V) ->
  value_to_string(V);
where_to_string(V) when is_float(V) ->
  value_to_string(V); 
where_to_string({F1,T,F2}) ->
  where_to_string(F1) ++ " " ++ where_to_string(T) ++ " " ++ where_to_string(F2);  
where_to_string(V) when is_list(V) ->
  case io_lib:printable_unicode_list(V) of
    false ->
      "(" ++ lists:foldl(fun(E,Acc) -> Acc ++ " " ++ where_to_string(E) end,[],V) ++ ")";
    true ->
       "'" ++ V ++ "'"
  end.

result_to_value({atom,<<"character varying">>}) ->
  varchar;
result_to_value({atom,<<"bigint">>}) ->
  integer;
result_to_value({atom,<<"money">>}) ->
  float;
result_to_value({atom,<<"numeric">>}) ->
  float;
result_to_value({<<"numeric">>,_L,P,S}) ->
  {list_to_integer(binary_to_list(P)),list_to_integer(binary_to_list(S))};
result_to_value({<<"character varying">>,L,_P,_S}) ->
  list_to_integer(binary_to_list(L));
result_to_value({_T,_L,_P,_S}) ->
  undefined;
result_to_value({atom,B}) when is_binary(B) ->
  list_to_atom(string:to_lower(binary_to_list(B)));
result_to_value({atom,L}) when is_list(L) ->
  list_to_atom(L);
result_to_value({atom,A}) when is_atom(A) ->
  A;
result_to_value({atom,B}) when is_binary(B) ->
  list_to_integer(binary_to_list(B));
result_to_value(null) ->
  undefined.

field_to_string(#field{name=N,type=T,length=L,null=I} = _F) ->
  NStr = value_to_string(N), TStr = value_to_string(T),
  if NStr /= [] andalso TStr /= [] -> 
    NStr ++ " " ++ TStr ++ " " ++ has_value(length,L) ++ " " ++ has_value(null,I);
  true -> [] end;
field_to_string(Fs) when is_list(Fs) ->
  field_to_string(Fs,hd(Fs)).

field_to_string(Fs,F1) when is_atom(F1) ->
  string:strip(lists:foldl(fun(E,Acc) -> Acc ++ "," ++ atom_to_list(E) end,[],Fs),left,$,);
field_to_string(Fs,F1) when is_tuple(F1) ->
  string:strip(lists:foldl(fun(E,Acc) -> Acc ++ "," ++ where_to_string(E) end,[],Fs),left,$,);
field_to_string(Fs,F1) when is_record(F1,field) ->
  string:strip(lists:foldl(fun(E,Acc) -> Acc ++ ",\n" ++ field_to_string(E) end,[],Fs),left,$,).

value_to_string(V) when is_atom(V) andalso V /= undefined ->
  atom_to_list(V); 
value_to_string(V) when is_integer(V) ->
  integer_to_list(V);
value_to_string(V) when is_float(V) ->
  float_to_list(V,[{decimals,12},compact]);
value_to_string({Mega,S,Micro}) when is_integer(S) ->
  integer_to_list(Mega) ++ integer_to_list(S) ++ integer_to_list(Micro);
value_to_string(V) when is_list(V) ->
  V;
value_to_string(_V) ->
  [].

has_value(length,{L,P}) ->
  "(" ++ value_to_string(L) ++ "," ++ value_to_string(P) ++ ")";
has_value(length,V) when V /= undefined ->
  "(" ++ value_to_string(V) ++ ")";
has_value(schema,V) when V /= undefined ->
  value_to_string(V) ++ ".";
has_value(ifexists,V) when V =:= 'not' ->
  "IF NOT EXISTS";
has_value(ifexists,V) when V =:= yes ->
  "IF EXISTS";
has_value(cascade,V) when V /= undefined ->
  "CASCADE";
has_value(odc,V) when V /= undefined ->
  "ON DELETE " ++ has_value(cascade,V);
has_value(null,V) when V =:= no orelse V =:= undefined ->
  "NOT NULL";
has_value(_,_) ->
  [].

default_name({Key,T},N) when N =:= undefined->
  value_to_string(Key) ++ "_" ++ value_to_string(T) ++ "_" 
    ++ value_to_string(now());
default_name({_Key,_T},N) ->
  N.

add_constraint(S,N,Cs) when Cs /= undefined ->
  lists:foldl(fun(E,Acc) -> Acc ++ 
    "ALTER TABLE " ++ has_value(schema,S) ++ value_to_string(N) 
    ++ " ADD CONSTRAINT " ++ constraint_to_string(N,E)
  ++ "\n" end,[],Cs);
add_constraint(_S,_N,_C) ->
  [].
 
constraint_to_string(T,#pk{id=N,fields=Fs} = _C) ->
  default_name({pk,T},N) ++ " PRIMARY KEY (" ++ field_to_string(Fs) ++ ");";
constraint_to_string(T,#unique{id=N,fields=Fs} = _C) ->
  default_name({uq,T},N) ++ " UNIQUE (" ++ field_to_string(Fs) ++ ");";
constraint_to_string(T,#fk{id=N,on_delete_cascade=Odc,fields=Fs,r_schema=Rs,r_table=Rt,r_fields=RFs} = _C) ->
  default_name({fk,T},N) ++ " FOREIGN KEY (" ++ field_to_string(Fs) 
  ++ ") REFERENCES " ++  has_value(schema,Rs) ++ value_to_string(Rt) ++ " (" ++ field_to_string(RFs) 
  ++ ") " ++ has_value(odc,Odc) ++ ";".


 
tuples_to_fields([{I,T,L}|Ts],Result) ->
  tuples_to_fields(Ts,Result ++ [#field{name=I,type=T,length=L}]);
tuples_to_fields([],Result) ->
  Result.

  

