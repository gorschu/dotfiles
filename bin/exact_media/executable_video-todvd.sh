#!/bin/bash

# AVI or any video to DVD iso Script

# Change to "ntsc" if you'd like to create NTSC disks
# DvdAuthor 7 and up needs this
export VIDEO_FORMAT=PAL
format="pal"

red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

# Check we have enough command line arguments
if [ $# -lt 1 ]; then
    echo "Usage: $0 <input file 1 ... input file n>"
    exit
fi

# Check for dependencies
missing=0
dependencies=("ffmpeg" "dvdauthor" "genisoimage")
for command in "${dependencies[@]}"; do
    if ! command -v "${command}" &>/dev/null; then
        echo "${red}'${command}' not found${reset}"
        missing=1
    fi
done

if [ $missing = 1 ]; then
    echo "${red}Please install the missing applications and try again${reset}"
    exit
fi

# Check the files exists
for var in "$@"; do
    if [ ! -e "${var}" ]; then
        echo "${red}File '${var}' not found${reset}"
        exit
    fi
done

echo "${green}Converting video to mpeg2 format${reset}"

for var in "$@"; do
    ffmpeg -i "${var}" -y -target ${format}-dvd -aspect 16:9 "${var}.mpg"
    if [ $? != 0 ]; then
        echo "${red}Conversion failed${reset}"
        exit 1
    fi
done

echo "${green}Creating XML file${reset}"

echo "<dvdauthor>
<vmgm />
<titleset>
<titles>
<pgc>" >dvd.xml

for var in "$@"; do
    echo "<vob file=\"${var}.mpg\" />" >>dvd.xml
done

echo "</pgc>
</titles>
</titleset>
</dvdauthor>" >>dvd.xml

echo "${green}Creating DVD contents${reset}"

dvdauthor -o dvd -x dvd.xml

if [ $? != 0 ]; then
    echo "${red}DVD creation failed${reset}"
    exit
fi

echo "${green}Creating ISO image${reset}"

genisoimage -dvd-video -o dvd.iso dvd/

if [ $? != 0 ]; then
    echo "${red}ISO creation failed${reset}"
    exit
fi

# Everything passed. Cleanup
for var in "$@"; do
    rm -f "${var}.mpg"
done
rm -rf dvd/
rm -f dvd.xml

echo "${green}Success: dvd.iso image created${reset}"
echo "burn with: growisofs -dvd-compat -Z /dev/sr0=./dvd.iso"
