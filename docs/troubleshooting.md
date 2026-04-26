# 🔧 Troubleshooting Log

> Format każdego wpisu: **Problem → Przyczyna → Rozwiązanie → Weryfikacja → Wniosek**
> Opis analizy jest ważniejszy niż samo rozwiązanie — pokazuje jak myślę, nie tylko co wpisałem.

---


## Problem: Usługa Nginx nie uruchamia się (Status: Failed) po zmianach w konfiguracji.
Kiedy wystąpił:
Podczas próby przeładowania serwera WWW po edycji parametrów nasłuchiwania.

>[screenshots/scenariusz-nginx-stopped.png](screenshots/scenariusz-nginx-stopped.png)

Przyczyna:
Błąd składni w pliku konfiguracyjnym (literówka w dyrektywie), który uniemożliwił binariom Nginxa poprawne sparsowanie ustawień podczas startu.

Rozwiązanie:

Użycie `sudo systemctl status nginx` w celu potwierdzenia, że usługa jest nieaktywna.

Wykonanie testu składni: `sudo nginx -t` (kluczowe narzędzie, które wskazało konkretną linię i plik z błędem).

Poprawa błędu w edytorze `nano`.

Weryfikacja: Ponowny test `nginx -t` zakończony statusem syntax is ok, a następnie `sudo systemctl start nginx`.

>[screenshots/scenariusz-nginx-naprawiony.png](screenshots/scenariusz-nginx-naprawiony.png)

Wniosek:
Nigdy nie restartuj usługi "w ciemno". Narzędzia do testowania konfiguracji (takie jak `nginx -t`) są pierwszą linią obrony przed nieplanowanym przestojem serwera (downtime).

## Problem: Błąd "403 Forbidden" przy próbie wejścia na stronę WWW.
Kiedy wystąpił:
Po zmianie struktury katalogów lub restrykcyjnej modyfikacji uprawnień do plików źródłowych.

>[screenshots/scenariusz-403-blad.png](screenshots/scenariusz-403-blad.png)

Przyczyna:
Brak uprawnień odczytu (r) dla użytkownika systemowego www-data (pod którym działa Nginx) do pliku index.nginx-debian.html lub brak uprawnień wykonania (x) do katalogu nadrzędnego.

Rozwiązanie:

Analiza logów błędów: `tail -f /var/log/nginx/error.log` (wykryto wpis: Permission denied).

Audyt uprawnień: `ls -la /var/www/html`.

Nadanie poprawnych uprawnień: `chmod 644 index.html`.

Weryfikacja: Odświeżenie przeglądarki i poprawne wyświetlenie treści strony.

>[screenshots/scenariusz-403-naprawiony.png](screenshots/scenariusz-403-naprawiony.png)

Wniosek:
Błąd 403 to najczęściej problem na styku warstwy aplikacji i systemu plików. Kluczowe jest zrozumienie, że usługa WWW musi mieć fizyczną możliwość "dotknięcia" plików, które ma serwować.


## Problem: Brak możliwości połączenia przez SSH (Connection Refused vs Timeout).
Kiedy wystąpił:
Podczas prób zdalnego logowania do serwera po pracach konserwacyjnych.

Przyczyna:


W przypadku Timeout: Połączenie "zgubione" lub zablokowane.


>[screenshots/scenariusz-ssh-timeout.png](screenshots/scenariusz-ssh-timeout.png)


W przypadku Refused: usługa SSH (sshd) nie działa lub nie nasłuchuje na danym porcie.

>[screenshots/scenariusz-ssh-refused.png](screenshots/scenariusz-ssh-refused.png)

Rozwiązanie:

Dla Refused: Lokalny dostęp do konsoli i komenda `sudo systemctl start ssh`.

>[screenshots/scenariusz-ssh-refused-naprawiony.png](screenshots/scenariusz-ssh-refused-naprawiony.png)

Dla Timeout: Sprawdzenie stanu firewalla: sudo ufw status. Jeśli port 22 był zablokowany – sudo ufw allow ssh.

>[screenshots/scenariusz-ssh-timeout-naprawiony.png](screenshots/scenariusz-ssh-timeout-naprawiony.png)


Weryfikacja: Pomyślne logowanie przez SSH.

Wniosek:
Umiejętność rozróżnienia błędu "Refused" (aplikacja leży) od "Timeout" (sieć/firewall blokuje) skraca czas diagnostyki o połowę. Pozwala natychmiast określić, czy szukać problemu w usługach, czy w regułach bezpieczeństwa.

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


