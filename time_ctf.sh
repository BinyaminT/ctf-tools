#!/bin/bash

cd ~/Documents || exit 1

# Pedir nombre de sesión y CTF
echo 'Nombre de la sesión de tmux: '
read -r sesion
echo "Nombre del CTF: "
read -r carpeta

# Crear carpeta base del CTF si no existe
if [ ! -d "$carpeta" ]; then
    mkdir -p "$carpeta"
fi
cd "$carpeta" || exit 1

# Pedir IP y guardarla
echo "Ingresa dirección IP:"
read -r ip
echo "$ip" > ip.txt

# Crear estructura de carpetas
mkdir -p nmap enum/{web,smb,ftp} creds exploit/{scripts,payloads,exploits} postexploit/{loot,persistencia,datos_extraidos} flags

# Archivos base
touch creds/{hashes.txt,usuarios_passwords.txt}

# Crear sesión tmux y ventanas
tmux new-session -d -s "$sesion"
tmux new-window -t "$sesion:0" -n 'openvpn'
tmux new-window -t "$sesion:1" -n 'escaner'
tmux new-window -t "$sesion:2" -n 'fuzzing'
tmux new-window -t "$sesion:3" -n 'exploit'

# Lanzar VPN, recuerda poner el nombre de tu vpn o nombrarle "conec"
tmux send-keys -t "$sesion:0" "sudo openvpn ~/conec.ovpn" C-m

# Ventana de escaneo
tmux send-keys -t "$sesion:1" "cd nmap && clear" C-m
tmux send-keys -t "$sesion:1" "
while ! ip a show tun0 | grep -q 'inet'; do
    clear
    sleep 5
done" C-m

tmux send-keys -t "$sesion:1" "
nmap -O -sV -T5 -sS -Pn --min-rate 6000 -p- --open -oA ./resultados '$ip' && \
awk '/^PORT/{detalle=1} detalle' resultados.nmap > analisis.txt && \
os_detectado=\$(grep -i 'OS details\\|Running' resultados.nmap | awk -F: '{print tolower(\$2)}')

if echo \"\$os_detectado\" | grep -qi 'windows'; then
    echo 'SO detectado: Windows'
    mkdir -p ../postexploit/privesc/windows
elif echo \"\$os_detectado\" | grep -qi 'linux'; then
    echo 'SO detectado: Linux'
    mkdir -p ../postexploit/privesc/linux
else
    echo 'No se pudo detectar el sistema operativo.'
fi
" C-m

# Ventana de fuzzing
tmux send-keys -t "$sesion:2" "cd enum/web && clear" C-m
tmux send-keys -t "$sesion:2" "ffuf -w /usr/share/wordlists/seclists/Discovery/Web-Content/common.txt -u http://$ip/FUZZ" 

# Ventana de explotación
tmux send-keys -t "$sesion:3" "cd exploit && clear" C-m

# Conectarse a la sesión
tmux attach-session -t "$sesion" \; select-window -t "$sesion":0




















































/usr/share/wordlists/seclists/Discovery/Web-Content/common.txt 