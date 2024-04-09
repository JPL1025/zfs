#!/bin/bash

# Check if the script is run as root (UID 0)
if [ "$UID" -eq 0 ]; then
    echo "This script should not be run as root. Please run as a regular user."
    exit 1
fi

#Reset test directory
./reset.sh

# Check the number of arguments passed
if [ $# -eq 0 ]; then
    echo "No arguments provided."

    readarray -t statesArray < states.txt
    readarray -t testsArray < zfscreatefiles.txt
    
    echo "Running full suite."
    
elif [ $# -eq 1 ]; then
    echo "One argument provided: $1"


    if [[ "$1" == *"ksh"* ]]; then
	readarray -t statesArray < states.txt
	testsArray=($1)
	echo "Running test over all states"
    else
        statesArray=($1)
	readarray -t testsArray < zfscreatefiles.txt	
	echo "Running all tests with one state"
    fi

elif [ $# -eq 2 ]; then
    echo "Two arguments provided: $1 and $2"

    if [[ "$1" == *"ksh"* ]]; then
	statesArray=($2)
	testsArray=($1)
    else
        statesArray=($1)
	testsArray=($2)     
    fi
    
    echo "Running specific test."
fi

    
#COMMAND="./zfs-tests.sh -t ../zfs-tests/tests/functional/cli_root/zfs_create/zfs_create_001_pos.ksh"

for script in "${testsArray[@]}"; do
	
    COMMAND="./zfs-tests.sh -t ../${script}"

    # Default command to replace
    replace="zfs create"

    for state in "${statesArray[@]}"; do

	#Replace the state in the current test
	sudo sed -i "s/$replace/$state/g" ${script}

	#Print state being tested
	echo -e "\n\nNow testing: $state \n"

	#Execute the test
	$COMMAND
	
	#Set so the next test can read it
	replace="$state"
	
    done
    
done

#Reset test directory
./reset.sh

exit 0

