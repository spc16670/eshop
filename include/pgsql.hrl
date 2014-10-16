%
% Every record needs an id. 
% -----------------------------------------------------------------------------

-record(user,{
  id = [ 
    {type,{'bigserial',[]}}
    ,{constraints,[{'pk',[]},{null,false}]}
  ]
  ,email = [
    {type,{'varchar',[{length,50}]}}
    ,{constraints,[{null,false}]}
  ]
  ,password = [
    {type,{'varchar',[{length,50}]}}
    ,{constraints,[{null,false}]}
  ]
  ,date_registered = [
    {type,{'timestamp',[]}}
  ]
}).

-record(shopper,{
  id = [ 
    {type,{'bigserial',[]}}
    ,{constraints,[{'pk',[]},{null,false}]}
  ]
  ,fname = [
    {type,{'varchar',[{length,50}]}}
  ]
  ,mname = [
    {type,{'varchar',[{length,50}]}}
  ]
  ,lname = [
    {type,{'varchar',[{length,50}]}}
  ]
  ,dob = [
    {type,{'date',[]}}
  ]
  ,gender = [
    {type,{'varchar',[length,1]}}
  ]
  ,user_id = [
    {type,{'bigint',[]}}
    ,{constraints,[
      {references,[{table,user}]}
      ,{null,true}
    ]}
  ]
}).

-record(address_type,{
  id = [ 
    {type,{'serial',[]}}
    ,{constraints,[{'pk',[]},{null,false}]}
  ]
  ,type = [
    {type,{'varchar',[{length,50}]}}
  ]  
}).

-record(shopper_address,{
  id = [ 
    {type,{'bigserial',[]}}
    ,{constraints,[{'pk',[]},{null,false}]}
  ]
  ,line1 = [
    {type,{'varchar',[{length,50}]}}
  ]
  ,line2 = [
     {type,{'varchar',[{length,50}]}}
  ]
  ,line3 = [
     {type,{'varchar',[{length,50}]}}
  ]
  ,postcode = [
    {type,{'varchar',[{length,50}]}}
  ]
  ,city = [
    {type,{'varchar',[{length,50}]}}
  ]
  ,country = [
    {type,{'varchar',[{length,50}]}}
  ]
  ,type = [
    {type,{'integer',[]}}
    ,{constraints,[
      {references,[{table,address_type}]}
      ,{null,false}
    ]}
  ]
  ,shopper_id = [
    {type,{'bigint',[]}}
    ,{constraints,[
      {references,[{table,shopper}]}
      ,{null,true}
    ]}
  ]
}).

-record(phone_type,{
  id = [ 
    {type,{'serial',[]}}
    ,{constraints,[{'pk',[]},{null,false}]}
  ]
  ,type = [
    {type,{'varchar',[{length,50}]}}
  ]  
}).

-record(shopper_phone, {
  id = [ 
    {type,{'bigserial',[]}}
    ,{constraints,[{'pk',[]},{null,false}]}
  ]
  ,number = [
    {type,{'varchar',[{length,50}]}}
  ]
  ,type = [
    {type,{'integer',[]}}
    ,{constraints,[
      {references,[{table,phone_type}]}
      ,{null,false}
    ]}
  ]
  ,shopper_id = [
    {type,{'bigint',[]}}
    ,{constraints,[
      {references,[{table,shopper}]}
      ,{null,true}
    ]}
  ]
}).

-record(category, {
  id = [ 
    {type,{'serial',[]}}
    ,{constraints,[{'pk',[]},{null,false}]}
  ]
  ,name = [
    {type,{'varchar',[{length,124}]}}
  ]
  ,description = [
    {type,{'varchar',[{length,512}]}}
  ]
}).

-record(category_images, {
  id = [ 
    {type,{'serial',[]}}
    ,{constraints,[{'pk',[]},{null,false}]}
  ]
  ,name =[
    {type,{'varchar',[{length,256}]}}
  ]
  ,category_id = [
    {type,{'integer',[]}}
    ,{constraints,[
      {references,[{table,category}]}
      ,{null,false}
    ]}
  ]
}).

-record(supplier, {
  id = [
    {type,{'bigserial',[]}}
    ,{constraints,[{'pk',[]},{null,false}]}
  ]
  ,name = [
    {type,{'varchar',[{length,512}]}}
  ] 
}).


-record(supplier_address,{
  id = [ 
    {type,{'bigserial',[]}}
    ,{constraints,[{'pk',[]},{null,false}]}
  ]
  ,line1 = [
    {type,{'varchar',[{length,50}]}}
  ]
  ,line2 = [
     {type,{'varchar',[{length,50}]}}
  ]
  ,line3 = [
     {type,{'varchar',[{length,50}]}}
  ]
  ,postcode = [
    {type,{'varchar',[{length,50}]}}
  ]
  ,city = [
    {type,{'varchar',[{length,50}]}}
  ]
  ,country = [
    {type,{'varchar',[{length,50}]}}
  ]
  ,type = [
    {type,{'integer',[]}}
    ,{constraints,[
      {references,[{table,address_type}]}
      ,{null,false}
    ]}
  ]
  ,supplier_id = [
    {type,{'bigint',[]}}
    ,{constraints,[
      {references,[{table,supplier}]}
      ,{null,true}
    ]}
  ]
}).

-record(supplier_phone, {
  id = [ 
    {type,{'bigserial',[]}}
    ,{constraints,[{'pk',[]},{null,false}]}
  ]
  ,number = [
    {type,{'varchar',[{length,50}]}}
  ]
  ,type = [
    {type,{'integer',[]}}
    ,{constraints,[
      {references,[{table,phone_type}]}
      ,{null,false}
    ]}
  ]
  ,supplier_id = [
    {type,{'bigint',[]}}
    ,{constraints,[
      {references,[{table,supplier}]}
      ,{null,true}
    ]}
  ]
}).

-record(product, {
  id = [ 
    {type,{'bigserial',[]}}
    ,{constraints,[{'pk',[]},{null,false}]}
  ]
  ,name = [
    {type,{'varchar',[{length,512}]}}
  ]
  ,category_id = [
    {type,{'integer',[]}}
    ,{constraints,[
      {references,[{table,category}]}
      ,{null,false}
    ]}
  ]
  ,price = [
    {type,{'numeric',[{precision,10},{scale,2}]}}
  ]
  ,qunatity = [
    {type,{'integer',[]}}
  ]
  ,description = [
    {type,{'varchar',[{length,1024}]}}
  ]
  ,dimensions = [
    {type,{'varchar',[{length,128}]}}
  ]
  ,weigth = [
    {type,{'numeric',[{precision,12},{scale,3}]}}
  ]
}).

-record(payment, {
  id = [ 
    {type,{'bigserial',[]}}
    ,{constraints,[{'pk',[]},{null,false}]}
  ]
}).

-record(order,{
  id = [ 
    {type,{'bigserial',[]}}
    ,{constraints,[{'pk',[]},{null,false}]}
  ]
  ,shopper_id = [
    {type,{'bigint',[]}}
    ,{constraints,[
      {references,[{table,shopper}]}
      ,{null,false}
    ]}
  ]
  ,payment_id = [
    {type,{'bigint',[]}}
    ,{constraints,[
      {references,[{table,payment}]}
      ,{null,true}
    ]}
  ]
  ,order_datetime = [  
    {type,{'timestamp',[]}}
  ]
  ,ship_datetime = [  
    {type,{'timestamp',[]}}
  ]
}).

-record(order_details,{
  id = [ 
    {type,{'bigserial',[]}}
    ,{constraints,[{'pk',[]},{null,false}]}
  ]
  ,order_id = [
    {type,{'bigint',[]}}
    ,{constraints,[
      {references,[{table,order},{on_delete,cascade}]}
      ,{null,false}
    ]}
  ]
  ,product_id = [
    {type,{'bigint',[]}}
    ,{constraints,[
      {references,[{table,product}]}
      ,{null,false}
    ]}
  ]
  ,product_price = [
    {type,{'numeric',[{precision,10},{scale,2}]}}
  ]
  ,qunatity = [
    {type,{'integer',[]}}
  ]
  ,discount = [
    {type,{'integer',[]}}
  ]
  ,total = [
    {type,{'numeric',[{precision,10},{scale,2}]}}
  ]
  ,ship_datetime = [  
    {type,{'timestamp',[]}}
  ]
}).


