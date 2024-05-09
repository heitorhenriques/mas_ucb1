iterations(0).
!start.

+!start: action(A,C)
<- makeArtifact("c0","example.Counter",[C],Id);
    focus(Id);
    send_operation(A);
    !run.

+!run : iterations(N) & N < 50
<- .wait(5000);
    get_avg_time(Action,Avg_time);
    -iterations(N);
    +iterations(N+1);
    !run.


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }