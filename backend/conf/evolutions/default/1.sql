# --- Created by Ebean DDL
# To stop Ebean DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table event (
  event_id                  bigint not null,
  name                      varchar(255),
  desc                      varchar(255),
  from_epoch                bigint,
  to_epoch                  bigint,
  constraint pk_event primary key (event_id))
;

create table Client (
  client_id                 bigint not null,
  name                      varchar(255),
  lang                      varchar(255),
  constraint uq_Client_name unique (name),
  constraint pk_Client primary key (client_id))
;

create sequence event_seq;

create sequence Client_seq;




# --- !Downs

SET REFERENTIAL_INTEGRITY FALSE;

drop table if exists event;

drop table if exists Client;

SET REFERENTIAL_INTEGRITY TRUE;

drop sequence if exists event_seq;

drop sequence if exists Client_seq;

