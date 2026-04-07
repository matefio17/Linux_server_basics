# README

# 🐧 Projekt: Linux Server Basics (Ubuntu Server 22.04)

## 🎯 Cel projektu

Konfiguracja bezpiecznego serwera WWW, zarządzanie dostępem SSH oraz symulacja i rozwiązywanie realnych problemów typu Helpdesk (L1/L2).

## 🛠️ Stack Technologiczny

- **System:** Ubuntu Server 22.04 LTS (VM VirtualBox)
- **Web Server:** Nginx
- **Security:** OpenSSH (Klucze RSA), UFW Firewall
- **Narzędzia:** systemd, journalctl, chmod/chown

## 🚀 Kluczowe Etapy Realizacji

### 1. Hardening SSH

- [ ]  Generowanie pary kluczy (publiczny/prywatny).
- [ ]  Wyłączenie logowania hasłem (bezpieczeństwo przed Brute Force).
- [ ]  *Screenshot: Logowanie kluczem z hosta.*

### 2. Serwer WWW i Uprawnienia

- [ ]  Instalacja Nginx i konfiguracja `index.html`.
- [ ]  Zarządzanie grupami: stworzenie użytkownika `jankowalski` i nadanie uprawnień do `/var/www/html`.
- [ ]  *Screenshot: Działająca strona w przeglądarce.*

### 3. Bezpieczeństwo Sieciowe (UFW)

- [ ]  Konfiguracja firewalla (blokada wszystkiego poza SSH i HTTP).
- [ ]  *Screenshot: Wynik komendy ufw status.*

## 🛠️ Scenariusze Helpdesk (Case Studies)

| Problem | Diagnoza | Rozwiązanie |
| --- | --- | --- |
|  |  |  |
|  |  |  |

## 📚 Czego się nauczyłem?

- Zarządzanie bezpieczeństwem repozytorium: Praktyczne wykorzystanie .gitignore do filtrowania wrażliwych danych (klucze prywatne SSH) i plików tymczasowych systemu operacyjnego.

- Konfiguracja kart sieciowych w VM: Zrozumienie różnicy między trybem NAT (izolacja) a Bridged Adapter (serwer jako pełnoprawny host w sieci lokalnej).

- Diagnostyka sieciowa CLI: Interpretacja wyników komendy ip a i identyfikacja adresów IPv4 w interfejsach sieciowych Linuxa.

- Edycja plików w terminalu: Sprawne poruszanie się w edytorze Nano (skróty klawiszowe, zapisywanie, buforowanie zmian).

---

## **👨‍💻** Autor

---

**matefio17 -** Projekt zrealizowany w ramach praktycznej nauki i stanowi część portfolio
