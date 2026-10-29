# This is document for config wsl for window server

## Install guide for window subsystem linux 

### Requirement  
````
- If this is the first time install ubuntu to wsl: following this guide for install Ubuntu for wsl

in powershell mode in window
```
wsl --list --online 
wsl --install -d Ubuntu-24.
```
--- 
1. Open powershell enable wsl (Window Subsystem Linux)

Enalbe and access to Ubuntu
```
wsl -d Ubuntu -u root -- exec sleep infinity
```
- Check wsl already keep alive 
```
wsl -l -v 
```
2. Install OpenSSHServer into Ubuntu 
in Command line Ubuntu mode 
```
sudo apt update
sudo apt install openssh-server -y
sudo systemctl enable ssh
sudo systemctl start ssh
```
3. Config Port Forwarding from Ubuntu to WSL
Because WSL and Window using seperate Port. That a reason i must be map port 22 (ssh) Window foward to WSL.
in powershell mode
```
(echo [wsl2] & echo networkingMode=mirrored & echo vmIdleTimeout=-1) > "%USERPROFILE%\.wslconfig"
```
or open notepad and paste 
```
[wsl2]
networkingMode=mirrored
vmIdleTimeout=-1
```
check content in this file 
```
type "%USERPROFILE%\.wslconfig"
```
4. Config Task Scheduler for running wsl when computer sleep 
Because Window Desktop will sleep whether user dont using it.
-> Must create the task keep alive although the computer in Sleep Mode 
```
schtasks /create /tn "KeepWSLAlive" /tr "wsl.exe -d Ubuntu -u root -- sleep infinity" /sc onstart /ru SYSTEM /f
```
check this task scheduler (Status: Running, Last Result: 0/-1)
```
schtasks /query /tn "KeepWSLAlive" /fo LIST /v
```
Run this task
```
schtasks /run /tn "KeepWSLAlive"
```
5. Access to WSL 
```
wsl -d Ubuntu
```
After setup WSL for window. Install docker, nginx, cloudflared for deploy application.


