tempo_espera(5000).
melhor(Nome):- avg_time(T)[source(Nome)] & not(avg_time(Outro)[source(Ag)] & Outro < T).
!minha_vez.

+!executar: action(A) & tempo_espera(Tempo)
<-  send_operation(A);
    .wait(Tempo);
    get_avg_time(X,N);
    -avg_time(_);
    +avg_time(N);
    .broadcast(tell,avg_time(N)).

+!minha_vez: .all_names(L) & .length(L,SizeL) & .findall(S,avg_time(_)[source(S)],X) & .length(X,SizeA) & SizeL == SizeA <- !verificar_melhor.
+!minha_vez: .all_names(L) & .length(L,SizeL) & .findall(S,avg_time(_)[source(S)],X) & .length(X,SizeA) & SizeL > SizeA
<-  .print(SizeA);
    !verificar_vez.

+!verificar_vez: vez(N) & number(M) & M == N
<-  .print("Assumir");
    !executar;
    inc;
    !minha_vez.

+!verificar_vez: vez(N) & number(M) & M \== N
<-  .print("Não é minha vez");
    !minha_vez.

+!verificar_melhor: 
       melhor(self) 
    <- 
        .print("Assumir");
        !executar;
        !minha_vez.

+!verificar_melhor: 
       melhor(Nome) 
    <- 
        .print("Vai Assumir ", Nome);
        !minha_vez.


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }