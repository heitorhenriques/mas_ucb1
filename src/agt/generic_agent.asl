tempo_espera(5000).
melhor(Nome):- svg_time(T)[source(Nome)] & not(avg_time(Outro)[source(Ag)] & Outro < T).
!minha_vez.

+avg_time(N)[source(S)]: S \== self & avg_time(M)[source(self)] & M < N
<-  .print("Minha vez");
    +minha_vez.

+avg_time(N)[source(S)]: S \== self & avg_time(M)[source(self)] & M > N
<-  .print("Não é minha vez");
    .broadcast(tell,avg_time(M)).

+minha_vez: action(A) & tempo_espera(Tempo)
<-  -minha_vez;
    send_operation(A);
    .wait(Tempo);
    get_avg_time(X,N);
    -avg_time(_);
    +avg_time(N);
    .broadcast(tell,avg_time(N));
    inc.

+!minha_vez: .allagents(L) & .count(L,SizeL) & .count(avg_time(_),SizeA) & SizeL == SizeA <- !verificar_melhor.
+!minha_vez: .allagents(L) & .count(L,SizeL) & .count(avg_time(_),SizeA) & SizeL > SizeA <- !verificar_vez.

+!verificar_vez: vez(N) & number(M) & M == N
<-  +minha_vez.

+!verificar_melhor: 
       melhor(self) 
    <- 
        .print("Assumir").  

+!verificar_melhor: 
       melhor(Nome) 
    <- 
        .print("Vai Assumir ", Nome).  