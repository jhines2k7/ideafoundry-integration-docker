file="./failed_installs.txt"

if [[ -s $file ]] ; then
    echo "======> recreating kafka or mysql nodes if they have not been created ..."

    while read machine || [[ -n $machine ]] ; do
        if
    done < $file
    
else
    echo "======> there were no machines with failed docker installations ..."
fi ;