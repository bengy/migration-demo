# --- Created by Ebean DDL
# To stop Ebean DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table modell_user (
  muser_id                  bigint not null,
  name                      varchar(255),
  lang                      varchar(255),
  constraint pk_modell_user primary key (muser_id))
;

create sequence modell_user_seq;




# --- !Downs

SET REFERENTIAL_INTEGRITY FALSE;

drop table if exists modell_user;

SET REFERENTIAL_INTEGRITY TRUE;

drop sequence if exists modell_user_seq;

