# Automated Nginx Proxy Manager Deployment

A robust Bash-based automation tool to deploy **Nginx Proxy Manager (NPM)** and seamlessly integrate it with other Docker containers. 

Instead of manually configuring networks for every service, this script handles the infrastructure logic, ensuring your reverse proxy is instantly connected to your target services.

## 🌟 Key Features

- **Idempotent Deployment**: Safe to run multiple times; it only performs necessary updates.
- **Auto-Linking**: Automatically attaches existing or new containers to the shared proxy network.
- **Multi-SSL Management**: Specialized logic to map multiple externally managed SSL certificates to NPM.
- **Persistence**: Configures containers to restart automatically and maintain connectivity after host reboots.
- **Zero-Downtime**: Executes hot-reloads for Nginx when certificates are updated.

---

## 🚀 Quick Start

### 1. Clone the repository
```bash
git clone https://github.com/avl12ng/nginx_proxy_manager_docker.git
cd nginx_proxy_manager_docker
```

### 2. Configure your environment
The deployment is managed via the `npm.conf` file. Create yours from the template:
```bash
cp npm.conf.example npm.conf
```

### 3. Deployment
Make the script executable and run it to deploy the stack and link your containers:
```bash
chmod +x npm_build.sh
./npm_build.sh
```

---

## ⚙️ Configuration (npm.conf)

Open `npm.conf` and adjust the variables to match your environment:

| Variable | Description |
| :--- | :--- |
| **PROXY_NETWORK** | Name of the shared Docker bridge network. |
| **CONTAINERS_TO_LINK** | Array of container names to be connected to the proxy. |
| **HTTP_PORT** | Public HTTP port (default 80). |
| **HTTPS_PORT** | Public HTTPS port (default 443). |
| **ADMIN_PORT** | NPM Admin Dashboard port (default 81). |
| **SSL_ROOT_PATH** | Absolute host path to your central SSL store. |
| **CUSTOM_CERTIFICATES** | Mapping of "NPM_ID:FOLDER_NAME" for SSL. |

### Configuration Example
```bash
# Shared Network
PROXY_NETWORK="nginx-proxy-network"

# Apps to proxy
CONTAINERS_TO_LINK=("container_name1" "container_name2")

# SSL Mapping (NPM_ID:FOLDER_NAME)
SSL_ROOT_PATH="/data/ssl"
CUSTOM_CERTIFICATES=(
    "1:test.org"
    "2:website.domain.org"
)
```
---

## 🔒 SSL Management (External Certificates)

This script automates the mapping of certificates managed outside of NPM (e.g., Certbot or manual).

- Host Structure: Store certificates in `/data/ssl/domain.tld/` containing `fullchain.pem` and `privkey.pem`.
- NPM ID: Create a "Custom Certificate" in the NPM Web UI (Port 81). The first one will be ID 1.
- Symlinks: The script mounts your SSL root in Read-Only mode and creates symbolic links to `/data/custom_ssl/npm-X/` automatically.

---

## 🖥️ Log in to the Admin Panel

URL: `http://<your-server-ip>:81`

Default Credentials:
- Email: admin@example.com
- Password: changeme

---

## 📜 Credits

This project automates the setup of the excellent Nginx Proxy Manager.
- Credits to Nginx Proxy Manager for the original sources and Docker images.

---

## ⚖️ License

This project is open-source and available under the MIT License.
