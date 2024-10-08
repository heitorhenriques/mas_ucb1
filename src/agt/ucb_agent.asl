// Agent ucb_agent.asl in project teste

/* Initial beliefs and rules */

/* Initial goals */
action("0").
// action("1").
// action("2").
action("3").
iterations(0).
!start.

+!start : observation_window(Window)
<- .findall(S,action(S),L);
    for (.member(K,L)){
        log("Testing action...", K);
        !set_composition(K);
        .wait(Window);
        ignoreAvgTime;
        log("Average time ignored...", K);
        .wait(Window);
        !create_reward;
    };
    !update_confidence_level;
    !ucb.

+!ucb : iterations(N) & observation_window(Window)
<-  !composition(Action);
    !set_composition(Action);
    .wait(Window);
    log("Choosing the composition...", Action);
    ignoreAvgTime;
    .wait(Window);
    !update_reward;
    !update_confidence_level;
    !ucb.

+!composition(Action) : composition(Action,_,_,Confidence_level) & not(composition(A1,_,_,C1) & Confidence_level < C1 & A1 \== Action)
<-  .concat("New composition set to action ", Action, ".", Message);
    log(Message, "").

+!update_confidence_level : iterations(N)
<-  .findall(r(Action,S,Times_chosen,Confidence_level),composition(Action,S,Times_chosen,Confidence_level),L);
    for ( .member(r(Action,S,Times_chosen,Confidence_level),L)){
        -composition(Action,S,Times_chosen,Confidence_level);
        confidenceLevel(S,Times_chosen,N,New_confidence);
        .concat("The new confidence level is ", New_confidence, ".", " Action ", Action, " was chosen ", Times_chosen, " times.", Message);
        log(Message, Action);
        +composition(Action,S,Times_chosen,New_confidence);
    }.

+!update_reward : true
<-  log("Updating reward...", "");
    !get_avg(Action,Avg_time);
    ?composition(Action,S,Times_chosen,Confidence_level);
    -composition(Action,S,Times_chosen,Confidence_level);
    getReward(Avg_time, Reward);
    +composition(Action,S+Reward,Times_chosen+1,Confidence_level);
    .concat("Reward: ", Reward, Message);
    log(Message, Action);
    .concat("Confidence Level: ", Confidence_level, Message1);
    log(Message1, Action);
    .concat("Times Chosen: ", Times_chosen + 1, Message2);
    log(Message2, Action);
    .concat("Average Response Time: ", Avg_time, " ms", Message3);
    log(Message3, Action);
    !update_system.

+!create_reward : true
<-  !get_avg(Action,Avg_time);
    getReward(Avg_time, Reward);
    +composition(Action,Reward,1,0);
    .concat("Reward: ", Reward, Message);
    log(Message, Action);
    .concat("Response Time: ", Avg_time, " ms", Message1);
    log(Message1, Action);
    !update_system.

+!update_system : true
<-  log("Updating system...", "");
    ?iterations(N);
    -iterations(N);
    +iterations(N+1).

+!set_composition(S) : true
<- sendOperation(S).

+!get_avg(Action,Avg_time) : true
<-  getAvgTime(Action,Avg_time).

-get_avg(Action,Avg_time) : true
<-  .wait(1000);
    !get_avg(Action,Avg_time).

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
