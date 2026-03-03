#!/usr/bin/bash
# This is kind of a tutorial for myself to learn and set up ssh cerificate authorization (ca).
# Need to have password (or key) authorization enabled on host for this to initially be set up.
# Allow root login in order to copy files over to host (server) (VeryBad! Change it back after setup!!).
# Uncomment the functions in main() to run functions one at a time to ensure no errors.
# I am using sshpass (pacman sshpass) here to automate some logins. I think thats ok in my local enviroment vm's.

# Define a few variables...
server_rob="vm1.arch"
server="root@192.168.122.41"
client_directory="$HOME/.ssh"
server_directory="/etc/ssh"
user_key="user_key"
host_key="host_key"
ca_directory="$client_directory/ca"
ca_user="ca_user"
ca_host="ca_host"
my_host_ca_configuration="20-my_ca.conf"
fake_passwd="root" # avoid typing in password each time (just for this tutorial)

# 1.
# Setup a secret directory or place for the certificate authority (CA)
# Generate certificate keys (they are just reg keys) for both server and client
# Of course the actual CA would not go here.
make_CA() {
  mkdir "$ca_directory"
  ssh-keygen -f "$ca_directory"/"$ca_user" -C "My User CA"
  ssh-keygen -f "$ca_directory"/"$ca_host" -C "My Host CA"
}

# 2.
# Set up keys for both the client and the host.
# DO NOT put password on host key as sshd needs to access it!
# For this to work for server must allow root login on server
# Maybe just go into server directly and do this
# Cant seem to add a comment over the ssh wire for server host_key
#   but just go into the host_key file and edit the comment if desired.
generate_keys() {
  ssh-keygen -f "$client_directory"/"$user_key" -C "My User Key"
  printf '\n%s\n' "GENERATING HOST KEY... LEAVE P/W BLANK!"
  sshpass -p "$fake_passwd" ssh "$server" ssh-keygen -f "$server_directory"/"$host_key"
}

# 3.
# Copy the server public key over to where ever the CA is
# Sign host_key.pub using the Certificate Authority
# Make sure principles field `-n` is correct (correct hosts names)
# Send certificate back to Host machine (host_key-cert.pub)
# Remove the host_key.pub & host_key-cert.pub files (do not need anymore after certificate is created)
sign_host_certificate() {
  local hostname="192.168.122.41"
  sshpass -p "$fake_passwd" scp "$server":"$server_directory"/"$host_key".pub "$client_directory"
  printf '\n%s\n' "SIGNING HOST PUBLIC KEY FOR CERTIFICATE..."
  ssh-keygen -h -s "$ca_directory"/"$ca_host" -I "host-machine" -n "$hostname" -V +22d "$client_directory"/"$host_key".pub
  sshpass -p "$fake_passwd" scp "$client_directory"/"$host_key"-cert.pub "$server":"$server_directory"
  rm "$client_directory"/"$host_key".pub "$client_directory"/"$host_key"-cert.pub
}

# 4.
# Configure server...
# Add configuration file (gets merged into sshd_config)
# Copy configuration file to /etc/ssh/sshd_configd/
# Copy CA user_key.pub to server (allows host to trust the client user)
# Restart the host sshd
# Delete my_host_ca_con file as not needed here
# NOTE: use the name conf NOT config here rob you dumbass.
configure_host() {
  : >"$my_host_ca_configuration" # ': >' creates the file and truncates it
  cat <<EOF >>"$my_host_ca_configuration"
  PasswordAuthentication no
  AuthenticationMethods publickey
  
  TrustedUserCAKeys /etc/ssh/${ca_user}.pub
  HostKey /etc/ssh/${host_key}
  HostCertificate /etc/ssh/${host_key}-cert.pub
EOF
  sshpass -p "$fake_passwd" scp "$client_directory"/"$my_host_ca_configuration" "$server":"$server_directory"/sshd_config.d/
  sshpass -p "$fake_passwd" scp "$ca_directory"/"$ca_user".pub "$server":"$server_directory"
  sshpass -p "$fake_passwd" ssh "$server" systemctl restart sshd
  rm "$my_host_ca_configuration"
}

# 5.
# Sign user_key.pub with CA to create user certificate
# Add the CA host public key to the client_directory/known_hosts file for host auth (no more tofu)
# Rob you need to remember that the principles field needs to be correct or leave blank
# or it wont work. Remember how you spent hours figuring that out.
# The `*` here allows any host using this CA (I think)
sign_user_certificate() {
  printf '\n%s\n' "SIGNING USER PUBLIC KEY FOR CERTIFICATE..."
  ssh-keygen -s "$ca_directory"/"$ca_user" -I "client-machine" -n "rob" -V +22d "$client_directory"/"$user_key".pub
  echo "@cert-authority * $(cat "$ca_directory"/"$ca_host".pub)" >"$client_directory"/known_hosts
}

delete_ca_config() {
  # This is just to remvove the sshd config file so I can clear back to default settings
  # allowing me to be able to test the above commands.
  printf '\n%s\n' "DELETING HOST CA CONFIG..."
  ssh -t -i "$user_key" "$server_rob" "sudo rm /etc/ssh/sshd_config.d/$my_host_ca_configuration; sudo systemctl restart sshd"
}

main() {
  # delete_ca_config
  # make_CA
  generate_keys
  sign_host_certificate
  configure_host
  sign_user_certificate
}
main
