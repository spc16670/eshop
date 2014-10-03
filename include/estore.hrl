-include("$RECORDS_PATH/pgsql.hrl").
-include("$RECORDS_PATH/mnesia.hrl").
-include("$RECORDS_PATH/es.hrl").

-define(RECORD_NAME(Record),estore_utils:record_name(Record)).
-define(APP,estore).
