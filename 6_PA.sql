-- LOCK TABLE player IN ROW SHARE MODE NOWAIT;
-- ^-- Is not H/W => not inneed

--------------------------
--
--
--    Потерянные изменения
--
--
--------------------------

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
BEGIN TRAN
GO
    SELECT rating FROM player;
    UPDATE player SET rating += 1;

COMMIT TRAN;
GO

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

   UPDATE player SET rating += 1;

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


SET TRANSACTION ISOLATION LEVEl repeatabLe READ-- UNCOMMITTED 
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

BEGIN TRAN

   UPDATE player SET rating += 1;

ROLLBACK;



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
  
    INSERT INTO player VALUES (34, 'THOMAS','CASPER',1, 'M', '10.10.1969',6,2003);

COMMIT TRAN;


-- Getting everything back if something goes wrong
IF @@TRANCOUNT > 0 ROLLBACK;





--------------------------
--
--
--    Deadlock test
--
--
--------------------------


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRAN

     UPDATE player SET first_name = 'Phantom'
	 WHERE rating < 2100


	 --UPDATE player SET first_name = 'Phantom'
	 --WHERE rating > 2300

ROLLBACK;
