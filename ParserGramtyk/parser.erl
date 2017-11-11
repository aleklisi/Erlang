-module(parser).
-compile([export_all]).


%gramatyka {a,aa,aaa,aaaa,...}

rule(1,0) -> [1];
rule(2,1) -> [a];
rule(3,1) -> [1,a];

%gramatyka {ba,baa,baaa,baaaa,...}

rule(4,0) -> [b,1];
rule(5,1) -> [a];
rule(6,1) -> [1,a];

%gramatyka a^n b^n
rule(7,0) -> [1];
rule(8,1) -> [a,b];
rule(9,1) -> [a,1,b];

rule(_RuleNumber,_Variable) -> [removethislist].

%gramatyka {a,aa,aaa,aaaa,...}
gramatyka(1) -> [1,2,3];
%gramatyka {ba,baa,baaa,baaaa,...}
gramatyka(2) -> [4,5,6]; 
%gramatyka a^n b^n
gramatyka(3) -> [7,8,9];

gramatyka(_) -> io:fwrite("Ta grmatyka jeszcze nie istnieje\n").

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
    ListOfSolutionsWithoutDuplicates = sets:to_list(SetOfSolutions).


applay_list_of_rules_X_times(Words,0,_) -> Words;
applay_list_of_rules_X_times(Words,IterationLeft,ListOfRules) -> 
    NewWords = iterate_words(Words,ListOfRules),
    NewWords ++ applay_list_of_rules_X_times(NewWords,IterationLeft - 1,ListOfRules).

iterate_words([],_) -> [];
iterate_words([H|T],ListOfRules) -> applay_all_rules_from_list(H,ListOfRules) ++ iterate_words(T,ListOfRules).

%słowo startowe to 0, a zmienne to kolejne liczby
run(Iteracje,NrGramatyki) ->
    applay_list_of_rules_X_times([[0]],Iteracje,gramatyka(NrGramatyki)).