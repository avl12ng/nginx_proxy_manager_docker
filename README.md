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

The script relies on npm.conf to identify which services to bridge:

- **PROXY_NETWORK**: The name of the shared Docker bridge network.
- **CONTAINERS_TO_LINK**: A list of container names.

Copy the example file to create your own configuration
```bash
cp npm.conf.example npm.conf
```

Edit npm.conf and list your container names in CONTAINERS_TO_LINK
```bash
# --- Nginx Proxy Manager Automator Configuration Template ---

# 1. SHARED NETWORK CONFIGURATION
# This is the bridge network that NPM and your apps will share.
PROXY_NETWORK="nginx-proxy-network"

# 2. TARGET CONTAINERS
# List the names of the containers you want to link to the proxy.
# Use spaces to separate names.
# Example: ("website" "database-admin" "api-service")
CONTAINERS_TO_LINK=(
    "container_name1"
    "container_name2"
)

# 3. DOCKER COMPOSE SETTINGS
# The filename of your Nginx Proxy Manager compose file
COMPOSE_FILE="docker-compose.yml"
```

🔒 SSL Management

If you use externally generated certificates:

- Copy your fullchain.pem and privkey.pem into the ./data/custom_ssl/npm-X folder (where X is your certificate ID in NPM).
- The script executes nginx -s reload within the container to apply updates without dropping active connections.

📜 Credits

This project automates the setup of the excellent Nginx Proxy Manager.

    Credits to Nginx Proxy Manager for the original sources and Docker images.

⚖️ License

This project is open-source and available under the MIT License.
