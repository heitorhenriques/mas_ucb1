observation_window(5000).
best(Name):- avg_time(T)[source(Name)] & not(avg_time(Other)[source(Ag)] & Other < T).
!my_turn.

+!clear[source(S)] : true
<-  .abolish(avg_time(_)[source(S)]).

+avg_time(V)[source(S)]: S \== self & avg_time(X)[source(S)] & X \== V
<-  -avg_time(X)[source(S)];
    !my_turn.

+avg_time(V)[source(S)]: S \== self & not(avg_time(X)[source(S)] & X \== V)
<-  !my_turn.

+!execute: action(A) & observation_window(Window)
<-  send_operation(A);
    .wait(Window);
    ignoreAvgTime;
    log("Response Ignored", A);
    .wait(Window);
    get_avg_time(X,N);
    -avg_time(_);
    +avg_time(N);
    .concat("Response time: ", N, Message);
    log(Message, A);
    .broadcast(achieve,clear);
    .broadcast(tell,avg_time(N)).

+!my_turn: .all_names(L) & .length(L,SizeL) & .findall(S,avg_time(_)[source(S)],X) & .length(X,SizeA) & SizeL == SizeA <- !verify_best.
+!my_turn: .all_names(L) & .length(L,SizeL) & .findall(S,avg_time(_)[source(S)],X) & .length(X,SizeA) & SizeL > SizeA
<-  !verify_turn.

+!verify_turn: turn(N) & number(M) & M == N
<-  !execute;
    inc;
    !my_turn.

+!verify_turn: turn(N) & number(M) & M \== N
<-  log("Not my turn!", "").


+!verify_best: best(self) 
<-  !execute;
    !verify_best.

+!verify_best: best(Name) 
<-  .concat(Name, " is assuming!", Message);
    log(Message, "").


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }