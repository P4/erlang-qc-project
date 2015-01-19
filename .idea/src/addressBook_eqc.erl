%%%-------------------------------------------------------------------
%%% @author Pawel
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. sty 2015 13:14
%%%-------------------------------------------------------------------
-module(addressBook_eqc).
-author("Pawel").

-include_lib("eqc/include/eqc.hrl").

%% API
%-export([]).
-compile(export_all).

% Record def.
-record(contact, {firstname, lastname, phone_number = [], mail = []}).
% record processing
getname(Contact) -> {Contact#contact.firstname,Contact#contact.lastname}.
getemails(Contact) -> Contact#contact.mail.
getphones(Contact) -> Contact#contact.phone_number.

%non-empty list

removing_contact() ->
  ?FORALL(B1, generators:addressBook_notempty(),
      ?FORALL(Contact, elements(B1),
        begin
          {F,L} = getname(Contact),
          B2 = addressBook:removeContact(B1,F,L),
          not lists:member( {F,L}, [getname(C) || C <- B2 ] )
        end
      )
  ).

adding_new_contact() ->
  ?FORALL( {First,Last,Book},
    {generators:name(),generators:name(),
      generators:addressBook()},
    ?IMPLIES(
      not lists:member({First,Last}, [getname(C) || C <- Book]),
      begin
        B2 = addressBook:addContact(Book,First,Last),
        lists:member( {First,Last}, [getname(C) || C <- B2 ] )
      end
    )
  ).

adding_existing_contact() ->
  ?FORALL(B, generators:addressBook_notempty(),
    ?FORALL(C, elements(B),
      begin
        {F,L} = getname(C),
        "Such contact already exists" == addressBook:addContact(B,F,L)
      end
    )
  ).

