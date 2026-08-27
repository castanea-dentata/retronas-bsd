#!/usr/bin/env bash

### Checking for new startup, old installs wont have it
if [ ! -x /usr/local/bin/retronas ]
then
    clear
    #installing a simple starup script
    cp /usr/local/retronas-bsd/dist/retronas /usr/local/bin/retronas
    chmod a+x /usr/local/bin/retronas
    echo -e "We have upgraded your RetroNAS, you can now run the RetroNAS config tool with the following command:\n\nretronas\n\nThis message will appear only once\n"
    echo "Press enter to continue"
    read -s
fi