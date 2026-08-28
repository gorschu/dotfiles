# Homebrew's alsa-lib looks for plugins inside its own Cellar, which is empty,
# so anything linked against it (spotify_player) cannot load the PipeWire PCM
# plugin and its audio thread dies. Point ALSA at the distro plugin directory.
if [[ -d /usr/lib64/alsa-lib ]]; then
    export ALSA_PLUGIN_DIR=/usr/lib64/alsa-lib
fi
