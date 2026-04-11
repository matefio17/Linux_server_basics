# README

# 🐧 Projekt: Linux Server Basics (Ubuntu Server 22.04) - samodzielna nauka administracji Linux.

## 📋 Spis treści
 
- [Problem](#-problem)
- [Rozwiązanie](#-rozwiązanie)
- [Technologie i narzędzia](#-technologie-i-narzędzia)
- [Struktura projektu](#-struktura-projektu)

## 🎯 Problem
 
Chciałem zdobyć praktyczne doświadczenie z administracją Linux, które można pokazać na rozmowie kwalifikacyjnej. Kursy wideo i tutoriale dawały wiedzę teoretyczną, ale nie uczyły jak reagować gdy coś się psuje. Postanowiłem zbudować projekt który:
 
- wymusza samodzielne rozwiązywanie problemów zamiast kopiowania komend,
- symuluje realne scenariusze z pracy helpdesk (usługa nie działa, brak uprawnień, pełny dysk),
- kończy się udokumentowanym portfolio

## ✅ Rozwiązanie
 
Postawiłem własny serwer Ubuntu Server 22.04 LTS w VirtualBox

## 🛠️ Technologie i narzędzia
 
| Kategoria | Narzędzie | Do czego użyte |
|-----------|-----------|----------------|
| System | Ubuntu Server 22.04 LTS | System operacyjny serwera |
| Wirtualizacja | VirtualBox | Środowisko uruchomieniowe |
| Dostęp zdalny | OpenSSH | Zarządzanie serwerem z laptopa |
| Serwer WWW | Nginx | Serwowanie strony HTML |
| Firewall | UFW (iptables) | Ograniczenie ruchu sieciowego |
| Zarządzanie usługami | systemd | Kontrola i monitoring usług |
| Automatyzacja | crontab | Zadania cykliczne |
| Bezpieczeństwo | fail2ban | Ochrona przed brute-force |
| Dokumentacja | Git + GitHub | Kontrola wersji i portfolio |
 
---
 
## 📁 Struktura projektu
 
```
.
├── README.md                    # Ten plik
├── .gitignore                   # Wykluczenia (klucze prywatne, logi)
├── configs/
│   ├── nginx.conf               # Konfiguracja serwera WWW
│   ├── sshd_config              # Konfiguracja serwera SSH (oczyszczona)
│   └── ufw_rules.txt            # Zrzut aktywnych reguł firewalla
├── scripts/
│   ├── log_date.sh              # Skrypt uruchamiany przez crontab
│   └── setup_user.sh            # Skrypt dodający użytkownika z sudo
├── docs/
│   ├── troubleshooting.md       # Udokumentowane scenariusze helpdesk
│   ├── cheatsheet.md            # Komendy pogrupowane tematycznie
│   └── screenshots/
│       ├── htop-zasoby.png
│       ├── ssh-bez-hasla.png
│       ├── nginx-strona-glowna.png
│       ├── nginx-wlasna-strona.png
│       ├── ufw-status.png
│       ├── ls-uprawnienia.png
│       ├── ssh-hardening-blad-hasla.png
│       ├── scenariusz-nginx-stopped.png
│       ├── scenariusz-nginx-naprawiony.png
│       ├── scenariusz-403-blad.png
│       ├── scenariusz-403-naprawiony.png
│       ├── ssh-timeout.png
│       └── ssh-refused.png
└── LICENSE
```

---

## 📅 Tydzień 1 – Fundamenty i SSH
 
**Cel:** Postawić serwer i zarządzać nim zdalnie bez wpisywania hasła.

Dzień 1 – Maszyna wirtualna
Zainstalowałem VirtualBox i stworzyłem maszynę wirtualną z Ubuntu Server 22.04 LTS. Wybrałem tryb sieci Bridged żeby serwer był widoczny w sieci domowej jako osobne urządzenie z własnym adresem IP.

> [docs/screenshots/htop-zasoby.png](docs/screenshots/htop-zasoby.png)

Świeżo uruchomiony serwer zużywa blisko 200 MB RAM — reszta dostępna dla usług

Czego się nauczyłem: 

- Dlaczego do mojego projektu lepszy będzie tryb Bridged, który daje serwerowi własny adres IP zamiast domyślnego dla VirtualBox NAT, który chowa adres IP maszyny za adresem komputera.

  

Dzień 2 – Instalacja i zabezpieczenie fundamentów

Finalizacja instalacji i pierwsze logowanie – system jest "czysty", ale wymaga aktualizacji i konfiguracji uprawnień.

Czego się nauczyłem:

- Zarządzanie pakietami (APT): Poznałem różnicę między `sudo apt update`(pobieranie list pakietów z serwera) a `sudo apt upgrade` (instalacja najnowszych wersji zainstalowanych programów wraz z łatkami bezpieczeństwa)

- Bezpieczeństwo uprawnień (sudo vs root): Warto unikać administracji systemem z poziomu konta root. Root może wszystko wię bardzo łatwo coś zepsuć.



Dzień 3 - Pierwsze połączenie SSH

Skonfigurowałem połączenie między moim komputerem (klientem) a maszyną wirtualną (serwerem), co jest kluczowym krokiem w pracy administratora – w realnych warunkach serwery rzadko posiadają podpięty monitor.

> [docs/screenshots/ssh-bez-hasla.png](docs/screenshots/ssh-bez-hasla.png)

Poprawne zalogowanie przez SSH: widoczny komunikat o dodaniu hosta do listy zaufanych oraz wynik komend weryfikujących tożsamość serwera.

Czego się nauczyłem:

- SSH dzięki silnemu szyfrowaniu zapewnia bezpieczne połączenie, które nawet gdy zostanie przechwycone nie będzie możliwe do odczytania

- Ustaliłem adres IP serwera (10.65.0.57). Tryb bridge w maszynie wirtualnej zapewniił to, że mój serwer prosi DHCP w sieci o przydzielenie konfiguracji sieciowej tak samo jak robią to inne urządzenia.

- Przy pierwszym logowaniu zatwierdziłem fingerprint serwera. Jest to unikalny ciąg znaków, który umożliwia identyfikację serwera. Taki mechanizm przydaje się przy zapomieganiu atakom MITM, gdy ktoś podszywa się pod serwer.

- Rozróżniam klienta SSH (mój komputer) od serwera SSH (usługa w moim serwerze z którą się łączę)



## 📅 Tydzień 2 – Nginx, Użytkownicy i Firewall
 
**Cel:** Serwer serwuje stronę WWW, dostęp ograniczony firewallem.



## 📅 Tydzień 3 – Scenariusze Helpdesk
 
**Cel:** Symulacja realnych problemów — metodyczne diagnozowanie i naprawianie.
 
> Pełna dokumentacja wszystkich scenariuszy: [docs/troubleshooting.md](docs/troubleshooting.md)


## 🔄 Co zrobiłbym inaczej


## 🚀 Wnioski i co dalej


## 📚 Zasoby które były pomocne


## **👨‍💻** Autor

---

**Mateusz Markiewicz -** Projekt zrealizowany w ramach praktycznej nauki i stanowi część portfolio
