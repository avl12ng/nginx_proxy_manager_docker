# Automated Nginx Proxy Manager Deployment

A robust Bash-based automation tool to deploy **Nginx Proxy Manager (NPM)** and seamlessly integrate it with other Docker containers. 

Instead of manually configuring networks for every service, this script handles the infrastructure logic, ensuring your reverse proxy is instantly connected to your target services.

## 🌟 Key Features

- **Idempotent Deployment**: Safe to run multiple times; it only performs necessary updates.
- **Auto-Linking**: Automatically attaches existing or new containers to the shared proxy network.
- **Persistence**: Configures containers to restart automatically and maintain connectivity after host reboots.
- **External SSL Support**: Optimized for users who manage their own certificates (custom import) with zero-downtime reloads.

## 🚀 Quick Start

### 1. Clone the repository
```bash
git clone https://github.com/avl12ng/nginx_proxy_manager_docker.git
cd nginx_proxy_manager_docker
```

### 2. Configure your environment

Copy the template and list your running container names in the CONTAINERS_TO_LINK array:
```bash
chmod +x npm_build.sh
./npm_build.sh
```

⚙️ Configuration (npm.conf)

The deployment is managed via the npm.conf file. This file centralizes your network settings, container links, and host port mappings.

Setup your configuration file

First, create your local configuration by copying the provided template:
```bash
cp npm.conf.example npm.conf
```
Define your variables

Open `npm.conf` and adjust the following parameters to match your environment:
```bash
# 1. SHARED NETWORK CONFIGURATION
PROXY_NETWORK="nginx-proxy-network"

# 2. TARGET CONTAINERS
CONTAINERS_TO_LINK=(
    "container_name1"
    "container_name2"
)

# 3. HOST PORT SETTINGS
HTTP_PORT=80
HTTPS_PORT=443
ADMIN_PORT=81

# 4. CUSTOM SSL CONFIGURATION
SSL_CERT_PATH="/data/ssl/domain.org"

# 5. DOCKER COMPOSE SETTINGS
COMPOSE_FILE="docker-compose.yml"
```
| Variable | Description |
| :--- | :--- |
| **PROXY_NETWORK** | The name of the shared Docker bridge network for the proxy. |
| **CONTAINERS_TO_LINK** | Array of container names to be automatically connected to the proxy. |
| **HTTP/HTTPS_PORT** | Public ports exposed on your host (defaults to 80/443). |
| **ADMIN_PORT** | The port used to access the NPM Web Dashboard (default 81). |
| **SSL_CERT_PATH** | Absolute host path to your SSL folder (must contain `fullchain.pem` & `privkey.pem`). |

### 3. Deployment

Deploy the NPM container
```bash
chmod +x npm_build.sh
./npm_build.sh
```

### 4. Log in to the Admin

When your docker container is running, connect to it on port 81 for the admin interface. Sometimes this can take a little bit because of the entropy of keys.
```plaintext
http://127.0.0.1:81
```

### 5. SSL Management

🔒 If you use externally generated certificates:

- Copy your fullchain.pem and privkey.pem into the ./data/custom_ssl/npm-X folder (where X is your certificate ID in NPM).
- The script executes nginx -s reload within the container to apply updates without dropping active connections.

### 6. Credits

This project automates the setup of the excellent Nginx Proxy Manager.

📜 Credits to Nginx Proxy Manager for the original sources and Docker images.

### 7. License

⚖️ This project is open-source and available under the MIT License.
