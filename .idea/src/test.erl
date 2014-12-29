%%%-------------------------------------------------------------------
%%% @author Kubix
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. gru 2014 16:53
%%%-------------------------------------------------------------------
-module(test).
-include_lib("eqc/include/eqc.hrl").
-compile(export_all).
-author("Kubix").

%% API
-export([]).

% funkcja nie przechodząca wszystkich testów(przy 1000 się zwykle sypie)
% wywołujemy w konsoli -> eqc:quickcheck(eqc:numtests(1000,test:prop_delete_1())).
prop_delete_1() ->
  ?FORALL({I,L},{int(),list(int())},
    not lists:member(I, lists:delete(I,L))).

% funkcja przechodząca wszystkie testy(duplikaty usuwane)
% wywołujemy w konsoli -> eqc:quickcheck(eqc:numtests(1000,test:prop_delete_2())).
prop_delete_2() ->
  ?FORALL({I,L},{int(),list(int())},
    ?IMPLIES(no_duplicates(L),
      not lists:member(I,lists:delete(I,L)))).

no_duplicates(L) -> lists:usort(L) == lists:sort(L).

