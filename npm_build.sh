#!/bin/bash
# =================================================================
# Automated NPM Deployment Script
# Credits to https://github.com/NginxProxyManager for sources
# =================================================================

# 1. Load configuration
if [ -f ./npm.conf ]; then
    source ./npm.conf
else
    echo "ERROR: npm.conf not found! Please create it from npm.conf.example."
    exit 1
fi

echo "--- Generating Environment File (.env) ---"
# Create the .env file for Docker Compose injection
cat <<EOF > .env
PROXY_NETWORK=$PROXY_NETWORK
HTTP_PORT=$HTTP_PORT
HTTPS_PORT=$HTTPS_PORT
ADMIN_PORT=$ADMIN_PORT
SSL_ROOT_PATH=$SSL_ROOT_PATH
EOF

echo "--- Starting NPM Deployment ---"

# 2. Network Management
if ! docker network ls | grep -q "$PROXY_NETWORK"; then
    echo "[*] Creating network: $PROXY_NETWORK"
    docker network create "$PROXY_NETWORK"
else
    echo "[#] Network $PROXY_NETWORK already exists."
fi

# 3. NPM Stack Update
if ! docker compose -f "$COMPOSE_FILE" up -d; then
    echo "ERROR: Failed to start NPM. Check for port conflicts."
    exit 1
fi

echo "--- Syncing Custom SSL Certificates ---"

# 4. Symbolic Links Logic for Multiple Certs
# This links your host folders to NPM's internal structure
for entry in "${CUSTOM_CERTIFICATES[@]}"; do
    # Extract ID and Folder from "ID:FOLDER" format
    NPM_ID="${entry%%:*}"
    DOMAIN_DIR="${entry#*:}"
    
    # Path inside the local data folder (mounted in NPM)
    TARGET_DIR="./data/custom_ssl/npm-$NPM_ID"
    
    echo "[*] Linking NPM ID $NPM_ID to folder $DOMAIN_DIR"
    
    # Create target directory if missing
    mkdir -p "$TARGET_DIR"
    
    # Create symbolic links to the files inside the container's mount point
    # We use relative paths or absolute paths matching the container's internal view
    ln -sf "/data/external_certs/$DOMAIN_DIR/fullchain.pem" "$TARGET_DIR/fullchain.pem"
    ln -sf "/data/external_certs/$DOMAIN_DIR/privkey.pem" "$TARGET_DIR/privkey.pem"
done

# Reload Nginx to apply new certificate links
docker exec nginx-proxy-manager nginx -s reload

# 5. Connectivity Helper
connect_container() {
    local name=$1
    if [ "$(docker ps -q -f name=^/${name}$)" ]; then
        if ! docker inspect "$name" --format '{{json .NetworkSettings.Networks}}' | grep -q "$PROXY_NETWORK"; then
            echo "[+] Connecting $name to $PROXY_NETWORK..."
            docker network connect "$PROXY_NETWORK" "$name"
        else
            echo "[#] $name is already connected."
        fi
    fi
}

# 6. Process containers
echo "[*] Verifying container connections..."
for container in "${CONTAINERS_TO_LINK[@]}"; do
    connect_container "$container"
done

echo "--- Deployment Finished Successfully ---"
