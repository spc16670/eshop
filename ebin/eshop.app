{application, eshop, [
  {description, ""}
  ,{vsn, "1"}
  ,{registered, [eshop_app]}
  ,{applications, [
    kernel
    ,stdlib
  ]}
  ,{mod, { eshop_app, []}}
  ,{modules,[
    eshop_app
    ,eshop_sup
    ,eshop
    ,eshop_session
    ,eshop_utls
    ,eshop_db_worker
    ,eshop_db_sup
    ,eshop_db
    ,eshop_db_mnesia
    ,eshop_session_sup
    ,eshop_session_worker
    ,eshop_log
    ,eshop_bullet_handler
    ,eshop_rest
    ,bullet_handler
  ]}
  ,{env, []}
 ]}.
