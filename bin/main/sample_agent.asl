// Agent sample_agent in project teste

/* Initial beliefs and rules */

/* Initial goals */
action("0").
action("1").
action("2").
action("3").
iterations(0).
!start.

/* Plans */

+!start : true
<- .findall(S,action(S),L);
    for (.member(K,L)){
        .print("Testing action ",K);
        !set_composition(K);
        .wait(7500);
        !create_reward;
    };
    !ucb.

+!ucb : iterations(N) & N < 50
<-  .wait(7500);
    .print("Choosing the composition");
    !update_reward;
    !update_confidence_level;
    !composition(Action);
    !set_composition(Action);
    !ucb.

+!composition(Action) : composition(Action,_,_,Confidence_level) & not(composition(A1,_,_,C1) & Confidence_level < C1 & A1 \== Action)
<- .print("done").

+!update_confidence_level : iterations(N)
<-  .findall(r(Action,S,Times_chosen,Confidence_level),composition(Action,S,Times_chosen,Confidence_level),L);
    for ( .member(r(Action,S,Times_chosen,Confidence_level),L)){
        -composition(Action,S,Times_chosen,Confidence_level);
        confidence_level(S,Times_chosen,N,New_confidence);
        .print("The new confidence level for the action ",Action," is ",New_confidence,". This action was chosen ", Times_chosen, " times.");
        +composition(Action,S,Times_chosen,New_confidence);
    }.

+!update_reward : true
<-  print("updating reward");
    !get_avg(Action,Avg_time);
    ?composition(Action,S,Times_chosen,Confidence_level);
    -composition(Action,S,Times_chosen,Confidence_level);
    Reward = 100/Avg_time;
    +composition(Action,S+Reward,Times_chosen+1,Confidence_level);
    .print("Reward = ",Reward,", Confindence Level = ",Confidence_level,", Times chosen = ",Times_chosen+1," for action ", Action," with average response time ",Avg_time);
    !update_system.

+!create_reward : true
<-  !get_avg(Action,Avg_time);
    Reward = 100/Avg_time;
    +composition(Action,Reward,1,0);
    .print("Reward value ",Reward," for action ", Action," with average response time ",Avg_time);
    !update_system.

+!update_system : true
<-  .print("Updating System");
    ?iterations(N);
    -iterations(N);
    +iterations(N+1).

+!set_composition(S) : true
<- send_operation(S).

+!get_avg(Action,Avg_time) : true
<-  get_avg_time(Action,Avg_time);
    .print("The avarege time is ",Avg_time).

-get_avg(Action,Avg_time) : true
<-  .wait(1000);
    !get_avg(Action,Avg_time).

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
