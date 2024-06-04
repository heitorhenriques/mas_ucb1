iterations(0).
!start.

+!start: action(A,C)
<- makeArtifact("c0","example.Counter",[C],Id);
    focus(Id);
    sendOperation(A);
    !run.

+!run : iterations(N) & N < 50
<- .wait(5000);
    getAvgTime(Action,Avg_time);
    .print("[ Action ", Action," - Iteration ", N," ] Response Time: ", Avg_time);
    -iterations(N);
    +iterations(N+1);
    !run.


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }