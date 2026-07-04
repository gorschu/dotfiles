# GPG Bootstrap And Maintenance

The trusted day-to-day bootstrap source is the 1Password item:

```text
Private / GPG Key Personal
```

Normal bootstrap imports only:

```text
public_cert
secret_subkeys
ownertrust
```

Expected local key shape after bootstrap:

```text
sec#  rsa4096/DEE550054AA972F6 ... [C]
ssb   rsa4096/9B73D324A9B66BAC ... [S]
ssb   rsa4096/0EE188E69A7B55CA ... [E]
ssb   rsa4096/C119099D66495614 ... [A]
```

`sec#` is intentional: the primary/master secret key is not usable in the
daily keyring. Daily decrypt/sign uses the local secret subkeys protected by the
`subkey_passphrase` value in 1Password.

## 1Password Fields

```text
password
```

Master key passphrase. Needed only for key maintenance: rotating/extending
subkeys, changing UIDs, revoking, or rebuilding the master secret backup.

```text
subkey_passphrase
```

Daily local-GPG passphrase. This protects `secret_subkeys` after bootstrap.

```text
master_secret
```

Full primary/master secret key export. Do not import this into the daily
keyring. Use it only in a temporary maintenance GNUPGHOME.

```text
revocation_cert
```

Break-glass revocation certificate.

The `*_file` fields duplicate the same payloads as file attachments for manual
recovery/auditing. Bootstrap uses the text fields.

## Future Subkey Rotation

Do rotation in a temporary maintenance GNUPGHOME, not in the daily keyring.

The source of truth is 1Password.

Create a maintenance keyring:

```sh
work=$(mktemp -d)
chmod 700 "$work"
export GNUPGHOME="$work/gnupg"
mkdir -m 700 "$GNUPGHOME"

op read "op://Private/GPG Key Personal/public_cert" --out-file "$work/public.asc" --force
op read "op://Private/GPG Key Personal/master_secret" --out-file "$work/master_secret.asc" --force
op read "op://Private/GPG Key Personal/ownertrust" --out-file "$work/ownertrust.txt" --force

gpg --import "$work/public.asc"
gpg --import "$work/master_secret.asc"
gpg --import-ownertrust "$work/ownertrust.txt"
```

Use the master passphrase to extend or rotate subkeys:

```sh
gpg --edit-key 0A47650A15E4F0F4003EC450DEE550054AA972F6
```

After rotation, export the updated public cert and master secret:

```sh
fpr=0A47650A15E4F0F4003EC450DEE550054AA972F6
gpg --armor --export "$fpr" > "$work/public.asc"
gpg --armor --export-secret-keys "$fpr" > "$work/master_secret.asc"
```

Publish the updated public cert so other machines and services can discover the
new subkey metadata:

```sh
gpg --keyserver hkps://keyserver.ubuntu.com:443 --send-keys "$fpr"
```

Create a separate daily staging keyring so `secret_subkeys` is protected by the
daily passphrase, not the master passphrase:

```sh
daily="$work/daily-gnupg"
mkdir -m 700 "$daily"
GNUPGHOME="$daily" gpg --import "$work/public.asc"
GNUPGHOME="$daily" gpg --import "$work/master_secret.asc"
GNUPGHOME="$daily" gpg --change-passphrase "$fpr"
GNUPGHOME="$daily" gpg --armor --export-secret-subkeys "$fpr" > "$work/secret_subkeys.asc"
```

During `--change-passphrase`:

```text
old passphrase: master key passphrase
new passphrase: daily local-GPG passphrase
```

Update the matching 1Password fields/files with the new exports, then test in a
fresh temporary GNUPGHOME before replacing any real `~/.gnupg`.

Do not use the daily keyring as the source for `master_secret`; it intentionally
lacks the usable primary secret key.
