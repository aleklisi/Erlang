-module(pytania).
-compile(export_all).
%cd("C:/Users/sebac/Documents/Erlang/Programs/Erlang/Nacia").

%co zwroci ?? lists : any(fun(X)-> X > 3 end, [1, 2, 3, 4]). odp true

% lists : all(fun(X)-> X > 3 end, [1, 2, 3, 4]). odp false

% lists : append([[1,2],[3,4],[a,b,c]]). odp [1,2,3,4,a,b,c]

% lists : seq(1, 10). odp [1,2,3,4,5,6,7,8,9,10]

%lists:foldl(fun(X,Prod)-> X * -Prod end, 1, [1, 2, 3]). odp -6

%Jaka operaje mozesz wykonac na nieskonczonej liscie?
%tylko foldr nie foldl

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

NiechdanyjestPID=<1.2.3>orazwiadomoscwpostaciatomuotrescimessage.którezponizszychwysyławwwiadomoscdoprocesuowwpidzie?

PID!message.

Danyjestmoduł moj_mod,
	któryzawierafunkcj moja_fun 
			     któraprzyjmujejakoargumentlisteliczbcałkowitych.
NapiszkodktóryuruchomiwwfunkcjejakoNOWYporceszlistaliczb 1,2,3,4,5,6,7 jakoargument

spawn(moj_mod, moja_funk, [lists:seq(1,7)]).

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

napisz kod eportujacy funkcje f/2 danego zdanego modułu
-export([f/2]).

napisz kod importujacy funkcje f/2 z modułu moj_mod
-import(moj_mod,[f/2]).

Dana sa listy
L1 = lists : seq(1, 9).
L2 = lists : seq(1, 5).
dopisz kod zwracajacy liste [6, 7, 8, 9]

L1 -- L2.
lists:subtract(L1,L2).

Dana sa listy
L1 = lists : seq(1; 5).
L2 = [a; b; c; d; e].
dopisz kod zwracajacy liste [1, a, 2, b, 3, c, 4, d, 5, e]

lists:zip(L1,L2).

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

Zdefiniuj stałą dla całego modułu TIMOUT na wartosc 200
-define(TIMEOUT,200).

time() -> ?TIMEOUT.

jak uruchomic debugger w shellu Erlanga?
debugger:start().

Jak poprawnie zdefiniować funkcje anonimową w Erlang
F = fun(X) -> 2*X end.

T1 i T2 są typu Time. Ich różnica będzie typu...
Duration

Co zrobić, żeby program poczekał?
Użyc delay
		 
Aby linijka "Gen: Generator;" była poprawna, należy użyć 
		 pakietu:Ada.Numerics.Discrete_Random lub Ada.Numerics.Float_Random

type Wektor is array (Integer range <>) of Float;
procedure los_wektor(w : in Wektor) is
begin
Reset(Gen);
for E of w loop
	E := Random(Gen);
end loop;
end los_wektor;
Ta procedura jest:

Niepoprawna. Powinno być "procedure los_wektor(w : in out Wektor) is".

type Wektor is array (Integer range <>) of Float;
function do_something(w : in Wektor ) return Boolean is
(for all I in w'First..(w'Last-1) => w(I)<=w(I+1));
Ta funkcja:
Sprawdzi, czy wektor jest posortowany niemalejąco.


A,B,C są tablicami. "A := B & C;"

Zadziała, o ile A'Range jest równe B'Range + C'Range.

Co nie zakończy zadania w Adzie?
Wykonanie instrukcji terminate
Zgłoszenie obsłużonego wyjątku.

Jaka instrukcja pozwala na (normalne) zakończenie zadania?
break / terminate/ exit/ stop

Jakiego typu musi być wartość przekazana instrukcji delay?
Duration/ Float/ Integer/ Span

Co jest odpowiednikiem monitora w Adzie?
monitor/ zmienna dzielona/ obiekt chroniony/ zadanie 

raczej obiekt chroniony

Który z atrybutów nie jest dostępny dla typów wyliczeniowych?
Vat/ Range/ Succl/ Firs

Mozna: First/Last ; Succ/ Pred ; Pos; Val

Które zdanie dotyczące funkcji w Adzie nie jest prawdziwe?
Atrybuty funkcji maja domyślnie tryb in./
Atrybuty funkcji mogą mieć tryb out./ (NIE MOGA MIEC)
Funkcja może zawierać wiele instrukcji return./
Funkcja musi zawierać przynajmniej jedną instrukcję return./

Wartości jakiego typu nie może przyjmować wyróżnik typu
rekordowego?
Character/ Boolean/ Integer/ Float

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

pyth(_) when N =< 0 -> erlang:error("N <= 0");
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

 Napisz prosty serwer, który będzie zwracał wiadomość, jaką otrzymał od klienta (usługa “echo”). 
Serwer ma przyjmować komunikaty od dowolnego procesu. 
PID serwera przekazywany jest jako parametr.  

-module(mod).
-compile(export_all).   

% -----  proces server  -------  
loop() ->     
	receive  
		{req, From, Msg} ->           From ! {response, self(), Msg}    
	end,      
	loop().   

% -------  funkcja klienta  -------- 
% ServerPid :  pid procesu który odapala funkcję loop() - czyli naszego servera % Msg : treść wiadomości   
client(ServerPid, Msg) ->     
	ServerPid ! {req, self(), Msg},   
	receive      
		{response, ServerPid, Msg} ->     
			io:format("Wiadomosc otrzymana z server: ~p ~n",[Msg])    
	after 1000 -> {error}   
	end.    
% ------  funkcja tworząca proces servera  ------  
start() ->   
    spawn(mod, loop, []). 

 Napisz program, który dla podanej listy procesów L roześle do każdego procesu z listy wiadomość “hello”.  

func([]) ->   
	{ok}; 
func([H|T]) ->   
	H!hello,    
	func(T).   

27. Napisz prostą bazę danych.
Ma istnieć możliwość zapisu, usunięcia oraz odczytu wszystkich elementów.
Baza ma działać jako oddzielny proces i ma zapisywać, usuwać elementy z wewnętrznej listy. 
Do komunikacji z bazą używaj funkcji add/1, delete/1 oraz show/0.  

-module(mod). 
-compile(export_all).   
% --- tworzy bazę + rejestruje nazwę celem łatwego dostępu do niej z innych funkcji  
start() ->    register(database, spawn(mod, loop, [[]])).   
% --- proces bazy danych ---- 
% L : jest to lista do której będę dodawane/odejmowane elementy   
loop(L) ->  
	receive   
		{add, Data} ->      
			loop(L++[Data]);   
		{delete, Data} ->        
			loop(lists:delete(Data, L));    
		{show} ->           io:format("~p ~n",[L]),   
 
          loop(L)   
	end.   

%------ Obsługa bazy danych ---------  
add(Data) -> 
	database!{add, Data}.
delete(Data) -> 
	database!{delete, Data}. 
show() -> 
	database!{show}. 

 Napisz program, który zwróci listę N procesów.  

-module(mod).  
 
-compile(export_all).   

%---- tworzenie listy procesów ----- 
func(N) -> [spawn(mod, loop, []) || _<-lists:seq(1,N)].  
%------ funkcja procesu -----
loop() ->     io:format("Pid ~p ~n",[self()]). 

 Zaimplementuj algorytm sortowania QuickSort.  
-module(mod). 
-compile(export_all).  
% tablica zero elementowa juz jest posorotwana
qsort([]) -> []; 
% tablica jedno elementowa już jest posortowana 
qsort([H]) -> [H];

qsort(L)  when length(L) > 1 ->    % wybor elementu który będzie pivotem    
	PivotIndex = length(L) div 2,     
	% pbranie wartości pivotu     
	PivotElement = lists:nth(PivotIndex, L),  
	% usunięcie wartości Pivota z listy    
	NewList = lists:delete(PivotElement, L),  
	% posegreguj elementy na liscie    
	{Lmin, Lmax} = func(PivotElement, NewList),  
	% wywolaj rekurencyjnie sortowanie na dwóch podtablicach. 
	qsort(Lmin) ++ [PivotElement] ++ qsort(Lmax).  

% funkcja pomocnicza : dzieli tablicę na dwie podtablice 
func(N, L) -> func(N, L, [], []).  
func(_N, [], Lmin, Lmax) -> 
	{Lmin, Lmax}; 
func(N, [H|T], Lmin, Lmax) when H < N -> 
	func(N, T, [H|Lmin], Lmax); 
func(N, [H|T], Lmin, Lmax) ->
	func(N, T, Lmin, [H|Lmax]). 

 Napisz funkcję, która usypia dany proces na X milisekund. Ma działać jak timer:sleep().  

-module(mod).
-compile(export_all).  

sleep(N) ->  
	receive    
	after N ->          
			ok    
	end.

 Napisz funkcję, która dla dwóch podanych list L1 i L2 (tej samej długości) połączy je tworząc nową listę.
Każdy element w nowej liście ma być maksimum z wartości lokalnej w liście L1 i L2. 

-module(mod). 
-compile(export_all).  
func([],[]) -> []; 
func([H1|T1], [H2|T2]) ->   
	if        H1 > H2  -> 
			[H1 | func(T1, T2)];    
		H1 =< H2 -> 
			[H2 | func(T1, T2)]   
	end.   

 Napisz funkcję, która dla podanej listy L i indeksu Index zwróci nową listę, 
	gdzie element pod wskazanym indeksem podwoi swoją wartość.  
-module(mod). 
-compile(export_all).  

func(L, Index) ->  
	NewValue = 2 * lists:nth(Index, L),   
	lists:sublist(L, Index-1) ++ [NewValue] ++ lists:sublist(L, Index+1, length(L)). 

 Napisz nieskończoną pętlę, która dla podanej listy L będzie wyświetlała każdy element w osobnym wierszu.  

-module(mod).
-compile(export_all).  

func(L) -> func(L, L).  

func([], L) ->     
	func(L, L); 
func([H|T], L) ->    
	io:format("~p ~n",[H]),  
    	timer:sleep(250),   
	func(T, L).   

Na podstawie danej listy L zrób nową listę niezawierającą liczb całkowitych.  

-module(mod). 
-compile(export_all). 

func([]) -> []; 
func([H|T]) when not is_integer(H) -> 
	[H | func(T)]; 
func([_|T]) -> func(T). 

Napisz program, który dla zadanej listy L zwróci listę zawierającą tylko elementy parzyste z listy L.  

-module(mod). 
-compile(export_all).  

func([]) -> []; 
func([H|T]) when H rem 2 == 0 ->
	[H | func(T)]; 
func([_|T]) -> func(T). 

Zbadaj, czy elementy danej listy składającej się z cyfr tworzą liczbę palindromiczną.  

-module(mod).
-compile(export_all).  

func(L) -> 
	func(L, lists:reverse(L)).

func([],[]) -> 
	{tak}; 
func([H1|T1], [H2|T2]) when H1 == H2 -> 
	func(T1, T2); 
func(_, _) -> {nie}. 

Napisz funkcję factorial(N), która obliczy silnię z liczby N.  

-module(mod).
-compile(export_all).

factorial(0) -> 
	1; 
factorial(N) -> 
	N * factorial(N-1).   

14. Wypisz N kolejnych liczb trójkątnych.  
-module(mod). 
-compile(export_all).  

func(1) -> 
	[1]; 
func(N) -> 
	func(N-1) ++ [lists:foldl(fun(X, Sum)-> X+Sum end, 0, lists:seq(1,N))]. 

 Napisz funkcję, która dla danej listy list scali wszystkie liczby.  

-module(mod). 
-compile(export_all).  

concatenate([]) -> 
	[]; 
concatenate([H|T]) ->
	H ++ concatenate(T). 

 Napisz funkcję, która odwróci porządek wszystkich elementów w tablicy.  

-module(mod). 
-compile(export_all).  

reverse([H]) -> 
	[H]; 
reverse([H|T]) -> 
	reverse(T) ++ [H]. 

Napisz funkcję, która dla podanej listy L oraz liczby całkowitej N zwróci listę wszystkich liczb z list L, które są mniejsze bądź równe liczbie N.  
  
-module(mod). 
-compile(export_all).  

filter([H|T], N) when H =< N -> 
	[H | filter(T, N)]; 
filter(_, _) ->   
	[].   

1. Napisz funkcję sum/1, która dla podanej liczby naturalnej N zwróci sumę wszystkich liczb naturalnych od 1 do N.  

-module(mod). 
-compile(export_all). 

sum(1) -> 
	1; 
sum(N) -> 
	N + sum(N-1).   

2. Napisz funkcję sum/2, która dla danych liczb N i M, gdzie N<=M, zwróci sumę liczb pomiędzy N i M. Jeżeli N>M, to zakończ proces.  

-module(mod). 
-compile(export_all).  

sum(N, M) when N > M -> 
	exit(self(), kill);
sum(M, M) -> 
	M;  
sum(N, M) -> 
	N + sum(N+1, M).  

3. Napisz funkcję, która dla danego N zwróci listę postaci [1,2,...,N-1,N].  
-module(mod). 
-compile(export_all). 

create(N) -> 
	create(1, N).   
 
create(N, N) -> 
	[N]; 
create(A, N) -> 
	[A | create(A+1, N)]. 

4. Napisz funkcję, która dla danego N zwróci listę formatu [N,N-1,...,2,1].  
-module(mod).
-compile(export_all).  

reverse_create(0) -> [];
reverse_create(N) -> 
	[N | reverse_create(N-1)].   

5. Napisz funkcję, która wyświetli liczby naturalne pomiędzy 1 a N. Każda liczba ma zostać wyświetlona w nowym wierszu.  
-module(mod). 
-compile(export_all). 

func(N) -> 
	func(1, N).  
func(N, N) ->   
	io:format("Number:~p~n",[N]); 
func(A, N) ->    
	io:format("Number:~p~n",[A]),  
	func(A+1, N).   

6. Napisz funkcję, która wyświetli wszystkie liczby parzyste pomiędzy 1 a N. Każda liczba ma zostać wyświetlona w nowym wierszu.  
-module(mod).
-compile(export_all).  

func(N)  when N > 1 -> 
	func(2, N); 
func(_) -> {brak}.  

func(A, N) when A =< N ->  
	io:format("Number:~p~n",[A]),     
	func(A+2, N); f
func(_, _) ->     {koniec}

szkielet obsługi wyjątków w języku Ada?  
begin -- . . . 
exception 
when Constraint_Error | Program_Error =>  
	     --. . . w
when Storage_Error --. . . 
when others => --. . . 
end ;   

Ada. Znajdź element maksymalny w tablicy i podziel wszystkie elementy przez niego.  

with Ada.Text_IO; 
use Ada.Text_IO;  

procedure Max_I_Podziel is Arr : 

Array (1..10) of Float; 
Max : Float;  
 
begin 
	Arr := ( 1..2 => 2.0, 5..8 => 4.0, others => 1.0);  
	Max :=  Arr(Arr'First); 
	for I in Arr'Range loop 
			   if Max < Arr(I) then 
				      Max := Arr(I); 
			   end if; 
	end loop;  
	Put_Line("Max: " & Max'Img);

	for I in Arr'Range loop 
			Arr(I) := Arr(I) / Max; 
			Put_Line(I'Img & ":" & Arr(I)'Img); 
	end loop;
end Max_I_Podziel;   

Napisz w Erlangu funkcję generującą liczby Fibonacciego na dwa sposoby: rekurencyjnie i iteracyjnie.  

fibo_reku(0) -> 0; 
fibo_reku(1) -> 1;  
 
fibo_reku(N) -> 
	fibo_reku(N-1) + fibo_reku(N-2).  

fibo_iter(N) -> 
	fibo_iter(N, 0, 1). 
fibo_iter(0, Wynik, _) -> Wynik; 
fibo_iter(Iter, Wynik, Next) -> 
	fibo_iter(Iter-1, Next, Wynik+Next).


Funkcja sumujaca dwie liczby zespolone ADA
with Ada.Text_IO; use Ada.Text_IO;
procedure Hello is

type Zespolone is 
    record
        Re: Float;
        Im: Float;
    end record;
    
procedure dodaj_zespolone(z1: in Zespolone; z2: in Zespolone; res: in out Zespolone ) is
begin
    res.Re := z1.Re + z2.Re;
    res.Im := z1.Im + z2.Im;
end dodaj_zespolone;

z1: Zespolone;
z2: Zespolone;
res: Zespolone;

begin
    Put_Line ("Hello, world!");
    z1.Re := 1.0;
    z1.Im := 2.5;
    
    z2.Re := 2.0;
    z2.Re := 2.5;
    
    dodaj_zespolone(z1,z2,res);
    
    Put_Line("Res: " & res.Re'Img & "i" & res.Im'Img );
    
end Hello;

function dodaj_zespolone(z1: Zespolone; z2: Zespolone) return Zespolone is
Res: Zespolone;
begin
    Res.Re := z1.Re + z2.Re;
    Res.Im := z1.Im + z2.Im;
    return Res;
end dodaj_zespolone;

Funkcja spr czy zadana liczba jest pierwsza
function czy_pierwsza(n: Integer) return Boolean is
I: Integer;
begin
    if (n < 2) then 
        return false;
    end if;
    I:= 2;
    while (I*I <= n) loop
        if (n mod I = 0) then
            return false;
        end if;
        I := I + 1;
   end loop;
   
   return true;
end czy_pierwsza;

ADA 
 «A:4,B:4,C:8» = «56,66». A=3,B=8,C=8#102
 
 Przykładem dekompozycji eksploracyjnej nie jest: qsort
 
 Spotkania w Adzie są niesymetryczne
 
 Prawo Amdahla służy do określenia maksymalnego spodziewanego zwiększenia wydajności całkowitej systemu jeżeli tylko 
 część systemu została ulepszona.
 
 Napisz funkcję w j. erlang, która podaną listę skróci o połowę uśredniając sąsiednie elementy. 
 Funkcja ma obsługiwać też listy nieparzyste. Napisz wersje gdzie ostatni element jest pomijany i 
 doklejany. dest(0) = (src(0)+src(1))/2
 
 skroc_pomin([]) -> [];
skroc_pomin([H]) -> [];
skroc_pomin([H1,H2|T]) -> [(H1+H2)/2|skroc_pomin(T)].

skroc_doklej([]) -> [];
skroc_doklej([H]) -> [H];
skroc_doklej([H1,H2|T]) -> [(H1+H2)/2 | skroc_doklej(T)].


 
