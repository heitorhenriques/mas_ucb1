# Detalhamento dos Módulos

O sistema será composto de quatro elementos principais: o servidor web (*distributor*), o sistema de agentes, dois distribuidores remotos (*remote distributor*) e um cliente que fará as requisições ao servidor. 

A ideia principal por trás do conceito de Sistemas Auto-distribuídos (SDS) é transferir mais responsabilidade pelo design distribuído de sistemas de software para o próprio sistema. Os desenvolvedores de SDS precisam apenas projetar e desenvolver o software local (ou seja, software que roda em um único processo), deixando as decisões de design distribuído para serem realizadas pelo próprio sistema em tempo de execução, com base na observação do ambiente operacional atual.

Dada uma métrica específica, por exemplo, o tempo de resposta coletado do sistema em execução, o SDS experimenta realocar e replicar seus componentes constituintes para aprender qual composição distribuída gera a maior recompensa. Para concretizar esse conceito, o SDS é desenvolvido usando um modelo baseado em componentes que permite que os sistemas de software sejam desenvolvidos a partir de componentes de software reutilizáveis e pequenos.

Esses modelos baseados em componentes permitem mudanças na arquitetura em tempo de execução sem tempo de inatividade, ou seja, enquanto o software continua a lidar com solicitações de entrada. Esse mecanismo de adaptação permite que o SDS substitua qualquer um de seus componentes constituintes por componentes proxy, Chamadas de Procedimento Remoto (RPCs) para redirecionar chamadas de função locais para os componentes realocados em outras máquinas.

![alt text](image.png)

A figura mostra um SDS executando em um cluster de 3 nós. No nível de infraestrutura, temos três máquinas conectadas à mesma rede local. No nível do sistema operacional, consideramos que todas as máquinas estão executando o $Process 1$, que possui um tempo de execução de modelo baseado em componentes que executa um software local originalmente projetado (rotulado como 'Service') e o framework SDS, composto pelos módulos Assembly, Perception e Distributor.

O módulo Assembly é responsável por carregar, conectar os componentes e executá-los; o módulo Perception é responsável por inserir tipos especiais de componentes (denominados Perception proxy) que são responsáveis por coletar métricas de desempenho do sistema e de seu ambiente operacional; e, finalmente, o módulo Distributor é responsável por injetar o Distribution proxy no sistema local em execução, realocando e criando réplicas do componente original para serem executadas em máquinas externas.

O SDS também possui o módulo Learning que executa em um processo diferente e é responsável por aprender qual composição do sistema tem o melhor desempenho. O módulo Learning interage com o Distributor por meio de uma API HTTP, através da qual o módulo Learning é capaz de: *i)* obter uma lista das possíveis composições do sistema, *ii)* consultar periodicamente o desempenho do sistema, e *iii)* atribuir uma composição específica ao sistema.