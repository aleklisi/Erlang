-module(pytania).
-compile(export_all).
%cd("C:/Users/sebac/Documents/Erlang/Programs/Erlang/Nacia").

%co zwroci ?? lists : any(fun(X)-> X > 3 end, [1, 2, 3, 4]). odp true

% lists : all(fun(X)-> X > 3 end, [1, 2, 3, 4]). odp false

% lists : append([[1,2],[3,4],[a,b,c]]). odp [1,2,3,4,a,b,c]

% lists : seq(1, 10). odp [1,2,3,4,5,6,7,8,9,10]

%lists:foldl(fun(X,Prod)-> X * -Prod end, 1, [1, 2, 3]). odp -6

%Napisz funkcje o nazwie my_fun która zwraca liczbę losową typu float z przedziału 2 do 4.

my_fun() -> (rand:uniform() + 1)  * 2.

my_fun2() -> (rand:uniform() * 2) + 2.

%Napisz funkcje o nazwie my_func lub kod do konsoli który zwraca liste 10
%losowych liczb losowa typu float z przedziału 0 do 1.

my_func() -> [rand:uniform() || _ <- lists:seq(1,10)].

my_funcc() -> createList([],10).

createList(L,0) -> L;
createList(L, N) -> 
    NewElement = rand:uniform(),
    NewList = L ++ [NewElement],
    N2 = N - 1,
    createList(NewList,N2).


%Napisz funkcje mySort przyjmujaca jako argument liste i sortujaca ją.

mySort(List) -> lists:sort(List).

mySort2([]) -> [];
mySort2([H]) -> [H];
mySort2([H|T]) ->
    Smaller = [X || X <- T, X < H],
    Greater = [Y || Y <- T, Y >= H],
    mySort2(Smaller) ++ [H] ++ mySort2(Greater).

%Napisz funkcje o naziwe map_add która przyjmuje Mape, Klucz i Wartosc i
%zwraca mape z dodana wartoscia i kluczem

map_add(Map,Key,Value) -> maps:put(Key,Value,Map).

map_add2(Map,Key,Value)-> Map#{Key => Value}.

%Napisz funkcje o naziwe map_add która przyjmuje Mape, Klucz i Wartosc i
%zwraca mape z uaktualniona (updated) wartoscia i kluczem

map_update(Map,Key,Value) -> map_add(Map,Key,Value).
map_update2(Map,Key,Value) -> Map#{Key => Value}.
map_update3(Map,Key, Value)-> Map#{ Key := Value}.

%Napisz funkcje o nazwie solution która bedzie oczekiwała na wiadomosc message i zwróci ok gdy ja dostanie

solution() ->
    receive 
        message -> ok
    end.

%Napisz funkcje o nazwie solution która Otrymuje jako argument liste intów i
%zwraca tylko parzyste z nich

solution2([]) -> [];
solution2([H|T]) ->
    case  H rem 2 == 0 of
        true -> [H] ++ solution2(T);
        false -> solution2(T)
    end.

solution3(List) -> [X ||X<- List, X rem 2 =:= 0].

% posumuj liczby od 1 do 100

sum() -> lists:foldr(fun(X,Prod) -> X + Prod end, 0, lists:seq(1,100)).
sum2() -> lists:sum(lists:seq(1,100)).

pomSum(0) -> 0;
pomSum(N)-> N + pomSum(N-1).

sum3()->pomSum(100).    

%Napisz funkcje o nazwie my_map która implementuje map wielowatkowo ( dla kazdego elementu listy osobny wątek) dodatkowe punkty za obsługę błędu.
my_map([], _) -> [];
my_map([H|T], F) -> [F(H)] ++ my_map(T,F).

thread(X,Fun,ParrentPID) -> ParrentPID ! {self(),Fun(X)}.

mapPIDS([],_) -> [];
mapPIDS([H|T],Fun) -> [spawn(pytania, thread, [H, Fun, self()])] ++ mapPIDS(T,Fun).

mainMap(List, Fun) -> 
    PIDs = mapPIDS(List,Fun),
    gather_all(PIDs, []).

gather1(PID) -> 
    receive 
        {PID, Result} -> Result
    after 
        3000 -> error
    end.

gather_all([],Results) -> Results;
gather_all(PIDs,Results) -> 
    [H|T] = PIDs,
    NewResult = gather1(H),
    gather_all(T,Results ++ [NewResult]).

%Napisz kod który zwróci najmniejszy element listy.

smallest(List) -> lists:min(List).
%definicja odpowienika kropki w haskellu
% DOT = fun(A,B) -> fun(X) -> A(B(X)) end end.
    
%Stwórz mape a => 1, b => 2, c => 3
map() -> #{a=>1,b=>2,c=>3}.

%lists:foldl(fun(X,Prod) -> {A,B} = X, Prod ++ [A,B] end, [],L5).

myFold([]) -> [];
myFold([{A,B}|T]) ->
    [A, B] ++ myFold(T). 

%<text>napisz funkcje my_receive która nie przyjmuje argumantu ale odbiera wioadomosc i jesli jest to atom pom to zwraca pom, jesli otrzyma cololwiek innego zwraca ok , jesli nie otrzyma nic przez 200 milisekund od uruchomienia zwraca atom timeout

my_receive() -> 
    receive 
        pom -> pom;
        _ -> ok
    after   
        200 -> timeout
    end.

% a < fun(X) -> X end. co sie wypisze ? true

% <text>napisz funkcje f która przyjmuje 1 argumant i zwraca a jesli argument jest mniejszy lub równy od 10, b jelsi argument jest w przedziale od 10 do 20,w kazdym inny przypadku zwrac c

myRet(A) when A =< 10 -> a;
myRet(A) when A < 20 -> b;
myRet(_) -> c.

%<text>napisz kod zwracający 2 elementowa krotkę skłądajacą sie z atomu a i liczy 5.

myKrotka() -> {a,5}.

%podaj przykład zachowania (behaviour) OTP 
%Odpowiedź przykładowa 1:
			%gen_server
	%Odpowiedź przykładowa 2:
			%gen_event
	%Odpowiedź przykładowa 3:
	%	supervisor

%% max listy
myMax(L) -> lists:max(L).

maxx(A,B) when A>=B -> A;
maxx(_,B) -> B.


% foldl(funckja dwuarg X(z listy) i Prod(pocztakowy), Prod, Lista)
myMax2([H|T]) -> lists:foldl(fun maxx/2, H, T).

%<text>Napisz program zwracający krotkę 2-elementową z najmniejszym i największym elementem listy (tmin\_max/1).
minMax([]) -> erlang:error("List is empty");
minMax([H|T]) -> {lists:foldl(fun(X, Prod) -> 
    case X < Prod of
         true -> X;
         false -> Prod
    end end , H, T), lists:foldl(fun maxx/2, H, T)}.

    %<text>Napisz program, który dla danego N zwróci listę formatu [N,N-1,…,2,1]

myList(N) when N < 0 -> erlang:error("N is negative");
myList(0) -> [];
myList(N) -> [N] ++ myList(N-1).

%lists:reverse(lists:seq(1,N)).

%<text>Napisz program generujący listę jedynek o zadanej długości.

generate(N) -> [1 || _ <- lists:seq(1,N)].

%<text>Napisz program generujący listę o podanej długości składającą się z podanego elementu.

generate2(Elem,N) -> [Elem || _ <- lists:seq(1,N)].

Weather = [{toronto, rain}, {montreal, storms}, {london, fog}, {paris, sun}, {boston, fog}, {vancouver, snow}].
[X || {X,Y} <- Weather, (Y == fog) or (Y == snow)].

Result: [london, boston, vancouver].

[{(X),Y} || X <- [1,2,3], Y <- [a,b]].
[{1,a}, {1,b}, {2,a}, {2,b}, {3,a}, {3,b}].

[X+Y || X <- [1,2], Y <- [2,3]].
[3,4,4,5].


%<text>Zdefiniuj stałą dla całego modułu TIMOUT na wartosc 200
-define(TIMEOUT, 200).

time() -> ?TIMEOUT.

!!!!!ADA
fragment kodu ktory bedzie uruchamial procedure blabla co 0.5 s kod ma niwelowac wplyw dlugosci wykonania procedury na czas pomiedzy uruchumieniami. Procedura ma sie wykonywac zawsze mniej niz 0.5 s

procedure Pol_Sec is 

	procedure blabla is 
	begin 
		//delay 0.3;
		Put_Line("Blabla");
	end blabla;   
 
	Loop_Time : Time_Span := To_Time_Span(0.5);
	Next_Loop_Time : Time;  
	begin 
	Next_Loop_Time := Clock; 

	loop 
		
		blabla;

		Next_Loop_Time := Next_Loop_Time + Loop_Time;
		delay until Next_Loop_Time;
	end loop;

end Pol_Sec;
