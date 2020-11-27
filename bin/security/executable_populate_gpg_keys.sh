#!/bin/zsh

for key in $(ls -1 ${HOME}/.password-store/keys/gpg/passphrases/*.gpg); do
    keyname=$(basename ${key:r})
    pass show -c keys/gpg/passphrases/${keyname} && \
        pass show keys/gpg/files/${keyname} | gpg --allow-secret-key-import --import
done

pass show keys/gpg/ownertrust | gpg --import-ownertrust

exit 0
