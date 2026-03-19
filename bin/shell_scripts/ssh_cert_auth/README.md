---

# SSH Certificate Authority (CA) Setup

This guide explains how to configure SSH certificate-based authentication using a trusted Certificate Authority (CA), instead of managing `authorized_keys` on every server.

---

## 🧠 Overview

Instead of copying public keys to each server:

* A **CA signs user public keys**
* Servers **trust the CA**
* Users authenticate using **short-lived certificates**

---

## 🔐 1. Create the CA

Run on a secure machine:

```bash
ssh-keygen -t ed25519 -f /etc/ssh/ca_user -C "SSH User CA"
```

Files created:

* `/etc/ssh/ca_user` (private key — keep secure)
* `/etc/ssh/ca_user.pub` (public key — distribute to servers)

---

## 🖥️ 2. Configure SSH Server

Edit `/etc/ssh/sshd_config`:

```bash
TrustedUserCAKeys /etc/ssh/ca_user.pub
```

(Optional) Restrict access using principals:

```bash
AuthorizedPrincipalsFile /etc/ssh/auth_principals/%u
```

Restart SSH:

```bash
sudo systemctl restart sshd
```

---

## 👤 3. Generate User Key

On the client machine:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
```

---

## ✍️ 4. Sign the User Key

On the CA machine:

```bash
ssh-keygen -s /etc/ssh/ca_user \
  -I username_identity \
  -n username \
  -V +8h \
  ~/.ssh/id_ed25519.pub
```

Options:

* `-I` → certificate identity (label)
* `-n` → allowed username(s)
* `-V` → validity period (e.g., `+8h`, `+1d`, `+52w`)

This creates:

```
~/.ssh/id_ed25519-cert.pub
```

---

## 🚀 5. Connect

Ensure both files exist on the client:

```
~/.ssh/id_ed25519
~/.ssh/id_ed25519-cert.pub
```

Then connect:

```bash
ssh user@server
```

No `authorized_keys` needed 🎉

---

## 🔒 6. (Optional) Configure Principals

Create per-user principal files:

```bash
sudo mkdir -p /etc/ssh/auth_principals
echo "username" | sudo tee /etc/ssh/auth_principals/username
```

---

## 🌐 7. (Optional) Host Certificates

Sign host keys:

```bash
ssh-keygen -s /etc/ssh/ca_host \
  -I host_identity \
  -h \
  -n hostname \
  /etc/ssh/ssh_host_ed25519_key.pub
```

Client trusts CA via `~/.ssh/known_hosts`:

```
@cert-authority *.example.com ssh-ed25519 AAAA...
```

---

## 🛠️ Troubleshooting

Check certificate details:

```bash
ssh-keygen -L -f ~/.ssh/id_ed25519-cert.pub
```

Verbose SSH:

```bash
ssh -vvv user@server
```

Check server logs:

```bash
sudo journalctl -u sshd
```

---

## 🔥 Best Practices

* Keep CA private key offline or secured
* Use short-lived certificates (`+8h` or less)
* Separate **user CA** and **host CA**
* Audit certificates regularly

---

## 📌 Summary

* Servers trust a CA
* CA signs user keys
* Users authenticate with certificates
* No more manual key distribution

---

---

If you want, I can upgrade this README with:

* a **script to automate signing**
* a **multi-server deployment example**
* or integration with tools like Vault or step-ca

