// Belief de qual é a melhor composição. Verifica que seu custo é MENOR que dos outros agentes:
// Name: nome do agente; 
best_agent(AgentName):- cost(Cost)[source(AgentName)] & not(cost(OtherAgent)[source(OtherAg)] & OtherAgent < Cost).

// Belief de qual é a melhor diferença (variação da curva). Verifica que a sua diferença é MENOR que a dos outros agentes
best_difference(AgentDifference):- difference(AgentDifference,_)[source(AgentName)] & not(difference(OtherAgent,_)[source(OtherAgent)] & OtherAgent < AgentDifference).

// Belief da Sensibilidade: um parâmetro que indica o quão sensitivo o sistema é para mudanças
sensibility(1).

// Belief do erro, o multiplicador de quanto o tempo de resposta pode mudar entre uma iteração e outra para acionar o evento de exploração
error(1.3).

// Belief da soma das diferenças de um agente
sum_difference(0).

// Belief de quantas vezes seguidas o agente rodou
executed_in_a_row(0).

// O algoritmo precisa iniciar fazendo uma exploração de todas as composições para adquirir os dados de cada uma e iniciar o processo de aprendizado:
!my_turn.

+!my_turn: avg_time(AverageTime, Iteration) & avg_time(AverageTime1,Iteration-1) & Iteration-1 \== 0 & not(difference(_,_)[source(self)])
/*
    Plano de quando é o turno do agente e não é a primeira iteração do programa
*/
<-  !update_diff;
    !calc_res;
    !verify_best.

+!my_turn: not(difference(_,_)[source(self)]) & action(Action)
/*
    Plano de início do algoritmo, quando não existem dados de diferença
*/
<-  log("Starting initial exploration!", Action);
    !verify_turn.

+difference(C,D)[source(AgentSource)]: AgentSource \== self & difference(E,F)[source(S)] & E \== C 
/*
    Plano de quando o agente recebe uma nova diferença de outro agente. Ele remove a diferença antiga para a nova substituir.
*/
<-  -difference(E,F)[source(S)].

+!verify_turn: turn(CurrentActionNumber) & number(ThisAction) & ThisAction == CurrentActionNumber & action(AgentName)
/*
    Plano de verificar o turno. Se for turno do agente, ele vai executar
*/
<-  !execute;
    inc;
    .broadcast(achieve, my_turn);
    !my_turn.

+!verify_turn: turn(CurrentActionNumber) & number(ThisAction) & ThisAction \== CurrentActionNumber & action(AgentName)
/* 
    Plano de verificar o turno. Se não for o turno do agente, ele vai skippar, printando que não é sua vez
*/
<-  log("Not my turn!", AgentName).

+!execute: action(ActionName) & mutex(Mutex) & Mutex == 0 & execute_in_a_row(ExecutedInARow)
/* 
    Plano de execução. Aqui o agente vai executar a operação, atualizando os dados de quantas vezes seguidas ele rodou, diferença e tempo de resposta
*/
<-  inc_mutex; // Inicia desativando o Mutex
    send_operation(ActionName);
    .wait(11000);
    ignoreAvgTime;
    .wait(11000);
    get_avg_time(ActionNumber, AverageTime);
    ?avg_time(_,Iteration);
    +avg_time(AverageTime,Iteration+1);
    // Atualizamos as vezes seguidas que rodamos
    NewExecutedInARow = ExecutedInARow + 1;
    -execute_in_a_row(ExecutedInARow);
    +execute_in_a_row(NewExecutedInARow);
    .concat("I ran ", NewExecutedInARow-2, " times in a row.", Message);
    log(Message, ActionName);
    .concat("Response time: ", N, Message2);
    log(Message2, ActionName);
    inc_mutex. // Finaliza reativando o Mutex

+!update_diff: avg_time(AverageTime, Iteration) & avg_time(AverageTime1, Iteration-1) & difference(CurrentDifference, OldDifference)[source(self)] & Iteration-1 \== 0 & sum_difference(DifferenceSum) & action(ActionName)
/*
    Plano para atualizar a crença da diferença. Atualiza a soma de diferenças e a diferença atual.
*/
<-  -sum_difference(DifferenceSum); // Remove a soma das diferenças antigas
    NewSum = DifferenceSum + (AverageTime - AverageTime1); // Calcula a nova soma
    +sum_difference(NewSum);
    -difference(CurrentDifference, OldDifference);
    NewDifference = (NewSum)/(Iteration-1);
    .concat("New difference: ", NewDifference, ". Old Difference: ", CurrentDifference, " Sum of differences: ", NewSum, Message);
    log(Message, ActionName);
    +difference(NewDifference, CurrentDifference);
    .broadcast(tell,difference(NewDifference, CurrentDifference)).

+!update_diff: avg_time(AverageTime, Iteration) & avg_time(AverageTime1, Iteration-1) & Iteration-1 \== 0 & sum_difference(DifferenceSum) & action(ActionName)
/*
    Plano para atualizar a crença da diferença. Atualiza a soma de diferenças e a diferença atual.
*/
<-  -sum_difference(DifferenceSum);
    NewSum = DifferenceSum + (AverageTime - AverageTime1);
    +sum_difference(NewSum);
    NewDifference = NewSum/(Iteration-1);
    +difference(NewDifference, 0);
    .concat("New difference: ", NewDifference, Message);
    log(Message, ActionName);
    .broadcast(tell,difference(NewDifference, 0)).

+!exploration: turn(AgentTurn) & number(AgentNumber) & AgentNumber == AgentTurn & action(ActionName) & exploring(ExplorationStep) & ExplorationStep < 2
/*
    Plano de exploração - segundo passo. Ele atualiza a crença do passo atual da exploração, executa uma vez, passa sua vez e manda o próximo agente seguir com a sua exploração
*/
<-  -exploring(ExplorationStep);
    !execute;
    +exploring(ExplorationStep+1);
    log("Second step of exploration", ActionName);
    inc;
    .broadcast(achieve, exploration).

+!exploration: exploring(ExplorationStep) & ExplorationStep > 1 & action(ActionNumber) & execute_in_a_row(ExecutedInARow)
/*
    Plano de exploração - último passo. Ele remove a crença de exploração, avisa que finalizou a exploração, manda o próximo agente seguir com a sua exploração e reseta quantas vezes seguidas ele rodou
*/
<-  -exploring(ExplorationStep);
    .broadcast(tell,finished);
    .broadcast(achieve,exploration);
    log("Finishing exploration", ActionName);
    // Reseta as vezes seguidas que a ação rodou
    -execute_in_a_row(ExecutedInARow)[source(_)];
    +execute_in_a_row(0);
    !my_exploration.

+!exploration: turn(CurrentActionNumber) & number(AgentNumber) & CurrentActionNumber == AgentNumber & action(ActionName) & not(finished)
/*
    Plano de exploração - primeiro passo. Cria a crença de que está no primeiro passo da exploração, executa uma vez, passa sua vez e manda o próximo agente fazer uma exploração
*/
<-  +exploring(1);
    log("First step of exploration", ActionName);
    !execute;
    inc;
    .broadcast(achieve, exploration).