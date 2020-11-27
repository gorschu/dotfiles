# opensuse and fedora don't not need this
# they are smart enough to source /etc/profile in their /etc/zprofile
distribution=$(lsb_release -si)

if [ "${distribution}" = "Ubuntu" ] || [ "${distribution}" = "Debian" ]; then
   if [ -n "$ZSH_VERSION" ]; then # emulate sh behaviour to not break shit
     emulate sh -c '. /etc/profile'
   else
     . /etc/profile
   fi
fi

