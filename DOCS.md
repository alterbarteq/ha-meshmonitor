# MeshMonitor - Home Assistant Add-on

Monitor swojej sieci Meshtastic bezpośrednio z Home Assistant.

Ten add-on uruchamia [MeshMonitor](https://github.com/Yeraze/meshmonitor) — aktywnie rozwijane narzędzie webowe do monitorowania węzłów Meshtastic przez TCP/HTTP.

## Instalacja

1. Dodaj to repozytorium do Home Assistant:
   - Przejdź do **Ustawienia → Add-ony → Sklep z dodatkami**
   - Kliknij menu (⋮) i wybierz **Repozytoria**
   - Dodaj adres tego repozytorium
2. Znajdź **MeshMonitor** i kliknij **Zainstaluj**
3. Skonfiguruj add-on (patrz niżej)
4. Kliknij **Uruchom**

## Konfiguracja

| Opcja | Opis | Domyślnie |
|-------|------|-----------|
| `meshtastic_node_ip` | Adres IP węzła Meshtastic z WiFi/Ethernet | `192.168.1.100` |
| `meshtastic_node_port` | Port TCP węzła (zwykle 4403) | `4403` |
| `admin_password` | Hasło dla konta `admin` (tylko pierwsze uruchomienie) | `changeme` |
| `log_level` | Poziom logowania: debug/info/warn/error | `info` |
| `db_type` | Baza danych: sqlite (zalecane dla HA) | `sqlite` |
| `timezone` | Strefa czasowa | `Europe/Warsaw` |
| `auto_upgrade` | Automatycznie aktualizuj do najnowszej wersji przy starcie | `false` |

## Pierwsze logowanie

Po uruchomieniu przejdź do panelu bocznego → **MeshMonitor** lub otwórz:
```
http://<adres-HA>:8099
```

Domyślne dane logowania:
- Login: `admin`
- Hasło: ustawione w konfiguracji (domyślnie `changeme`)

**Zmień hasło po pierwszym logowaniu!**

## Auto-upgrade

Gdy opcja `auto_upgrade: true` jest włączona, add-on przy każdym starcie:
1. Sprawdza najnowszy commit z gałęzi `main` na GitHubie
2. Jeśli jest nowa wersja — automatycznie aktualizuje kod i przebudowuje

Dzięki temu zawsze masz najnowszą wersję MeshMonitor bez aktualizowania add-ona.

## Dane

Wszystkie dane (baza SQLite, konfiguracja) są przechowywane w:
```
/share/meshmonitor/
```

Pliki są bezpieczne przy aktualizacjach i restartach.

## Wymagania

- Węzeł Meshtastic z włączonym WiFi lub połączeniem Ethernet
- Home Assistant OS lub Supervised
- Minimum 512 MB RAM

## Wsparcie

- Problemy z add-onem: [Issues tego repo]
- Problemy z MeshMonitor: [github.com/Yeraze/meshmonitor/issues](https://github.com/Yeraze/meshmonitor/issues)
- Discord MeshMonitor: [discord.gg/JVR3VBETQE](https://discord.gg/JVR3VBETQE)
