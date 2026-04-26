# README

# 🐧 Projekt: Linux Server Basics (Ubuntu Server 22.04) - samodzielna nauka administracji Linux.


## 🚀 TL;DR

Projekt przedstawia konfigurację i utrzymanie serwera Linux (Ubuntu 22.04) w środowisku labowym.

Zakres:
- SSH (klucze, hardening)
- Nginx (deployment + troubleshooting)
- UFW (firewall + security)
- systemd (zarządzanie usługami)
- Cron (automatyzacja)
- realne scenariusze awarii (SSH, 403, nginx fail)

Projekt skupia się na DIAGNOSTYCE i ROZWIĄZYWANIU problemów.


## 🧠 Wykazane umiejętności
- Administracja systemami Linux (Ubuntu Server)
- Podstawy sieci komputerowych (DHCP, adresacja IP, porty, SSH)
- Zarządzanie usługami (systemd)
- Konfiguracja serwerów WWW (Nginx)
- Konfiguracja zapory sieciowej (UFW)
- Rozwiązywanie problemów i analiza logów (Troubleshooting)
- Zarządzanie użytkownikami i uprawnieniami
- Skryptowanie w Bashu i automatyzacja (cron)


## 🏗️ Architektura

```mermaid
graph TD

    A[Laptop (SSH Client)]
    B[Router TP-Link TL-WR844N]
    C[Ubuntu Server 22.04 (VirtualBox VM)]

    A -->|SSH (port 22)| B
    B -->|LAN 192.168.0.0/24| C

    subgraph Server Services
        D[OpenSSH]
        E[Nginx (port 80)]
        F[UFW Firewall]
        G[systemd]
        H[Cron Jobs]
    end

    C --> D
    C --> E
    C --> F
    C --> G
    C --> H

    E -->|serves| I[HTML Page]
```



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
| DHCP Reservation | Router TP-Link TL-WR844N | Stały adres IP serwera |
| Serwer WWW | Nginx | Serwowanie strony HTML |
| Firewall | UFW (iptables) | Ograniczenie ruchu sieciowego |
| Zarządzanie usługami | systemd | Kontrola i monitoring usług |
| Automatyzacja | crontab | Zadania cykliczne |
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
│   └── log_date.sh              # Skrypt uruchamiany przez crontab
├── docs/
│   ├── troubleshooting.md       # Udokumentowane scenariusze helpdesk
│   └── screenshots/
│       ├── htop-zasoby.png
│       ├── ssh.png
│       ├── ssh-bez-hasla.png
│       ├── dhcp-reservation.png
│       ├── nginx-strona-glowna.png
│       ├── nginx-wlasna-strona-logi.png
│       ├── user-sudo-rules
│       ├── ufw-status.png
│       ├── ls-uprawnienia.png
│       ├── dzialanie-skryptu.png
│       ├── scenariusz-nginx-stopped.png
│       ├── scenariusz-nginx-naprawiony.png
│       ├── scenariusz-403-blad.png
│       ├── scenariusz-403-naprawiony.png
│       ├── scenariusz-ssh-timeout.png
│       ├── scenariusz-ssh-timeout-naprawiony.png
│       ├── scenariusz-ssh-refused.png
│       └── scenariusz-ssh-refused-naprawiony.png
└── LICENSE
```

---

## 📅 Etap 1 – Fundamenty i SSH
 
**Cel:** Postawić serwer i zarządzać nim zdalnie bez wpisywania hasła.

Dzień 1 – Maszyna wirtualna
Zainstalowałem VirtualBox i stworzyłem maszynę wirtualną z Ubuntu Server 22.04 LTS. Wybrałem tryb sieci Bridged żeby serwer był widoczny w sieci domowej jako osobne urządzenie z własnym adresem IP.

> [docs/screenshots/htop-zasoby.png](docs/screenshots/htop-zasoby.png)

Świeżo uruchomiony serwer zużywa blisko 200 MB RAM — reszta dostępna dla usług

Czego się nauczyłem: 

- Dlaczego do mojego projektu lepszy będzie tryb Bridged, który daje serwerowi własny adres IP zamiast domyślnego dla VirtualBox NAT, który chowa adres IP maszyny za adresem komputera.

---

Dzień 2 – Instalacja i zabezpieczenie fundamentów

Finalizacja instalacji i pierwsze logowanie – system jest "czysty", ale wymaga aktualizacji i konfiguracji uprawnień.

Czego się nauczyłem:

- Zarządzanie pakietami (APT): Poznałem różnicę między `sudo apt update`(pobieranie list pakietów z serwera) a `sudo apt upgrade` (instalacja najnowszych wersji zainstalowanych programów wraz z łatkami bezpieczeństwa)

- Bezpieczeństwo uprawnień (sudo vs root): Warto unikać administracji systemem z poziomu konta root. Root może wszystko więc bardzo łatwo coś zepsuć. Warto wspomnieć także, że korzystając z konta root w logach nie będzie widać kto dokonał zmiany lub użył danej komendy - w przeciwieństwie do sudo.

---

Dzień 3 - Pierwsze połączenie SSH

Skonfigurowałem połączenie między moim komputerem (klientem) a maszyną wirtualną (serwerem), co jest kluczowym krokiem w pracy administratora – w realnych warunkach serwery rzadko posiadają podpięty monitor.

> [docs/screenshots/ssh.png](docs/screenshots/ssh.png)

Poprawne zalogowanie przez SSH: widoczny komunikat o dodaniu hosta do listy zaufanych oraz wynik komend weryfikujących tożsamość serwera.

Czego się nauczyłem:

- SSH dzięki silnemu szyfrowaniu zapewnia bezpieczne połączenie, które nawet gdy zostanie przechwycone nie będzie możliwe do odczytania

- Ustaliłem adres IP serwera (10.65.0.57). Tryb bridge w maszynie wirtualnej zapewnił to, że mój serwer prosi DHCP w sieci o przydzielenie konfiguracji sieciowej tak samo jak robią to inne urządzenia.

- Przy pierwszym logowaniu zatwierdziłem fingerprint serwera. Jest to unikalny ciąg znaków, który umożliwia identyfikację serwera. Taki mechanizm przydaje się przy zapobieganiu atakom MITM, gdy ktoś podszywa się pod serwer.

- Rozróżniam klienta SSH (mój komputer) od serwera SSH (usługa w moim serwerze z którą się łączę)

---

Dzień 4 - Klucze SSH - Logowanie bez hasła

Dzisiejszym celem było wyeliminowanie konieczności wpisywania hasła przy każdym logowaniu oraz zwiększenie bezpieczeństwa serwera poprzez wykorzystanie pary kluczy SSH.

> [docs/screenshots/ssh-bez-hasla.png](docs/screenshots/ssh-bez-hasla.png)

Logowanie bez hasła: Serwer automatycznie rozpoznaje mój klucz prywatny i wpuszcza mnie do systemu w ułamku sekundy. 

Użyłem komendy `ssh-keygen -t ed25519`. Wybrałem algorytm ed25519 ze względu na jego wydajność i bezpieczeństwo. Upewniłem się, że klucze są w `~/.ssh/`.

⚠️ Początkowo wygenerowałem klucze już po zalogowaniu na serwer. Szybko zorientowałem się, że to błąd, ponieważ klucz prywatny musi pozostać na maszynie klienckiej. Poprawiłem architekturę dostępu, generując nową parę lokalnie i usunąłem klucze z serwera.

⚠️ Podczas próby kopiowania klucza publicznego na serwer napotkałem na problem - komenda `ssh-copy-id` nie jest natywnie dostępne w PowerShell'u z którego korzystam na maszynie klienckiej. Wobec powyższego zdecydowałem się skopiować go ręcznie wykorzystując program `nano`. Szczegóły:

> [docs/troubleshooting.md](docs/troubleshooting.md)

⚠️ Po skopiowaniu klucza zauważyłem, że nadal muszę wpisać hasło aby się zalogować. Przyczyną było błędne skopiowanie klucza publicznego - skopiowałem jedynie ciąg kodujący bez typu klucza i komentarza. Pominiecie tych danych powoduje, że usługa SSH nie rozpoznaje formatu i odrzuca próbę uwierzytelnienia.

⚠️ Logistyczny "Bug": Problem z DHCP

Zanim przeszedłem do konfiguracji kluczy, napotkałem istotną przeszkodę architektoniczną. W sieci akademickiej nie mam możliwości ustawienia statycznej rezerwacji adresu IP (DHCP Reservation).

- Problem: Każde uruchomienie serwera może skutkować przypisaniem innego adresu IP przez router akademika.

- Tymczasowe rozwiązanie: Dopóki nie przyjdzie mój własny router (który stworzy izolowany LAN), muszę każdorazowo sprawdzać IP komendą `ip a` i aktualizować komendę połączenia.

- Docelowe rozwiązanie: Własny router pozwoli mi na stałe powiązać MAC adres serwera z adresem IP, co ustabilizuje środowisko pracy.


Szczegółowe rozwiązanie tego problemu wraz z konfiguracją routera opiszę w:

> [docs/troubleshooting.md](docs/troubleshooting.md)


Czego się nauczyłem:

- Kryptografia asymetryczna: Mechanizm oparty na dwóch matematycznie powiązanych elementach. Klucz publiczny (kłódka) zostaje na serwerze, a prywatny (klucz) nigdy nie opuszcza komputera.

- Generowanie kluczy: Użyłem ssh-keygen. Klucze muszą powstać na komputerze, z którego się łączę (kliencie), aby prywatny element pary nigdy nie był przesyłany przez sieć.

- Transfer klucza: Z powodu problemów z `ssh-copy-id`, ręcznie skopiowałem klucz przy pomocy `nano`. Dzięki temu nauczyłem się z czego składa się taki klucz i że sama treść kryptograficzna to tylko jego część. 

- Bezpieczeństwo plików: Dowiedziałem się, że folder .ssh i plik authorized_keys muszą mieć restrykcyjne uprawnienia (600 - rw), inaczej serwer ze względów bezpieczeństwa zignoruje klucz. 

- Zapobieganie atakom brute-force: Przy pomocy `nano` wyłączyłem uwierzytelnianie hasłem w `/etc/ssh/sshd_config`. Nieużywanie hasła znacząco ogranicza zakres ataków takich jak brute-force.

  ---

Dzień 5 - DHCP Reservation - Rozwiązanie problemu z brakiem stałego adresu IP serwera

Dzisiejszym celem było skonfigurowanie urządzenia brzegowego (router TP-Link TL-WR844N), tak aby serwer otrzymywał stałą dzierżawę adresu `192.168.0.105` oraz aby odizolować serwer od niezarządzalnej sieci akademickiej. 

[docs/screenshots/dhcp-reservation.png](docs/screenshots/dhcp-reservation.png)

Dodatkowo postanowiłem, że zarówno serwer jak i maszyna kliencka będą połączone z TL-WR844N, dzięki czemu uzyskam bezpieczne odizolowane środowisko testowe.

Gdy problem został rozwiązany, postanowiłem dodatkowo oczyścić plik `~/.ssh/known_hosts` z nieaktualnej zawartości. 

Czego się nauczyłem:

- Konflikty DHCP: Doświadczyłem w praktyce, że zmiana konfiguracji DHCP po stronie routera wymaga odświeżenia dzierżawy co najszybciej osiągnąłem poprzez reboot serwera. Przekonałem się o tym gdy mimo ustawienia dzierżawy nie mogłem ustanowić połączenia przez SSH.

- Zarządzanie plikiem `known_hosts`: Dowiedziałem się, że czyszczenie nieaktualnych wpisów tożsamości serwerów to dobra praktyka pozwalająca utrzymać higienę pracy gdy serwer zmienia swoją konfigurację sieciową.

**🏁Podsmumowanie Etapu 1:**


 - Wirtualizacja: Poprawna konfiguracja VM w trybie Bridged Adapter.

 - Zarządzanie pakietami: Umiejętność bezpiecznej aktualizacji systemu (update vs upgrade).

 - Sieć: Stabilizacja środowiska przez DHCP Reservation na routerze fizycznym.

 - Dostęp zdalny: Konfiguracja OpenSSH z kluczami ED25519.
	
 - Hardening: Wyłączenie logowania hasłem i zabezpieczenie plików .ssh (chmod 600).

 - Troubleshooting: Rozwiązywanie problemów z fingerprintami (known_hosts) i formatowaniem kluczy.
---

## 📅 Etap 2 – Nginx, Użytkownicy i Firewall
 
**Cel:** Serwer serwuje stronę WWW, dostęp ograniczony firewallem.

Mając stabilne połączenie i stałe IP, przechodzę do Etapu 2: Web Server (Nginx) oraz zabezpieczenie brzegu sieci (UFW).


Dzień 6 - Nginx i zarządzanie usługami przez `systemd`

Dzisiaj skupiłem się na uruchomieniu pierwszej usługi serwerowej. Moim zadaniem było sprawienie, by serwer zaczął odpowiadać na zapytania HTTP.

>[docs/screenshots/nginx-strona-glowna.png](docs/screenshots/nginx-strona-glowna.png)


Czego się nauczyłem:

- Instalacja: Do instalacji usługi użyłem komendy `sudo apt install nginx`. Następnie z wykorzystaniem `htop` zweryfikowałem, że procesy nginx master oraz nginx worker działają. Finalnie z wykorzystaniem przeglądarki przeszedłem pod adres http://192.168.0.105 gdzie wyświetliła mi się wiadomość o poprawnej instalacji usługi. 

- Weryfikacja: Aby dodatkowo sprawdzić czy usługa funkcjonuje zgodnie z oczekiwaniami użyłem komendy `sudo systemctl status nginx`. Znalazłem tam informacje o usłudze takie jak pełne drzewko procesów. Dowiedziałem się także, że status active oznacza że usługa działa w tym momencie natomiast status enabled oznacza, że usługa jest ustawiona na autostart. Dodatkowo zweryfikowałem to komendą `sudo systemctl is-enabled nginx`.  

- Porty i nasłuchiwanie: Dowiedziałem się, że Nginx domyślnie działa na porcie 80, co dodatkowo sprawdziłem poleceniem `sudo lsof -i | grep nginx`. Dzięki temu zweryfikowałem wszystkie połączenia sieciowe związane ze sformułowaniem `nginx`

- Logi `/var/log/nginx/` - Dowiedziałem się, że Nginx generuje dwa rodzaje logów - `access.log` - czyli szczegółowe informacje o wszystkich zapytaniach HTTP, oraz `error.log` - przydatne w troubleshootingu.

- Architektura Nginx: Odnalazłem kod strony powitalnej w `/var/www/html/index.nginx-debian.html`. Jest to plik, który będę edytować w kolejnych krokach aby zmienić wygląd strony.

---

Dzień 7 – Zarządzanie treścią, Systemd Deep Dive i Logi LIVE


Po instalacji Nginxa przeszedłem do pełnej kontroli nad serwowaną treścią i diagnostyką usługi. Skonfigurowałem własny "Document Root", spersonalizowałem stronę główną i nauczyłem się monitorować ruch sieciowy w czasie rzeczywistym.


>[docs/screenshots/nginx-wlasna-strona-logi.png](docs/screenshots/nginx-wlasna-strona-logi.png)

Weryfikacja: Po lewej spersonalizowana strona index.html. Po prawej monitoring logów dostępu (access.log) na żywo. Widoczna korelacja między odświeżeniem strony a nowymi wpisami (statusy 200, 304 oraz ślad po błędzie 403 z testów).




Kluczowe osiągnięcia:

- Personalizacja CLI: Wykorzystałem edytor nano do modyfikacji pliku `/var/www/html/index.nginx-debian.html`. Zrozumiałem, dlaczego niezbędne są uprawnienia sudo (właścicielem katalogu jest root).

- Analiza cyklu życia usługi: Przetestowałem różnicę między restart a reload oraz sprawdziłem mechanizm autostartu poprzez disable/enable.

- Monitoring: Zamieniłem podstawowe komendy na bardziej profesjonalne narzędzia: `ss -tln` do audytu portów oraz `journalctl` do logów systemowych.



Czego się nauczyłem:

- Document Root: To katalog, z którego Nginx serwuje pliki. Domyślnie /var/www/html/. Brak pliku indeksu skutkuje błędem 403 Forbidden (brak uprawnień do listowania zawartości folderu).

- Mechanizm Cache: Doświadczyłem sytuacji, w której zmiany w HTML nie były widoczne mimo poprawnej edycji. Diagnoza: pamięć podręczna przeglądarki (klienta), a nie błąd serwera.


Interpretacja Logów: Nauczyłem się czytać strukturę access.log. Rozróżniam statusy:

- 200: OK – plik wysłany poprawnie.

- 304: Not Modified – przeglądarka użyła własnej kopii (cache).

- 404: Not Found – brakujący plik (np. favicon.ico).

- 403: Forbidden – próba dostępu do folderu bez pliku index.



Komendy użyte w tym etapie:

`sudo nano /var/www/html/index.nginx-debian.html` – edycja treści strony.

`sudo systemctl reload nginx` – przeładowanie konfiguracji bez przerywania połączeń.

`ss -tln | grep :80` – sprawdzenie, czy serwer nasłuchuje na porcie HTTP.

`tail -f -n 5 /var/log/nginx/access.log` – śledzenie ruchu na serwerze w czasie rzeczywistym (5 najnowszych linijek pliku).

`journalctl -u nginx --since "5 minutes ago"` – szybka diagnostyka ostatnich zdarzeń usługi.




Napotkane problemy i rozwiązania:

- Problem: Brak widocznych zmian po edycji HTML.

Rozwiązanie: Wyczyszczenie pamięci podręcznej przeglądarki (cache) lub otwarcie strony w trybie incognito.

- Problem: Błąd 403 po zmianie nazwy pliku na .bak.

Rozwiązanie: Nginx nie znalazł pliku zdefiniowanego w index i zablokował próbę wyświetlenia listy plików w katalogu ze względów bezpieczeństwa.


---

Dzień 8 – Architektura użytkowników i bezpieczeństwo haseł


Zgłębiłem mechanizmy zarządzania użytkownikami i grupami w systemie Linux. Zrozumiałem proces uwierzytelniania, strukturę przechowywania haseł oraz różnice w implementacji narzędzi do tworzenia kont.

Kluczowe osiągnięcia:

- Analiza plików systemowych: Rozbiłem strukturę `/etc/passwd` oraz `/etc/shadow`. Zidentyfikowałem użyte algorytmy hashowania: `$6$` (SHA-512) dla starszych kont oraz $y$ (yescrypt) dla nowo tworzonych.

- Troubleshooting logowania: Przeprowadziłem symulację blokady konta poprzez zmianę shella na `/bin/false`. Przeanalizowałem logi systemowe (`journalctl`), co pozwoliło mi zaobserwować natychmiastowe zamykanie sesji po udanym uwierzytelnieniu.

- Polityka haseł: Wykorzystałem narzędzie `chage` do wymuszenia zmiany hasła przy następnym logowaniu (ustawienie daty ostatniej zmiany na dzień 0).

- Zarządzanie grupami: Stworzyłem nową strukturę grup (`groupadd`) i przydzieliłem uprawnienia administracyjne (`sudoers`) poprzez modyfikację przynależności do grup dodatkowych.

Czego się nauczyłem:

- `adduser` vs `useradd`: Dowiedziałem się, że `adduser` to skrypt (wrapper), który automatyzuje tworzenie katalogów domowych i kopiowanie plików z `/etc/skel`. `useradd` to narzędzie niskopoziomowe, które bez dodatkowych flag tworzy "suche" konto bez środowiska pracy.

Kontekst sesji (`su -`): Zrozumiałem, że flaga - w poleceniu su jest krytyczna dla ładowania zmiennych środowiskowych (PATH, HOME). Bez niej użytkownik pracuje w "pożyczonym" kontekście, co może powodować błędy w działaniu skryptów i programów.


Najważniejsze komendy:

- `sudo adduser <user>` – interaktywne tworzenie kompletnego konta.

- `sudo chage -d 0 <user>` – wymuszenie natychmiastowej zmiany hasła.

- `sudo usermod -aG sudo <user>` – dodawanie użytkownika do grupy uprawnień administracyjnych (append to group).

- `su - <user>` – przełączanie na użytkownika z pełnym ładowaniem jego profilu.

---

Dzień 9 – Eskalacja uprawnień i zasada Least Privilege



Opis:
Skoncentrowałem się na bezpieczeństwie dostępu do zasobów systemowych. Przeszedłem od ogólnego nadawania uprawnień administracyjnych do precyzyjnego zarządzania dostępem za pomocą mechanizmu `sudoers`.

Kluczowe osiągnięcia:

- Granularne Sudo: Skonfigurowałem precyzyjną regułę w `visudo`, ograniczając uprawnienia użytkownika jankowalski wyłącznie do restartu usługi Nginx bez konieczności podawania hasła (NOPASSWD).

>[docs/screenshots/user-sudo-rules.png](docs/screenshots/user-sudo-rules.png)

- Analiza hierarchii uprawnień: Zdiagnozowałem konflikt, w którym przynależność do grupy `%sudo` nadpisywała moje restrykcyjne reguły. Rozwiązałem to poprzez zmianę logiki przyznawania uprawnień – rezygnację z grup na rzecz jawnych wpisów dla użytkowników.

- Badanie składni `visudo`: Zrozumiałem strukturę wpisu Użytkownik HOST=(Jako_Kto:Jako_Grupa) Komenda. Dowiedziałem się, jak kluczowe jest podawanie pełnych ścieżek do binariów (ustalonych za pomocą `whereis`).

Czego się nauczyłem:

- Zasada Najmniejszych Uprawnień: Zrozumiałem, że w profesjonalnym środowisku nie nadaje się pełnego roota każdemu pracownikowi. Każdy powinien mieć tylko tyle mocy, ile wymaga jego rola (np. Junior Dev tylko do restartu serwera).

- Bezpieczeństwo edycji (visudo): Poznałem narzędzie `visudo`, które chroni przed zapisaniem błędnej składni w pliku `/etc/sudoers`. Błąd w tym pliku mógłby trwale zablokować dostęp administracyjny do serwera.

- Logika "Top-to-Bottom": Plik `sudoers` jest czytany od góry do dołu, co oznacza, że reguły umieszczone niżej mogą nadpisać te wcześniejsze.

Najważniejsze komendy:

`sudo visudo` – bezpieczne narzędzie do edycji uprawnień sudo.

`whereis systemctl` – lokalizacja ścieżki do pliku wykonywalnego.

`sudo usermod -aG sudo <user>` – dodanie do grupy (append).

---

Dzień 10 – Chirurgia uprawnień rwx i własność plików (Ownership)

Opis:
Przeszedłem do praktycznego zarządzania dostępem do plików i katalogów. Zrozumiałem, jak system operacyjny decyduje o tym, kto może czytać, edytować lub uruchamiać dane zasoby, oraz jak te uprawnienia korelują z usługami takimi jak Nginx.


> [docs/screenshots/ls-uprawnienia.png](docs/screenshots/ls-uprawnienia.png)

Kluczowe osiągnięcia:

- Zarządzanie Własnością (`chown`): Przejąłem rekursywnie (-R) katalog `/var/www/html/` na własność swojego głównego użytkownika. Pozwoliło mi to na swobodną edycję treści strony WWW bez konieczności ciągłego używania sudo, co jest bezpieczniejszą praktyką.

- Analiza procesów (Nginx Context): Zidentyfikowałem, że proces główny Nginxa (master) działa jako root, ale procesy robocze (workers) działają jako użytkownik www-data. Zrozumiałem, że jest to kluczowe zabezpieczenie – w razie włamania przez lukę w stronie, napastnik przejmuje uprawnienia tylko tego ograniczonego konta.

- Eksperyment 403 Forbidden: Celowo odebrałem wszystkie uprawnienia do pliku index.nginx-debian.html (`chmod 000`). Potwierdziłem, że skutkuje to błędem 403 i namierzyłem odpowiedni wpis w logach `/var/log/nginx/access.log`.

Czego się nauczyłem:

- Matryca rwx: Opanowałem zapis numeryczny (np. 755, 644) oraz symboliczny (np. u+x, g-w).

- Znaczenie bitu wykonania (x) dla katalogów: Odkryłem, że uprawnienie r (odczyt) pozwala tylko zobaczyć listę plików, ale to uprawnienie x (wykonanie) pozwala "wejść" do katalogu (cd) i pracować na jego zawartości.

- Zasada Najmniejszych Uprawnień w praktyce: Zrozumiałem, dlaczego pliki tekstowe powinny mieć 644, a katalogi 755 – daje to niezbędny dostęp dla usług (Nginx), jednocześnie blokując możliwość nieautoryzowanej edycji.

Najważniejsze komendy:

`sudo chown -R user:group folder/` – rekursywna zmiana właściciela i grupy.

`chmod 644 <plik>` – standardowe uprawnienia dla plików (RW dla właściciela, R dla reszty).

`chmod 755 <katalog>` – standardowe uprawnienia dla folderów (wymagany bit X do nawigacji).

`ls -la` – szczegółowy podgląd maski uprawnień i właściciela.

---

Dzień 11 – Sieciowy Pancerz (UFW) i Test Trwałości (Persistence)

Opis:
Dopełniłem bezpieczeństwo serwera poprzez konfigurację firewalla (UFW) oraz zweryfikowałem stabilność i autostart usług po całkowitym restarcie systemu.

>[docs/screenshots/ufw-status.png](docs/screenshots/ufw-status.png)

Kluczowe osiągnięcia:

- Implementacja UFW: Skonfigurowałem reguły dla HTTP/HTTPS (Nginx Full) oraz SSH.

- Ochrona Brute-Force: Zamiast zwykłego otwarcia portu, zastosowałem regułę limit dla SSH. Ogranicza ona liczbę prób połączeń (6 prób na 30 sekund), co chroni system przed zasypywaniem logów przez boty i oszczędza zasoby serwera.

- Chirurgia pliku `before.rules`: Przeprowadziłem test blokowania odpowiedzi na ping (ICMP). Zrozumiałem, że niskopoziomowe reguły wymagają edycji plików konfiguracyjnych i przeładowania firewalla (reload), aby zmiany weszły w życie.

- Audyt logów: Włączyłem logowanie UFW i przetestowałem je "na żywo" używając `tail -f /var/log/ufw.log`, próbując połączyć się przez telnet na zamknięty port (23).

- Gwarancja Trwałości: Wykryłem, że usługa SSH była ustawiona jako disabled. Naprawiłem to za pomocą systemctl enable, zapobiegając utracie dostępu do serwera po restarcie.


Czego się nauczyłem:

- Firewall: Dowiedziałem się, że UFW śledzi nawiązane połączenia, dzięki czemu aktywacja firewalla nie przerywa bieżącej sesji administratora.

- Zarządzanie Usługami: Opanowałem różnicę między status active (usługa działa teraz) a status enabled (usługa zadziała po restarcie).

- Profile Aplikacji: Zrozumiałem, że używanie profili takich jak Nginx Full jest bezpieczniejsze i wygodniejsze niż ręczne otwieranie pojedynczych portów.

Najważniejsze komendy:

`sudo ufw limit ssh` – inteligentne ograniczanie prób logowania.

`sudo ufw status verbose` – rozszerzony podgląd stanu zabezpieczeń.

`sudo ufw reload` - przeładowanie firewalla tak aby zmiany w plikach konfiguracyjnych zaczęły działać

`sudo systemctl enable [service]` – zapewnienie autostartu kluczowych usług.

`tail -f /var/log/ufw.log` – monitorowanie zablokowanych pakietów w czasie rzeczywistym.

---

Dzień 12 – Pierwsze kroki w Bash i harmonogram zadań Cron

Opis:
Rozpocząłem proces automatyzacji powtarzalnych czynności na serwerze. Stworzyłem skrypt monitorujący aktywność systemu oraz skonfigurowałem harmonogram zadań, aby odciążyć administratora od ręcznego uruchamiania procesów.

> [docs/screenshots/dzialanie-skryptu.png](docs/screenshots/dzialanie-skryptu.png)

Kluczowe osiągnięcia:

Tworzenie skryptu `log_date.sh`: Napisałem skrypt, który w sposób inteligentny zarządza strukturą plików. Skrypt sprawdza obecność katalogu na logi, a w przypadku jego braku – automatycznie go tworzy i inicjuje plik tekstowy.

Logika warunkowa: Zastosowałem instrukcję `if [ -d "$LOG_DIR" ]`, aby uniknąć błędów podczas próby zapisu do nieistniejących lokalizacji.

Automatyzacja przez Cron: Wdrożyłem skrypt do harmonogramu zadań systemu Linux (crontab). Skrypt wykonuje się automatycznie w tle, bez ingerencji użytkownika.

Czego się nauczyłem:

Shebang (`#!/bin/bash`): Zrozumiałem, że ta linia informuje system, jakiego interpretera ma użyć do przetworzenia komend w pliku.

Przekierowania strumieni: Wykorzystałem operator `>>`, aby dopisywać dane na końcu pliku (append) zamiast ich nadpisywania.

Składnia Crontab: Opanowałem strukturę pięciu gwiazdek (* * * * *). Zrozumiałem różnicę między specyficznym momentem (np. 1 * * * * – pierwsza minuta godziny) a interwałem (np. co minutę).

Najważniejsze komendy:

`chmod +x log_date.sh` – nadanie uprawnień wykonywalności dla skryptu.

`crontab -e` – edycja tabeli zadań cyklicznych dla bieżącego użytkownika.

`tail -f ~/projekt/logs/activity.log` – śledzenie dopisywanych logów w czasie rzeczywistym.

---

## 📅 Etap 3 – Scenariusze Helpdesk
 
**Cel:** Symulacja realnych problemów — metodyczne diagnozowanie i naprawianie.

Opis:
Ten etap to symulacja realnych problemów, z którymi mierzy się Administrator Systemów lub Inżynier Wsparcia. Zamiast podążać za instrukcją, celowo wprowadzałem awarie w konfiguracji, a następnie diagnozowałem je przy użyciu profesjonalnych narzędzi analizy logów i statusów usług.

 
> Pełna dokumentacja wszystkich scenariuszy: [docs/troubleshooting.md](docs/troubleshooting.md)


## 📚 Zasoby które były pomocne

W projekcie kierowałem się materiałami z sylabusa **LPI Linux Essentials** – korzystam z dostępnych **darmowych materiałów edukacyjnych udostępnianych przez LPI**, które pomagają mi poznawać tematy związane z administracją Linux, bezpieczeństwem, siecią i zarządzaniem systemem w sposób uporządkowany. Dzięki temu projekt jest zgodny ze standardowym podejściem do nauki Linux'a, a jednocześnie pozwala mi budować własne praktyczne portfolio na podstawie wymagań sylabusa.



## **👨‍💻** Autor


**Mateusz Markiewicz -** Projekt zrealizowany w ramach praktycznej nauki i stanowi część portfolio
