### Docker
Para instalar o Docker na sua máquina, siga os passos abaixo referentes ao seu sistema operacional.
#### Linux
1. Atualize sua lista de pacotes:
    ```bash
    sudo apt update
    ```
2. Instale os pacotes pré-requisitados pelo Docker pelo comando abaixo:
    ```bash
    sudo apt install apt-transport-https ca-certificates curl software-properties-common
    ```
3. Adicione a chave GPG para o repositório oficial do Docker no seu sistema:
    ```bash
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    ```
4. Adicione o repositório do Docker às fontes do APT:
    ```bash
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
    ```

5. Em seguida, atualize o banco de dados do pacote com os pacotes do Docker do recém adicionado repositório:
    ```bash
    sudo apt update
    ```

6. Finalmente, instale o Docker:
    ```bash
    sudo apt install docker-ce
    ```

7. Para rodar os comandos do Docker sem usar `sudo`, rode o seguinte comando:
    ```bash
    sudo usermod -aG docker ${USER}
    ```

#### Windows
1. **Baixe o instalador do Docker Desktop:**
   - Acesse o site oficial do Docker e baixe o instalador do Docker Desktop para Windows:
     [Link para Download](https://www.docker.com/products/docker-desktop/).

3. **Execute o instalador:**
   - Clique duas vezes no arquivo `.exe` baixado para iniciar a instalação.
   - Marque a opção para ativar o **WSL 2** (Windows Subsystem for Linux 2) durante a instalação, se solicitado.

4. **Habilite o WSL 2:**
   - Se você ainda não tiver o WSL 2 instalado, abra o PowerShell como administrador e execute os comandos abaixo para habilitar o WSL e definir o WSL 2 como padrão:
     ```powershell
     dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
     dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
     wsl --set-default-version 2
     ```

5. **Reinicie seu computador:**
   - É necessário reiniciar o sistema para aplicar as mudanças.

6. **Finalize a instalação do Docker Desktop:**
   - Após a reinicialização, abra o Docker Desktop. Ele pode pedir para você concluir a configuração do WSL 2.

7. **Verifique a instalação:**
   - Para verificar se o Docker está instalado corretamente, abra o PowerShell ou o Prompt de Comando e execute:
     ```powershell
     docker --version
     ```

8. **Configuração opcional - Executar Docker sem privilégios de administrador:**
   - Abra o Docker Desktop e vá para **Settings** > **General** e habilite a opção **"Use the WSL 2 based engine"**.
   - Certifique-se de que seu usuário faz parte do grupo `docker-users`. Para isso, abra o PowerShell como administrador e execute:
     ```powershell
     net localgroup docker-users "SEU_USUARIO" /add
     ```