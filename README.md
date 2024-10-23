# Self Adaptive Systems: Multiagent Approach

## Pré-Requisitos
### Dana
Para executar o projeto, é necessário instalar a linguagem de programação Dana, especificamente a versão 253.

Instale a linguagem baixando a versão 253 pelos links abaixo:
- <a href="https://www.projectdana.com/download/win64/253">Windows 64-bit</a>
- <a href="https://www.projectdana.com/download/win32/253">Windows 32-bit</a>
- <a href="https://www.projectdana.com/download/ubu64/253">Linux 64-bit</a>
- <a href="https://www.projectdana.com/download/ubu32/253">Linux 32-bit</a>
- <a href="https://www.projectdana.com/download/osx/253">Mac OS</a>

Dentro do arquivo de compressão da instalação, haverá um arquivo `HowToInstall.txt` com detalhes do processo de instalação respectivo ao sistema operacional selecionado.

Resumindo, o processo geral envolve descomprimir o arquivo `.zip` e adicionar o diretório dos arquivos `dnc` e `dana` nas variáveis de ambiente de sua máquina. Isso fará com que o computador acesse estes arquivos executáveis pelo terminal em qualquer diretório. Para testar, basta rodar

```bash
dana app.SysTest
```

### JaCaMo
A forma mais fácil de instalar e usar JaCaMo é através da instalação de Gradle. Outros métodos e mais detalhes para a instalação do JaCaMo podem ser encontradas no link: https://github.com/jacamo-lang/jacamo/blob/main/doc/install.adoc.

Para instalar com Gradle, basta seguir os passos referentes ao seu sistema operacional:

#### Linux
```bash
wget -q http://jacamo-lang.github.io/jacamo/nps/np1.3.zip
unzip np1.3.zip
./gradlew --console=plain
```

#### Windows
1. Baixe o arquivo no link http://jacamo-lang.github.io/jacamo/nps/np1.3.zip
2. Descompresse o arquivo
3. Rode o arquivo `gradlew.bat`

## Como executar o projeto
### Compilação 
Antes de conseguir executar os componentes do servidor, é necessário compilar os componentes em Dana.

#### Linux
Para compilar o projeto em Dana, basta seguir os seguintes passos:
1. Entre no diretório `self_distributing_system` usando `cd self_distributing_system`
2. Dê permissão ao arquivo `compile.sh` usando `chmod +x ./compile.sh`
3. Execute o arquivo usando o comando `./compile.sh`

#### Windows
No Windows, você pode rodar todos os comandos do `compile.sh` manualmente, utilizando o bloco de comandos abaixo:
```bash
cd server
dnc . -v -sp ../distributor
cd ..
cd distributor
dnc . -sp ../server -v
dnc Distributor.dn -sp ../server -v
dnc RemoteDist.dn
dnc RemoteList.dn
dnc ./monitoring -sp ../server -v
dnc ./util  -v
dnc ./proxy -sp ../readn -v
cd ..
cd client
dnc . -v
cd ..
cd readn
dnc . -sp ../ -v
cd ../readn-writen
dnc . -sp ../ -v
cd ../writen
dnc . -sp ../ -v
cd ../constant
dnc . -sp ../ -v
cd ..
```
### Execução (sem docker)
Com os componentes de Dana compilados, podemos executar o projeto. Primeiramente, é preciso rodar os _distributors_ do projeto _self_distributing_system_. Para isso, abra três terminais no diretório _self_distributing_system/distributor_.

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

## Selecionando Quais Agentes Rodar
Para selecionar qual algoritmo será usado, no arquivo `mas_ucb1.jcm` temos 3 opções: UCB1, composição única, e o sistema de agentes.
### Rodando UCB1
Para rodar o algoritmo UCB1, o bloco de código
```
agent ucb: ucb_agent.asl.asl {
    focus: c1
}

workspace w {
   artifact c1: example.Counter("ucb", 0)
}
```
precisa ser descomentado. Dentro de `Counter()`, temos dois atributos: os nomes do gráfico e do csv que serão gerados, e um número que representa se o algoritmo irá alterar a lista durante a execução ou não. Se deixado em 0, a lista se manterá constante durante a execução. Em 1, a lista será incrementada em 1 valor para cada iteração. Em 2, o algoritmo irá reduzir o tamanho da lista em 1 elemento por iteração.

### Rodando composição única
Para testar apenas uma composição, o bloco de código
```
agent onecomposition: onecomposition.asl {
    beliefs: action("0", "local", 0)
    // beliefs: action("1","propagate", 0)
    // beliefs: action("2","alternate", 0)
    // beliefs: action("3","sharding", 0)
}
```
precisa ser descomentado. Neste caso, descomente apenas a composição a ser testada nos beliefs.

### Rodando os agentes 
Para rodar os agentes inteligentes, o bloco de código
```
agent bob: self_distributing_agent.asl {
    focus: c1
    beliefs:    number(0)
                action("0")                    
}

agent maria: self_distributing_agent.asl {
    focus: c1
    beliefs:    number(1)
                action("3")
}                  
 
workspace w {
   artifact c1: example.Actions("agents", 0)
}
```
precisa ser descomentado. Para selecionar entre manter a lista constante, incrementar ou decrementar durante a execução, basta alterar o número entre 0, 1 e 2, respectivamente, na linha `artifact c1: example.Actions("agents", 0)`.

## Casos analisados
| Caso  | READ_FACTOR | Itens na Lista         | Modificação na Lista                  | UCB (Min) | UCB (Max) | ERRO Agentes |
|-------|-------------|------------------------|---------------------------------------|-----------|-----------|--------------|
| Caso 1| 2           | Começa com 2, +1 por iteração | 1 elemento adicionado por iteração    | 3 ms      | 3500 ms   | 1.3          |
| Caso 2| 2           | 2 itens fixos           | Nenhuma                               | 3 ms      | 120 ms    | N/A          |
| Caso 3| 8           | 38 itens fixos          | Nenhuma                               | 2700 ms   | 3700 ms   | N/A          |
| Caso 4| 2           | 90, -1 por iteração     | 1 elemento removido por iteração      | 1 ms      | 5000 ms   | N/A          |
