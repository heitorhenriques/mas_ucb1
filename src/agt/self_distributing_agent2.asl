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
!start_turn.

+!start_turn: avg_time(AverageTime, Iteration) & avg_time(OldAverageTime, Iteration - 1) & Iteration - 1 \== 0 & not(difference(_, _)[source(self)])
/*
    Plano de quando é o turno do agente e não é a primeira iteração do programa.
*/
<-  !update_diff;
    !calculate_result;
    !verify_best.

+!start_turn: not(difference(_, _)[source(self)])
/*
    Plano de início do algoritmo, quando não existem dados de diferença.
*/
<-  !verify_turn.

+difference(NewDifference, CurrentDifference)[source(AgentSource)]: AgentSource \== self & difference(OldDifference, OlderDifference)[source(Source)] & OldDifference \== NewDifference 
/*
    Plano de quando o agente recebe uma nova diferença de outro agente. Ele remove a crença da diferença antiga para substituir com a nova.
*/
<-  -difference(OldDifference, OlderDifference)[source(Source)].

+!check_if_still_best: difference(CurrentDifference, OldDifference)[source(self)] & error(Error) & not(difference(OtherAgentsCurrentDifference,_)[source(OtherAgent)] & math.abs(CurrentDifference) > math.abs(OtherAgentsCurrentDifference) * Error) & result(CurrentResult)[source(self)] & result(OtherAgentsResult)[source(Source)] & Source \== self & executed_in_a_row(ExecutedInARow) & ExecutedInARow < 22
/*
    Checa se o agente ainda é o melhor. Se for, continua o fluxo normal.
*/
<-  .concat("I'm still the best. This is my average difference time is ", CurrentDifference, ". I ran ", ExecutedInARow - 2, " times in a row.", Message);
    ?action(ActionName);
    log(Message, ActionName);
    !verify_best.

+!check_if_still_best: executed_in_a_row(ExecutedInARow)
/*
    Se não passa na checagem acima, significa que o agente não é mais o melhor e precisamos iniciar uma exploração.
*/
<-  ?action(ActionName);
    log("Starting exploration", ActionName);
    .broadcast(achieve, exploration);
    !exploration.

+!calculate_result: best_difference(BestDifference) & sensibility(Sensibility) & difference(CurrentDifference, _)[source(self)] & result(OldResult)[source(self)] & .findall(Action, difference(_, _)[source(Action)], ActionsDifferences) & .all_names(ActionsNames) & .length(Action, DifferencesLength) & .length(ActionsNames, NamesLength) & DifferencesLength == NamesLength & action(ActionName)
/*
    Calcula o resultado atual para o agente usando a fórmula de recompensa descrita no artigo.
    Faz os cálculos, remove a crença antiga de resultado e envia para todos os agentes a sua recompensa.
    Este caso verifica se o agente já possui uma recompensa antiga para substituí-la.
*/
<-  ?avg_time(AvgTime, _);
    DeltaDifference = CurrentDifference - BestDifference;
    DifferenceSum = CurrentDifference + BestDifference;
    DifferenceAverage = DifferenceSum / 2;
    Ratio = DeltaDifference / DifferenceAverage;
    NewResult = AvgTime + (AvgTime * math.abs(Ratio) * Sensibility);
    -result(OldResult);
    +result(NewResult);
    .concat("New result calculated: ", NewResult, Message);
    log(Message, ActionName);
    .broadcast(tell, result(NewResult)).

+!calculate_result: best_difference(BestDifference) & sensibility(Sensibility) & difference(CurrentDifference,_)[source(self)] & .findall(Action, difference(_,_)[source(Action)], ActionsDifferences) & .all_names(ActionsNames) & .length(ActionsDifferences, DifferencesLength) & .length(ActionsNames, NamesLength) & DifferencesLength == NamesLength & action(ActionName)
/*
    Calcula o resultado atual para o agente usando a fórmula de recompensa descrita no artigo.
    Faz os cálculos, remove a crença antiga de resultado e envia para todos os agentes a sua recompensa.
    Este caso adiciona uma nova recompensa quando o agente não possui um resultado antigo nas suas crenças.
*/
<- ?avg_time(AvgTime, _);
    DeltaDifference = CurrentDifference - BestDifference;
    DifferenceSum = CurrentDifference + BestDifference;
    DifferenceAverage = DifferenceSum / 2;
    Ratio = DeltaDifference / DifferenceAverage;
    NewResult = AvgTime + (AvgTime * math.abs(Ratio) * Sensibility);
    +result(NewResult);
    .concat("New result calculated: ", NewResult, Message);
    log(Message, ActionName);
    .broadcast(tell, result(NewResult)).

-!calculate_result: true
/*
    Plano de falha para o cálculo do resultado. Caso não entre em nenhum dos casos, ele apenas espera e tenta novamente.
*/
<-  .wait(1000);
    !calculate_result.

+result(NewResult)[source(Source)]: Source \== self & result(OldResult)[source(Source)] & OldResult \== NewResult
/*
    Plano de quando um agente recebe o resultado de outro agente. Ele apenas remove a crença antiga, mantendo apenas a nova e volta para o ciclo normal.
*/
<-  -result(OldResult)[source(Source)];
    !verify_best.

+!verify_turn: turn(CurrentActionNumber) & number(ThisAction) & ThisAction == CurrentActionNumber & action(AgentName)
/*
    Plano de verificar o turno. Se for turno do agente, ele vai executar
*/
<-  !execute;
    inc;
    .broadcast(achieve, start_turn);
    !start_turn.

+!verify_turn: turn(CurrentActionNumber) & number(ThisAction) & ThisAction \== CurrentActionNumber & action(AgentName)
/* 
    Plano de verificar o turno. Se não for o turno do agente, ele vai pular, printando que não é sua vez
*/
<-  log("Not my turn!", AgentName).

+!verify_best: .findall(Action, result(_)[source(Action)], ActionsResults) & .all_names(AgentsNames) & .length(ActionsResults, ResultsLength) & .length(AgentsNames, NamesLength) & ResultsLength == NamesLength & best(self)
/*
    Verifica se o agente é o melhor. Ele executa, atualiza a diferença e checa se ainda é seu turno.
*/
<-  !execute;
    !update_diff;
    !check_if_still_best.
    
+!verify_best: .findall(Action, result(_)[source(Action)], ActionsResults) & .all_names(AgentsNames) & .length(ActionsResults, ResultsLength) & .length(AgentsNames, NamesLength) & ResultsLength == NamesLength & best(BestAgent) & action(ActionName)
/*
    Verifica que outro agente é o melhor. Printa que o outro agente vai assumir.
*/
<-  .concat(BestAgent, " is assuming!", Message);
    log(Message, ActionName).

-!verify_best: true
/*
    Plano de verificação de falha, caso as verificações deem errado, ele espera 1 segundo e tenta novamente.
*/
<-  .wait(1000);
    !verify_best.

+!execute: action(ActionName) & mutex(Mutex) & Mutex == 0 & executed_in_a_row(ExecutedInARow)
/* 
    Plano de execução. Aqui o agente vai executar a operação, atualizando os dados de quantas vezes seguidas ele rodou, diferença e tempo de resposta
*/
<-  inc_mutex; // Inicia desativando o Mutex
    send_operation(ActionName);
    .wait(11000);
    ignoreAvgTime;
    .wait(11000);
    get_avg_time(ActionNumber, AverageTime);
    ?avg_time(_, Iteration);
    +avg_time(AverageTime, Iteration + 1);
    // Atualizamos as vezes seguidas que rodamos
    NewExecutedInARow = ExecutedInARow + 1;
    -executed_in_a_row(ExecutedInARow);
    +executed_in_a_row(NewExecutedInARow);
    .concat("I ran ", NewExecutedInARow - 2, " times in a row.", Message);
    log(Message, ActionName);
    .concat("Response time: ", Iteration, Message2);
    log(Message2, ActionName);
    inc_mutex. // Finaliza reativando o Mutex

+!update_diff: avg_time(AverageTime, Iteration) & avg_time(OldAverageTime, Iteration - 1) & difference(CurrentDifference, OldDifference)[source(self)] & Iteration - 1 \== 0 & sum_difference(DifferenceSum) & action(ActionName)
/*
    Plano para atualizar a crença da diferença. Atualiza a soma de diferenças e a diferença atual.
*/
<-  -sum_difference(DifferenceSum); // Remove a soma das diferenças antigas
    NewSum = DifferenceSum + (AverageTime - OldAverageTime); // Calcula a nova soma
    +sum_difference(NewSum);
    -difference(CurrentDifference, OldDifference);
    NewDifference = (NewSum) / (Iteration - 1);
    .concat("New difference: ", NewDifference, ". Old Difference: ", CurrentDifference, " Sum of differences: ", NewSum, Message);
    log(Message, ActionName);
    +difference(NewDifference, CurrentDifference);
    .broadcast(tell, difference(NewDifference, CurrentDifference)).

+!update_diff: avg_time(AverageTime, Iteration) & avg_time(OldAverageTime, Iteration - 1) & Iteration - 1 \== 0 & sum_difference(DifferenceSum) & action(ActionName)
/*
    Plano para atualizar a crença da diferença. Atualiza a soma de diferenças e a diferença atual.
*/
<-  -sum_difference(DifferenceSum);
    NewSum = DifferenceSum + (AverageTime - OldAverageTime);
    +sum_difference(NewSum);
    NewDifference = NewSum / (Iteration - 1);
    +difference(NewDifference, 0);
    .concat("New difference: ", NewDifference, Message);
    log(Message, ActionName);
    .broadcast(tell, difference(NewDifference, 0)).

+!exploration: turn(AgentTurn) & number(AgentNumber) & AgentNumber == AgentTurn & action(ActionName) & exploring(ExplorationStep) & ExplorationStep < 2
/*
    Plano de exploração - segundo passo. Ele atualiza a crença do passo atual da exploração, executa uma vez, passa sua vez e manda o próximo agente seguir com a sua exploração
*/
<-  -exploring(ExplorationStep);
    !execute;
    +exploring(ExplorationStep + 1);
    log("Second step of exploration", ActionName);
    inc;
    .broadcast(achieve, exploration).

+!exploration: exploring(ExplorationStep) & ExplorationStep > 1 & action(ActionNumber) & executed_in_a_row(ExecutedInARow)
/*
    Plano de exploração - último passo. Ele remove a crença de exploração, avisa que finalizou a exploração, manda o próximo agente seguir com a sua exploração e reseta quantas vezes seguidas ele rodou,
*/
<-  -exploring(ExplorationStep);
    .broadcast(tell, finished);
    .broadcast(achieve, exploration);
    log("Finishing exploration", ActionName);
    // Reseta as vezes seguidas que a ação rodou
    -executed_in_a_row(ExecutedInARow)[source(_)];
    +executed_in_a_row(0);
    !finish_exploration.

+!exploration: turn(CurrentActionNumber) & number(AgentNumber) & CurrentActionNumber == AgentNumber & action(ActionName) & not(finished)
/*
    Plano de exploração - primeiro passo. Cria a crença de que está no primeiro passo da exploração, executa uma vez, passa sua vez e manda o próximo agente fazer uma exploração.
*/
<-  +exploring(1);
    log("First step of exploration", ActionName);
    !execute;
    inc;
    .broadcast(achieve, exploration).

+!finish_exploration: avg_time(CurrentAverageTime, Iteration) & avg_time(OldAverageTime, Iteration - 1) & Iteration - 1 \== 0 & difference(_, _)[source(self)] & finished
/*
    Plano de fim de exploração. Remove a crença de que o outro agente finalizou (para poder iniciar outra no futuro), atualiza a diferença, resultado e volta ao ciclo normal.
*/
<-  -finished[source(_)];
    !update_diff;
    !calculate_result;
    !verify_best.

-!finish_exploration: true
/*
    Plano de falha para o fim de exploração. Se as outras verificações deem errado, espera 1 segundo e tenta novamente.
*/
<-  .wait(1000);
    !finish_exploration.

// Inclui os templates do JaCaMo
{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }