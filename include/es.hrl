%
% Every record needs to have an index specified.
% Every record name is also an ES type.
% 
% -----------------------------------------------------------------------------

-record(review,{
  index = [{'name',test}]
  ,id = [{type,long}]
  ,author = [{type,string}]
  ,created_date = [{type,date}]
  ,score = [{type,integer}]
  ,text = [{type,string}]
}).

