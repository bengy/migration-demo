# --- Created by Ebean DDL
# To stop Ebean DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table client (
  client_id                 bigint not null,
  name                      varchar(255),
  lang                      varchar(255),
  constraint pk_client primary key (client_id))
;

create sequence client_seq;




# --- !Downs

SET REFERENTIAL_INTEGRITY FALSE;

drop table if exists client;

SET REFERENTIAL_INTEGRITY TRUE;

drop sequence if exists client_seq;

