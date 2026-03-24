#!/usr/bin/bash
# SSH Key Certificate Authorization for Users on the same client machine.
# TODO
# function for signing users that are on another host. It will be exactly
# the same as the one for cert-host.

ca_directory="/home/rob/.ssh/ca"
ca_user="ca_key_user"
ca_host="ca_key_host"
color_bold_underline="\e[1;4;34m"
normal_color="\e[0m"

# 1. Create a Certificate Authority for signing public keys...
# Setup a secret directory or place for the certificate authority (CA).
# Generate certificate keys (they are just reg keys) for both my_host and client.
# Of course the actual CA would go somewhere very secure... not here.
make_CA() {
  mkdir "$ca_directory" &>/dev/null
  ssh-keygen -f "$ca_directory"/"$ca_user" -C "My User CA"
  ssh-keygen -f "$ca_directory"/"$ca_host" -C "My Host CA"
}

signing_my_own_user_account() {
  ssh-keygen -f "$client_directory"/"$user_key"
  ssh-keygen -s "$ca_directory"/"$ca_user" -I "client-machine" -n "rob,ben" -V +22d \
    "$user_key".pub &>/dev/null
  echo "@cert-authority * $(cat ${ca_directory}/ca_key_host.pub)" >"$client_directory"/known_hosts
}

signing_other_user_accounts() {
  sudo ssh-keygen -f "$client_directory"/"$user_key"
  echo "@cert-authority * $(cat ${ca_directory}/ca_key_host.pub)" | sudo tee \
    "$client_directory"/known_hosts &>/dev/null

  sudo cp -a "$client_directory"/"$user_key".pub .
  ssh-keygen -s ${ca_directory}/ca_key_user -I "client-machine" -n "rob,$my_username" -V +22d \
    "$user_key".pub &>/dev/null
  sudo mv "$user_key"-cert.pub "$client_directory" &>/dev/null

  sudo chown -R "$my_username":"$my_username" "$client_directory"
  rm -rf "$user_key".pub
}

confirm_user() {
  clear
  read -r -e -p "SIGNING SSH CERTIFICATE FOR USER: " -i "rob" my_username
  printf "You've selected USER: ${color_bold_underline}%s${normal_color}.\n" "$my_username"
  client_directory="/home/${my_username}/.ssh"
  user_key="${my_username}_key"

  if [[ "$my_username" == "$USER" ]]; then
    signing_my_own_user_account
  elif id -u "$my_username" &>/dev/null; then # does user exist?
    signing_other_user_accounts
  else
    printf "The USER ${color_bold_underline}%s${normal_color} does not exist.\n" "$my_username"
  fi
}
confirm_user
