#!/usr/bin/with-contenv bashio

bashio::log.info "Konfigurowanie MeshMonitor (v4.0+)..."

# Wczytaj opcje z Home Assistant
NODE_IP=$(bashio::config 'meshtastic_node_ip')
NODE_PORT=$(bashio::config 'meshtastic_node_port')
ADMIN_PASS=$(bashio::config 'admin_password')
LOG_LEVEL=$(bashio::config 'log_level')
TZ=$(bashio::config 'timezone')
HA_URL=$(bashio::config 'ha_url')
SESSION_SECRET=$(bashio::config 'session_secret')

# Jeśli session_secret jest puste, wygeneruj losowy
if [ -z "${SESSION_SECRET}" ]; then
    SESSION_SECRET=$(cat /proc/sys/kernel/random/uuid | tr -d '-')
    bashio::log.warning "session_secret nie ustawiony — wygenerowano losowy. Przy restarcie sesje wygasną!"
fi

# ALLOWED_ORIGINS: adres przez który użytkownik wchodzi na MeshMonitor
# Musi zawierać adres HA (ingress) oraz bezpośredni port
# Ustawiamy * dla uproszczenia w sieci lokalnej — w produkcji podaj HA_URL
ALLOWED_ORIGINS="${HA_URL},*"

# Utwórz katalog na dane
mkdir -p /data/meshmonitor

# Utwórz plik .env dla MeshMonitor
# UWAGA: MESHTASTIC_NODE_IP bootstrapuje tylko pierwsze źródło przy świeżej instalacji!
# Po pierwszym uruchomieniu zarządzaj źródłami z Dashboard → Sources
cat > /opt/meshmonitor/.env.production << EOF
# Auto-generowany przez HA add-on - nie edytuj ręcznie
# MeshMonitor v4.0+

# Połączenie z węzłem (tylko pierwsze uruchomienie!)
MESHTASTIC_NODE_IP=${NODE_IP}
MESHTASTIC_NODE_PORT=${NODE_PORT}

# Serwer
PORT=3001
HOST=0.0.0.0
NODE_ENV=production

# Dane
DATA_DIR=/data/meshmonitor
DATABASE_URL=file:/data/meshmonitor/meshmonitor.db

# Bezpieczeństwo - CORS (wymagane od v4.0!)
ALLOWED_ORIGINS=${ALLOWED_ORIGINS}
SESSION_SECRET=${SESSION_SECRET}
TRUST_PROXY=true

# Iframe (potrzebne dla panelu bocznego HA)
IFRAME_ALLOWED_ORIGINS=${HA_URL}

# Logowanie
LOG_LEVEL=${LOG_LEVEL}
TZ=${TZ}
EOF

# Ustaw hasło admina tylko przy pierwszym uruchomieniu
if [ ! -f "/data/meshmonitor/.initialized" ]; then
    bashio::log.info "Pierwsze uruchomienie — ustawiam hasło admina..."
    echo "ADMIN_PASSWORD=${ADMIN_PASS}" >> /opt/meshmonitor/.env.production
    touch /data/meshmonitor/.initialized
    bashio::log.info "Pamiętaj: zmień hasło admina po pierwszym logowaniu!"
else
    bashio::log.info "Istniejąca instalacja — pomijam ustawianie hasła admina."
fi

# Opcja auto-upgrade
if bashio::config.true 'auto_upgrade'; then
    bashio::log.info "Auto-upgrade włączony. Sprawdzam aktualizacje..."
    cd /opt/meshmonitor
    git fetch origin main --depth=1
    LOCAL=$(git rev-parse HEAD)
    REMOTE=$(git rev-parse origin/main)
    if [ "$LOCAL" != "$REMOTE" ]; then
        bashio::log.info "Znaleziono aktualizację! Aktualizuję MeshMonitor..."
        git pull origin main --recurse-submodules
        npm ci 2>/dev/null || npm install
        npm run build
        npm run build:server
        bashio::log.info "Aktualizacja zakończona."
    else
        bashio::log.info "MeshMonitor jest aktualny ($(git rev-parse --short HEAD))."
    fi
fi

bashio::log.info "Konfiguracja gotowa. Node: ${NODE_IP}:${NODE_PORT} | Origins: ${ALLOWED_ORIGINS}"
