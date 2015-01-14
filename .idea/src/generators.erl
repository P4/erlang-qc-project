%%%-------------------------------------------------------------------
%%% @author Pawel
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. sty 2015 11:17
%%%-------------------------------------------------------------------
-module(generators).
-author("Pawel").

-include_lib("eqc/include/eqc.hrl").

%% API
-compile(export_all).

% addressBook
-record(contact, {firstname, lastname, phone_number = [], mail = []}).

%Generatory danych.

%Znaki alfanumeryczne
uppercase() -> eqc_gen:choose($A,$Z).
lowercase() -> eqc_gen:choose($a,$z).
digit() -> eqc_gen:choose($0,$9).

% [A-Za-z0-9]+
alnum() -> eqc_gen:non_empty( eqc_gen:list(
  eqc_gen:oneof([uppercase(),lowercase(),digit()])
)).

% Imię/Nazwisko [A-Z][a-z]*
name() -> eqc_gen:non_empty(
  [uppercase() | eqc_gen:list(lowercase())]
).

% domena, np. example.org
domain() ->
  LowerGen = eqc_gen:non_empty(eqc_gen:list(lowercase())),
  TLDs = eqc_gen:oneof(["com","net","org"]),
  ?LET({Lower,TLD}, {LowerGen,TLDs}, Lower++[$.|TLD]).

% adres e-mail
email() -> ?LET(
  {User,Domain}, {alnum(),domain()},
  User++[$@|Domain]
).

% nr telefonu: XXX-XXX-XXX, X=[0-9]
phone() -> [
  digit(),digit(),digit(),$-,
  digit(),digit(),digit(),$-,
  digit(),digit(),digit()
].

% wpis AddressBook'a
contact() -> ?LET(
  {FirstName,LastName,Phones,Emails}, {
    name(),name(),
    eqc_gen:default( [], eqc_gen:list(email()) ),
    eqc_gen:default( [], eqc_gen:list(phone()) )
  },
  #contact{
    firstname = FirstName, lastname = LastName,
    phone_number = Phones, mail = Emails
  }
).