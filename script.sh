#!/bin/bash

# Funcția pentru verificarea validității unei adrese IP
check_ip() {
    local hostname=$1  # Numele de host
    local ip=$2        # Adresa IP
    local dns_server=$3 # Serverul DNS pentru verificare

    # Rezolvăm numele de host folosind nslookup și extragem ultima adresă IP
    resolved_ip=$(nslookup $hostname $dns_server 2>/dev/null | grep 'Address:' | tail -n1 | awk '{print $2}')

    # Verificăm dacă IP-ul rezolvat diferă de cel furnizat
    if [[ "$resolved_ip" == "$ip" ]]; then
        echo "Adresa IP pentru $hostname este validă."
    else
        echo "Bogus IP for $hostname! (Așteptat: $ip, Rezolvat: $resolved_ip)"
    fi
}

# Script principal: Iterăm prin fișierul /etc/hosts
cat /etc/hosts | while read ip dom
do
    # Ignorăm liniile comentate sau goale
    if [[ "$ip" == \#* || -z "$ip" ]]; then
        continue
    fi

    # Apelăm funcția check_ip cu hostname, IP și serverul DNS 8.8.8.8
    check_ip "$dom" "$ip" "8.8.8.8"
done
