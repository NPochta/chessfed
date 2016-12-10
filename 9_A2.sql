-- ==================================================================================== --
--                                                                                      --
--                               Лабораторная работа №9                                 --
--                                                                                      --  
-- ==================================================================================== --


IF OBJECT_ID ('RATING_INC', 'TR') IS NOT NULL DROP TRIGGER RATING_INC;
GO
IF OBJECT_ID ('RATING_DEC', 'TR') IS NOT NULL DROP TRIGGER RATING_DEC;
GO



------------------------------------------------------------------------------------------
-- Задача 1
--
-- При занесении занятого шахматистом места рейтинг шахматиста, занявшего место не ниже 
-- 3-го увеличивается на величину: 
--
-- ( 4 - место ) * квалификационный уровень турнира, 
------------------------------------------------------------------------------------------


CREATE TRIGGER [RATING_INC] ON [dbo].[PARTICIPATION]
FOR INSERT
AS

BEGIN
     PRINT ('Trigger for updating rating is activated! INCREASE ATTEMPT')

	 DECLARE @rating INT;
	 SET @rating = (
		    SELECT RATING
	        FROM RATING rte
	        INNER JOIN INSERTED ixd ON ixd.PLAYER_ID = rte.PLAYER_ID
	 )
			
	 INSERT INTO RATING
	     SELECT ply.PLAYER_ID, @rating + (4 - pcp.PLACE) * cmp.TYPE_ID, GETDATE ()

	 FROM PLAYER ply
	 INNER JOIN PARTICIPATION pcp ON pcp.PLAYER_ID = ply.PLAYER_ID
	 INNER JOIN RATING        rtg ON rtg.PLAYER_ID = ply.PLAYER_ID
	 INNER JOIN COMPETITION   cmp ON cmp.COMPETITION_ID = pcp.COMPETITION_ID
	 WHERE pcp.PLACE < 3
END
GO




------------------------------------------------------------------------------------------
-- Задача 2
--
-- При занесении занятого шахматистом места рейтинг шахматиста из первой тройки и занявшего 
-- место ниже пятого понижается на величину: 
--
-- 0,1 * занятое место.
------------------------------------------------------------------------------------------



CREATE TRIGGER [RATING_DEC] ON [dbo].[PARTICIPATION]
FOR INSERT
AS

BEGIN
     PRINT ('Trigger for updating rating is activated! DECREASE ATTEMPT')

     DECLARE @is_change_need BIT;
	 SET @is_change_need =  
	 
	      CASE WHEN EXISTS
		            (
					    SELECT plr.PLAYER_ID FROM 
	                    (
						    SELECT TOP 3 plx.PLAYER_ID
						    FROM PLAYER plx
						    ORDER BY (SELECT RATING FROM RATING ret WHERE ret.PLAYER_ID = plx.PLAYER_ID)  DESC
				        )
				        AS plr 
						INNER JOIN inserted ON plr.PLAYER_ID = inserted.PLAYER_ID
						INNER JOIN PARTICIPATION pcp ON pcp.PLAYER_ID = plr.PLAYER_ID
						WHERE pcp.PLACE > 5
					) THEN 1
					ELSE 0
					END
    
	
	
	 INSERT INTO RATING
	 SELECT ply.PLAYER_ID, (
	                       SELECT RATING 
						   FROM RATING rte
						   INNER JOIN INSERTED idx ON idx.PLAYER_ID = rte.PLAYER_ID
					  ) - 0.1 * pcp.place, getdate()  
	 
	 FROM PLAYER ply
	 INNER JOIN PARTICIPATION pcp ON pcp.PLAYER_ID = ply.PLAYER_ID
	 INNER JOIN INSERTED      idx ON idx.PLAYER_ID = ply.PLAYER_ID
	 WHERE @is_change_need = 1
END

---------
-- FIN --
---------