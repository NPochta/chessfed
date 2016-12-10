set dateformat dmy

if exists(select * from sys.views where NAME = 'GRADE_VIEW_N')          drop view GRADE_VIEW_N;
if exists(select * from sys.views where NAME = 'COUNTRY_VIEW_N')        drop view COUNTRY_VIEW_N;
if exists(select * from sys.views where NAME = 'PLAYER_VIEW_N')         drop view PLAYER_VIEW_N;
if exists(select * from sys.views where NAME = 'PARTICIPATION_VIEW_N')  drop view PARTICIPATION_VIEW_N;
go

--Город, год, шахматист, звание, место - только призеры.
update PARTICIPATION_VIEW_N
set [city name]=''

create view PARTICIPATION_VIEW_N as
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

select * from PARTICIPATION_VIEW_N
go

--Шахматист, рейтинг, изменение рейтинга.

create view PLAYER_VIEW_N as
     select PLAYER.FIRST_NAME + ' ' + PLAYER.LAST_NAME as [Name],
	        PLAYER.RATING                              as [Player rating],
			PLAYER.RATING - (
			      select top 1 (NEW_RATING) 
				  from HISTORY 
				  
				  where HISTORY.PLAYER_ID = PLAYER.PLAYER_ID 
				     group by PLAYER_ID, HISTORY.NEW_DATE, HISTORY.NEW_RATING
				     order by PLAYER_ID desc
			)                                          as [Rating diff]
	 from PLAYER, PARTICIPATION group by PLAYER.PLAYER_ID, FIRST_NAME, LAST_NAME, PLAYER.RATING
go

select * from PLAYER_VIEW_N
go


-- Звание, имя, фамилия, место, дата начала, дата конца турнира

create view GRADE_VIEW_N as 
    select  GRADE.GRADE, 
		    PLAYER.FIRST_NAME, 
		    PLAYER.LAST_NAME, 
		    PARTICIPATION.PLACE,
		    GAME.START_DATE,
		    GAME.END_DATE
	from GRADE, PLAYER, GAME, COUNTRY, PARTICIPATION

    where PLAYER.GRADE_ID = GRADE.GRADE_ID 
	  and (GAME.BLACK_PART = PLAYER.PLAYER_ID or GAME.WHITE_PART = PLAYER.PLAYER_ID)
	  and PARTICIPATION.PLAYER_ID = PLAYER.PLAYER_ID and PARTICIPATION.COMPETITION_ID = GAME.COMPETITION_ID;
go

declare @current_year int;
declare @cryr_start   date;
declare @cryr_end     date;

set @current_year = datepart(year,getdate());
set @cryr_start   = cast ('01.01.' + cast (@current_year as varchar) as datetime);
set @cryr_end     = cast ('31.12.' + cast (@current_year as varchar) as datetime);

select GRADE                                  [Grade],
      count (distinct (FIRST_NAME+LAST_NAME)) [Number of players with that grade],
	  avg   (PLACE)                           [Average place],

	  (select count (PLACE) from GRADE_VIEW where PLACE = 1 and START_DATE between @cryr_start and @cryr_end)
	  as 'Victories in current year (the really current year)'
      
	  from GRADE_VIEW where SCORE = 1
	  group by GRADE order by GRADE desc; 
go



--Страна, фамилия, имя, город проведения соревнований, место

create view COUNTRY_VIEW_N as
     select COUNTRY.NAME,
	        PLAYER.FIRST_NAME,
			PLAYER.LAST_NAME,
		    COMPETITION.CITY_ID,
			PARTICIPATION.PLACE

	 from  COUNTRY, CITY, PLAYER, GAME, COMPETITION, PARTICIPATION
	 where PLAYER.COUNTRY_ID = COUNTRY.COUNTRY_ID 
	   and PARTICIPATION.COMPETITION_ID = COMPETITION.COMPETITION_ID 
	   and PARTICIPATION.PLAYER_ID = PLAYER.PLAYER_ID
	   with check option;
go


select NAME                                          [Country],
       count (distinct (FIRST_NAME+LAST_NAME))       [Number of players from that country]

       from COUNTRY_VIEW
	   group by NAME; 
go