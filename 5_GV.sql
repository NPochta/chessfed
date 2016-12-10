set dateformat dmy

if exists(select * from sys.views where NAME = 'GRADE_VIEW')          drop view GRADE_VIEW;
if exists(select * from sys.views where NAME = 'COUNTRY_VIEW')        drop view COUNTRY_VIEW;
if exists(select * from sys.views where NAME = 'PLAYER_VIEW')         drop view PLAYER_VIEW;
if exists(select * from sys.views where NAME = 'PARTICIPATION_VIEW')  drop view PARTICIPATION_VIEW;
go

--Звание, количество шахматистов в этом звании, количество побед на турнирах в текущем году, среднее место на турнирах в текущем году.

create view GRADE_VIEW as 
    select  GRADE.GRADE_ID as ID, 
	        GRADE.GRADE, 
		    PLAYER.FIRST_NAME, 
		    PLAYER.LAST_NAME, 
		    GAME.GAME_ID, 
		    GAME.SCORE,
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



--Страна, количество шахматистов из этой страны, принимавших участие в турнирах, количество побед шахматистов из этой страны.

create view COUNTRY_VIEW as
     select COUNTRY.NAME,
	        PLAYER.FIRST_NAME,
			PLAYER.LAST_NAME,
		    COMPETITION.CITY_ID,
			PARTICIPATION.PLACE

	 from  COUNTRY, CITY, PLAYER, GAME, COMPETITION, PARTICIPATION
	 where PLAYER.COUNTRY_ID = COUNTRY.COUNTRY_ID 
	   and PARTICIPATION.COMPETITION_ID = COMPETITION.COMPETITION_ID 
	   and PARTICIPATION.PLAYER_ID = PLAYER.PLAYER_ID;
go


select NAME                                          'Country',
       count (distinct (FIRST_NAME+LAST_NAME))       'Numbe of players from that country' /*,
	   (select count (distinct FIRST_NAME+LAST_NAME) as CN_NAME from COUNTRY_VIEW where PLACE = 1)
	                                                 'Victories in this country'*/

       from COUNTRY_VIEW
	   group by NAME; 
go



--Шахматист, рейтинг, статистика по всем проводившимся турнирам, изменение рейтинга.

create view PLAYER_VIEW as
     select PLAYER.FIRST_NAME,
	        PLAYER.LAST_NAME, 
			GAME.SCORE,
		    PLAYER.RATING,
			HISTORY.NEW_RATING

	  from PLAYER, GAME, HISTORY
	 where (GAME.BLACK_PART = PLAYER.PLAYER_ID or GAME.WHITE_PART = PLAYER.PLAYER_ID)
	   and HISTORY.PLAYER_ID = PLAYER.PLAYER_ID
go
select FIRST_NAME + ' ' + LAST_NAME as 'NAME',
       sum (SCORE)                  as 'Total score',
	   count (SCORE)                as 'Games played',
	   RATING                       as 'Start rating',
       avg (NEW_RATING)             as 'Average rating',
	   max (NEW_RATING) - RATING    as 'Achieved during games'
	   
	   from PLAYER_VIEW 
	   group by RATING, FIRST_NAME, LAST_NAME order by RATING desc;
go


--Город, год, шахматист, звание, место - только призеры.

create view PARTICIPATION_VIEW as
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

select * from PARTICIPATION_VIEW