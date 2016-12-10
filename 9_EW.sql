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


------------- META --------------
-- Trigger name: RATING_INC
-- Table:        PARTICIPATION INSERT
-- Activated:    AFTER
-- Works on:     FOR ROW
---------------------------------

CREATE TRIGGER [RATING_INC] ON [dbo].[PARTICIPATION]
FOR INSERT
AS

BEGIN

     PRINT ('Trigger for updating rating is activated! INCREASE ATTEMPT')
     
	 UPDATE ply SET RATING  = 
	      CASE WHEN pcp.PLACE < 3
		         THEN ply.RATING + (4 - pcp.PLACE) * cmp.TYPE_ID
		         ELSE ply.RATING 
		  END

	 FROM PLAYER ply

	 INNER JOIN PARTICIPATION pcp ON pcp.PLAYER_ID = ply.PLAYER_ID
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


------------- META --------------
-- Trigger name: RATING_DEC
-- Table:        PARTICIPATION INSERT
-- Activated:    AFTER
-- Works on:     FOR ROW
---------------------------------

CREATE TRIGGER [RATING_DEC] ON [dbo].[PARTICIPATION]
FOR INSERT
AS

BEGIN
     PRINT ('Trigger for updating rating is activated! DECREASE ATTEMPT')
     UPDATE ply
	 SET RATING = 
		   CASE WHEN EXISTS 
			      (
				      SELECT plr.PLAYER_ID FROM 
	                  (
						    SELECT TOP 3 plx.PLAYER_ID
						    FROM PLAYER plx
						    ORDER BY plx.RATING DESC
				      )
				      AS plr 
				      WHERE plr.PLAYER_ID = ply.PLAYER_ID
				  ) 
				  AND pcp.PLACE > 5

		   THEN ply.RATING - 0.1 * place
		   ELSE ply.RATING END
	 FROM PLAYER ply
	 INNER JOIN PARTICIPATION pcp ON pcp.PLAYER_ID = ply.PLAYER_ID
END

---------
-- FIN --
---------