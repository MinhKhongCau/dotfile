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

If Windows restarts or runs without an active interactive login, create a scheduled task to start and keep the WSL instance alive in the background.

Open **Command Prompt as Administrator** and execute:

```cmd
:: Create the task to run automatically on system boot with elevated privileges
schtasks /create /tn "KeepWSLAlive" /tr "wsl.exe -d Ubuntu-24.04 -u root -- exec sleep infinity" /sc onstart /ru "%USERNAME%" /rl HIGHEST /f

:: Run the task immediately without restarting
schtasks /run /tn "KeepWSLAlive"
```

Verify the task registration and WSL execution status:

```cmd
:: Check scheduled task configuration
schtasks /query /tn "KeepWSLAlive" /fo LIST /v

:: Verify that the Ubuntu instance is in 'Running' state
wsl -l -v
```

> **Important:** Scheduled tasks cannot execute when the host hardware enters low-power suspension. Disable Windows sleep:
> * Go to **Settings > System > Power & sleep** -> Set **Sleep** to **Never** when plugged in.

### 4.1. Alternative: Configure via Task Scheduler GUI

If running headless via CLI encounters permission mismatches, configure the background task using the Windows GUI:

1. **Open Task Scheduler:**
   * Press `Win + R`, type `taskschd.msc`, and press **Enter** (Run as Administrator).
   * In the right panel (**Actions**), click **Create Task...** *(Do not choose "Create Basic Task")*.

2. **General Tab:**
   * **Name:** `KeepWSLAlive`
   * Under **Security options**:
     * Click **Change User or Group...**, enter your Windows username (`%USERNAME%`), and click **OK**.
     * Select **Run whether user is logged on or not** *(Mandatory for running without interactive login)*.
     * Check **Run with highest privileges**.
     * **Configure for:** Select **Windows 10** or **Windows 11**.

3. **Triggers Tab:**
   * Click **New...** $\rightarrow$ Set **Begin the task:** to **At startup**.
   * Ensure **Enabled** is checked $\rightarrow$ Click **OK**.

4. **Actions Tab:**
   * Click **New...** $\rightarrow$ Set **Action:** to **Start a program**.
   * **Program/script:**
     ```text
     wsl.exe
     ```
   * **Add arguments (optional):**
     ```text
     -d Ubuntu -u root -- sleep infinity
     ```
     *(Adjust `Ubuntu` if your distribution name differs in `wsl -l -v`)*.
   * Click **OK**.

5. **Conditions & Settings Tabs:**
   * In **Conditions**: Uncheck all options under **Power** (*Stop if the computer switches to battery power*, etc.).
   * In **Settings**:
     * Check **Allow task to be run on demand**.
     * Check **Run task as soon as possible after a scheduled start is missed**.
     * Uncheck **Stop the task if it runs longer than**.
   * Click **OK** $\rightarrow$ Enter your **Windows Account Password** when prompted to store execution credentials.

6. **Verify Execution:**
   * Right-click `KeepWSLAlive` in **Task Scheduler Library** $\rightarrow$ Select **Run**.
   * Verify status in CMD/PowerShell:
     ```cmd
     wsl -l -v
     ```
     The distribution state should now show **Running**.
---

## 5. Next Steps

With the base environment running:
- Install Docker Engine / Docker Compose inside Ubuntu.
- Configure reverse proxies (Nginx / Cloudflare Tunnel (`cloudflared`)).
