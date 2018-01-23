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

Funkcja wyliczajaca silnie rekurencyjnie (ADA) dla blednych danych zglos wyjatek

function Factorial (N : Integer) return Integer is
	Error_Negative: exception;
begin
   
   if N <= 0 then
	raise Error_Negative with "Arg jest ujemny";
end if;
	    
   if N = 1 then
      return 1;
   else
      return (N * Factorial (N - 1));
   end if;
end Factorial;
	    
Erlang mapa
	    Map = #{a=>1, b=>2, c=>3}.

Odwroc liste bez lists:reverse

myReverse([],Result) -> Result;
myReverse([H|T], Result) -> myReverse(T,[H]++Result).

Program wyliczajacy trojki pitagoresjkie od 1..n
wynik ma byc lista ktorek

pyth(N) ->     [ {A,B,C} ||
		A <- lists:seq(1,N),  
		B <- lists:seq(1,N),  
		C <- lists:seq(1,N),
		A+B+C =< N,  
		A*A+B*B == C*C      ].

Operatora przypisania w ADZIE NIE MOZNA przeladowac

ZADANIE SPORADYCZNE sluzy do reakcji na zdarzenia Asynchroniczne

DOt. obiektow chronionych w Adzie:
wywolanie procedury ob. chronionego powoduje reewaluacje dozorcow dla wejsc

lists:zipWith(fun(X,Y) -> {X,Y} end, [1,2,3], [a,b,c]).
[{1,a}, {2,b}, {3,c}].

lists:foldl(fun(X,Sum) -> X-Sum end, 3, [X-1 || X <- lists:seq(1,5), X > 2]).
Wynik to: 0
explaination: 
X = 2 Sum = 3 (2 -3 = -1)
X = 3 Sum = -1 (3 - -1 = 3+1 = 4)
X = 4 Sum = 4 (4-4 = 0)

[X+Y || X <- [1,2], Y <- [2,3]].

[3,4,4,5]

Funkcja dzielaca liczby calkowite w Adzie. Jesli dzielnik == 0 to ma byc zglaszany wyjatek Zero z wiadomoscia "Nie dziel przez 0"
with Ada.Text_IO;
use Ada.Text_IO;

procedure Hello is 
	function Dzielenie(Dzielna: Integer; Dzielnik: Integer) return Integer is
		Error_Ujemny : exception;
		begin
			if Dzielnik = 0 then
				   raise Error_ujemny with "Nie dziel przez 0 !";
			end if;
				    
			return Dzielna/Dzielnik;
		end Dzielnie;

	begin
		Put("Podziel: 3/3 = " & Dzielenie(3,3)'Img);
	end Hello;

Napisz procedure w ktorej moze dojsc do zgloszenia wyjatku Name_Error wraz z przykkladowo obsluga
 procedure Open_or_Create (File: in out File_Type;
                            Mode: File_Mode; Name: String) is
  begin
    Open (File, Mode, Name);
  exception
    when Name_Error => Create (File, Mode, Name);
  end Open_or_Create;

Operacje bitowe mozemy wykonywac na TYPIE RESZTOWYM

Typy kontrolowane w Adzie -> pozwalaja programiscie na zdefiniowanie metod wykonywanych przy: inicjalizacji,
finalziacji i poprawianiu po przypisaniu.

Dla typu ograniczonego w Adzie: nie sa automatcyznie generowane operatory: :=, =, /=

lists:foldl(fun(X, Sum) -> X-Sum end, 0, [1,2,3,4,5]).
Wynik: 3.

bariery nie sa wartosciowane w obiekcie chronionym po wykonaniu funkcji

Wyroznik pozwala na parametryzacje wybranych typow

funkcja musi miec wszystkie parametry typu in 
function DFile(X: in A) retrun D

lists:zipWith(fun(X,Y) -> [X,[X|[Y]]] end, [1,2,3], [a,b,c]).
[[1,[1,a]],[2,[2,b]], [3,[3,c]]]

Instrukcja abort powoduje natychmiastowe bezwarunkowe zakonczenie zadania

Parametr klasowy T'Class:
			   - obejmuje wszystkie typy wyprowadzone z T
			    - pozwala na przechowywanie wartosci dowolnego typu wyprowadzonego z T
			    - wchodzac w sklad parametrow podprogramow wyklucza je z operacji podstawowych
			    
false: ma zawsze staly rozmiar i dlatego pozwala na wskazywanie dowolnego typu pochodnego
			    
Wykonanie w przeplocie: jedno zadanie wykonywane w danym momencie, kilka rozpoczetych
			   
CCS dopuszcza, aby def agentow byly wzajmenie rekurencyjne: zawsze
Wykonanie rownolegle: kilka zadan wykonywanych jednoczesnie
			   
identyfikator w Adzie: 
			   - musi sie zaczynac od litery
		           - nie moze zawierac spacji
		           - nie moze zaczynac sie od cyfry
		           - nie moze zawiera znaku specjalnego innego niz _
		       
Napisz funkcję w j. erlang, która podaną listę skróci o połowę uśredniając sąsiednie elementy. 
Funkcja ma obsługiwać też listy nieparzyste.
Napisz wersje gdzie ostatni element jest pomijany i doklejany.  dest(0) = (src(0)+src(1))/2 		      

short(X) -> short2(X,[]).

short2([], Res) -> lists:reverse(Res);
short2([A], Res) -> short2([],[A|Res]); // doklejamy
short2([A], Res) -> short2([],Res); //pomijamy
short2([A,B|T], Res) ->
		Md = (A+B/2),
		short2(T,[Md|Res]).

Napisz równoległą implementację funkcji map w Erlangu pmap(Fun,[Items]). 
Funkcja ma uwzględniać błędne działanie funkcji Fun na elementach listy. 

pmap(Function, List) ->   
	% spawn process for each element, and gather their pids into list   
	Pids = [spawn(?MODULE,execute, [self(), Function, El]) || El <- List], 
	%gather the results of the processes (in order) into a list   
	gather(Pids).  

% Execute the function and send the result back to the receiver
execute(Recv, Function, Element) ->  
	Recv ! {self(), catch(Function(Element))}.  
  
gather([]) ->
	[]; 
gather([H | T]) ->   
	receive     
		{H, Ret} ->      
			[Ret | gather(T)]   
	end.  
% example usage % 
MODULE_NAME:pmap((fun(X)-> 10/X end),[1,2,0,3,4,5,0,-1]).  
///inna wersja 
pmap(_,[])->[]; 
pmap(FUN,L)->    
	[begin   spawn(?MODULE,usingFun,[self(),FUN,A]),  
		 receive   
			 X->X 
		 end     
	 end || A<-L].  

usingFun(Pid,FUN,A)->     
	case catch(FUN(A)) of  
		B -> Pid!B    
	end.   

Napisz program, który stworzy 10 zadań i wywoła ich wejścia. 
Po otrzymaniu wywołaniu wejścia zadania mają się zakończyć (Ada).
Uwaga!! Program najpierw stworzy wszystkie zadania a później rozpocznie komunikację. 

procedure zad1 is  
task type A is   
	entry E; 
end;  

task body A is 
begin  
	accept E; 
end;  

procesy: array(Integer range 1..10) of A; 

begin   
	for i in 1..10 loop     
		procesy(i).E; 
	end loop; 
end zad1;   

Napisz w Erlangu „fork bomb”. Funkcja start() ma utworzyć 10 procesów, każdy z nich ma utworzyć kolejnych 10 procesów itd.
Po stworzeniu wspomnianych 10 procesów każdy proces „ojciec” ma zacząć wysyłać do nich wiadomości w nieskończonej pętli

start() -> 
	Pids = [ spawn(fun start/0) || _ <- lists:seq(1,10)], 
	loop(Pids).  

loop(Pids) -> 
	lists:foreach(fun(Pid) -> Pid ! {starting_pids, Pids} end, Pids),
	loop(Pids).

Napisz program w j. Erlang, który stworzy 100 procesów. 
Po stworzeniu wszystkich procesów program ma odczekać 2 sek i wysyłać do stworzonych procesów wiadomość 'pa'. 
Po otrzymaniu wiadomości procesy potomne mają wypisać swój pid i zakończyć się. 

start() -> 
	Pids = [ spawn(fun dziecko/0) || _ <- lists:seq(1,100)], 
	timer:sleep(2000), 
	lists:foreach(fun(Pid) -> Pid ! pa end, Pids).  

dziecko() -> 
	receive 
		pa -> io:fwrite("~p~n",[self()]) 
	end. 

Napisz fragment kodu w języku Ada, który pozwoli max przez 5sek oczekiwać na zakończenie wykonania procedury "FixWorld(W:World)".
Jeśli procedura się nie zakończy w tym czasie to ma zostać wyświetlony komunikat. 

with ada.text_io; 
use ada.text_io; 

procedure fixworld is 

procedure xx is
begin    
	delay 3.0;     
	put_line("xx");
end xx;  

begin     

select  
  	delay 2.0;
  	put_line("nie wykonano xx");     
	then 
		abort   xx; 
end select;  
end fixworld;   

Napisz w Erlangu sam kod procesu, który będzie odsyłał do nadawcy jego własną wiadomość.
Przychodząca wiadomość ma format {Pid,Data}. Gdzie Pid to identyfikator procesu nadawcy a Data to wiadomość do odesłania.
Jeśli proces otrzyma wiadomości, 
	które nie pasują do podanego wzorca to mają one zostać usunięte z kolejki i zignorowane. 

loop() -> 
	receive 
		{Pid,Data} -> Pid ! {Pid,Data};
		_ -> ok 
	end, 
	loop(). 

Napisz kod implementujący zegar Lamporta. (Pojedyncza funkcja procesu.) 
lamport(N) ->    
	receive  
		{msg,T} when  T> N ->  lamport(T+1); 
		{msg,T} when  T =< N ->  lamport(N+1) 
	end.  

