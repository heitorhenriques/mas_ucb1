observation_window(5000).
best(Name):- result(T)[source(Name)] & not(result(Other)[source(Ag)] & Other < T).
best_difference(D):- difference(D,_)[source(Name)] & not(difference(Other,_)[source(Ag)] & Other < D).
sensibility(1).
erro(0.1).
!my_turn.

+difference(_,_)[source(S)]: S \== self & .findall(A,difference(_,_)[source(A)],L) & .all_names(M) & .length(L,X) & .length(M,Y) & X == Y
<-  .concat("Got the difference from ", S, Message);
    log(Message, "");
    !calc_res.

+!check: difference(Nova,Antiga)[source(self)] & erro(Erro) & Antiga + (Antiga * Erro) >= Nova & Antiga - (Antiga * Erro) <= Nova
<-  !execute.

+!check: true
<-  !calc_res;
    !verify_best.

+!calc_res: best_difference(D) & sensibility(Se) & difference(L,_)[source(self)] & result(C)[source(self)]
    <- ?avg_time(A,_);
    X = L - D;
    Y = L + D;
    B = Y/2;
    Z = X/B;
    V = A + (A * Z * Se);
    .concat("Sending my result ", V, Message);
    log(Message, "");
    -result(C);
    +result(V);
    .broadcast(tell,result(V)).

+!calc_res: best_difference(D) & sensibility(Se) & difference(L,_)[source(self)]
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

+result(V)[source(S)]: S \== self & result(C)[source(S)]
<-  .print("Atualizando result. Recebi um ", V, " vou retirar um ", C);
    -result(C);
    !verify_best.

+result(V)[source(S)]: S \== self 
<- !verify_best.

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

+!update_diff: avg_time(A,N) & avg_time(A1,N-1) & difference(Nova,Antiga)[source(S)] & S == self & N-1 \== 0
<-  -difference(Nova,Antiga);
    X = ((A-A1) + Nova)/(N-1);
    +difference(X,Nova).

+!update_diff: avg_time(A,N) & avg_time(A1,N-1) & N-1 \== 0
<-  Nova = (A-A1)/(N-1);
    +difference(Nova,0);
    log("Broadcasting my difference!!", "");
    X = 0;
    .broadcast(tell,difference(Nova,X)).

+!my_turn: avg_time(A,N) & avg_time(A1,N-1) & N-1 \== 0
<-  log("Exploration finished", "");
    !update_diff;
    !calc_res.

+!my_turn: true
<-   !verify_turn.

+!verify_turn: turn(N) & number(M) & M == N & action(A)
<-  !execute;
    log("Incrementing turn...", A);
    inc;
    !my_turn.

+!verify_turn: turn(N) & number(M) & M \== N & action(A)
<-  log("Not my turn!", A).


+!verify_best: best(self) 
<-  log("I am assuming", "");
    !execute;
    !update_diff;
    !check.
    
+!verify_best: best(Name) 
<-  .concat(Name, " is assuming!", Message);
    log(Message, "").

+check_turn: true
<- !my_turn.

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }