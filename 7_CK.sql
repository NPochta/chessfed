
-- This is not h/w, but one inner test

select dp.class_desc, s.name as 'Schema', o.name as 'Object', dp.permission_name, 
       dp.state_desc, prin.[name] as 'User'
from sys.database_permissions dp
  join sys.database_principals prin
    on dp.grantee_principal_id = prin.principal_id
  join sys.objects o
    on dp.major_id = o.object_id
  join sys.schemas s
    on o.schema_id = s.schema_id
where left(o.name, 9) = 'COMPETITION'
  and dp.class_desc = 'OBJECT_OR_COLUMN'
union all
SELECT dp.class_desc, s.name as 'Schema', '-----' as 'Object', dp.permission_name, 
       dp.state_desc, prin.[name] as 'User'
from sys.database_permissions dp
  join sys.database_principals prin
    on dp.grantee_principal_id = prin.principal_id
  join sys.schemas s
    on dp.major_id = s.schema_id
where dp.class_desc = 'SCHEMA';