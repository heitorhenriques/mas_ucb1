observation_window(5000).
best(Name):- result(T)[source(Name)] & not(result(Other)[source(Ag)] & Other < T).
best_difference(D):- difference(D,_)[source(Name)] & not(difference(Other,_)[source(Ag)] & Other < D).
sensibility(1).
erro(0.1).
!my_turn.

+difference(_,_)[source(S)]: S \== self & .findall(A,difference(_,_)[source(A)],L) & .all_names(M) & .length(L,X) & .length(M,Y) & X == Y
<-  .print("Got the difference from ", S); !calc_res.

<<<<<<< HEAD
+difference(Nova,Antiga)[source(S)]: S == self & erro(Erro) & Antiga + (Antiga * Erro) > Nova & Antiga - (Antiga * Erro) < Nova
<-  !execute.

+difference(Nova,Antiga)[source(S)]: S == self & erro(Erro) & Antiga + (Antiga * Erro) < Nova & Antiga - (Antiga * Erro) > Nova
<-  !calc_res.

+!calc_res: best_difference(D) & sensibility(Se) & difference(L,Antiga)[source(self)]
<- ?avg_time(A,_); X = L - D; .print(X); Y = L + D; B = Y/2; Z = X/B; V = A + (A * Z * Se); .print("Sending my result ", V); +result(V); .broadcast(tell,result(V)).

+result(_)[source(S)]: S \== self & .findall(A,result(_)[source(A)],L) & .all_names(M) & .length(L,X) & .length(M,Y) & X == Y
<- !verify_best.
=======
+avg_time(V)[source(S)]: S \== self & avg_time(X)[source(S)] & X \== V
<-  -avg_time(X)[source(S)];
    !my_turn.

+avg_time(V)[source(S)]: S \== self & not(avg_time(X)[source(S)] & X \== V)
<-  !my_turn.
>>>>>>> ca7c910d9d73d77fe379579f2f6073170744595f

+!execute: action(A) & observation_window(Window)
<-  send_operation(A);
    .wait(Window);
    ignoreAvgTime;
    .wait(Window);
    get_avg_time(X,N);
    ?avg_time(_,Z);
    +avg_time(N,Z+1);
    !update_diff;
    .concat("Response time: ", N, Message);
    log(Message, A).

+!update_diff: avg_time(A,N) & avg_time(A1,N-1) & difference(Nova,Antiga) & N-1 \== 0
<-  -difference(Nova,Antiga);
    X = ((A-A1) + Nova)/(N-1);
    +difference(X,Nova).

+!update_diff: avg_time(A,N) & avg_time(A1,N-1) & N-1 \== 0
<-  Nova = (A-A1)/(N-1);
    +difference(Nova,0);
    .broadcast(tell,difference(Nova,_)).

+!my_turn: avg_time(A,N) & avg_time(A1,N-1) & N-1 \== 0 <- .print("Exploration finished"); !update_diff; !calc_res.
+!my_turn: true
<-   !verify_turn.

+!verify_turn: turn(N) & number(M) & M == N
<-  !execute;
    inc;
    !my_turn.

+!verify_turn: turn(N) & number(M) & M \== N & action(A)
<-  log("Not my turn!", A).


+!verify_best: best(self) 
<-  .print("I am assuming");
    !execute.
    

+!verify_best: best(Name) 
<-  .concat(Name, " is assuming!", Message);
    log(Message, "").


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }