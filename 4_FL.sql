
set dateformat dmy

-- Выбрать турнир с наибольшим количеством гроссмейстеров.
/*


--Выбрать тех шахматистов, которые выиграли не менее трех турниров в течение 2005 г.

select pl.pl_name as 'Chessmates, who won 3 tournaments during 2005' from
      (
        select plyr.FIRST_NAME + ' ' + plyr.LAST_NAME as pl_name , count (cmp.COMPETITION_ID) as cmp_id
          from PLAYER plyr
			 join PARTICIPATION pcp   on pcp.PLAYER_ID = plyr.PLAYER_ID
             join COMPETITION   cmp   on cmp.COMPETITION_ID = pcp.COMPETITION_ID
		   where pcp.PLACE = 1 and cmp.START_DATE > '01.01.2005' and cmp.END_DATE < '31.12.2005'
		   group by FIRST_NAME + ' ' + LAST_NAME 
       ) as pl  
	   where pl.cmp_id > 3

*/
--Выбрать те турниры, где ни одно призовое место не занял представитель страны-хозяина турнира.

select trn.NAME as [Tournament name], cmp.TOURNAMENT_ID
      from TOURNAMENT trn
	      join COMPETITION cmp on cmp.TOURNAMENT_ID = trn.TOURNAMENT_ID
