ARG BUILD_FROM
FROM $BUILD_FROM

# Zainstaluj Node.js 20, git i narzędzia
RUN apk add --no-cache \
    nodejs \
    npm \
    git \
    curl \
    bash \
    sqlite \
    jq \
    tzdata

# Sklonuj MeshMonitor (zawsze najnowszy main)
WORKDIR /opt
RUN git clone --recurse-submodules --depth=1 https://github.com/Yeraze/meshmonitor.git meshmonitor

WORKDIR /opt/meshmonitor

# Zainstaluj zależności i zbuduj
RUN npm ci --prefer-offline 2>/dev/null || npm install
RUN npm run build
RUN npm run build:server

# Utwórz katalog na dane
RUN mkdir -p /data/meshmonitor

# Skopiuj skrypty startowe
COPY rootfs /

RUN chmod +x /etc/cont-init.d/meshmonitor.sh
RUN chmod +x /etc/services.d/meshmonitor/run
RUN chmod +x /etc/services.d/meshmonitor/finish

# Domyślny port
EXPOSE 3001

VOLUME ["/data/meshmonitor"]
