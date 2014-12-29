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

prop_delete() ->
  ?FORALL({I,L},{int(),list(int())},
    ?IMPLIES(no_duplicates(L),
      not lists:member(I,lists:delete(I,L)))).
no_duplicates(L) -> lists:usort(L) == lists:sort(L).