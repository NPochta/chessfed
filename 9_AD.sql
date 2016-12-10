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
     
	 DECLARE @new_rat int;
	 SET     @new_rat = (SELECT MAX (RATING_ID) FROM RATING) + 1

	 INSERT INTO RATING
	 SELECT @new_rat, (SELECT RATING FROM RATING WHERE RATING_ID = @new_rat - 1) + (4 - pcp.PLACE) * cmp.TYPE_ID, getdate()  
	
	 FROM PLAYER ply
	 INNER JOIN PARTICIPATION pcp ON pcp.PLAYER_ID = ply.PLAYER_ID
	 INNER JOIN RATING        rtg ON rtg.RATING_ID = ply.RATING_ID
	 INNER JOIN COMPETITION   cmp ON cmp.COMPETITION_ID = pcp.COMPETITION_ID
	 WHERE pcp.PLACE < 3

	 UPDATE ply SET RATING_ID = 
         CASE WHEN pcp.PLACE < 3  
		       THEN @new_rat
	     END 
	 	   
	 FROM PLAYER ply
	 INNER JOIN PARTICIPATION pcp ON pcp.PLAYER_ID = ply.PLAYER_ID
	 INNER JOIN RATING        rtg ON rtg.RATING_ID = ply.RATING_ID
	 INNER JOIN COMPETITION   cmp ON cmp.COMPETITION_ID = pcp.COMPETITION_ID
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
	 
	 DECLARE @new_rat int;
	 SET     @new_rat = (SELECT MAX (RATING_ID) FROM RATING) + 1

     DECLARE @is_change_need BIT;
	 SET @is_change_need =  
	 
	      CASE WHEN EXISTS
		            (
					    SELECT plr.PLAYER_ID FROM 
	                    (
						    SELECT TOP 3 plx.PLAYER_ID
						    FROM PLAYER plx
						    ORDER BY (SELECT RATING FROM RATING ret WHERE ret.RATING_ID = plx.RATING_ID)  DESC
				        )
				        AS plr 
						INNER JOIN inserted ON plr.PLAYER_ID = inserted.PLAYER_ID
						INNER JOIN PARTICIPATION pcp ON pcp.PLAYER_ID = plr.PLAYER_ID
						WHERE pcp.PLACE > 5
					) THEN 1
					ELSE 0
					END
    
	
	
	 INSERT INTO RATING
	 SELECT @new_rat, (SELECT RATING FROM RATING WHERE RATING_ID = @new_rat - 1) - 0.1 * pcp.place, getdate()  
	 
	 FROM PLAYER ply
	 INNER JOIN PARTICIPATION pcp ON pcp.PLAYER_ID = ply.PLAYER_ID
	 WHERE @is_change_need = 1



     UPDATE ply
	 SET RATING_ID = 
		   CASE WHEN @is_change_need = 1 
		   THEN @new_rat
		   END
	 FROM PLAYER ply
END

---------
-- FIN --
---------