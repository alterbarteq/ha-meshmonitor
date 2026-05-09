# ha-meshmonitor

Home Assistant Add-on uruchamiający [MeshMonitor](https://github.com/Yeraze/meshmonitor) — narzędzie do monitorowania sieci Meshtastic.

## Dlaczego ten add-on?

Istniejący add-on [bhardie/ha-meshmonitor](https://github.com/bhardie/ha-meshmonitor) jest przestarzały.
Ten add-on zawsze uruchamia **najnowszą wersję** z oficjalnego repozytorium Yeraze/meshmonitor.

## Instalacja

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2FTWOJ-USERNAME%2Fha-meshmonitor)

Lub ręcznie:
1. **Ustawienia → Add-ony → Sklep z dodatkami → Menu (⋮) → Repozytoria**
2. Dodaj: `https://github.com/TWOJ-USERNAME/ha-meshmonitor`
3. Zainstaluj **MeshMonitor**

## Struktura

```
ha-meshmonitor/
├── config.yaml                          # Konfiguracja add-ona dla HA Supervisor
├── Dockerfile                           # Buduje środowisko z MeshMonitor
├── DOCS.md                              # Dokumentacja dla użytkowników
└── rootfs/
    ├── etc/
    │   ├── cont-init.d/
    │   │   └── meshmonitor.sh           # Init: czyta opcje HA, tworzy .env
    │   └── services.d/
    │       └── meshmonitor/
    │           ├── run                  # Uruchomienie serwera
    │           └── finish               # Obsługa zatrzymania
```

## Funkcje

- 🔄 **Zawsze aktualna wersja** — klonuje kod bezpośrednio z GitHub przy budowaniu
- ⬆️ **Auto-upgrade** — opcjonalne automatyczne aktualizacje przy starcie
- 🔧 **Konfiguracja przez UI** — wszystkie opcje dostępne w panelu HA
- 📊 **Ingress** — dostęp przez panel boczny HA bez otwierania portów
- 💾 **Trwałe dane** — baza danych i konfiguracja przeżywa aktualizacje
- 🏗️ **Multi-arch** — obsługa amd64, aarch64 (RPi 4/5), armv7 (RPi 3)

## Wymagania

- Węzeł Meshtastic z WiFi lub Ethernet (IP w sieci lokalnej)
- Home Assistant OS lub Supervised
- 512 MB RAM minimum
