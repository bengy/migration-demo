# --- Created by Ebean DDL
# To stop Ebean DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table event (
  event_id                  bigint not null,
  name                      varchar(255),
  info                      varchar(255),
  from_epoch                bigint,
  to_epoch                  bigint,
  constraint pk_event primary key (event_id))
;

create table request (
  request_id                bigint not null,
  title                     varchar(255),
  desc                      varchar(255),
  inserted                  bigint,
  user_client_id            bigint,
  reply_to_request_id       bigint,
  constraint pk_request primary key (request_id))
;

create table Client (
  client_id                 bigint not null,
  name                      varchar(255),
  lang                      varchar(255),
  constraint uq_Client_name unique (name),
  constraint pk_Client primary key (client_id))
;

create sequence event_seq;

create sequence request_seq;

create sequence Client_seq;

alter table request add constraint fk_request_user_1 foreign key (user_client_id) references Client (client_id) on delete restrict on update restrict;
create index ix_request_user_1 on request (user_client_id);
alter table request add constraint fk_request_replyTo_2 foreign key (reply_to_request_id) references request (request_id) on delete restrict on update restrict;
create index ix_request_replyTo_2 on request (reply_to_request_id);



# --- !Downs

SET REFERENTIAL_INTEGRITY FALSE;

drop table if exists event;

drop table if exists request;

drop table if exists Client;

SET REFERENTIAL_INTEGRITY TRUE;

drop sequence if exists event_seq;

drop sequence if exists request_seq;

drop sequence if exists Client_seq;

