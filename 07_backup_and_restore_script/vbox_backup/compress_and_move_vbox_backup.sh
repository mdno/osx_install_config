#!/bin/bash

# checking and defining some variables
DATE=$(date +%F)
VBOXMACHINES="/Users/$USER/virtualbox"
#VBOXTARGZSAVEDIR="$VBOXTARGZSAVEDIR"/$"DATE"
VBOXTARGZFILE="$VBOXTARGZSAVEDIR"/"$(basename "$VBOXMACHINES")"_"$DATE".tar.gz

echo ''
#echo "VBOXTARGZSAVEDIR is "$VBOXTARGZSAVEDIR""
#echo "VBOXAPPLESCRIPTDIR "$VBOXAPPLESCRIPTDIR""
#echo "VBOXMACHINES "$VBOXMACHINES""
#echo "VBOXTARGZFILE is "$VBOXTARGZFILE""

# compressing and checking integrity of backup folder on desktop
function archiving_tar_gz {
    
    # calculating backup folder size
    PVSIZE=$(/usr/local/bin/gdu -scb "$VBOXMACHINES" | tail -1 | awk '{print $1}' | while read i ; do echo $(echo $i*1.0 | bc | cut -d'.' -f1  ) ; done)
    #echo "PVSIZE is "$PVSIZE""
    
    # compressing and checking integrity of backup folder on desktop
    echo ''
    echo "archiving "$(dirname "$VBOXMACHINES")"/"$(basename "$VBOXMACHINES")"/ to "$(echo "$VBOXTARGZFILE")""
    pushd "$(dirname "$VBOXMACHINES")" >/dev/null; tar -cpf - "$(basename "$VBOXMACHINES")" | pv -s "$PVSIZE" | /usr/local/bin/pigz --best > "$VBOXTARGZFILE"; popd >/dev/null && echo '' && echo 'testing integrity of file(s)' && echo -n "$(basename "$VBOXTARGZFILE")"'... ' && /usr/local/bin/gtar -tzf "$VBOXTARGZFILE" >/dev/null 2>&1 && echo file is OK || echo file is INVALID

}

if [ -e "$VBOXTARGZFILE" ]
then
    read -p "file \"$VBOXTARGZFILE\" already exist, overwrite it (y/N)?" CONT1
    if [ "$CONT1" == "y" ]
    then
        rm "$VBOXTARGZFILE"
        archiving_tar_gz
    else
        :
    fi
else
    archiving_tar_gz
fi

# done
echo ''
echo 'done ;)'