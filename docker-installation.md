### Docker Installation

To install Docker on your machine, follow the steps below according to your operating system.

#### Linux
1. **Update your package list:**
    ```bash
    sudo apt update
    ```

2. **Install prerequisites required by Docker:**
    ```bash
    sudo apt install apt-transport-https ca-certificates curl software-properties-common
    ```

3. **Add the GPG key for Docker's official repository:**
    ```bash
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    ```

4. **Add Docker's repository to APT sources:**
    ```bash
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
    ```

5. **Update the package database to include Docker's repository:**
    ```bash
    sudo apt update
    ```

6. **Install Docker:**
    ```bash
    sudo apt install docker-ce
    ```

7. **Run Docker commands without `sudo`:**
    ```bash
    sudo usermod -aG docker ${USER}
    ```

#### Windows
1. **Download the Docker Desktop installer:**
   - Visit the official Docker website and download the Docker Desktop installer for Windows:  
     [Download Link](https://www.docker.com/products/docker-desktop/).

2. **Run the installer:**
   - Double-click the downloaded `.exe` file to begin installation.  
   - Select the option to enable **WSL 2** (Windows Subsystem for Linux 2) during setup if prompted.

3. **Enable WSL 2:**
   - If WSL 2 is not already enabled, open PowerShell as administrator and run the following commands:
     ```powershell
     dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
     dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
     wsl --set-default-version 2
     ```

4. **Restart your computer:**
   - Restart the system to apply the changes.

5. **Complete Docker Desktop setup:**
   - After restarting, open Docker Desktop. It may prompt you to finish the WSL 2 configuration.

6. **Verify the installation:**
   - To ensure Docker is installed correctly, open PowerShell or Command Prompt and run:
     ```powershell
     docker --version
     ```

7. **Optional Configuration – Run Docker without administrator privileges:**
   - Open Docker Desktop, go to **Settings** > **General**, and enable the **"Use the WSL 2 based engine"** option.  
   - Add your user to the `docker-users` group. Open PowerShell as administrator and execute:
     ```powershell
     net localgroup docker-users "YOUR_USERNAME" /add
     ```