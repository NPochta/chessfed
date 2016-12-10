
EXECUTE AS USER = 's33';
CREATE TABLE TESTFORUSERS33 (
    A_FIELD  int          not null,
    B_FIELD  char         not null,

    constraint PLAYER_KEY primary key (A_FIELD)
);


grant SELECT (RATING) on PLAYER to test8; 
go








/*

--H/W
---- Lets do something complicated. Take this select from lab4 as an example
select top 1 tourn.NAME as 'Name of tournament', COUNT (GRADE) as 'Grossmaster count'
         from TOURNAMENT tourn 
			join COMPETITION comp  on comp.TOURNAMENT_ID = tourn.TOURNAMENT_ID
			join GAME        gam   on gam.COMPETITION_ID = comp.COMPETITION_ID	
			join PLAYER      playr on ((gam.BLACK_PART = playr.PLAYER_ID) or (gam.WHITE_PART = playr.PLAYER_ID))
			join GRADE       grad  on playr.GRADE_ID = grad.GRADE_ID
		 where grad.GRADE = '0MG' group by NAME order by [Grossmaster count] desc
go

---- Trying to access view we made in admin user
select * from PART_VIEW; 

*/