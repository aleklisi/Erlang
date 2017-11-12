-module(parser).
-compile([export_all,debug_info]).
-export([run/3]).
-import(list_com,[list_devide_to_three/1,list_remove_empty/1,remove_duplicates/1]).
-import(gramatyki,[rule/2,gramatyka/1]).

applay_single_rule_to_single_word(RuleNumber,{WordP,WordS,WordK}) ->
    RuleResult = gramatyki:rule(RuleNumber,WordS),
    case RuleResult of
        removethislist -> 
            cantapplayrule; 
        _ -> 
            WordP ++ RuleResult ++ WordK
    end.

applay_single_rule_to_list_of_words(_,[]) -> [];
applay_single_rule_to_list_of_words(RuleNumber,ListOfDevidedWords) ->
    [H|T] = ListOfDevidedWords,
    NewWord = applay_single_rule_to_single_word(RuleNumber,H),
    case NewWord of 
        cantapplayrule -> applay_single_rule_to_list_of_words(RuleNumber,T);
        _ -> NewWord ++ applay_single_rule_to_list_of_words(RuleNumber,T)
    end.

iterate_all_possible_rules(_,[]) -> [];
iterate_all_possible_rules([],_) -> [];
iterate_all_possible_rules(Word,ListOfRules) ->
    [H|T] = ListOfRules,
    AllWordPossibilities = list_com:list_devide_to_three(Word),
    Pom = applay_single_rule_to_list_of_words(H,AllWordPossibilities) ,
    Pom2 = iterate_all_possible_rules(Word,T),
    list_com:list_remove_empty([Pom] ++ Pom2).

iterate_words([],_) -> [];
iterate_words(_,[]) -> [];
iterate_words(Words,ListOfRules) ->
    [HW|TW] = Words,
    Pom = iterate_all_possible_rules(HW,ListOfRules),
    list_com:list_remove_empty(Pom ++ iterate_words(TW,ListOfRules)).

run(0,_,StartWords) -> StartWords;
run(Iteration,NumerGramtyki,StartWords) -> 
    NewWords = iterate_words(StartWords,gramatyki:gramatyka(NumerGramtyki)),
    DupicatesRemoved = list_com:remove_duplicates(NewWords),
    DupicatesRemoved ++ run(Iteration - 1,NumerGramtyki,DupicatesRemoved).


go() -> wypisz(list_com:remove_duplicates(run(8,1,[[0]]))).

wypisz([H|T]) -> io:fwrite("~p\n",[H]),wypisz(T); 
wypisz([]) -> ok.