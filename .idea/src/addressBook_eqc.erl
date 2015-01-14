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

-record(contact, {firstname, lastname, phone_number = [], mail = []}).

removing_contact() ->
  ?FORALL(Book, eqc_gen:list(generators:contact()),
    ?IMPLIES( Book /= [],
      ?FORALL(Contact, elements(Book),
        begin
          {F,L} = {Contact#contact.firstname, Contact#contact.lastname},
          B2 = addressBook:removeContact(Book,F,L),
          not lists:member({F,L}, [{C#contact.firstname, C#contact.lastname} || C <- B2 ])
        end
      )
    )
  ).
