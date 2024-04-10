// Agent sample_agent in project teste

/* Initial beliefs and rules */

/* Initial goals */
action("0").
action("1").
action("2").
action("3").
!start.

/* Plans */

+!start : true
    <- .print("hello world.");
    .findall(S,action(S),L);
    for (.member(K,L)){
        .print("Testing action ",K);
        !set_composition(K);
        .wait(7500);
        !get_avg;
    };
    !find_min(A,Ag);
    //?min(A,Ag);
    .send(client,tell,avg_time(Ag));
    .print("The minimun avarege time was ",Ag," with action ",A);
    .print("Setting the distributor with the smallest avarege time");
    !set_composition(A);
    .send(client,achieve,stop).

+!find_min(A,Ag) : composition(A,Ag) & not(composition(A1,Ag1) & Ag1 <= Ag & A \== A1)
<- +min(A,Ag).

+!set_composition(S) : true
<- send_operation(S).

+!get_avg : true
    <- get_avg_time(Action,Avg_time);
    +composition(Action,Avg_time);
    .print("The avarege time is ",Avg_time).

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
