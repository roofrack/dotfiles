#!/usr/bin/bash
# This is kind of a tutorial for myself to learn and set up ssh cerificate authorization (ca).
# Need to have password (or key) authorization enabled on host for this to initially be set up.
# Allow root login in order to copy files over to host (server) (VeryBad! Change it back after setup!!).
# Uncomment the functions in main() to run functions one at a time to ensure no errors.
# I am using sshpass (pacman sshpass) here to automate some logins. I think thats ok in my local enviroment vm's.
# Can really fine tune restrictions on certificates by using the principle field and setting a time limit.

# Define a few variables...
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

# 1. Create a Certificate Authority for signing public keys...
# Setup a secret directory or place for the certificate authority (CA).
# Generate certificate keys (they are just reg keys) for both server and client.
# Of course the actual CA would not go somewhere very secure... not here.
make_CA() {
  mkdir "$ca_directory"
  ssh-keygen -f "$ca_directory"/"$ca_user" -C "My User CA"
  ssh-keygen -f "$ca_directory"/"$ca_host" -C "My Host CA"
}

# 2. Generate USER Keys...
generate_user_keys() {
  printf '\n%s\n' "GENERATING USER KEY..."
  ssh-keygen -f "$client_directory"/"$user_key" -C "My User Key"
}

# 3. Sign user_key.pub using the ca_host Certificate Authority...
# Rob you need to remember that the principles field needs to be correct or leave blank
# or it wont work. Remember how you spent hours figuring that out. Use correct user names here!
sign_user_certificate() {
  printf '\n%s\n' "SIGNING USER PUBLIC KEY CERTIFICATE..."
  ssh-keygen -s "$ca_directory"/"$ca_user" -I "client-machine" -n "root,rob" -V +22d "$client_directory"/"$user_key".pub
}

# 4. Configure the client...
# Add the CA host public key to the ~/.ssh/known_hosts file for host auth (no more tofu).
# The `*` here allows any host using this CA (I think).
# NOTE: This has to run last as known_hosts file gets truncated with this function and it
# erases the `root known host` thus preventing server commands from being able to ssh in.
configure_client() {
  echo "@cert-authority * $(cat "$ca_directory"/"$ca_host".pub)" >"$client_directory"/known_hosts
}

# 5. Generate HOST Keys...
# DO NOT put password on host key as sshd needs to access it!
# Must allow root login on server for the server commands to work.
# Maybe just go into server directly and generate host keys there.
# Cant seem to add a comment over the ssh wire for server host_key
# but just go into the host_key file and edit the comment if desired.
# CAN NOT use sshpass here as must log in once as root before using sshpass. I think maybe
# because the known_hosts file needs to get updated with the root key first. I dunno?
generate_host_keys() {
  printf '\n%s\n' "LOGGING INTO HOST & GENERATING HOST KEY..."
  ssh "$server" ssh-keygen -f "$server_directory"/"$host_key"
}

# 6. Sign host_key.pub using the Certificate Authority...
# Copy the host public key over to where ever the CA is.
# Make sure principles field `-n` is correct (correct host names).
# Send certificate back to Host machine (host_key-cert.pub).
# Remove the host_key.pub & host_key-cert.pub files (do not need anymore after certificate is created).
sign_host_certificate() {
  local hostname="192.168.122.41"
  printf '\n%s\n' "SIGNING HOST PUBLIC KEY CERTIFICATE..."
  sshpass -p "$fake_passwd" scp "$server":"$server_directory"/"$host_key".pub "$client_directory"
  ssh-keygen -h -s "$ca_directory"/"$ca_host" -I "host-machine" -n "$hostname" -V +22d "$client_directory"/"$host_key".pub
  sshpass -p "$fake_passwd" scp "$client_directory"/"$host_key"-cert.pub "$server":"$server_directory"
  rm "$client_directory"/"$host_key".pub "$client_directory"/"$host_key"-cert.pub
}

# 7. Configure HOST... NOTE: THIS LOCKS DOWN THE SERVER TO NO LOGINS VIA PASSWORDS
# Create configuration file (gets merged into sshd_config).
# Copy configuration file from here to HOST:/etc/ssh/sshd_configd/.
# Copy CA user_key.pub to server (allows host to trust the client user).
# Restart the host sshd.
# Delete my_host_ca_configuration file as not needed here.
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

# Little helper function for...
# Deletes my sshd_conf & restarts sshd.
# Deleting my sshd_conf changes the sshd_conf back to default settings where
# password logins ARE allowed. This is necessary to enable client to access the
# host root /etc directory and make changes (add & copy files).
# Why would I want to do this? For rapid testing ssh stuff inside my vm enviroment.
# Can NOT use sshpass here (doesnt work)
delete_ca_config() {
  printf '\n%s\n' "DELETING... HOST:/etc/ssh/sshd_config.d/$my_host_ca_configuration"
  ssh -q -t -i "$user_key" "$server" "rm /etc/ssh/sshd_config.d/$my_host_ca_configuration &> /dev/null; \
      systemctl restart sshd &> /dev/null; echo RESTARTING sshd..."
}

main() {
  delete_ca_config
  # make_CA
  generate_user_keys
  sign_user_certificate
  generate_host_keys
  sign_host_certificate
  configure_host
  configure_client
}
main
