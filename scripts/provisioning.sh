#!/bin/bash


# provisioning.sh - skrypt tworzcy uytkownika z uprawnieniami do restartu Nginx



# WALIDACJA UPRAWNIEN DO URUCHOMIENIA

# upewniam sie czy skrytp uruchamia root -> sprawdzam czy efektywny identyfikator uzytkowni>

if [[ $EUID -ne 0 ]]; then
    echo "Ten skrypt musi by uruchomiony jako root"
    exit 1
fi

USERNAME=$1

# upewniam sie czy podano argument $1 - czyli nazwe uzytkownika. Robie to poprzez -z co zwr>
# $0 to parametr przechowujacy nazwe skryptu lub sposob jego wywolania (./provisioning.sh)


if [[ -z "$USERNAME" ]]; then
    echo "Zastosuj: $0 [USERNAME]"
    exit 1
fi

# DODAWANIE UZYTKOWNIKA

# tworze uzytkownika wraz z katalogiem domowym i shellem bash - w przypadku niepowodzenia w>

useradd -m -s /bin/bash "$USERNAME" || { echo "Nie udalo sie dodac uzytkownika"; exit 1; }


# USTAWIANIE HASLA I SPRAWDZENIE CZY PRZESZLO

# jesli passwd nie przeslo -> usun uzytkownika i jego dane

if ! passwd "$USERNAME"; then
    userdel -r "$USERNAME"
    echo "Nie udalo sie ustawic hasla. Konto usuniete."
    exit 1
fi

# NADAWANIE UPRAWNIEN SUDO

# osobny plik w /etc/sudoers.d/ aby nie ryzykowac bledow z glownym pllikiem
# sprawdzam sciezke do systemctl uzywajac polecenia which zeby uniknac bledow
# nadaje specyficzne uprawnienia oczekiwane przez sudo


SERVICE_PATH=$(which systemctl)

echo "$USERNAME ALL=(ALL) NOPASSWD: $SERVICE_PATH restart nginx" > "/etc/sudoers.d/$USERNAM>
chmod 440 "/etc/sudoers.d/$USERNAME"



# WALIDACJA SKLADNI SUDOERS (odpowiednik nginx -t)

visudo -cf "/etc/sudoers.d/$USERNAME"



# POTWIERDZENIE

echo "UTWORZONO UZYTKOWNIKA $USERNAME"
exit 0