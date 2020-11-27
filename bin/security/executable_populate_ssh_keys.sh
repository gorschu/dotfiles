#!/bin/zsh

destination="${HOME}/.ssh"

[[ ! -d ${destination} ]] && mkdir -p ${destination} && \
    chmod 700 ${destination}

for key in $(ls -1 ${HOME}/.password-store/keys/ssh/files/*.gpg); do
    keyname=$(basename ${key:r})
    if [[ ${keyname} =~ ".*-public" ]]; then
        filename=$(echo $keyname | sed -r 's/(.*)-public/\1.pub/')
    else
        filename=${keyname}
    fi

    [[ ! -f "${destination}/${keyname}" ]] || \
        [[ ! -s "${destination}/${keyname}" ]] && \
        pass show keys/ssh/files/${keyname} > "${destination}/${filename}" && \
        chmod 600 "${destination}/${filename}"
done

exit 0
