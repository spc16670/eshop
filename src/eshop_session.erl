-module(eshop_session).

-export([
  all/0
  , on_request/1
  , get_cookie/1
  , set_cookie/1
  , drop_session/1
  , authenticate/1
]).

%% --------------------------------------------------------------------

all() ->
  MatchHead = '_',
  Guard = [],
  Result = ['$$'],
  gproc:select([{MatchHead, Guard, Result}]).

authenticate(Cred) ->
  Email = eshop_utls:get_value(<<"email">>,Cred,<<"">>), 
  Password = eshop_utls:get_value(<<"password">>,Cred,<<"">>),
  User = eshop_db:select_shopper(Email),
  authenticate(Email,Password,User).

authenticate(_E,_P,{ok,[]}) ->
  [{<<"error">>,<<"Invalid">>}];
authenticate(E,P,{ok,U}) ->
  Email = eshop_utls:get_value(<<"email">>,U,<<"">>),
  Password = eshop_utls:get_value(<<"password">>,U,<<"">>),
  if Email =:= E andalso Password =:= P ->
    I = eshop_utls:get_value(<<"id">>,U,<<"">>),
    F = eshop_utls:get_value(<<"fname">>,U,<<"">>),
    L = eshop_utls:get_value(<<"lname">>,U,<<"">>),
    G = eshop_utls:get_value(<<"gender">>,U,<<"">>),
    Payload = [E,I],
    Secret = eshop_db_mnesia:get_setting(jwt_secret),
    Token = ejwt:encode(Payload,Secret),
    [{<<"token">>,Token}
      ,{<<"email">>,E}
      ,{<<"fname">>,F}
      ,{<<"lname">>,L}
      ,{<<"gender">>,G}
    ];
  true -> [{<<"error">>,<<"Invalid credentials">>}] end.

%%  
on_request(Req) ->
  {Cookie,Path,Req2} = get_cookie(Req),
  io:fwrite("Cookie is: ~p Path: ~p ~n",[Cookie,Path]),
  case Cookie of
    undefined ->
      %Req4 = session_no(Req2, Path);
      {Cookie2,Req3} = set_cookie(Req2),
      {Cookie2,Path,Req3};
    _ ->
      {Cookie2,Path2,Req3} = get_cookie(Req2),
      {Cookie2,Path2,Req3}
  end.
%      PEER = session_db:get(SESSID),
%      case PEER of
%	 undefined ->
%	   case Path of
%	    <<"/logoff">> ->
%	      Req4 = Req2;
%	    _ ->
%	      Req3 = cowboy_req:set_resp_header(<<"Location">>,<<"/logoff">>,Req2),
%	      {ok, Req4} = cowboy_req:reply(302, [], "", Req3)
%	  end;
%	_ ->
%	  Req4 = session_yes(Req2, Path)
%	end
%  end,
%  Req4.
 
session_no(Req, Path) ->
    case lists:member(Path,[<<"/main">>,<<"/logoff">>]) of
        true ->
            Req1 = cowboy_req:set_resp_header(<<"Location">>,<<"/">>,Req),
            {ok, Req2} = cowboy_req:reply(302, [], "", Req1);
        _ ->
            Req2 = Req
    end,
    Req2.
 
session_yes(Req, Path) ->
    case lists:member(Path,[<<"/login">>, <<"/registration">>, <<"/">>]) of
        true ->
            Req1 = cowboy_req:set_resp_header(<<"Location">>,<<"/main">>,Req),
            {ok, Req2} = cowboy_req:reply(302, [], "", Req1);
        _ ->
            Req2 = Req
    end,
    Req2.
 
get_cookie(Req) ->
  {Path, Req1} = cowboy_req:path(Req),
  {Cookie, Req2} = cowboy_req:cookie(<<"COOKIE">>, Req1),
  {Cookie, Path, Req2}.
 
set_cookie(Req) ->
  Cookie = eshop_utls:generate_hash(),
  Req1 = cowboy_req:set_resp_cookie(<<"COOKIE">>,Cookie,[{path, <<"/">>}],Req),
  {Cookie,Req1}.
 
drop_session(Req) ->
  Req2 = cowboy_req:set_resp_header(<<"Set-Cookie">>,<<"COOKIE=deleted; expires=Thu, 01-Jan-1970 00:00:01 GMT; path=/">>, Req),
  Req2.


