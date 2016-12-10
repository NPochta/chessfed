-- ==================================================================================== --        
--                                                                                      --
--                               Лабораторная работа №4                                 --
--                                                                                      --  
-- ==================================================================================== --


------------------------------------------------------------------------------------------
-- Задача 1
-- Выбрать турнир с наибольшим количеством гроссмейстеров.
------------------------------------------------------------------------------------------

SELECT TOP 1 WITH TIES tourn.NAME AS [Name of tournament], 
          COUNT (GRADE) AS [Grossmaster count]

FROM TOURNAMENT tourn 
JOIN COMPETITION comp  ON comp.TOURNAMENT_ID = tourn.TOURNAMENT_ID
JOIN GAME        gam   ON gam.COMPETITION_ID = comp.COMPETITION_ID
JOIN PLAYER      playr ON ((gam.BLACK_PART = playr.PLAYER_ID)
                       OR (gam.WHITE_PART = playr.PLAYER_ID))
JOIN GRADE       grad  ON playr.GRADE_ID = grad.GRADE_ID

WHERE grad.GRADE = '0MG' 
GROUP BY NAME 
ORDER BY [Grossmaster count] DESC


------------------------------------------------------------------------------------------
-- Задача 2
-- Выбрать те турниры, где ни одно призовое место не занял представитель страны-хозяина турнира
------------------------------------------------------------------------------------------

SELECT trn.NAME

FROM TOURNAMENT trn
INNER JOIN COMPETITION   cmp ON cmp.TOURNAMENT_ID  = trn.TOURNAMENT_ID
INNER JOIN PARTICIPATION pcp ON pcp.COMPETITION_ID = cmp.COMPETITION_ID
INNER JOIN PLAYER        plr ON plr.PLAYER_ID      = pcp.PLAYER_ID
INNER JOIN CITY          cty ON cty.CITY_ID        = cmp.CITY_ID
INNER JOIN COUNTRY       cat ON cat.COUNTRY_ID     = cty.COUNTRY_ID
INNER JOIN COUNTRY       car ON car.COUNTRY_ID     = plr.COUNTRY_ID

WHERE pcp.PLACE > 3 AND car.COUNTRY_ID != cat.COUNTRY_ID
GROUP BY trn.NAME


------------------------------------------------------------------------------------------
-- Задача 3
-- Выбрать тех шахматистов, которые выиграли не менее трех турниров в течение 2005 г.
------------------------------------------------------------------------------------------

SET DATEFORMAT dmy

SELECT plyr.FIRST_NAME + ' ' + plyr.LAST_NAME [Player name]

FROM PLAYER plyr
INNER JOIN PARTICIPATION pcp ON pcp.PLAYER_ID      = plyr.PLAYER_ID
INNER JOIN COMPETITION   cmp ON pcp.COMPETITION_ID = cmp.COMPETITION_ID

WHERE pcp.PLACE < 3 
  AND cmp.START_DATE > '01.01.2005' 
  AND cmp.END_DATE < '31.12.2005'
  
GROUP BY plyr.FIRST_NAME, plyr.LAST_NAME
HAVING COUNT (TOURNAMENT_ID) > 3


------------------------------------------------------------------------------------------
-- Задача 4
-- Определить турниры, в которых участник с самым высоким рейтингом занял последнее место.
------------------------------------------------------------------------------------------

SELECT * FROM (SELECT tra.NAME [Name]

FROM TOURNAMENT trn
INNER JOIN COMPETITION   cmp ON cmp.TOURNAMENT_ID  = trn.TOURNAMENT_ID
INNER JOIN PARTICIPATION pcp ON pcp.COMPETITION_ID = cmp.COMPETITION_ID
INNER JOIN PLAYER        plr ON pcp.PLAYER_ID      = plr.PLAYER_ID
INNER JOIN PARTICIPATION pcx ON pcp.PLAYER_ID      = pcx.PLAYER_ID
                            AND pcp.PLACE  < pcx.PLACE
INNER JOIN PLAYER        pyr ON pyr.RATING > plr.RATING
INNER JOIN COMPETITION   cpm ON cpm.COMPETITION_ID = pcx.COMPETITION_ID
INNER JOIN TOURNAMENT    tra ON tra.TOURNAMENT_ID  = cpm.TOURNAMENT_ID
) [Namelist]
GROUP by Name
ORDER BY Name DESC


---------
-- FIN --
---------