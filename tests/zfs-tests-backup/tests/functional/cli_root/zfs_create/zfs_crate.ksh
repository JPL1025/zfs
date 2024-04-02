#!/bin/ksh
zfs create -b 512 -o copies=3 -V 1G -b 512 -o copies=3 -V 1G -b 512 -o copies=3 -V 1G -b 512 -o copies=3 -V 1G -b 512 -o copies=3 -V 1G -b 512 -o copies=3 -V 1G
