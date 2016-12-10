--ep. 1

grant SELECT (RATING) on PLAYER to test7 with GRANT option;  

--ep. 2  (revoke or deny - doesn't matter in this case)

revoke SELECT (RATING) on PLAYER to test7 cascade;








/*

---- Creating user for current test login. To make things easier, we name them the same (used once)
-- create user test7 for login test7; 


---- Create new role analog to existing one (used once)
--create role PART_ROLE authorization db_datareader;
--go 


---- Add member to role (used once)
--exec sp_addrolemember @rolename = 'PART_ROLE', @membername = 'test7';
--go


---- Granting SELECT, INSERT, UPDATE the whole table to test7 user
grant SELECT, INSERT, UPDATE                             on COMPETITION to test7;


---- Granting SELECT the whole table
grant SELECT on PLAYER to test7;


---- test7 user can now transfer his permission to SELECT PLAYER.RATING to other users
grant SELECT (RATING) on PLAYER to test7 with GRANT option;  


---- Allowing only data inneed for making select
grant SELECT  (COMPETITION_ID, WHITE_PART, BLACK_PART)   on GAME       to test7;
grant SELECT  (GRADE_ID)                                 on PLAYER     to test7;
grant SELECT  (TOURNAMENT_ID, NAME)                      on TOURNAMENT to test7;
grant SELECT  (GRADE_ID, GRADE)                          on GRADE      to test7;
 

---- Create view to let only used data in it, not in db-s 

if exists(select * from sys.views where NAME = 'PART_VIEW')  drop view PART_VIEW;
go
create view PART_VIEW as
       select CITY.NAME                                   [City name],
	          year (COMPETITION.START_DATE)               [Year],
			  PLAYER.FIRST_NAME + ' ' + PLAYER.LAST_NAME  [Name of player],
			  GRADE.GRADE                                 [Grade],
	          PARTICIPATION.PLACE                         [Final place]

        from PLAYER, CITY, GRADE, PARTICIPATION, COMPETITION
       where COMPETITION.CITY_ID = CITY.CITY_ID
	     and PARTICIPATION.COMPETITION_ID =  COMPETITION.COMPETITION_ID
         and PARTICIPATION.PLAYER_ID      =  PLAYER.PLAYER_ID
		 and PLAYER.GRADE_ID              =  GRADE.GRADE_ID
		 and PARTICIPATION.PLACE          <= 3
go

grant SELECT on PART_VIEW to test7;


/*

Folowing operations have to be used only once

create user  test8 FOR LOGIN test8; create login lab7tst with password = '12345', CHECK_POLICY = OFF;

-- add role to test7

create role PART_ROLE authorization db_datareader;
go 
exec sp_addrolemember @rolename = 'PART_ROLE', @membername = 'test7';

*/
*/