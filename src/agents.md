# Detailing the Agents

To address the challenges of dynamic environments in distributed systems, we propose a multi-agent approach that enables real-time learning and adaptation. This approach employs multiple learning agents that start without prior information or training, allowing the system to continuously learn the dynamics of the environment and determine the optimal system compositions as conditions change.

Each agent in the multi-agent system is responsible for evaluating a specific system composition and measuring its performance when applied. The agents communicate to exchange information about the collected metrics and, together, reach a consensus on which composition shows the best performance.

Initially, the system undergoes an exploration phase, during which each agent tests its composition, collecting performance metrics for a predefined period. All agents take turns in this process, ensuring that all compositions are evaluated. One of the metrics used is the average response time, represented by $Avg_i^t$, which corresponds to the average time observed for composition $i$ over a time interval $t$.

Learning is conducted over time based on observed differences in the performance of each composition. The formula  

$$
\Delta^t_i = \frac{1}{\mathcal{N}-1} \sum_{k=1}^{\mathcal{N}} \big(Avg_i^{(t-k-1)} - Avg_i^{(t-k)}\big)
$$

calculates the average of the differences between the observations of the average response time for composition $i$ across consecutive time intervals. This analysis allows the agents to understand how the environment evolves and dynamically adjust their composition choices.

After the exploration phase, the system can determine which composition offers the best performance prospect by comparing the $\Delta^t_i$ values for all compositions. This analysis is performed using the formula  

$$
\Delta^t \mathit{MIN} = \min(\Delta^t_i, \ldots, \Delta^t_n),
$$

which identifies the composition with the smallest $\Delta^t_i$ value, i.e., the one that best adapts to the environmental conditions at time $t$.  
