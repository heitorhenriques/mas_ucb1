# Implementação do UCB1 em JaCaMo
## Como rodar
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

Em seguida, rode o _client_ que fará as requisições. Para isso, abra mais um terminal e entre no diretório _self_distributing_system/client_ e execute o comando
```bash
dana Get.o
```

Por fim, precisamos executar o projeto JaCaMo. 

Por fim abra mais um terminal no diretório base do projeto, onde o arquivo _gradlew_ está, e execute o comando.

```bash
./gradlew run
```

Caso seja a primeira vez que você esteja rodando o projeto, talvez seja necessário dar permissão ao arquivo _gradlew_, então execute o comando:

```bash
chmod +x gradlew
```
