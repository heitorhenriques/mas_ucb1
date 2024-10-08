best(Name):- result(T)[source(Name)] & not(result(Other)[source(Ag)] & Other < T).
best_difference(D):- difference(D,_)[source(Name)] & not(difference(Other,_)[source(Ag)] & Other < D).
sensibility(1).
erro(1.8).
sum_difference(0).
!my_turn.

+difference(C,D)[source(S)]: S \== self & difference(E,F)[source(S)] & E \== C 
<-  -difference(E,F)[source(S)].

+!check: difference(Nova,Antiga)[source(self)] & erro(E) & not(difference(ONova,_)[source(Ag)] & math.abs(Nova) > math.abs(ONova) * E) & result(Resultado)[source(self)] & result(Resultados)[source(S)] & S \== self
<-  .concat("I'm still the best. This is my average difference time is ", Nova, Message);
    ?action(A);
    log(Message, A);
    !verify_best.

+!check: true
<-  ?action(A);
    log("Starting exploration", A);
    .broadcast(achieve,exploration);
    !exploration.

+!calc_res: best_difference(D) & sensibility(Se) & difference(L,_)[source(self)] & result(F)[source(self)] & .findall(A,difference(_,_)[source(A)],G) & .all_names(M) & .length(G,C) & .length(M,E) & C == E & action(Acao)
<-  ?avg_time(A,_);
    X = L - D;
    Y = L + D;
    B = Y/2;
    Z = X/B;
    V = A + (A * math.abs(Z) * Se);
    -result(F);
    +result(V);
    .concat("New result calculated: ", V, Message);
    log(Message, Acao);
    .broadcast(tell,result(V)).

+!calc_res: best_difference(D) & sensibility(Se) & difference(L,_)[source(self)] & .findall(A,difference(_,_)[source(A)],F) & .all_names(M) & .length(F,C) & .length(M,E) & C == E & action(Acao)
<- ?avg_time(A,_);
    X = L - D;
    Y = L + D;
    B = Y/2;
    Z = X/B;
    V = A + (A * math.abs(Z) * Se);
    +result(V);
    .concat("New result calculated: ", V, Message);
    log(Message, Acao);
    .broadcast(tell,result(V)).

-!calc_res: true
<-  .wait(1000);
    !calc_res.

+result(V)[source(S)]: S \== self & result(A)[source(S)] & A \== V
<-  -result(A)[source(S)];
    !verify_best.

+!execute: action(A) & observation_window(Window) & mutex(S) & S == 0
<-  inc_mutex;
    send_operation(A);
    .wait(Window);
    ignoreAvgTime;
    .wait(Window);
    get_avg_time(X,N);
    ?avg_time(_,Z);
    +avg_time(N,Z+1);
    .concat("Response time: ", N, Message);
    log(Message, A);
    inc_mutex.

+!update_diff: avg_time(A,N) & avg_time(A1,N-1) & difference(Nova,Antiga)[source(self)] & N-1 \== 0 & sum_difference(S) & action(Acao)
<-  -sum_difference(S);
    Y = S+(A-A1);
    +sum_difference(Y);
    -difference(Nova,Antiga);
    X = (Y)/(N-1);
    .concat("New difference: ", X, ". Old Difference: ", Nova, " Sum of differences: ", Y, Message);
    log(Message, Acao);
    +difference(X,Nova);
    .broadcast(tell,difference(X,Nova)).

+!update_diff: avg_time(A,N) & avg_time(A1,N-1) & N-1 \== 0 & sum_difference(S) & action(Acao)
<-  -sum_difference(S);
    X = S+(A-A1);
    +sum_difference(X);
    Nova = X/(N-1);
    +difference(Nova,0);
    .concat("New difference: ", Nova, Message);
    log(Message, Acao);
    .broadcast(tell,difference(Nova,0)).

+!my_exploration: avg_time(A,N) & avg_time(A1,N-1) & N-1 \== 0 & difference(_,_)[source(self)] & finished
<-  -finished[source(_)];
    !update_diff;
    !calc_res.

-!my_exploration: true
<-  .wait(1000);
    !my_exploration.

+!my_turn: avg_time(A,N) & avg_time(A1,N-1) & N-1 \== 0 & not(difference(_,_)[source(self)])
<-  !update_diff;
    !calc_res;
    !verify_best.

+!my_turn: not(difference(_,_)[source(self)])
<-  !verify_turn.

+!verify_turn: turn(N) & number(M) & M == N & action(A)
<-  !execute;
    inc;
    .broadcast(achieve,my_turn);
    !my_turn.

+!verify_turn: turn(N) & number(M) & M \== N & action(A)
<-  log("Not my turn!", A).


+!verify_best: .findall(A,result(_)[source(A)],Z) & .all_names(M) & .length(Z,C) & .length(M,E) & C == E & best(self) 
<-  !execute;
    !update_diff;
    !check.
    
+!verify_best: .findall(A,result(_)[source(A)],Z) & .all_names(M) & .length(Z,C) & .length(M,E) & C == E & best(Name) & action(Acao)
<-  .concat(Name, " is assuming!", Message);
    log(Message, Acao).

-!verify_best: true
<-  .wait(1000);
    !verify_best.

-!my_turn.

+!exploration: turn(N) & number(M) & M == N & action(A) & exploring(Number) & Number < 2
<-  -exploring(Number);
    !execute;
    +exploring(Number+1);
    log("Second step of exploration", A);
    inc;
    .broadcast(achieve,exploration).

+!exploration: exploring(Number) & Number > 1 & action(A)
<-  -exploring(Number);
    .broadcast(tell,finished);
    .broadcast(achieve,exploration);
    log("Finishing exploration", A);
    !my_exploration.

+!exploration: turn(N) & number(M) & M == N & action(A) & not(finished)
<-  +exploring(1);
    log("First step of exploration", A);
    !execute;
    inc;
    .broadcast(achieve,exploration).

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }