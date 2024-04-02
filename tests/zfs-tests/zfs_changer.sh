#!/bin/bash

# Check if the script is run as root (UID 0)
if [ "$UID" -eq 0 ]; then
    echo "This script should not be run as root. Please run as a regular user."
    exit 1
fi

readarray -t statesArray < states.txt

COMMAND="./zfs-tests.sh -t ../zfs-tests/tests/functional/cli_root/zfs_create/zfs_create_001_pos.ksh"

# Default command to replace
replace="zfs create"

for state in "${statesArray[@]}"; do

    #Replace the state in the current test
    sudo sed -i "s/$replace/$state/g" zfs-tests/tests/functional/cli_root/zfs_create/zfs_create_001_pos.ksh

    #Print state being tested
    echo -e "\n\nNow testing: $state \n"

    #Execute the test
    $COMMAND
    
    #Set so the next test can read it
    replace="$state"
    
done

exit 0

