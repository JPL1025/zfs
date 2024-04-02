#!/bin/bash

echo "Removing test directory"

rm -rf zfs-tests

echo "Replacing test directory with backup"

cp -R zfs-tests-backup zfs-tests

exit 0

