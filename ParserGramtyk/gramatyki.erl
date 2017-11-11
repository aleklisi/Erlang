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
rule(15,[b|b]) -> [b];
rule(16,[c,c]) -> [b];
rule(17,[b,c]) -> [c];
rule(18,[c,b]) -> [c];


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

gramatyka(_) -> io:fwrite("Ta grmatyka jeszcze nie istnieje\n").