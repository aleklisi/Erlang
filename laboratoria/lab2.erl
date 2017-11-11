%% coding: utf-8
-module(lab2).
-compile(compressed).
-export([map_append/3,
         map_update/3,
         map_display/1,
         count_occurences/1,
         count_occurences_in_files/1,
         map_merge_with/3]).

-spec map_append(term(),term(),map()) -> map().
map_append(Key, Value, Map) ->
    Map#{ Key =>Value }.

-spec map_update(term(),term(),map()) -> map().
map_update(Key, Value, Map) ->
    Map#{ Key := Value}.

-spec map_print_single(term(),term()) -> any().
map_print_single(K,V) -> 
    io:fwrite("~s => ~w\n",[K,V]),
    V.

-spec map_display(map()) -> 'ok'.
map_display(Map) -> maps:map(fun map_print_single/2,Map),
                    ok.

-spec map_merge_with(Fun,Map1,Map2) -> Map3 when 
      Fun :: fun((V1::T, V2::T) -> V3::T),
                 Map1 :: map(),
                 Map2 :: map(),
                 Map3 :: map(),
                 T :: term().
map_merge_with(Fun,M1,M2)->
    Key2 = maps:keys(M2),
    Fm = fun(K2, Acc) -> 
                 KeyInAcc = maps:is_key(K2,Acc),
                 if KeyInAcc -> 
                        maps:put(K2,
                                 Fun(
                                   maps:get(K2,Acc),
                                   maps:get(K2,M2)
                                  ),
                                 Acc);
                    true ->
                        maps:put(K2,maps:get(K2,M2),Acc)
                 end
         end,
    lists:foldl(Fm,M1,Key2).

-spec read_file_content(atom() | binary() | [atom() | [any()] | char()]) -> [byte()].
read_file_content(Name) ->
    {ok,FBin} = file:read_file(Name),
    binary:bin_to_list(FBin).

-spec tokenize_string([byte()]) -> [nonempty_string()].
tokenize_string(String) -> 
    TokenSeparators = " \n\r\t,.~`!@#$%^&*()-=+[]\\<>?/:;\"|{}'",
    string:tokens(String,TokenSeparators).

-spec aggregate_tokens([nonempty_string()],map()) -> map().
aggregate_tokens([],Map) -> Map;
aggregate_tokens([Tok|TokList],Map) ->
    KeyPresent = maps:is_key(Tok,Map),
    M1 = if 
             KeyPresent -> 
                 maps:update_with(Tok,fun(X) -> X+1 end,Map);
             true -> maps:put(Tok,1,Map)
         end,
    aggregate_tokens(TokList,M1).

-spec count_occurences(atom() | binary() | [atom() | [any()] | char()]) -> map().
count_occurences(FileName) ->
    Tokens = tokenize_string(read_file_content(FileName)),
    aggregate_tokens(Tokens,maps:new()).

-spec count_occurences_in_files([atom() | [any()] | char()]) -> any().
count_occurences_in_files(Pattern) ->
    Files = filelib:wildcard(Pattern),
    FileOccurences = lists:map(fun count_occurences/1, Files),
    lists:foldl(fun(E,Acc) -> 
                        map_merge_with(fun(X,Y)-> X+Y end,Acc,E) 
                end,
                #{},
                FileOccurences).
