

--------------------------
--
--
--    Потерянные изменения
--
--
--------------------------

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRAN
GO
    SELECT rating FROM player;
    UPDATE player SET rating += 1;

COMMIT TRAN;
GO

-- Checking that everything is not ok
SELECT rating FROM player;


-- Getting everything back if something goes wrong
IF @@TRANCOUNT > 0 ROLLBACK;
    


--------------------------
--
--
--    Неповторяемое чтение
--
--
--------------------------




SET TRANSACTION ISOLATION LEVEL READ COMMITTED
--SET TRANSACTION ISOLATION LEVEL REPEATABLE READ 

BEGIN TRAN
   
   SELECT rating FROM player;


   
   SELECT rating FROM player;

COMMIT TRAN;


-- Getting everything back if something goes wrong
IF @@TRANCOUNT > 0 ROLLBACK;



--------------------------
--
--
--    Грязное чтение
--
--
--------------------------



SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
--SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

BEGIN TRAN
   
   SELECT rating FROM player;
   SELECT rating FROM player;
   SELECT rating FROM player;

COMMIT TRAN;





-- Getting everything back if something goes wrong
IF @@TRANCOUNT > 0 ROLLBACK;


--------------------------
--
--
--    Фантом
--
--
--------------------------

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ  
--SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

BEGIN TRAN
    
   SELECT rating FROM player WHERE rating in (2000, 2005);

   
   SELECT rating FROM player WHERE rating in (2000, 2005);

COMMIT TRAN;





--------------------------
--
--
--    Deadlock test
--
--
--------------------------



SET TRANSACTION ISOLATION LEVEL READ COMMITTED -- Different level, no difference
BEGIN TRAN

    SELECT * FROM player WHERE rating < 2100

     UPDATE player SET first_name = 'Phantom' 
	 WHERE rating in (2000, 2400)  -- Welcome to deadlock!

SELECT first_name as 'Name' FROM player;

ROLLBACK;

