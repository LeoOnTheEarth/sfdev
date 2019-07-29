PHP Develop Environment with WSL and Docker
===========================================

## Pre-Requirements

1. Install Windows Subsystem for Linux (WSL)
2. Go to **Microsoft Store**, install **Ubuntu 18.04 LTS** distribution.
3. Launch **Ubuntu 18.04 LTS** and setup your username and password
4. Install Hyper-V
5. Install **[Docker Desktop](https://hub.docker.com/editions/community/docker-ce-desktop-windows)**

## Installation

1. Clone the [`sfdev`](https://github.com/LeoOnTheEarth/sfdev) into `C:/sfdev/`
2. Enter WSL mode  

   ```bash
   $ wsl.exe
   ```

3. Execute `install.sh` script  
   
   ```bash
   $ /mnt/c/sfdev/wsl/install.sh
   ```

4. Add `C:/sfdev/bin` into your Windows `$PATH` environment. 

