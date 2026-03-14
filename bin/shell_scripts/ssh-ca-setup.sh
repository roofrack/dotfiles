#!/usr/bin/bash
# Tutorial to learn and set up ssh cerificate authorization (ca).
# Can really fine tune restrictions on certificates by using the principle field and setting a time limit.
# This script initially sets up key authorization and then uses that to set up CA authorization.
# The ~/.ssh/known_hosts file gets the host ca public key which is used to trust all certified hosts.

# Define variables...
# my_host="192.168.122.10"
my_host="192.168.122.41"
server="${USER}@${my_host}"
client_directory="${HOME}/.ssh"
server_directory="/etc/ssh"
user_key="user_key"
host_key="host_key"
ca_directory="${client_directory}/ca"
ca_user="ca_user"
ca_host="ca_host"
my_host_ca_configuration="20-my_ca.conf" # NOTE: conf NOT config!!

# 1. Create a Certificate Authority for signing public keys...
# Setup a secret directory or place for the certificate authority (CA).
# Generate certificate keys (they are just reg keys) for both server and client.
# Of course the actual CA would go somewhere very secure... not here.
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

# 3. Sign user_key.pub using the Certificate Authority ca_user key...
# Rob you need to remember that the principles field needs to be correct or leave blank
# or it wont work. Remember how you spent hours figuring that out. Use correct user names here!
sign_user_certificate() {
  printf '\n%s\n' "SIGNING USER PUBLIC KEY CERTIFICATE..."
  ssh-keygen -s "$ca_directory"/"$ca_user" -I "client-machine" -n "root,$USER" -V +22d \
    "$client_directory"/"$user_key".pub &>/dev/null
}

# 4. Configure the client...
# This needs to be last in main function.
# Add the CA host public key to the ~/.ssh/known_hosts file for host auth (no more tofu).
# Must prepend '@cert-authority *' to host pub key.
# The `*` here allows any host using this CA (I think). Could add host ip or name I think.
configure_client() {
  echo "@cert-authority * $(cat "$ca_directory"/"$ca_host".pub)" >"$client_directory"/known_hosts
}

# 5. Generate HOST Keys...
# DO NOT put password on host key as sshd needs to access it!
# Could just go into server directly and generate host keys there.
# Cant seem to add a comment over the ssh wire for server host_key
# but just go into the host_key file and edit the comment if desired.
generate_host_keys() {
  clear
  printf '%s\n' "For host machine $my_host..."
  printf '\n%s\n' "GENERATING HOST KEY..."
  ssh -t -q -i "$user_key" "$server" "sudo ssh-keygen -f $server_directory/$host_key"
}

# 6. Sign host_key.pub using the Certificate Authority...
# Copy the host public key over to where ever the CA is.
# Make sure principles field `-n` is correct (correct host names).
# Send certificate back to host machine (host_key-cert.pub).
# Remove the host_key.pub & host_key-cert.pub files here (do not need anymore after certificate is created).
sign_host_certificate() {
  printf '\n%s\n' "SIGNING HOST PUBLIC KEY CERTIFICATE..."
  scp -i "$user_key" "$server":"$server_directory"/"$host_key".pub "$client_directory" &>/dev/null
  ssh-keygen -h -s "$ca_directory"/"$ca_host" -I "host-machine" -n "$my_host" -V +22d \
    "$client_directory"/"$host_key".pub &>/dev/null
  scp -i "$user_key" "$client_directory"/"$host_key"-cert.pub "$server":"/tmp" &>/dev/null
  ssh -t -q -i "$user_key" "$server" "sudo mv /tmp/$host_key-cert.pub $server_directory &>/dev/null"
  rm "$client_directory"/"$host_key".pub "$client_directory"/"$host_key"-cert.pub &>/dev/null
}

# 7. Configure HOST...
# NOTE: THIS LOCKS DOWN THE SERVER - NO ROOT OR PASSWORD LOGINS (KEY AUTH ONLY).
# Creates configuration file (gets merged into host sshd_config).
# Copy CA user_key.pub to server (allows host to trust the client user).
# Restart the host sshd.
configure_host() {
  printf '\n%s\n' "CONFIGURING host settings..."
  ssh -t -q -i user_key "$server" "sudo tee \
    $server_directory/sshd_config.d/$my_host_ca_configuration &>/dev/null <<EOF
PasswordAuthentication no
AuthenticationMethods publickey
PermitRootLogin no
  
  
TrustedUserCAKeys /etc/ssh/${ca_user}.pub
HostKey /etc/ssh/${host_key}
HostCertificate /etc/ssh/${host_key}-cert.pub
EOF"
  scp -i "$user_key" "$ca_directory"/"$ca_user".pub "$server":/tmp &>/dev/null
  printf '\n%s\n' "RESTARTING host sshd..."
  ssh -t -i "$user_key" "$server" "sudo mv /tmp/$ca_user.pub $server_directory && \
    sudo systemctl restart sshd &>/dev/null && rm /home/$USER/.ssh/authorized_keys &>/dev/null"
}

# Sets up temporary key authorization and then can pass the key to ssh-agent (no more typing key p/w's).
# First, this pulls in remote host public key and copies to client ~/.ssh/known_host file.
# Second, then pushes the client public key to the host's ~/.ssh/authorized keys directory.
# (if get the host pub key first then you avoid tofu)
# Only need to run this initially if ssh keys auth has never been set up for the host before.
temporary_key_authorization() {
  ssh-keyscan -t ed25519 "$my_host" >"$client_directory"/known_hosts
  ssh-copy-id -i "$client_directory"/"$user_key".pub "$my_host"
}

start_ssh_agent() {
  killall ssh-agent
  eval "$(ssh-agent -s)"
  ssh-add "$client_directory"/"$user_key"
}

# Order is important here.
main() {
  # make_CA
  generate_user_keys
  sign_user_certificate
  temporary_key_authorization
  start_ssh_agent
  generate_host_keys
  sign_host_certificate
  configure_host
  configure_client
}
main
