#!/bin/bash

# source https://unix.stackexchange.com/a/190615

# Testing IPv4 connectivity
if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
  echo "IPv4 is up"
else
  echo "IPv4 is down"
fi

# Testing IP connectivity and DNS
if ping -q -c 1 -W 1 google.com >/dev/null; then
  echo "The network is up"
else
  echo "The network is down"
fi

# Testing web connectivity
case "$(curl -s --max-time 2 -I http://google.com | sed 's/^[^ ]*  *\([0-9]\).*/\1/; 1q')" in
  [23]) echo "HTTP connectivity is up";;
  5) echo "The web proxy won't let us through";;
  *) echo "The network is down or very slow";;
esac



# 
if nc -zw1 google.com 443; then
  echo "SSL[test1]  connectivity is up"
fi

test=google.com
if nc -zw1 $test 443 && echo |openssl s_client -connect $test:443 2>&1 |awk '
  $1 == "SSL" && $2 == "handshake" { handshake = 1 }
  handshake && $1 == "Verification:" { ok = $2; exit }
  END { exit ok != "OK" }'
then
  echo "SSL[test2] connectivity is up"
fi