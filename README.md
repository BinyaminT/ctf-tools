# 🛡️ CTF Setup Automático con tmux y Nmap

Este script automatiza la creación de un entorno de trabajo para CTFs, ideal para máquinas tipo HackTheBox, TryHackMe, Proving Grounds, etc.

## 🚀 ¿Qué hace?

- Crea una estructura ordenada de directorios para cada CTF.
- Lanza una sesión de `tmux` con:
  - `openvpn` (para conectarse a la red VPN del CTF).
  - escaneo automático con `nmap`.
  - fuzzing con `ffuf`.
  - una ventana para explotación.
- Detecta el sistema operativo del objetivo (Linux o Windows) y crea la carpeta correspondiente.
- Organiza todos los archivos por fase: enum, creds, exploit, privesc, etc.

---

## 📦 Requisitos

Antes de usar este script, asegúrate de tener instalado lo siguiente:

```bash
sudo apt update && sudo apt install -y \
  tmux \
  nmap \
  ffuf \
  openvpn \
  seclists
  ```


También es recomendable clonar SecLists si no está instalada en /usr/share/wordlists/seclists:

```bash
sudo git clone https://github.com/danielmiessler/SecLists.git /usr/share/wordlists/seclists
```

---

## Estructura de directorios del CTF

```
NombreDelCTF/
├── ip.txt
├── writeup.md
├── nmap/
├── enum/
│   ├── web/
│   ├── smb/
│   └── ftp/
├── creds/
├── exploit/
│   ├── scripts/
│   ├── payloads/
│   └── exploits/
├── postexploit/
│   ├── privesc/
│   │   └── linux/ o windows/
│   ├── loot/
│   ├── persistencia/
│   └── datos_extraidos/
└── flags/
```

## ⚙️ Cómo usar el script
Coloca tu archivo .ovpn en tu home con el nombre que tu desees en mi caso es conec.ovp o edita el script para cambiar la ruta o el nombre.

Dale permisos de ejecución al script y corre:

```bash
chmod +x auto-ctf.ss && ./auto-ctf.sh
```
## ▶️ Instrucciones de uso


- 💻 **Ingresa el nombre de la sesión tmux**  
  Esto crea el entorno dividido en ventanas (VPN, escaneo, fuzzing, etc).

- 📁 **Ingresa el nombre del CTF**  
  Se usará como nombre para la carpeta que contendrá toda la estructura.

- 🌐 **Ingresa la IP del objetivo**  
  Es la dirección que se va a escanear automáticamente con `nmap` y usar para `ffuf`.

✅ **El script se encargará del resto.**

