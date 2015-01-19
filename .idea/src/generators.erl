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
uppercase() -> choose($A,$Z).
lowercase() -> choose($a,$z).
digit() -> choose($0,$9).

% [A-Za-z0-9]+
alnum() -> non_empty( list(
  oneof([uppercase(),lowercase(),digit()])
)).

% Imię/Nazwisko [A-Z][a-z]*
name() -> non_empty(
  [uppercase() | list(lowercase())]
).

% domena, np. example.org
domain() ->
  LowerGen = non_empty(list(lowercase())),
  TLDs = oneof(["com","net","org"]),
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
    default( [], list(email()) ),
    default( [], list(phone()) )
  },
  #contact{
    firstname = FirstName, lastname = LastName,
    phone_number = Phones, mail = Emails
  }
).

addressBook() -> list(contact()).
addressBook_notempty() -> non_empty(addressBook()).