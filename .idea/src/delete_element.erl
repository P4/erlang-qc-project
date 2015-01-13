%%%-------------------------------------------------------------------
%%% @author Kubix
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. gru 2014 16:53
%%%-------------------------------------------------------------------
-module(delete_element).
-include_lib("eqc/include/eqc.hrl").
-compile(export_all).
-author("Kubix").

%% API
-export([]).

% funkcja nie przechodząca wszystkich testów(przy 1000 się zwykle sypie)
% wywołujemy w konsoli -> eqc:quickcheck(eqc:numtests(1000,delete_element:prop_delete_1())).
prop_delete_1() ->
  ?FORALL({I,L},{int(),list(int())},
    not lists:member(I, lists:delete(I,L))).

% funkcja przechodząca wszystkie testy(duplikaty usuwane)
% wywołujemy w konsoli -> eqc:quickcheck(eqc:numtests(1000,delete_element:prop_delete_2())).
prop_delete_2() ->
  ?FORALL({I,L},{int(),list(int())},
    ?IMPLIES(no_duplicates(L),
      not lists:member(I,lists:delete(I,L)))).

% funkcja pokazująca jak ułomny jest nasz generator danych bez narzuconych żadnych ograniczzeń. Generuje prawie same listy nie zawierające na wejściu elementu, który hcemy usunąć.
% wywołujemy w konsoli -> eqc:quickcheck(eqc:numtests(100,delete_element:empty_lists_interesting_fact())).
empty_lists_interesting_fact() ->
  ?FORALL({I,L},{int(),list(int())},
    collect(lists:member(I,L),
      not lists:member(I,lists:delete(I,L)))).


% funkcja wywalająca się bardzo szybko(wystarczy ok. 14 testów).
% wywołujemy w konsoli -> eqc:quickcheck(eqc:numtests(1000,delete_element:prop_delete_3())).
prop_delete_3() ->
  ?FORALL(L,list(int()),
    ?IMPLIES(L /= [],
      ?FORALL(I,elements(L),
        not lists:member(I,lists:delete(I,L))))).

no_duplicates(L) -> lists:usort(L) == lists:sort(L).



% finalna dobra implementacja(wykorzystuje funkcję no_duplicates/1)
% wywołujemy w konsoli -> eqc:quickcheck(eqc:numtests(1000,delete_element:prop_delete_3())).

prop_delete_final() ->
  ?FORALL({I,L},
    {int(),list(int())},
    ?IMPLIES(no_duplicates(L),
      not lists:member(I,lists:delete(I,L)))).

ulist(Elem) ->
  ?LET(L,list(Elem),
    lists:usort(L)).

prop_delete_final_misconception() ->
  fails(
    ?FORALL(L,list(int()),
      ?IMPLIES(L /= [],
        ?FORALL(I,elements(L),
          not lists:member(I,lists:delete(I,L)))))).

%koniec problemu 1, pt. "Delete Element From The List"