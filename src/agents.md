# Detalhamento dos Agentes

Para enfrentar os desafios de ambientes dinâmicos em sistemas distribuídos, propomos uma abordagem multiagente que permite aprendizado e adaptação em tempo real. Essa abordagem utiliza múltiplos agentes de aprendizado que começam sem informações prévias ou treinamento, permitindo que o sistema aprenda continuamente as dinâmicas do ambiente e determine as composições ótimas do sistema conforme as condições mudam.  

Cada agente no sistema multiagente é responsável por avaliar uma composição específica do sistema e medir o desempenho dessa composição quando aplicada. Os agentes comunicam-se para trocar informações sobre as métricas coletadas e, juntos, chegam a um consenso sobre qual composição apresenta o melhor desempenho. 

Inicialmente, o sistema passa por uma fase de exploração, durante a qual cada agente testa sua composição, coletando métricas de desempenho por um período predefinido. Todos os agentes se revezam nesse processo, garantindo que todas as composições sejam avaliadas. Uma das métricas utilizadas é o tempo médio de resposta, representado por $Avg_i^t$, que corresponde ao tempo médio observado para a composição $i$ em um intervalo de tempo $t$. 

O aprendizado é realizado ao longo do tempo com base nas diferenças observadas no desempenho de cada composição. A fórmula  

$$
\Delta^t_i = \frac{1}{\mathcal{N}-1} \sum_{k=1}^{\mathcal{N}} \big(Avg_i^{(t-k-1)} - Avg_i^{(t-k)}\big)
$$

calcula a média das diferenças entre as observações do tempo médio de resposta para a composição $i$ em intervalos de tempo consecutivos. Essa análise permite aos agentes compreender como o ambiente evolui e ajustar suas escolhas de composição de forma dinâmica.  

Após a fase de exploração, o sistema pode determinar qual composição apresenta a melhor perspectiva de desempenho ao comparar os valores de $\Delta^t_i$ para todas as composições. Essa análise é feita utilizando a fórmula  

$$
\Delta^t \mathit{MIN} = \min(\Delta^t_i, \ldots, \Delta^t_n),
$$

que identifica a composição com o menor valor de $\Delta^t_i$, ou seja, aquela que se adapta melhor às condições do ambiente em $t$.  
