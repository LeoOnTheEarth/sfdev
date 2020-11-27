PHP Develop Environment with WSL
================================

## Pre-Requirements

1. Install Windows Subsystem for Linux (WSL)
2. Go to **Microsoft Store**, install **Ubuntu 18.04 LTS** distribution.
3. Launch **Ubuntu 18.04 LTS** and setup your username and password

## Installation

First, open Windows Command Prompt (a.k.a. `cmd.exe`)

1. Clone [`sfdev`](https://github.com/LeoOnTheEarth/sfdev) into `C:\sfdev`  

    ```bash
    C:\> cd C:\
    C:\> git clone https://github.com/LeoOnTheEarth/sfdev
    ```

2. Enter WSL mode, and install Ubuntu packages  

    ```bash
    C:\> wsl
    ```

    Then, execute `install.sh` script  
   
    ```bash
    $ /mnt/c/sfdev/wsl/install.sh
    ```

3. Execute command to start all services  

    ```bash
    C:\> C:\sfdev\bin\sfdev-service.bat restart
    ```
