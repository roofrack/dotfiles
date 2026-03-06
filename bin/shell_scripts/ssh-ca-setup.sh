#!/usr/bin/bash
# This is kind of a tutorial for myself to learn and set up ssh cerificate authorization (ca).
# Need to have password (or key) authorization enabled on host for this to initially be set up.
# Allow root login in order to copy files over to host (server) (VeryBad! Change it back after setup!!).
# Uncomment the functions in main() to run functions one at a time to ensure no errors.
# Can really fine tune restrictions on certificates by using the principle field and setting a time limit.
# If root is not added to user certificate principles field (-n) then can NOT ssh into server as root user.

# Define a few variables...
server="root@192.168.122.41"
client_directory="$HOME/.ssh"
server_directory="/etc/ssh"
user_key="user_key"
host_key="host_key"
ca_directory="$client_directory/ca"
ca_user="ca_user"
ca_host="ca_host"
my_host_ca_configuration="20-my_ca.conf" # NOTE: conf NOT config!!

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

# 3. Sign user_key.pub using the Certificate Authority ca_user key...
# Rob you need to remember that the principles field needs to be correct or leave blank
# or it wont work. Remember how you spent hours figuring that out. Use correct user names here!
sign_user_certificate() {
  printf '\n%s\n' "SIGNING USER PUBLIC KEY CERTIFICATE..."
  ssh-keygen -s "$ca_directory"/"$ca_user" -I "client-machine" -n "root,rob" -V +22d \
    "$client_directory"/"$user_key".pub &>/dev/null
}

# 4. Configure the client...
# Add the CA host public key to the ~/.ssh/known_hosts file for host auth (no more tofu).
# The `*` here allows any host using this CA (I think).
configure_client() {
  echo "@cert-authority * $(cat "$ca_directory"/"$ca_host".pub)" >"$client_directory"/known_hosts
}

# 5. Generate HOST Keys...
# DO NOT put password on host key as sshd needs to access it!
# Must allow 'PermitRootLogin yes' on server for the server commands to work from the client.
# Maybe just go into server directly and generate host keys there.
# Cant seem to add a comment over the ssh wire for server host_key
# but just go into the host_key file and edit the comment if desired.
generate_host_keys() {
  printf '\n%s\n' "LOGGING INTO HOST..."
  printf '\n%s\n' "GENERATING HOST KEY..."
  ssh -i "$user_key" "$server" ssh-keygen -f "$server_directory"/"$host_key"
}

# 6. Sign host_key.pub using the Certificate Authority...
# Copy the host public key over to where ever the CA is.
# Make sure principles field `-n` is correct (correct host names).
# Send certificate back to Host machine (host_key-cert.pub).
# Remove the host_key.pub & host_key-cert.pub files (do not need anymore after certificate is created).
sign_host_certificate() {
  local hostname="192.168.122.41"
  printf '\n%s\n' "SIGNING HOST PUBLIC KEY CERTIFICATE..."
  scp -i "$user_key" "$server":"$server_directory"/"$host_key".pub "$client_directory" &>/dev/null
  ssh-keygen -h -s "$ca_directory"/"$ca_host" -I "host-machine" -n "$hostname" -V +22d "$client_directory"/"$host_key".pub &>/dev/null
  scp -i "$user_key" "$client_directory"/"$host_key"-cert.pub "$server":"$server_directory" &>/dev/null
  rm "$client_directory"/"$host_key".pub "$client_directory"/"$host_key"-cert.pub
}

# 7. Configure HOST...
# NOTE: THIS LOCKS DOWN THE SERVER - NO ROOT LOGINS if PermitRootLogin uncommented below.
# Create configuration file (gets merged into sshd_config).
# Copy configuration file from here to HOST:/etc/ssh/sshd_configd/.
# Copy CA user_key.pub to server (allows host to trust the client user).
# Restart the host sshd.
# Delete my_host_ca_configuration file as not needed here.
configure_host() {
  : >"$my_host_ca_configuration" # ': >' creates the file and truncates it
  cat <<EOF >>"$my_host_ca_configuration"
  #PermitRootLogin no
  PasswordAuthentication no
  AuthenticationMethods publickey
  
  
  TrustedUserCAKeys /etc/ssh/${ca_user}.pub
  HostKey /etc/ssh/${host_key}
  HostCertificate /etc/ssh/${host_key}-cert.pub
EOF

  printf '\n%s\n' "COPYING HOST CONFIG TO HOST..."
  scp -i "$user_key" "$client_directory"/"$my_host_ca_configuration" \
    "$server":"$server_directory"/sshd_config.d/ &>/dev/null
  scp -i "$user_key" "$ca_directory"/"$ca_user".pub "$server":"$server_directory" &>/dev/null
  ssh -i "$user_key" "$server" systemctl restart sshd &>/dev/null
  rm "$my_host_ca_configuration"
}

setup_ssh_agent() {
  eval "$(ssh-agent -s)" &>/dev/null
  ssh-add "$client_directory"/"$user_key" &>/dev/null
}

main() {
  setup_ssh_agent
  # make_CA
  generate_user_keys
  sign_user_certificate
  configure_client
  generate_host_keys
  sign_host_certificate
  configure_host
}
main
