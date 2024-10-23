iterations(0).
!start.

+!start: action(A,C, PerformOnLoop)
<- makeArtifact("c0","example.Counter",[C, PerformOnLoop],Id);
    focus(Id);
    sendOperation(A);
    !run.

+!run : iterations(N)
<- .wait(4000);
    getAvgTime(Action,Avg_time);
    .concat("Response time: ", Avg_time, " ms", Message);
    log(Message, Action);
    -iterations(N);
    +iterations(N+1);
    !run.


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }