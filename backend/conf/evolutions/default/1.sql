# --- Created by Ebean DDL
# To stop Ebean DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table user (
  user_id                   bigint not null,
  name                      varchar(255),
  lang                      varchar(255),
  constraint uq_user_name unique (name),
  constraint pk_user primary key (user_id))
;

create sequence user_seq;




# --- !Downs

SET REFERENTIAL_INTEGRITY FALSE;

drop table if exists user;

SET REFERENTIAL_INTEGRITY TRUE;

drop sequence if exists user_seq;

