-module(parser).
-compile([export_all]).
-export([run/2]).
-import(list_com,[list_devide_to_three/1]).
-import(gramatyki,[rule/2,gramatyka/1]).

add_to_each_list_new_begginnig([],_) -> [];
add_to_each_list_new_begginnig([H|T],Elem) -> [[Elem] ++ H | add_to_each_list_new_begginnig(T,Elem)].

applay_single_rule(_,[]) -> [];
applay_single_rule(RuleNumber,[H|T]) -> 
    RuleResult = rule(RuleNumber,H),
    RestOfWord = applay_single_rule(RuleNumber,T),
    FullWords = add_to_each_list_new_begginnig(RestOfWord,H),
    case RuleResult of
        [removethislist] -> FullWords;
        _ -> [RuleResult ++ T] ++ FullWords
    end.

applay_all_rules_from_list(Word,[]) -> Word;
applay_all_rules_from_list(Word,RuleNumbers) ->
    [H|T] = RuleNumbers,
    ListOfSolutionsWithDuplicates = applay_single_rule(H,Word) ++ applay_all_rules_from_list(Word,T),
    SetOfSolutionsWith = sets:from_list(ListOfSolutionsWithDuplicates),
    Pom = sets:from_list([0,Word] ++ Word),
    SetOfSolutions = sets:subtract(SetOfSolutionsWith,Pom),
    sets:to_list(SetOfSolutions).


applay_list_of_rules_X_times(Words,0,_) -> Words;
applay_list_of_rules_X_times(Words,IterationLeft,ListOfRules) -> 
    NewWords = iterate_words(Words,ListOfRules),
    NewWords ++ applay_list_of_rules_X_times(NewWords,IterationLeft - 1,ListOfRules).

iterate_words([],_) -> [];
iterate_words([H|T],ListOfRules) -> applay_all_rules_from_list(H,ListOfRules) ++ iterate_words(T,ListOfRules).

%słowo startowe to 0, a zmienne to kolejne liczby
run(Iteracje,NrGramatyki) ->
    applay_list_of_rules_X_times([[0]],Iteracje,gramatyka(NrGramatyki)).