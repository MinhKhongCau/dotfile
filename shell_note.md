# Note command line for myself

## Docker

- Docker swarm 
- Reload 
````
```
# List docker swarm
docker service ls
# Reload docker swarm 
docker service update <service-name>
```

# Setup openvpn

```
# Install openvpn
sudo apt update 
sudo apt install openvpn

# (Optional) move file ***.ovpn to ~/.config/openvpn/sslvpn-minhnq.tts-client-config.ovpn
mv ~/<file origin ovpn>/***.ovpn ~/.config/***.ovpn
sudo openvpn --config ~/.config/***.ovpn

# Enable openvpn (manual)
sudo systemctl enable --now openvpn openvpn@client

# Auto add username and pass when openvpn
nano ~/.config/openvpn/auth.txt
# (copy user name | pass with expample)
<username>
<password>

sudo openvpn --config ~/Downloads/sslvpn-minhnq.tts-client-config.ovpn --auth-user-pass /home/minhminh/.config/openvpn/auth.txt

```

## Install extention manager
- Vitals 
- Shell Tiling
- Dash2Dock Animated 
