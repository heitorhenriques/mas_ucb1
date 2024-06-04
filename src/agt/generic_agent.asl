tempo_espera(5000).
melhor(Nome):- avg_time(T)[source(Nome)] & not(avg_time(Outro)[source(Ag)] & Outro < T).
!minha_vez.

+minha_vez: action(A) & tempo_espera(Tempo)
<-  -minha_vez;
    send_operation(A);
    .wait(Tempo);
    get_avg_time(X,N);
    -avg_time(_);
    +avg_time(N);
    .broadcast(tell,avg_time(N));
    inc.

+!minha_vez: .all_names(L) & .length(L,SizeL) & .findall(S,avg_time(_)[source(S)],X) & .length(X,SizeA) & SizeL == SizeA <- !verificar_melhor.
+!minha_vez: .all_names(L) & .length(L,SizeL) & .findall(S,avg_time(_)[source(S)],X) & .length(X,SizeA) & SizeL > SizeA
<-  .print(SizeA);
    !verificar_vez.

+!verificar_vez: vez(N) & number(M) & M == N
<-  .print("Assumir");
    inc;
    ?avg_time(A);
    .broadcast(tell,avg_time(A));
    !minha_vez.

+!verificar_vez: vez(N) & number(M) & M \== N
<-  .print("Não é minha vez");
    !minha_vez.

+!verificar_melhor: 
       melhor(self) 
    <- 
        ?avg_time(N)[source(self)];
        .broadcast(tell,avg_time(N));
        .print("Assumir").  

+!verificar_melhor: 
       melhor(Nome) 
    <- 
        .print("Vai Assumir ", Nome).  


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }