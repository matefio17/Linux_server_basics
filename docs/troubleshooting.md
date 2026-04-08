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

> Błędy które napotkałem poza zaplanowanymi scenariuszami. Najbardziej autentyczna część dokumentacji.

---

### Problem: [krótki opis]

**Kiedy wystąpił:**
**Komunikat błędu:**
```

```
**Przyczyna:**

**Rozwiązanie:**
```bash

```
**Wniosek:**

---

### Problem: [krótki opis]

**Kiedy wystąpił:**
**Komunikat błędu:**
```

```
**Przyczyna:**

**Rozwiązanie:**
```bash

```
**Wniosek:**

---

### Problem: [krótki opis]

**Kiedy wystąpił:**
**Komunikat błędu:**
```

```
**Przyczyna:**

**Rozwiązanie:**
```bash

```
**Wniosek:**

---

*Dodawaj nowe wpisy powyżej tej linii w miarę napotykania problemów.*

---

## Wzorzec diagnostyczny którego używam

```
1. Co widzi użytkownik?          → opis symptomu
2. Czy usługa działa?            → systemctl status [usługa]
3. Co mówią logi?                → journalctl / tail /var/log/...
4. Czy sieć/firewall nie blokuje → ufw status, ss -tlnp
5. Czy uprawnienia są właściwe?  → ls -la [plik]
6. Czy jest miejsce na dysku?    → df -h
```
