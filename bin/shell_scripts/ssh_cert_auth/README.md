SSH Certificate Authority (CA) Setup
Automated setup of SSH certificate-based authentication using a trusted Certificate Authority (CA). This replaces traditional authorized_keys management with a centralized and scalable trust model.

🧠 Overview
This script:

Creates User CA and Host CA

Bootstraps access using an existing SSH key

Generates and signs host certificates

Configures the SSH server to trust the CA

Configures the client to trust host certificates

Locks down SSH to certificate-based authentication only

Key Features
No more authorized_keys management

Time-limited certificates (+30d by default)

Uses principals (-n) for host validation

Fully automated end-to-end setup

⚠️ Notes:

Initial access uses an existing SSH key ($user_key)

scp uses -P, ssh uses -p

Script assumes sudo access on the target host

⚙️ Usage
Bash
￼
./setup-ca.sh [HOST]
Example:
Bash
￼
./setup-ca.sh 192.168.122.40
If no host is provided, it defaults to:

￼
192.168.122.40
📁 Default Configuration
Variable	Description	Default
my_host	Target host	192.168.122.40
my_username	Local username	$USER
user_key	SSH key for bootstrap	~/.ssh/<user>_key
ca_dir	CA key directory	~/.ssh/ca
ca_user_key	User CA key	~/.ssh/ca/ca_user
ca_host_key	Host CA key	~/.ssh/ca/ca_host
host_key	Host SSH key	/etc/ssh/host_key
port	SSH port	22
￼
🚀 What the Script Does
1. 🔐 Create Certificate Authorities
Generates:

ca_user → signs user keys

ca_host → signs host keys

Uses ed25519 keys

Skips creation if they already exist

2. 🔑 Setup Temporary Access
Clears old host key entries

Adds host to known_hosts

Ensures SSH access using:

Existing key (~/.ssh/<user>_key)

Falls back to ssh-copy-id if needed

3. 🖥️ Generate Host Key (Remote)
On the target host:

Creates /etc/ssh/host_key if it doesn't exist

Uses ed25519

No passphrase (required for sshd)

4. ✍️ Sign Host Certificate
Copies host public key to local machine

Signs it with Host CA

Uses:

Principal: <host>

Validity: +30 days

Copies certificate back to host:

/etc/ssh/host_key-cert.pub

5. 🔒 Configure SSH Server
Creates:

￼
/etc/ssh/sshd_config.d/20-my_ca.conf
With:

Bash
￼
PasswordAuthentication no
AuthenticationMethods publickey
PermitRootLogin no
TrustedUserCAKeys /etc/ssh/ca_user.pub
HostKey /etc/ssh/host_key
HostCertificate /etc/ssh/host_key-cert.pub
Also:

Installs CA public key

Fixes permissions

Restarts sshd

⚠️ This step locks down SSH:

❌ No passwords

❌ No root login

✅ Certificate-based auth only

6. 🤝 Configure Client Trust
Adds Host CA to ~/.ssh/known_hosts:

Bash
￼
@cert-authority * <CA_HOST_PUBLIC_KEY>
Removes reliance on TOFU (Trust On First Use)

7. 🔐 Start SSH Agent
Starts ssh-agent if not running

Adds your user key automatically

🔄 Authentication Flow
Client connects to host

Host presents CA-signed host certificate

Client verifies via trusted CA

User authenticates using key (and optionally signed certs later)

⚠️ Important Notes
Host key must NOT have a passphrase

Certificate validity is 30 days by default

Principals (-n) must match hostname exactly

Script requires:

ssh, scp, ssh-keygen, ssh-copy-id, ssh-keyscan

You must have:

SSH access

sudo privileges on the host

🛠️ Troubleshooting
Permission Denied
Check SSH access manually:

Bash
￼
ssh -i ~/.ssh/<user>_key user@host
SSH Fails After Setup
Validate config:

Bash
￼
sudo sshd -t
Host Verification Issues
Reset known hosts:

Bash
￼
rm ~/.ssh/known_hosts
Re-run script.

✅ Benefits
Centralized SSH trust model

No authorized_keys distribution

Automatic trust via CA

Time-limited credentials

Scalable across many hosts

📌 Future Improvements
User certificate signing automation

Configurable certificate validity

Multi-host support

Role-based principals
