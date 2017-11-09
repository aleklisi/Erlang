-module(tree).
-compile([export_all]).

%Napisz moduł drzewa binarnego zawierający następujące funkcje:
%generacja losowego drzewa (liczby)
get_list_of_random_numbers() -> [rand:uniform(20) || _ <- lists:seq(1,5)].

%wstawianie elementu do drzewa
insert(Elem,{tree,empty}) -> {tree,Elem,{tree,empty},{tree,empty}};
insert(Elem,{tree,Content,Left,Right}) -> 
	case Elem > Content of 
		true -> {tree,Content,insert(Elem, Left),Right};		
		false -> {tree,Content,Left,insert(Elem,Right)}
	end.

%generacja drzewa z listy
insert_from_list([], Tree) -> Tree;
insert_from_list([H|T], Tree) ->
	NewTree = insert(H,Tree),
	insert_from_list(T, NewTree).

%zwinięcie drzewa do listy (3 dowolne metody)%1
to_list_lrn({tree,empty}) -> [];
to_list_lrn({tree,Content,Left,Right}) -> 
	to_list_lrn(Left) ++ to_list_lrn(Right) ++ [Content].
%2
to_list_lnr({tree,empty}) -> [];
to_list_lnr({tree,Content,Left,Right}) -> 
	to_list_lnr(Left) ++ [Content] ++ to_list_lnr(Right).
%3
to_list_rnl({tree,empty}) -> [];
to_list_rnl({tree,Content,Left,Right}) -> 
	to_list_rnl(Right) ++ [Content] ++ to_list_rnl(Left).
	
%szukanie elementu w drzewie (wersja "zwyczajna")
search(_,{tree,empty}) -> false;
search(Elem, {tree,Elem,_,_}) -> true;
search(Elem, {tree,_,Left,Right}) -> search(Elem,Left) or search(Elem,Right).
	
%szukanie elementu w drzewie (wersja "wyjątkowa")
search_exception(Elem,Tree) ->
	try  search_e(Elem,Tree) of
		_ -> not_found
	catch
		_:_ -> found
		end.
	
search_e(_,{tree,empty}) -> not_found;
search_e(Elem, {tree,Elem,_,_}) -> throw(found);
search_e(Elem, {tree,_,Left,Right}) -> 	search_e(Elem,Left),
	search_e(Elem,Right).