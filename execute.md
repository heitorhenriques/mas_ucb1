# Como Executar o Projeto
## Pré-Requisitos
- <a href="/docker-installation.md">Docker</a>


## Como Executar com Docker
O projeto utiliza o script `run.sh` para facilitar a execução dos contêineres necessários. Você pode executar diferentes serviços e clientes utilizando comandos específicos. Siga as instruções abaixo de acordo com seu sistema operacional.

### Linux
1. **Dê permissão de execução ao script `run.sh`**:
   ```bash
   chmod +x run.sh
   ```

2. **Para executar o script, utilize o comando abaixo**:
   ```bash
   ./run.sh <comando> [opções]
   ```

3. **Comandos disponíveis**:
    - `build`: Constrói as imagens Docker necessárias.
        ```bash
        ./run.sh build
        ```
   - `distributor`: Executa o contêiner do distribuidor.
     ```bash
     ./run.sh distributor -remote1_ip <ip> -remote2_ip <ip> -read_factor <valor>
     ```
   - `remote1`: Executa o contêiner `remote1`.
     ```bash
     ./run.sh remote1 -distributor_ip <ip>
     ```
   - `remote2`: Executa o contêiner `remote2`.
     ```bash
     ./run.sh remote2 -distributor_ip <ip>
     ```
   - `clientadd`: Executa o cliente que adiciona dois itens.
     ```bash
     ./run.sh clientadd -distributor_ip <ip>
     ```
   - `clientadd3`: Executa o cliente que adiciona trinta e oito itens.
     ```bash
     ./run.sh clientadd3 -distributor_ip <ip>
     ```
   - `clientadd4`: Executa o cliente que adiciona noventa itens.
     ```bash
     ./run.sh clientadd4 -distributor_ip <ip>
     ```
   - `clientget`: Executa o cliente que realiza uma leitura.
     ```bash
     ./run.sh clientget -distributor_ip <ip>
     ```
   - `agentes`: Executa o contêiner de agentes.
     ```bash
     ./run.sh agentes -distributor_ip <ip> -observation_window <valor> -add_remove <valor>
     ```


## Explicação dos Comandos do `run.sh`

### 1. **distributor**
O comando `distributor` inicia o contêiner que executa o **distribuidor principal**. Este é o servidor central, responsável por gerenciar todas as requisições feitas pelos clientes e distribuir o processamento para os distribuidores remotos (`remote1` e `remote2`), caso estejam configurados.

- **Parâmetros**: 
  - `-remote1_ip`: IP do distribuidor remoto `remote1`.
  - `-remote2_ip`: IP do distribuidor remoto `remote2`.
  - `-read_factor`: Fator de leitura, um valor inteiro que simula o processamento ao aplicar cálculos de números primos.

> **Nota:** O `read_factor` controla a quantidade de processamento realizado para cada requisição, simulando uma carga maior ou menor dependendo do valor configurado. Quanto maior o `read_factor`, mais tempo leva para processar a requisição.

**Exemplo**:
```bash
./run.sh distributor -remote1_ip 192.168.0.2 -remote2_ip 192.168.0.3 -read_factor 3
```


### 2. **remote1** e **remote2**
Os comandos `remote1` e `remote2` iniciam os distribuidores remotos. Eles atuam como **auxiliares** do distribuidor principal para dividir a carga de processamento. Isso é útil para melhorar a escalabilidade do sistema, permitindo que o distribuidor principal delegue parte do trabalho para esses nós.

- **Parâmetros**:
  - `-distributor_ip`: IP do distribuidor principal.

> **Nota:** Na implementação atual, você precisa rodar os dois distribuidores remotos para poder usar as configurações remotas do programa.

**Exemplo**:
```bash
./run.sh remote1 -distributor_ip 192.168.0.1
```

### 3. **clientadd**, **clientadd3**, **clientadd4**
Esses comandos executam diferentes clientes que fazem requisições de **adição de itens** ao sistema.

- `clientadd`: Adiciona 2 itens.
- `clientadd3`: Adiciona 38 itens.
- `clientadd4`: Adiciona 90 itens.

- **Parâmetros**:
  - `-distributor_ip`: IP do distribuidor principal para onde as requisições serão enviadas.

> **Nota:** Estes clientes realizam requisições POST, enviando novos itens para serem processados pelo distribuidor principal.

**Exemplo**:
```bash
./run.sh clientadd -distributor_ip 192.168.0.1
```

### 4. **clientget**
Este comando executa um cliente que faz **requisições GET** em loop ao sistema, solicitando a recuperação de itens já armazenados.

- **Parâmetros**:
  - `-distributor_ip`: IP do distribuidor principal.

> **Nota:** Para rodar os agentes, este cliente deve estar rodando para os dados de tempo de resposta serem acessíveis.

**Exemplo**:
```bash
./run.sh clientget -distributor_ip 192.168.0.1
```

### 5. **agentes**
Os agentes são responsáveis por **monitorar e ajustar automaticamente o distribuidor principal** com base nos tempos de resposta. 

- **Parâmetros**:
  - `-distributor_ip`: IP do distribuidor principal.
  - `-observation_window`: Janela de observação para medir o tempo de resposta (em milissegundos).
  - `-add_remove`: Configuração para definir se os agentes irão adicionar (1) ou remover (2) itens da lista. Se for configurado como `0`, não realiza nenhuma dessas ações.

> **Nota:** Os agentes monitoram o tempo de resposta das requisições e podem alterar a configuração do sistema para tentar melhorar o desempenho, ajustando automaticamente o comportamento do distribuidor.

**Exemplo**:
```bash
./run.sh agentes -distributor_ip 192.168.0.1 -observation_window 5000 -add_remove 1
```

### 6. **build**
O comando `build` constrói as imagens Docker necessárias para o projeto.

- **Sem parâmetros adicionais**.

> **Nota:** Utilize este comando sempre que fizer alterações no código ou na configuração Docker para garantir que as imagens estejam atualizadas.

**Exemplo**:
```bash
./run.sh build
```

### Windows
No Windows, você precisará executar o script usando o **Git Bash**, **PowerShell**, ou **WSL** (caso esteja habilitado). Siga o passo a passo abaixo:

1. **Abra o terminal (Git Bash, PowerShell ou WSL)**.
2. **Navegue até o diretório onde o `run.sh` está localizado**:
   ```powershell
   cd caminho\para\o\mas_ucb1
   ```

3. **Execute o script utilizando o comando abaixo**:
   ```bash
   ./run.sh <comando> [opções]
   ```

4. **Comandos disponíveis**:
   - `build`: Constrói as imagens Docker necessárias.
     ```bash
     ./run.sh build
     ```
   - `distributor`: Executa o contêiner do distribuidor.
     ```bash
     ./run.sh distributor -remote1_ip <ip> -remote2_ip <ip> -read_factor <valor>
     ```
   - `remote1`: Executa o contêiner `remote1`.
     ```bash
     ./run.sh remote1 -distributor_ip <ip>
     ```
   - `remote2`: Executa o contêiner `remote2`.
     ```bash
     ./run.sh remote2 -distributor_ip <ip>
     ```
   - `clientadd`: Executa o cliente que adiciona dois itens.
     ```bash
     ./run.sh clientadd -distributor_ip <ip>
     ```
   - `clientadd3`: Executa o cliente que adiciona trinta e oito itens.
     ```bash
     ./run.sh clientadd3 -distributor_ip <ip>
     ```
   - `clientadd4`: Executa o cliente que adiciona noventa itens.
     ```bash
     ./run.sh clientadd4 -distributor_ip <ip>
     ```
   - `clientget`: Executa o cliente que realiza uma leitura.
     ```bash
     ./run.sh clientget -distributor_ip <ip>
     ```
   - `agentes`: Executa o contêiner de agentes.
     ```bash
     ./run.sh agentes -distributor_ip <ip> -observation_window <valor> -add_remove <valor>
     ```


### Opções do Script
- `-distributor_ip`: IP do distribuidor (padrão: `localhost`)
- `-remote1_ip`: IP do `remote1` (padrão: `localhost`)
- `-remote2_ip`: IP do `remote2` (padrão: `localhost`)
- `-read_factor`: Fator de leitura (padrão: `2`)
- `-observation_window`: Janela de observação para os agentes (padrão: `5000`)
- `-add_remove`: Define se os agentes vão adicionar (1) ou remover (2) itens da lista (padrão: `0` - nenhum)

### Exemplos
- **Executando o distribuidor com IPs customizados**:
  ```bash
  ./run.sh distributor -remote1_ip 192.168.0.2 -remote2_ip 192.168.0.3 -read_factor 3
  ```

- **Executando o cliente que adiciona dois itens**:
  ```bash
  ./run.sh clientadd -distributor_ip 192.168.0.1
  ```

- **Construindo as imagens Docker**:
  ```bash
  ./run.sh build
  ```

## Pré-Requisitos para Rodar sem Docker
- <a href="/self_distributing_system/dana-installation.md">Dana</a>
- <a href="/src/jacamo-installation.md">JaCaMo</a>

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

### Execução (sem Docker)
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
| 1| 2           | Começa com 2, +1 por iteração | 1 elemento adicionado por iteração    | 3 ms      | 3500 ms   | 1.3          |
| 2| 2           | 2 itens fixos           | Nenhuma                               | 3 ms      | 120 ms    | N/A          |
| 3| 8           | 38 itens fixos          | Nenhuma                               | 2700 ms   | 3700 ms   | N/A          |
| 4| 2           | 90, -1 por iteração     | 1 elemento removido por iteração      | 1 ms      | 5000 ms   | N/A          |
