#!/bin/bash

set -e

CONFIG_DIRECTORY="./config"
USERS_FILE="$CONFIG_DIRECTORY/users.conf"
KEYS_DIRECTORY="$CONFIG_DIRECTORY/keys"

if [[ ! -d $CONFIG_DIRECTORY ]]; then
  mkdir -p $CONFIG_DIRECTORY
fi

if [[ ! -f $USERS_FILE ]]; then
  touch $USERS_FILE
  password="$(pwgen 32 -N 1)"
  encrypted_password="$(echo $password | \
    makepasswd --crypt-md5 --clearfrom=- | \
    awk '{print $2}')"
  echo -e "user:$encrypted_password:e:1001" > $USERS_FILE
  echo -e "$password"
fi

if [[ ! -d $KEYS_DIRECTORY ]]; then
  mkdir -p $KEYS_DIRECTORY
  ssh-keygen -N '' -C share -t ed25519 \
    -f $KEYS_DIRECTORY/ssh_host_ed25519_key < /dev/null
  ssh-keygen -N '' -C share -t rsa -b 4096 \
    -f $KEYS_DIRECTORY/ssh_host_rsa_key < /dev/null
fi
