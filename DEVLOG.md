# DEVLOG

# 📓 Devlog Projektu: Linux Server Basics

Ten dziennik dokumentuje proces budowy, napotkane problemy oraz zdobytą wiedzę podczas tworzenia własnego serwera domowego.

---

## 📅 Dzień 1: Fundamenty, Git i Narodziny Serwera

**Data:** 2026-04-07

**Czas pracy:** ok. 2h (intensywna konfiguracja)

### 🎯 Cel:

- Przygotowanie profesjonalnego repozytorium GitHub jako "bazy dowodzenia".
- Instalacja i wstępna konfiguracja Ubuntu Server 22.04 LTS w wersji "Headless" (bez GUI).

### 🚀 Co udało się zrobić:

- **Inicjalizacja projektu:** Stworzyłem lokalne repozytorium Git i połączyłem je z GitHubem.
- **Konfiguracja bezpieczeństwa:** Skonfigurowałem plik `.gitignore`, aby automatycznie blokować wysyłanie wrażliwych danych (klucze SSH) oraz śmieci systemowych.
- **Wirtualizacja:** Utworzyłem Maszynę Wirtualną (VM) w VirtualBoxie (4GB RAM, 25GB SDD).
- **Instalacja OS:** Pomyślnie zainstalowałem system Ubuntu Server 22.04 LTS wraz z usługą OpenSSH.
- **Konfiguracja sieci:** Ustawiłem kartę sieciową w trybie **Bridged**, dzięki czemu serwer stał się widoczny w sieci domowej pod własnym adresem IP.

### 🛠️ Czego się nauczyłem (Skill Tags):

- **Git/GitHub:** Obsługa przepływu pracy: `init` -> `add` -> `commit` -> `push`. Zarządzanie gałęziami (`main` vs `master`).
- **Security:** Praktyczne zastosowanie `.gitignore`. Zrozumienie ryzyka związanego z upublicznianiem kluczy prywatnych.
- **Networking:** Różnica między trybami sieci w VirtualBox (NAT vs Bridged). Podstawowa diagnostyka komendą `ip a`.
- **Linux Admin:** Instalacja systemu w trybie tekstowym, obsługa menedżera pakietów `apt` oraz edytora `nano`.

### ⚠️ Napotkane problemy i rozwiązania:

- **Problem:** Błędna nazwa pliku ignorowania (`.ignore` zamiast `.gitignore`).
    - **Rozwiązanie:** Zmiana nazwy komendą `mv .ignore .gitignore` i weryfikacja przez `git status`.
- **Problem:** Konflikt końców linii LF/CRLF między Windowsem a Linuxem.
    - **Rozwiązanie:** Globalna konfiguracja Gita: `git config --global core.autocrlf true`.
- **Problem:** Błąd pushowania `src refspec main does not match any`.
    - **Rozwiązanie:** Wykonanie pierwszego commita i ręczna zmiana nazwy gałęzi na `main` przez `git branch -M main`.

### 📸 Logi i weryfikacja:

- Pomyślny test  `.gitignore` (Git przestał śledzić pliki `.key`).
- System Ubuntu Server uruchomiony pomyślnie i gotowy do połączeń SSH.

---

*Następny krok: Konfiguracja bezpiecznego dostępu przez klucze SSH.*