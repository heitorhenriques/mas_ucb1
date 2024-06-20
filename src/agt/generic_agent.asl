observation_window(5000).
best(Name):- result(T)[source(Name)] & not(result(Other)[source(Ag)] & Other < T).
best_difference(D):- difference(D,_)[source(Name)] & not(difference(Other,_)[source(Ag)] & Other < D).
sensibility(1).
erro(0.1).
!my_turn.

+difference(C,D)[source(S)]: S \== self & difference(E,F)[source(S)] & E \== C 
<-  .print("Atualizando difference. Recebi um ", C, " vou retirar um ", E);
    -difference(E,F)[source(S)].

+!check: difference(Nova,Antiga)[source(self)] & erro(Erro) & Antiga + (Antiga * Erro) >= Nova & Antiga - (Antiga * Erro) <= Nova
<-  !verify_best.

+!check: difference(Nova,Antiga)[source(self)] & erro(Erro) & Antiga + (Antiga * Erro) < Nova | Antiga - (Antiga * Erro) > Nova
<-  .print("Starting exploration")
    .broadcast(achieve,exploration);
    !exploration.

+!calc_res: best_difference(D) & sensibility(Se) & difference(L,_)[source(self)] & result(F)[source(self)] & .findall(A,difference(_,_)[source(A)],G) & .all_names(M) & .length(G,C) & .length(M,E) & C == E
<-  ?avg_time(A,_);
    X = L - D;
    Y = L + D;
    B = Y/2;
    Z = X/B;
    V = A + (A * Z * Se);
    .concat("Sending my result ", V, Message);
    log(Message, "");
    -result(F);
    +result(V);
    .broadcast(tell,result(V)).

+!calc_res: best_difference(D) & sensibility(Se) & difference(L,_)[source(self)] & .findall(A,difference(_,_)[source(A)],F) & .all_names(M) & .length(F,C) & .length(M,E) & C == E
<- ?avg_time(A,_);
    X = L - D;
    Y = L + D;
    B = Y/2;
    Z = X/B;
    V = A + (A * Z * Se);
    .concat("Sending my result ", V, Message);
    log(Message, "");
    +result(V);
    .broadcast(tell,result(V)).

-!calc_res: true
<-  .wait(1000);
    !calc_res.

+result(V)[source(S)]: S \== self & result(A)[source(S)] & A \== V
<-  .print("Atualizando result. Recebi um ", V, " vou retirar um ", A);
    -result(A)[source(S)];
    !verify_best.

+!execute: action(A) & observation_window(Window)
<-  send_operation(A);
    .wait(Window);
    ignoreAvgTime;
    .wait(Window);
    get_avg_time(X,N);
    ?avg_time(_,Z);
    +avg_time(N,Z+1);
    .concat("Response time: ", N, Message);
    log(Message, A).

+!update_diff: avg_time(A,N) & avg_time(A1,N-1) & difference(Nova,Antiga)[source(self)] & N-1 \== 0
<-  -difference(Nova,Antiga);
    X = ((A-A1) + Nova)/(N-1);
    +difference(X,Nova);
    .broadcast(tell,difference(X,Nova)).

+!update_diff: avg_time(A,N) & avg_time(A1,N-1) & N-1 \== 0
<-  Nova = (A-A1)/(N-1);
    +difference(Nova,0);
    log("Broadcasting my difference!!", "");
    .broadcast(tell,difference(Nova,0)).

+!my_turn: avg_time(A,N) & avg_time(A1,N-1) & N-1 \== 0 & difference(_,_)[source(self)]
<-  log("Exploration finished", "");
    !update_diff;
    !calc_res;
    !verify_best.

+!my_turn: avg_time(A,N) & avg_time(A1,N-1) & N-1 \== 0 & not(difference(_,_)[source(self)])
<-  log("Exploration finished", "");
    !update_diff;
    !calc_res;
    !verify_best.

+!my_turn: not(difference(_,_)[source(self)])
<-   !verify_turn.

+!verify_turn: turn(N) & number(M) & M == N & action(A)
<-  !execute;
    log("Incrementing turn...", A);
    inc;
    .broadcast(achieve,my_turn);
    !my_turn.

+!verify_turn: turn(N) & number(M) & M \== N & action(A)
<-  log("Not my turn!", A).


+!verify_best: .findall(A,result(_)[source(A)],Z) & .all_names(M) & .length(Z,C) & .length(M,E) & C == E & best(self) 
<-  log("I am assuming", "");
    !execute;
    !update_diff;
    !check.
    
+!verify_best: .findall(A,result(_)[source(A)],Z) & .all_names(M) & .length(Z,C) & .length(M,E) & C == E & best(Name) 
<-  .concat(Name, " is assuming!", Message);
    log(Message, "").

-!verify_best: true
<-  .wait(1000);
    !verify_best.

-!my_turn.

+!exploration: turn(N) & number(M) & M == N & action(A)
<-  +exploring(1);
    !execute;
    log("Incrementing turn...", A);
    inc;
    .broadcast(achieve,exploration).

+!exploration: turn(N) & number(M) & M == N & action(A) & exploring(Number) & Number < 1
<-  -exploring(Number);
    !execute;
    +exploring(Number+1);
    log("Incrementing turn...", A);
    inc;
    .broadcast(achieve,exploration).

+!exploration: exploring(Number) & Number > 1
<- !my_turn.

-!exploration: true
<- .print("Not my turn")



{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }