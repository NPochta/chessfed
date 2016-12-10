-- TESTING ALGORYTHMS --

select * from GAME;


/*

alter table GAME     drop constraint FK_GAME_B, FK_GAME_W;
alter table HISTORY  drop constraint FK_HISTORY_P;
alter table PLAYER   drop constraint PLAYER_KEY;


alter table PLAYER   alter column PLAYER_ID bigint not null;
alter table HISTORY  alter column PLAYER_ID bigint not null;
alter table GAME     alter column WHITE_PART bigint not null;
alter table GAME     alter column BLACK_PART bigint not null;

alter table PLAYER   add constraint PLAYER_KEY primary key (PLAYER_ID);

alter table GAME add
     constraint FK_GAME_W foreign key (WHITE_PART)    references PLAYER     (PLAYER_ID)       on update no action on delete no action,
     constraint FK_GAME_B foreign key (BLACK_PART)    references PLAYER     (PLAYER_ID)       on update no action on delete no action

alter table HISTORY add
    constraint FK_HISTORY_P foreign key (PLAYER_ID)   references PLAYER     (PLAYER_ID)    on update no action on delete no action


--begin tran
--alter table HISTORY  drop constraint PK__HISTORY__5E53F32281E391A8;
--alter table GAME     drop constraint FK_GAME_B;
--alter table GAME     drop constraint FK_GAME_W;
--alter table PLAYER   drop constraint PK__PLAYER__5E53F32206376452;
--rollback


--alter table HISTORY  drop constraint PK__HISTORY__5E53F32281E391A8;
--alter table PLAYER   drop constraint PK__PLAYER__5E53F32206376452;

--alter table PLAYER   alter column PLAYER_ID bigint not null;
--alter table HISTORY  alter column PLAYER_ID bigint not null;
alter table GAME     alter column WHITE_PART bigint not null;
alter table GAME     alter column BLACK_PART bigint not null;

alter table PLAYER   add constraint PLAYER_KEY primary key (PLAYER_ID);

alter table GAME add
     constraint FK_GAME_W foreign key (WHITE_PART)    references PLAYER     (PLAYER_ID)       on update no action on delete no action,
     constraint FK_GAME_B foreign key (BLACK_PART)    references PLAYER     (PLAYER_ID)       on update no action on delete no action

alter table HISTORY add
    constraint FK_HISTORY_P foreign key (PLAYER_ID)   references PLAYER     (PLAYER_ID)    on update no action on delete no action
*/

