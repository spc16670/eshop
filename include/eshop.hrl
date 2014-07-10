
-define(APP,eshop).

-define(KEY(Id),{n,l,Id}).
-define(WORKER_PFX,<<"worker-">>).
-define(HANDLER_PFX,<<"handler-">>).
-define(WORKER_KEY(Sid),?KEY(<<?WORKER_PFX/binary,Sid/binary>>)).
-define(HANDLER_KEY(Sid),?KEY(<<?HANDLER_PFX/binary,Sid/binary>>)).

