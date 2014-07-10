#!/bin/bash

function create_certs {

  # -- CREATE A PRIVATE KEY
  printf "\n--- CREATE A PRIVATE KEY (THE SAME KEY WILL BE USED FOR A DUMMY CA) ---\n\n"
  openssl genrsa -des3 -out $1.in.key 1024

  # -- REMOVE THE PASSPHRASE (THIS COULD BE DONE IN ONE STEP)
  printf "\n--- REMOVE THE PASSPHRASE FROM THE KEYSTORE ---\n"
  cp $1.in.key $1.in.key.bak
  openssl rsa -in $1.in.key.bak -out $1.in.key
  rm -rf $1.in.key.bak

  # -- CREATE a CSR (Certificate Signing Request)
  printf "\n--- CREATING A CERTIFICATE SIGNING REQUEST FOR $1\n"
  openssl req -new -key $1.in.key -out $1.in.csr -subj "/C=UK/ST=Scotland/L=Glasgow/O=KFIS/OU=IS/CN=lamazone.com"

  #openssl req -new -x509 -nodes -sha1 -days 1825 -key $1.in.key -out $1.in.crt

  # -- CREATE A DUMMY CA CERTIFICATE USING THE SAME PRIVATE KEY
  printf "\n--- CREATING A CERTIFICATE FOR A DUMMY CA FOR $1\n"
  openssl req -new -x509 -key $1.in.key -out ca.$1.in.crt  -subj "/C=PL/ST=Podkarpacie/L=Frysztak/O=SC/OU=IS/CN=laputanrobot.com"

  # -- SIGN THE CSR WITH A DUMMY CA CERTIFICATE AND THE CA KEY WHICH IS THE SAME AS THE PRIVATE KEY
  # -- SET EXPIRY TIME TO 5 YEARS
  printf "\n--- SIGNING THE CSR FOR $1\n\n"
  openssl x509 -req -days 1825 -in $1.in.csr -CA ca.$1.in.crt -CAkey $1.in.key -out $1.in.crt -set_serial 01
}

function cleanup {
  ls -ltr | grep .in. | awk '{print $9}' | while read plik; do rm -rf $plik; done
}

case "$1" in
  "")
    echo $"Please provide a file prefix e.g: my_project"
  ;;
  *)
    cleanup
    create_certs $1
esac

