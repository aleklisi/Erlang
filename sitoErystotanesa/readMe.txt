Plik sito.erl zawiera implementacje potokową sita.

Dla porównania powstała komkurencyjna implementacja.
W plikach child.erl i master.erl. 

Aby uruchomić 2 implementację wpisz:

c(child).
c(master).
master:test().

Modyfikacja parametrów:
najprisciej w pliku master.erl zamien linie:
 	TaskTimeToCalculate = 1000 * 10,
	NumberOfThreads = 32, 

TaskTimeToCalculate - paramietr górnej granicy dla sita
NumberOfThreads - nazwa zmiennej mowi dostatecznie duzo

Bardziej skomplikowane zmiany tylko na własną odpowiedizalność!!! 