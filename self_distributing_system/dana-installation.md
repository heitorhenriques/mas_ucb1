# Instalação de Dana
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