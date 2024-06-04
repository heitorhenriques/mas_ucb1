// Agent sample_agent in project teste

/* Initial beliefs and rules */

/* Initial goals */
action("0").
// action("1").
// action("2").
action("3").
iterations(0).
!start.

/* Plans */

+!start : true
<- .findall(S,action(S),L);
    for (.member(K,L)){
        .print("\n[ Action ", K, " ] Testing action...");
        !set_composition(K);
        .wait(10000);
        ignoreAvgTime;
        .wait(10000);
        !create_reward;
    };
    !update_confidence_level;
    !ucb.

+!ucb : iterations(N) & N < 50
<-  !composition(Action);
    !set_composition(Action);
    .wait(10000);
    .print("Choosing the composition...");
    ignoreAvgTime;
    .wait(10000);
    !update_reward;
    !update_confidence_level;
    .print("Average time ignored...");
    !ucb.

+!composition(Action) : composition(Action,_,_,Confidence_level) & not(composition(A1,_,_,C1) & Confidence_level < C1 & A1 \== Action)
<- .print("New composition set to action ", Action, ".").

+!update_confidence_level : iterations(N)
<-  .findall(r(Action,S,Times_chosen,Confidence_level),composition(Action,S,Times_chosen,Confidence_level),L);
    for ( .member(r(Action,S,Times_chosen,Confidence_level),L)){
        -composition(Action,S,Times_chosen,Confidence_level);
        confidenceLevel(S,Times_chosen,N,New_confidence);
        .print("\n[ Action ", Action, " ] The new confidence level is ",New_confidence,". \n[ Action ", Action, " ] Was chosen ", Times_chosen, " times.");
        +composition(Action,S,Times_chosen,New_confidence);
    }.

+!update_reward : true
<-  print("Updating reward...");
    !get_avg(Action,Avg_time);
    ?composition(Action,S,Times_chosen,Confidence_level);
    -composition(Action,S,Times_chosen,Confidence_level);
    getReward(Avg_time, Reward);
    +composition(Action,S+Reward,Times_chosen+1,Confidence_level);
    .print("\n[ Action ", Action, " ] Reward: ",Reward,"\n[ Action ", Action, " ] Confidence Level: ", Confidence_level,"\n[ Action ", Action, " ] Times Chosen: ", Times_chosen+1,"\n[ Action ", Action, " ] Average Response Time: ", Avg_time);
    !update_system.

+!create_reward : true
<-  !get_avg(Action,Avg_time);
    getReward(Avg_time, Reward);
    +composition(Action,Reward,1,0);
    .print("\n[ Action ", Action, " ] Reward: ",Reward,"\n[ Action ", Action, " ] Response Time: ", Avg_time);
    !update_system.

+!update_system : true
<-  .print("Updating System...");
    ?iterations(N);
    -iterations(N);
    +iterations(N+1).

+!set_composition(S) : true
<- sendOperation(S).

+!get_avg(Action,Avg_time) : true
<-  getAvgTime(Action,Avg_time);
    .print("\n[ Action ", Action, " ] Response Time: ", Avg_time).

-get_avg(Action,Avg_time) : true
<-  .wait(1000);
    !get_avg(Action,Avg_time).

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
