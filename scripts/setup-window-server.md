# Setting Up WSL 2 on Windows Server / Desktop

A step-by-step guide to installing Ubuntu on WSL 2, enabling systemd/SSH, configuring mirrored networking, and keeping the instance running continuously in headless environments.

---

## 1. Prerequisites & Installation

Open **PowerShell as Administrator** and install the target distribution:

```powershell
# List available distributions
wsl --list --online

# Install Ubuntu 24.04
wsl --install -d Ubuntu-24.04
```

> **Note:** After installation completes, set your default UNIX username and password when prompted.

---

## 2. Configure WSL Networking & Timeout

To allow SSH and other services to bind directly to Windows host ports without manual port proxying, configure **Mirrored Networking Mode**.

Run the following in **PowerShell**:

```powershell
@"
[wsl2]
networkingMode=mirrored
vmIdleTimeout=-1

[boot]
systemd=true
"@ | Out-File -FilePath "$env:USERPROFILE\.wslconfig" -Encoding utf8
```

* `networkingMode=mirrored`: WSL shares the host network stack (ports opened in WSL are reachable directly via Windows IP/localhost).
* `vmIdleTimeout=-1`: Prevents the WSL 2 VM from terminating automatically when no terminal is open.
* `systemd=true`: Ensures services (like `ssh`, `docker`) can be managed with `systemctl`.

Restart WSL to apply the configuration:

```powershell
wsl --shutdown
```

---

## 3. Install & Enable OpenSSH Server

Log in to Ubuntu:

```powershell
wsl -d Ubuntu-24.04
```

Inside the Ubuntu shell, install and start OpenSSH:

```bash
sudo apt update && sudo apt install -y openssh-server

# Enable and start SSH service via systemd
sudo systemctl enable ssh
sudo systemctl restart ssh

# Verify status
sudo systemctl status ssh
```

> **Firewall Note:** If connecting from another machine on the LAN, allow port 22 in the Windows Firewall:
> ```powershell
> New-NetFirewallRule -Name "WSL-SSH" -DisplayName "Allow WSL SSH" -Direction Inbound -LocalPort 22 -Protocol TCP -Action Allow
> ```

---

## 4. Keep WSL Running on Boot (Headless Setup)

If Windows restarts or runs without an active interactive login, create a scheduled task to launch WSL in the background:

Run in **PowerShell (Administrator)**:

```powershell
$action = New-ScheduledTaskAction -Execute "wsl.exe" -Argument "-d Ubuntu-24.04 -u root -- exec sleep infinity"
$trigger = New-ScheduledTaskTrigger -AtStartup
Register-ScheduledTask -TaskName "KeepWSLAlive" -Action $action -Trigger $trigger -RunLevel Highest -User "$env:USERNAME"
```

Verify task status:

```powershell
Get-ScheduledTask -TaskName "KeepWSLAlive"
```

> **Important:** To prevent the machine from suspending background processes, disable system sleep in Windows:
> * Go to **Settings > System > Power & sleep** $\rightarrow$ Set **Sleep** to **Never** when plugged in.

---

## 5. Next Steps

With the base environment running:
- Install Docker Engine / Docker Compose inside Ubuntu.
- Configure reverse proxies (Nginx / Cloudflare Tunnel (`cloudflared`)).
