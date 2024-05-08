action("local").
!start.

+!start: action(A)
<- makeArtifact("c0","example.Counter",[A],Id);
    focus(Id);
   !set_composition("0");
    !run.

+!run : true
<- .wait(5000);
    get_avg_time(Action,Avg_time);
    !run.

+!set_composition(S) : true
<- send_operation(S).

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }