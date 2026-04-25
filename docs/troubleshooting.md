# 🔧 Troubleshooting Log

> Format każdego wpisu: **Problem → Środowisko → Analiza → Rozwiązanie → Wniosek**
> Opis analizy jest ważniejszy niż samo rozwiązanie — pokazuje jak myślę, nie tylko co wpisałem.

---

## Spis treści

- [Scenariusz 1 – Usługa nie działa](#scenariusz-1--usługa-nie-działa)
- [Scenariusz 2 – Błąd 403 Forbidden](#scenariusz-2--błąd-403-forbidden)
- [Scenariusz 3 – Pełny dysk](#scenariusz-3--pełny-dysk)
- [Scenariusz 4 – Problem z SSH](#scenariusz-4--problem-z-ssh)
- [Problemy napotkane przy okazji](#problemy-napotkane-przy-okazji)

---

## Scenariusz 1 – Usługa nie działa

**Data:**
**Czas rozwiązania:**

### Problem
<!-- Co nie działało? Co widać było w przeglądarce lub terminalu? -->



### Środowisko
<!-- Usługa, system, sposób dostępu -->



### Analiza
<!-- Jakie komendy uruchomiłeś? Co znalazłeś w logach? Co Cię naprowadziło na przyczynę? -->

```bash
# komendy których użyłem do diagnozy
```

```
# output który był kluczowy
```

**Co mnie naprowadziło na przyczynę:**


### Rozwiązanie

```bash
# komenda która naprawiła problem
```

**Weryfikacja:**
```bash
# jak sprawdziłem że działa
```

### Wniosek
<!-- Jednym-dwoma zdaniami: czego Cię nauczył ten scenariusz? -->



---

## Scenariusz 2 – Błąd 403 Forbidden

**Data:**
**Czas rozwiązania:**

### Problem



### Środowisko



### Analiza

```bash
# komendy których użyłem do diagnozy
```

```
# output który był kluczowy
```

**Co mnie naprowadziło na przyczynę:**


### Rozwiązanie

```bash

```

**Weryfikacja:**
```bash

```

### Wniosek



---

## Scenariusz 3 – Pełny dysk

**Data:**
**Czas rozwiązania:**

### Problem



### Środowisko



### Analiza

```bash

```

```

```

**Co mnie naprowadziło na przyczynę:**


### Rozwiązanie

```bash

```

**Weryfikacja:**
```bash

```

### Wniosek



---

## Scenariusz 4 – Problem z SSH

**Data:**
**Czas rozwiązania:**

### Problem



### Środowisko



### Analiza — błąd pierwszy

```bash

```

```

```

### Analiza — błąd drugi

```bash

```

```

```

**Różnica między oboma błędami i co każdy oznaczał:**


### Rozwiązanie

```bash

```

### Wniosek



---

## Problemy napotkane przy okazji

> Błędy które napotkałem poza zaplanowanymi scenariuszami. 

---

## Problem: Zmiany w blokowaniu odpowiedzi na Ping (ICMP) nie wchodzą w życie mimo edycji plików konfiguracyjnych.
Kiedy wystąpił:
Podczas audytu zabezpieczeń sieciowych i testowania reakcji serwera na polecenie ping.

Przyczyna:
Brak odświeżenia konfiguracji firewalla w pamięci operacyjnej systemu. Firewall (UFW) po edycji plików tekstowych takich jak /etc/ufw/before.rules nie wczytuje ich automatycznie.

Rozwiązanie:

Lokalizacja i edycja sekcji ICMP w pliku /etc/ufw/before.rules.

Zastosowanie komendy sudo ufw reload.

Weryfikacja: Wykonanie testu ping z maszyny zewnętrznej i potwierdzenie braku odpowiedzi (Request timed out).

Wniosek:
Zmiana plików konfiguracyjnych na dysku to tylko połowa sukcesu. W administracji Linuxem kluczowe jest zrozumienie, że większość usług wymaga sygnału (reload/restart), aby przeładować nowe parametry do działającej pamięci RAM.



## Problem: Ryzyko utraty dostępu do serwera po restarcie systemu (Cold Boot).
Kiedy wystąpił:
Podczas planowania testu trwałości usług (Persistence Test) przed wykonaniem komendy reboot.

Przyczyna:
Usługa OpenSSH była zainstalowana, ale nie posiadała flagi enabled w systemd. Oznacza to, że proces działał w bieżącej sesji, ale nie został dodany do skryptów startowych systemu.

Rozwiązanie:

Audyt stanu usług za pomocą `sudo systemctl status ssh`.

Użycie komendy `sudo systemctl enable ssh`.

Weryfikacja: Restart serwera (`sudo reboot`) i pomyślne nawiązanie nowej sesji SSH bez ingerencji manualnej.

Wniosek:
Status active informuje tylko o tym, co dzieje się "tu i teraz". Dobry administrator zawsze sprawdza status enabled, aby upewnić się, że infrastruktura podniesie się sama po awarii zasilania lub planowej konserwacji.



## Problem: Nadmiarowość i konflikty w regułach firewalla po testach konfiguracyjnych.
Kiedy wystąpił:
Podczas czyszczenia konfiguracji po wielokrotnym dodawaniu różnych wariantów dostępu do portów HTTP i HTTPS.

Przyczyna:
Dodawanie reguł "jedna na drugą" stworzyło nieczytelną listę, w której niektóre wpisy były zdublowane lub niepotrzebnie szerokie (np. pojedynczy port 80 obok profilu Nginx Full).

Rozwiązanie:

Wyświetlenie przejrzystej listy reguł z indeksami: `sudo ufw status numbered`.

Precyzyjne usunięcie zbędnych pozycji komendą `sudo ufw delete [numer_id]`.

Weryfikacja: Ponowne sprawdzenie statusu i potwierdzenie minimalnej, niezbędnej liczby reguł.

Wniosek:
Zasada "Keep It Simple" (KISS) dotyczy również firewalla. Im mniej reguł, tym łatwiejszy audyt bezpieczeństwa i mniejsza szansa na przeoczenie luki w pancerzu sieciowym.



## Problem: Masowe próby logowania botów do usługi SSH i zaśmiecanie logów systemowych.
Kiedy wystąpił:
Podczas analizy logów bezpieczeństwa i monitorowania prób nieautoryzowanego dostępu.

Przyczyna:
Standardowe ustawienie allow dla portu 22 pozwala na nielimitowaną liczbę prób połączeń, co ułatwia ataki typu Brute Force i generuje zbędny ruch.

Rozwiązanie:

Usunięcie standardowej reguły akceptującej port 22.

Wdrożenie reguły `sudo ufw limit ssh`.

Weryfikacja: Automatyczne blokowanie adresów IP wykonujących więcej niż 6 prób połączenia w ciągu 30 sekund.

Wniosek:
Zabezpieczenie to nie tylko blokowanie, ale też inteligentne limitowanie. Reguła limit to pierwsza linia obrony, która chroni nie tylko przed włamanie, ale też przed atakami typu Denial of Service (DoS) wycelowanymi w usługę logowania.




### Problem: Serwer traci dostępność pod dotychczasowym adresem IP po restarcie usługi sieciowej lub odświeżeniu dzierżawy DHCP przez router nadrzędny (akademicki).

**Kiedy wystąpił:**
Podczas kolejnej próby ustanowienia połączenia SSH

**Przyczyna:**
Niezarządzalna sieć akademicka. Brak uprawnień administratora do utworzenia rezerwacji.

**Rozwiązanie:**
  1.  Wdrożenie własnego routera TP-Link TL-WR844N.
  2.  Konfiguracja trybu WISP (Wireless ISP) w celu pobierania internetu z Wi-Fi akademickiego i udostępniania go w odizolowanej sieci LAN.
  3.  Konfiguracja DHCP Reservation: powiązanie MAC adresu VM ze stałym IP `192.168.0.105`.
  4.  Higiena bezpieczeństwa: Wyczyszczenie nieaktualnych wpisów w `~/.ssh/known_hosts`
  5.  Weryfikacja: ponowne uruchomienie VM i potwierdzenie, że adres IP pozostaje stały oraz połączenie SSH działa bez zmian.
     
**Wniosek:**

Stosowanie stałej konfiguracji IP w przypadku serwerów, zwłaszcza tych które oferują usługi jest kluczowe dla ciągłości biznesowej. W środowisku labowym bardzo łatwo zlekceważyć ten problem i stosować tzw. "workarounds" np. poprzez każdorazowe weryfikowanie nowego adresu i aktualizowanie komendy do połączeń SSH. W środowisku korporacyjnym, gdzie z usług serwera korzysta wielu użytkowników, takie obejścia są niedopuszczalne dlatego zależy mi żeby od samego początku nauki administracji stawiać na dobre praktyki.

---

## Problem: Skrypt w harmonogramie Cron nie uruchamia się co minutę zgodnie z założeniem.
Kiedy wystąpił:
Podczas weryfikacji logów po pierwszej konfiguracji `crontab -e`.

Przyczyna:
Błędna interpretacja składni czasu. Ustawienie 1 * * * * zamiast * * * * * spowodowało, że system planował uruchomienie skryptu tylko raz na godzinę (dokładnie w pierwszej minucie każdej godziny), zamiast co 60 sekund.

Rozwiązanie:

Otwarcie edytora zadań: `crontab -e`.

Korekta pierwszej gwiazdki na *, co oznacza "w każdej minucie".

Poprawa ścieżki na bezwzględną (absolutną), aby Cron zawsze wiedział, gdzie znajduje się plik wykonywalny, niezależnie od bieżącego kontekstu.

Weryfikacja: Obserwacja pliku logów i potwierdzenie nowych wpisów co minutę.

Wniosek:
Cron jest niezwykle precyzyjny, ale nie wybacza błędów w składni. W zadaniach automatyzacji kluczowe jest stosowanie pełnych ścieżek dostępu (np. `/home/user/...` zamiast `~/...`), ponieważ procesy systemowe często działają w innym środowisku (`PATH`) niż zalogowany użytkownik.
---


