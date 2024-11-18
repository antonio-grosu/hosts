#!/bin/bash

cat /etc/hosts | while read ip dom
do
    # Ignoră liniile comentate
    if [[ "$ip" == \#* || -z "$ip" ]]; then
        continue
    fi

    echo "Facem nslookup pentru $dom, IP-ul din hosts este $ip"

    # Obține adresa IP folosind nslookup
    resolved_ip=$(nslookup $dom 8.8.8.8 | grep 'Address:' | tail -n1 | awk '{print $2}')

    if [ "$resolved_ip" != "$ip" ]; then
        echo "Bogus IP for $dom in /etc/hosts! (Expected: $ip, Got: $resolved_ip)"
    fi
done
