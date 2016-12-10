
USE chfed; 
GO 

------------------------------------------------------------------------------------------------
-- Задача №1 
-- Выбрать имена всех таблиц, владельцем которых является 
-- назначенный пользователь базы данных (например, пользователь s33 для базы d33)
------------------------------------------------------------------------------------------------

SELECT sst.name as [Name]

FROM sys.tables                           AS sst
INNER JOIN sys.schemas              AS sss  ON sss.schema_id = sst.schema_id
LEFT  JOIN sys.extended_properties  AS sse  ON sse.major_id  = sst.object_id


WHERE USER_NAME(OBJECTPROPERTY(sst.object_id, 'OwnerId')) = 'dbo'
AND  (sse.name != 'microsoft_database_tools_support' OR sse.name IS NULL)

/* 
SELECT * FROM sys.extended_properties;
  sse.name != 'microsoft_database_tools_support'

  AND (sst.name != 'sysdiagrams')
  AND (sst.name != 'sp_helpdiagrams')
  AND (sst.name != 'sp_upgraddiagrams') 
  AND (sst.name != 'sp_creatediagram')
  AND (sst.name != 'sp_renamediagram')  
  AND (sst.name != 'sp_alterdiagram')  
  AND (sst.name != 'sp_dropdiagram')  
  AND (sst.name != 'sp_diagramobjects')   
  AND (sst.name != 'fn_dropdiagram')   
  AND (sst.name != 'dt_properties')   
  AND (sst.name != 'sysdiagrams')


--SELECT * FROM  sys.extended_properties;

--SELECT major_id, sst.name FROM sys.extended_properties sse
--INNER JOIN sys.tables sst ON sst.object_id = sse.major_id;
--AND sysobjects.id NOT IN (SELECT major_id FROM sys.extended_properties)

------------------------------------------------------------------------------------------------
-- Задача №2
-- выбрать имя таблицы, имя столбца таблицы, признак того,
-- допускает ли данный столбец null-значения, название типа данных
-- столбца таблицы - для всех таблиц,
-- созданных назначенным пользователем базы данных и всех их столбцов
------------------------------------------------------------------------------------------------

-- размер этого типа данных = максимально возможная длинна


SELECT isc.table_name               AS [Table name],
       isc.column_name              AS [Column name], 
	   isc.is_nullable              AS [Nullable], 
	   isc.data_type                AS [Type],
	   CASE 
	        WHEN (isc.character_maximum_length) IS NOT NULL
		    THEN  isc.character_maximum_length ELSE stp.max_length
	   END AS [Maximum size in bytes]

FROM  chfed.INFORMATION_SCHEMA.COLUMNS AS isc 
INNER JOIN sys.types   AS stp ON stp.name = isc.data_type
INNER JOIN sys.tables  AS sst ON sst.name = isc.table_name
INNER JOIN sys.schemas AS sss ON sss.schema_id = sst.schema_id

WHERE table_name IN (SELECT table_name FROM information_schema.tables WHERE table_type ='BASE TABLE') 
  AND table_name != 'sysdiagrams'
  AND USER_NAME(OBJECTPROPERTY(sst.object_id, 'OwnerId')) = 'dbo';

------------------------------------------------------------------------------------------------
-- Задача №3
-- выбрать название ограничения целостности (первичные и внешние ключи),
-- имя таблицы, в которой оно находится, признак того, что это за ограничение 
-- ('PK' для первичного ключа и 'F' для внешнего) - для всех ограничений целостности,
-- созданных назначенным пользователем базы данных.
------------------------------------------------------------------------------------------------

SELECT sso.[name] as 'Constraint name', sso.[type] as 'Constraint type'

FROM sys.objects AS sso
INNER JOIN sys.schemas    sss    ON sss.schema_id    = sso.schema_id

WHERE USER_NAME(OBJECTPROPERTY(sso.object_id, 'OwnerId')) = 'dbo'
  AND type_desc = 'FOREIGN_KEY_CONSTRAINT' OR type_desc = 'PRIMARY_KEY_CONSTRAINT' 
  AND sso.object_id NOT IN (SELECT major_id FROM sys.extended_properties)


------------------------------------------------------------------------------------------------
-- Задача №4
------------------------------------------------------------------------------------------------


SELECT child.name, parent.name

FROM sys.objects AS child 
INNER JOIN sys.objects    parent ON parent.object_id = child.parent_object_id
INNER JOIN sys.schemas    sss    ON sss.schema_id    = parent.schema_id

WHERE USER_NAME(OBJECTPROPERTY(parent.object_id, 'OwnerId')) = 'dbo'
  AND child.type = 'F'


------------------------------------------------------------------------------------------------
-- Задача №5
-- выбрать название представления, SQL-запрос, создающий это представление 
-- для всех представлений, созданных назначенным пользователем базы данных
------------------------------------------------------------------------------------------------

SELECT vie.name       AS 'Name', 
       coe.definition AS 'SQL code'     

FROM sys.views vie
INNER JOIN sys.sql_modules coe  ON coe.object_id = vie.object_id
INNER JOIN sys.schemas     sss  ON sss.schema_id = vie.schema_id

WHERE USER_NAME(OBJECTPROPERTY(vie.object_id, 'OwnerId')) = 'dbo'

------------------------------------------------------------------------------------------------
-- Задача №6
-- Выбрать название триггера, имя таблицы, для которой определен триггер -
-- для всех триггеров, созданных назначенным пользователем базы данных
--
-- Пусто, т.к. нет триггеров
------------------------------------------------------------------------------------------------

SELECT 
     sysobjects.name         AS 'Trigger name', 
     OBJECT_NAME(parent_obj) AS 'Table name' 

FROM sysobjects 
INNER JOIN sys.tables   tablelist  ON sysobjects.parent_obj = tablelist.object_id 
INNER JOIN sys.schemas  schemalist ON tablelist.schema_id = schemalist.schema_id 
INNER JOIN sys.schemas  sss  ON sss.schema_id = tablelist.schema_id

WHERE USER_NAME(OBJECTPROPERTY(tablelist.object_id, 'OwnerId')) = 'dbo' 
  AND sysobjects.type = 'TR' 