-module(gramatyki).
-compile([export_all,debug_info]).
-import(parser,[run/2]).

%gramatyka {a,aa,aaa,aaaa,...}

rule(1,[0]) -> [1];
rule(2,[1]) -> [a];
rule(3,[1]) -> [1,a];

%gramatyka {ba,baa,baaa,baaaa,...}

rule(4,[0]) -> [b,1];
rule(5,[1]) -> [a];
rule(6,[1]) -> [1,a];

%gramatyka a^n b^n
rule(7,[0]) -> [1];
rule(8,[1]) -> [a,b];
rule(9,[1]) -> [a,1,b];

%gramatyka a^n b^n c^k d^k
rule(10,[0]) -> [1,2];
rule(11,[1]) -> [a,1,b];
rule(12,[1]) -> [a,b];
rule(13,[2]) -> [c,2,d];
rule(14,[2]) -> [c,d];

%gramatyka gra w kule
rule(15,[b,b]) -> [b];
rule(16,[c,c]) -> [b];
rule(17,[b,c]) -> [c];
rule(18,[c,b]) -> [c];

%gramatyka dla języka palindromów nad alfabetem{a,b}
rule(19,[0]) -> [a];
rule(20,[0]) -> [b];
rule(21,[0]) -> [a,0,a];
rule(22,[0]) -> [b,0,b];

%gramatyka E→E+E|E∗E|(E)|2
rule(23,[e]) -> ["(",e,")"];
rule(24,[e]) -> [e,"*",e];
rule(25,[e]) -> [e,"+",e];
rule(26,[e]) -> [2];

% P={1 → c1c, 1 → ac2cb, c2 → 2ca, a2c → a3c, 3ca → ca3, 3cb → cba}, σ=1
rule(27,[1]) -> [c,1,c];
rule(28,[1]) -> [a,c,2,c,b];
rule(29,[c,2]) -> [2,c,a];
rule(30,[a,2,c]) -> [a,3,c];
rule(31,[3,c,a]) -> [c,a,3];
rule(32,[3,c,b]) -> [c,b,a];

% a^n v^n c^n
rule(33,[0]) -> [1,2];
rule(34,[0]) -> [1,0,2];
rule(35,[1,2]) -> [a,b,c];
rule(36,[1,a]) -> [a,1];
rule(37,[c,2]) -> [2,c];
rule(38,[1,b]) -> [a,b,b];
rule(39,[b,2]) -> [b,c];


rule(_RuleNumber,_Variable) -> removethislist.

%gramatyka {a,aa,aaa,aaaa,...}
gramatyka(1) -> [1,2,3];
%gramatyka {ba,baa,baaa,baaaa,...}
gramatyka(2) -> [4,5,6]; 
%gramatyka a^n b^n
gramatyka(3) -> [7,8,9];
%gramatyka a^n b^n c^k d^k
gramatyka(4) -> [10,11,12,13,14];
%gramatyka gra w kule
gramatyka(5) -> [15,16,17,18];
%gramatyka dla języka palindromów nad alfabetem{a,b}
gramatyka(6) -> [19,20,21,22];
%gramatyka E→E+E|E∗E|(E)|2
gramatyka(7) -> [23,24,25,26];
% P={1 → c1c, 1 → ac2cb, c2 → 2ca, a2c → a3c, 3ca → ca3, 3cb → cba}, σ=1
gramatyka(8) -> lists:seq(27,32);
% a^n v^n c^n
gramatyka(9) -> lists:seq(33,39);


gramatyka(_) -> io:fwrite("Ta grmatyka jeszcze nie istnieje\n").