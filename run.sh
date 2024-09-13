#/bin/bash
read -p 'Nombre de la sesion de tmux: ' sesion
read -p "Nombre del CTF: " carpeta
mkdir -p ./$carpeta
cd ./$carpeta
read -p "Ingresa direccion IP: " ip
echo "$ip" >> ip.txt

#Crear una sesion en tmux
tmux new-session -d -s "$sesion"
tmux new-window -t "$sesion:1" -n 'escaner'
tmux new-window -t "$sesion:2" -n 'fuzzing'
tmux new-window -t "$sesion:3" -n 'exploit'


#Enviar comandos necesarios a tmux

#Enviar la variable ip a los paneles abiertos

for ((i=1; i<4 ;i++)); do
	tmux send-keys -t "$sesion:$i" 'ip=$(cat ip.txt) && clear' C-m
done 


tmux send-keys -t "$sesion:0" 'sudo openvpn /home/binyamin/Binyamin.ovpn' C-m
tmux send-keys -t "$sesion:escaner" '
check_tunnel_ip() {
    ip addr show tun0 | grep inet
}

# Bucle while para esperar hasta que se cumpla la condición
while ! check_tunnel_ip; do
   echo "Esperando a que la interfaz tun0 tenga una dirección IP..."
  sleep 5  # Esperar 5 segundos antes de verificar nuevamente
done
ulimit -n 65535
rustscan -b 2250 $ip -- -sV -sC -oN escaner.txt
rm ip.txt
' C-m



#Permite abrir el panel principal de la vpn para poner la contrasena de su
tmux attach-session -t "$sesion:0" 
