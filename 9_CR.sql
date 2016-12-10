set dateformat dmy

if exists (select 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'PARTICIPATION') drop table PARTICIPATION;
if exists (select 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'HISTORY')       drop table HISTORY;
if exists (select 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'GAME')          drop table GAME;
if exists (select 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'COMPETITION')   drop table COMPETITION;
if exists (select 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'TOURNAMENT')    drop table TOURNAMENT;
if exists (select 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'TYPE')          drop table TYPE;
if exists (select 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'PLAYER')        drop table PLAYER;
if exists (select 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'RATING')        drop table RATING;
if exists (select 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'GRADE')         drop table GRADE;
if exists (select 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'CITY')          drop table CITY;
if exists (select 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'COUNTRY')       drop table COUNTRY;
if exists (select 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'STATUS')        drop table STATUS;

create table PLAYER (
    PLAYER_ID  int          not null,
    FIRST_NAME varchar (64) not null,
	LAST_NAME  varchar (64) not null,
    COUNTRY_ID smallint     not null, 
    GENDER     varchar (1)  not null,
    BIRTH_DATE date         not null,
    GRADE_ID   smallint     not null,
	RATING_ID  int          not null,
    constraint PLAYER_KEY primary key (PLAYER_ID)
);

create table COUNTRY (
    COUNTRY_ID     smallint  not null,
    NAME       varchar (64)  not null
	constraint COUNTRY_KEY primary key (COUNTRY_ID)
);

create table COMPETITION (
    COMPETITION_ID smallint  not null,
    TOURNAMENT_ID  smallint  not null,
    CITY_ID        smallint  not null,
    START_DATE     date      not null,
    END_DATE       date      not null,
    TYPE_ID        smallint  not null,
	PARTICIP_NO    int       not null,
	constraint COMPETITION_KEY primary key (COMPETITION_ID)
);
 
create table TYPE (
    TYPE_ID   smallint       not null,
    TYPE      varchar (64)   not null,
	constraint TYPE_KEY primary key (TYPE_ID)
);
 

create table CITY (
    CITY_ID    smallint      not null,
    NAME       varchar (64)  not null,
    COUNTRY_ID smallint      not null,
	constraint CITY_KEY primary key (CITY_ID)
);
 
 
create table GRADE (
    GRADE_ID   smallint      not null,
    GRADE      varchar (64)  not null,
	constraint GRADE_KEY primary key (GRADE_ID)
);
 
create table TOURNAMENT (
    TOURNAMENT_ID  smallint  not null,
    NAME      varchar (256)  not null unique,
	constraint TOURNAMENT_KEY primary key (TOURNAMENT_ID)
);
 
create table GAME (
    GAME_ID        smallint  not null,
    WHITE_PART     int       not null,
    BLACK_PART     int       not null,
	COMPETITION_ID smallint  not null,
    START_DATE     date      not null,
	END_DATE       date      not null,
	SCORE          real      not null 
	               check     (SCORE = 1.0 or SCORE = 0.0 or SCORE = 0.5),
	STATUS_ID      smallint  not null,
	constraint GAME_KEY primary key (GAME_ID)
);
 

create table STATUS (
    STATUS_ID      smallint not null,
    STATUS         varchar (64),
	constraint STATUS_KEY primary key (STATUS_ID)
);

create table RATING (
    RATING_ID  int          not null,
	RATING     int          not null,
	SET_DATE   date         not null

	constraint RATING_KEY primary key (RATING_ID)
);


create table HISTORY (
    PLAYER_ID  int        not null,
	NEW_RATING smallint   not null,
	NEW_DATE   date       not null,
	constraint HISTORY_KEY primary key (PLAYER_ID, NEW_DATE)
);

create table PARTICIPATION (
     PLAYER_ID       int,
	 COMPETITION_ID  smallint,
	 PLACE           int,
     constraint PARTICIPATION_KEY primary key (PLAYER_ID, COMPETITION_ID)
);

alter table PLAYER add
     constraint FK_PLAYER_C        foreign key (COUNTRY_ID)    references COUNTRY (COUNTRY_ID)        on update no action on delete no action,
	 constraint FK_PLAYER_G        foreign key (GRADE_ID)      references GRADE   (GRADE_ID)          on update no action on delete no action
 
alter table CITY add
     constraint FK_CITY_C          foreign key (COUNTRY_ID)    references COUNTRY   (COUNTRY_ID)      on update no action on delete no action
  
 
alter table COMPETITION add
     constraint FK_COMPETITION_C   foreign key (CITY_ID)       references CITY       (CITY_ID)        on update no action on delete no action,  
     constraint FK_COMPETITION_T   foreign key (TOURNAMENT_ID) references TOURNAMENT (TOURNAMENT_ID)  on update no action on delete no action,
     constraint FK_COMPETITION_R   foreign key (TYPE_ID)       references TYPE       (TYPE_ID)        on update no action on delete no action


alter table GAME add
     constraint FK_GAME_W          foreign key (WHITE_PART)    references PLAYER     (PLAYER_ID)      on update no action on delete no action,
     constraint FK_GAME_B          foreign key (BLACK_PART)    references PLAYER     (PLAYER_ID)      on update no action on delete no action,
     constraint FK_GAME_S          foreign key (STATUS_ID)     references STATUS     (STATUS_ID)      on update no action on delete no action

alter table HISTORY add
     constraint FK_HISTORY_P       foreign key (PLAYER_ID)     references PLAYER     (PLAYER_ID)      on update no action on delete no action

alter table PARTICIPATION add
     constraint FK_PARTICIPATION_P foreign key (PLAYER_ID)      references PLAYER     (PLAYER_ID)       on update no action on delete no action,
	 constraint FK_PARTICIPATION_C foreign key (COMPETITION_ID) references COMPETITION(COMPETITION_ID)  on update no action on delete no action


alter table PLAYER add
     constraint FK_PLAYER_R        foreign key (RATING_ID)    
	 references RATING (RATING_ID) on update no action on delete no action

