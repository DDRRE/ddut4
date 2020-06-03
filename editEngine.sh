#!/bin/bash

for cnffiles in ddut4_init.def
        do
                if [ -f "$cnffiles" ]
                        then
                                source "$cnffiles"
                                if [[ $? != '0' ]]
                                        then
                                                echo "Couldn't load ${cnffiles}. Terminating."
                                                exit 1
                                #no need for 'else' here
                                fi
                                #iecho "Loaded configuration file: $(pwd)/${cnffiles}"
                        else
                                echo "Couldn't find ${cnffiles}. Terminating."
                                exit 1
                fi
        done


if which nano &>/dev/null
        then
                editor='nano'
        else
                editor='vi'
fi

if [[ $1 == '' ]]
        then
                echo "No SRVNAME specified."
                echo "Usage: editEngine.sh SRVNAME [nosync]"
                exit 1
fi
if [[ $2 == 'nosync' ]]
        then
                nosync=1
fi

if [ ! -f ${rootdir}/ut4-"$1"/UnrealTournament/Saved/Config/LinuxServer/Engine.ini ]
        then
                echo "NOTE: ${rootdir}/ut4-$1/UnrealTournament/Saved/Config/LinuxServer/Engine.ini doesn't exist."
                read -p "Press enter to continue."
fi
$editor ${rootdir}/ut4-"$1"/UnrealTournament/Saved/Config/LinuxServer/Engine.ini

if [[ $nosync != '1' ]] && [[ $? == 0 ]]
        then
                echo "Syncing Engine.ini for ${1} to ${1}-Engine.ini"
                echo "(disable this by running editEngine.sh SRVNAME nosync)"
                cp ${rootdir}/ut4-"$1"/UnrealTournament/Saved/Config/LinuxServer/Engine.ini ${confdir}/"${1}"-Engine.ini
fi
