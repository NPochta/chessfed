-- ==================================================================================== --        
--                                                                                      --
--                               Лабораторная работа №9                                 --
--                                                                                      --  
-- ==================================================================================== --



BEGIN TRAN testInsert

SELECT * FROM PLAYER

INSERT   INTO PARTICIPATION VALUES (1, 2002, 1);
INSERT   INTO PARTICIPATION VALUES (2, 2003, 2);
INSERT   INTO PARTICIPATION VALUES (3, 2006, 6);
INSERT   INTO PARTICIPATION VALUES (4, 2004, 3);
INSERT   INTO PARTICIPATION VALUES (5, 2006, 5);
INSERT   INTO PARTICIPATION VALUES (6, 2004, 4);
INSERT   INTO PARTICIPATION VALUES (7, 2003, 1);

SELECT * FROM PLAYER


SELECT * FROM PARTICIPATION WHERE (COMPETITION_ID BETWEEN '2001' AND '2003') AND (PLAYER_ID BETWEEN '21' AND '23')


ROLLBACK
