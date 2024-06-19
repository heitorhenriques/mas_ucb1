# Implementação do UCB1 em JaCaMo
## Como rodar o projeto
Primeiro é preciso rodar os _distributors_ do projeto _self_distributing_system_. Para isso, abra três terminais no diretório _self_distributing_system/distributor_.

No primeiro execute:

```bash
dana -sp "../server;../readn" Distributor.o
```

Em um segundo terminal digite:

```bash
dana -sp ../readn RemoteDist.o
```

Em um terceiro terminal digite:

```bash
dana -sp ../readn RemoteDist.o 8082 2011
```

Com os _distributors_ sendo executados, precisamos adicionar elementos à lista antes de fazer requisições pelo _client_.Para isso, abra mais um terminal e entre no diretório _self_distributing_system/client_ e execute o comando:

```bash
dana Add.o
```

Em seguida, rode o _client_ que fará as requisições usando:
```bash
dana Get.o
```

Por fim, precisamos executar o projeto JaCaMo. Abra mais um terminal no diretório base do projeto, onde o arquivo _gradlew_ está, e execute o comando.

```bash
./gradlew run
```

Caso seja a primeira vez que você esteja rodando o projeto, talvez seja necessário dar permissão ao arquivo _gradlew_. Se este for o caso, execute o comando:

```bash
chmod +x gradlew
```

## Selecionando qual ação rodar
Para selecionar qual algoritmo será usado, no arquivo `mas_ucb1.jcm` temos 3 opções: UCB1, composição única, e o sistema de agentes.
### Rodando UCB1
Para rodar o algoritmo UCB1, o bloco de código
```
agent bob: sample_agent.asl {
    focus: c1
}

workspace w {
    artifact c1: example.Counter("ucb", "true")
}
```
precisa ser descomentado. Dentro de `Counter()`, temos dois atributos: o nome do gráfico e csv a serem gerados e um _boolean_ que indica se a lista será incrementada ao longo das iterações ou não.

### Rodando composição única
Para testar apenas uma composição, o bloco de código
```
agent bob: onecomposition.asl {
    beliefs: action("0","local")
    // beliefs: action("1","propagate")
    // beliefs: action("2","alternate")
    // beliefs: action("3","sharding")
}
```
precisa ser descomentado. Neste caso, descomente apenas a composição a ser testada nos beliefs.

### Rodando os agentes
Para rodar os agentes, o bloco de código
```
agent bob: generic_agent.asl {
    focus: c1
    beliefs:    number(0)
                action("0")                    
}

agent maria: generic_agent.asl {
    focus: c1
    beliefs:    number(1)
                action("3")
}                  
 
workspace w {
   artifact c1: example.Actions("agents", "true")
}
```
precisa ser descomentado.

## CASO 1
READ_FACTOR: 2;

Começando com 2 itens na lista;

1 elemento foi adicionado a cada iteração do programa;

Para o UCB, Min = 3 ms e Max = 3500

## CASO 2
READ_FACTOR: 2;

2 itens fixos na lista;

Para o UCB, Min = 3 ms e Max = 120 ms

## CASO 3
READ_FACTOR: 8;

38 itens fixos na lista;

Para o UCB, Min = 3100 ms e Max = 4500 ms

<!-- 
## Resultados 2 itens na lista READ_FACTOR 2:
Min = 1
Max = 160
Janela de observação = 5000

## Resultados 12 itens na lista READ_FACTOR 5:
Min = 360
Max = 605
Janela de observação = 5000

## Resultados adicionando 1 item a cada 6500 ms na lista com READ_FACTOR 2:
Iniciamos os agentes com 2 itens na lista ao invés de 0 pq o sharding dava erro.

Min = 3
Max = 3500
Janela de observação = 5000

Para o UCB, como utilizamos dois waits de 5000 ms para ignorar um dos resultados, precisamos alterar a adição dos itens no loop de Adds para 6000. -->