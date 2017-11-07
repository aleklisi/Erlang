-module(tree).
-compile([export_all]).

%Napisz moduł drzewa binarnego zawierający następujące funkcje:
%generacja losowego drzewa (liczby)

get_list_of_random_numbers() -> [rand:uniform(20) || _ <- lists:seq(1, 10)].

%wstawianie elementu do drzewa
tree_insert(Elem,empty) -> 
	{Elem,empty,empty};
tree_insert(Elem,{Content,Left,Right}) -> 
	case Elem > Content of 
		true -> {Content, tree_insert(Elem, Left), Right};		
		false -> {Content, Left, tree_insert(Elem, Right)}
	end.

%generacja drzewa z listy
tree_insert_list([], Tree) -> Tree;
tree_insert_list(List, Tree) ->
	[H|T] = List,
	NewTree = tree_insert(H,Tree),
	tree_insert_list(T, NewTree).

%zwinięcie drzewa do listy (3 dowolne metody)
%1
tree_to_list_lrn(empty) -> [];
tree_to_list_lrn({Content,Left,Right}) -> 
	tree_to_list_lrn(Left) ++ tree_to_list_lrn(Right) ++ [Content].
%2
%return sorting desc	
tree_to_list_lnr(empty) -> [];
tree_to_list_lnr({Content,Left,Right}) -> 
	tree_to_list_lnr(Left) ++ [Content] ++ tree_to_list_lnr(Right).
%3
%return sorting asc
tree_to_list_rnl(empty) -> [];
tree_to_list_rnl({Content,Left,Right}) -> 
	tree_to_list_rnl(Right) ++ [Content] ++ tree_to_list_rnl(Left).
	
%szukanie elementu w drzewie (wersja "zwyczajna" i wersja "wyjątkowa")
tree_search(_,empty) -> false;
tree_search(Elem, {Elem,_,_}) -> true;
tree_search(Elem, {Content,Left,Right}) -> tree_search(Elem,Left) or tree_search(Elem,Right).

%pom for testing
list_remove(_, []) -> [];
list_remove(Elem, [Elem|T]) -> T;
list_remove(Elem, [H|T]) -> [H] ++ list_remove(Elem,T).

list_anagram([],[]) -> true;
list_anagram(_,[]) -> false;
list_anagram([],_) -> false;
list_anagram([H|T],List2) -> 
	NewList2 = list_remove(H, List2),
	list_anagram(T,NewList2).