#!/bin/bash

# Check if the script is run as root (UID 0)
if [ "$UID" -eq 0 ]; then
    echo "This script should not be run as root. Please run as a regular user."
    exit 1
fi

#Reset test directory
./reset.sh

#All test scripts to be tested
#Can be added to in the future
testsArray=(
	"zfs-tests/tests/functional/cli_root/zfs_create/zfs_create_011_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_create/zfs_create_014_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_create/zfs_create_012_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_create/zfs_create_001_pos.ksh"
	"zfs-tests/tests/functional/limits/snapshot_limit.ksh"
	"zfs-tests/tests/functional/limits/filesystem_limit.ksh"
	"zfs-tests/tests/functional/limits/filesystem_count.ksh"
	"zfs-tests/tests/functional/limits/snapshot_count.ksh"
	"zfs-tests/tests/functional/features/large_dnode/large_dnode_007_neg.ksh"
	"zfs-tests/tests/functional/features/large_dnode/large_dnode_001_pos.ksh"
	"zfs-tests/tests/functional/features/large_dnode/large_dnode_008_pos.ksh"
	"zfs-tests/tests/functional/features/large_dnode/large_dnode_006_pos.ksh"
	"zfs-tests/tests/functional/features/large_dnode/large_dnode_009_pos.ksh"
	"zfs-tests/tests/functional/snapused/snapused_003_pos.ksh"
	"zfs-tests/tests/functional/snapused/snapused_005_pos.ksh"
	"zfs-tests/tests/functional/rsend/send_spill_block.ksh"
	"zfs-tests/tests/functional/rsend/send_holds.ksh"
	"zfs-tests/tests/functional/rsend/send-c_mixed_compression.ksh"
	"zfs-tests/tests/functional/rsend/send_realloc_files.ksh"
	"zfs-tests/tests/functional/rsend/rsend_010_pos.ksh"
	"zfs-tests/tests/functional/rsend/rsend_009_pos.ksh"
	"zfs-tests/tests/functional/reservation/reservation_018_pos.ksh"
	"zfs-tests/tests/functional/reservation/reservation_009_pos.ksh"
	"zfs-tests/tests/functional/reservation/reservation_012_pos.ksh"
	"zfs-tests/tests/functional/reservation/reservation_021_neg.ksh"
	"zfs-tests/tests/functional/reservation/reservation_010_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_reservation/zfs_reservation_002_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_reservation/zfs_reservation_001_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_program/zfs_program_json.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_send/zfs_send_001_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_send/zfs_send_006_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_send/zfs_send-b.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_send/zfs_send_sparse.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_send/zfs_send_002_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zpool_create/zpool_create_010_neg.ksh"
	"zfs-tests/tests/functional/cli_root/zfs/zfs_002_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_share/zfs_share_011_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_share/zfs_share_006_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_unmount/zfs_unmount_009_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_unmount/zfs_unmount_001_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_destroy/zfs_destroy_004_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_destroy/zfs_destroy_014_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_destroy/zfs_destroy_015_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_diff/zfs_diff_types.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_diff/zfs_diff_changes.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_clone/zfs_clone_010_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_clone/zfs_clone_004_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_receive/zfs_receive_-e.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_receive/zfs_receive_013_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_receive/zfs_receive_002_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_receive/zfs_receive_007_neg.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_receive/zfs_receive_014_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_receive/zfs_receive_006_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_receive/zfs_receive_012_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_receive/zfs_receive_008_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_receive/zfs_receive_015_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_receive/zfs_receive_001_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_receive/zfs_receive_005_neg.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_receive/zfs_receive_011_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zpool_clear/zpool_clear_001_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zpool_import/zpool_import_012_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zpool_import/zpool_import_errata4.ksh"
	"zfs-tests/tests/functional/cli_root/zpool_import/setup.ksh"
	"zfs-tests/tests/functional/cli_root/zpool_import/zpool_import_rename_001_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_rename/setup.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_rename/zfs_rename_014_neg.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_property/zfs_written_property_001_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_upgrade/zfs_upgrade_001_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_upgrade/zfs_upgrade_005_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_upgrade/zfs_upgrade_004_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_upgrade/zfs_upgrade_003_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_mount/zfs_mount_008_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_mount/zfs_mount_006_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_mount/zfs_multi_mount.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_mount/zfs_mount_test_race.ksh"
	"zfs-tests/tests/functional/cli_root/zpool_set/zpool_set_002_neg.ksh"
	"zfs-tests/tests/functional/cli_root/zpool_split/zpool_split_props.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_unshare/zfs_unshare_002_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_unshare/zfs_unshare_001_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_unshare/zfs_unshare_006_pos.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_snapshot/zfs_snapshot_005_neg.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_snapshot/zfs_snapshot_004_neg.ksh"
	"zfs-tests/tests/functional/cli_root/zfs_snapshot/zfs_snapshot_009_pos.ksh"
	"zfs-tests/tests/functional/quota/quota_005_pos.ksh"
	"zfs-tests/tests/functional/replacement/replacement_002_pos.ksh"
	"zfs-tests/tests/functional/replacement/replacement_003_pos.ksh"
	"zfs-tests/tests/functional/replacement/replacement_001_pos.ksh"
	"zfs-tests/tests/functional/privilege/privilege_001_pos.ksh"
	"zfs-tests/tests/functional/privilege/privilege_002_pos.ksh"
	"zfs-tests/tests/functional/online_offline/online_offline_003_neg.ksh"
	"zfs-tests/tests/functional/delegate/zfs_unallow_005_pos.ksh"
	"zfs-tests/tests/functional/delegate/zfs_allow_006_pos.ksh"
	"zfs-tests/tests/functional/delegate/zfs_allow_007_pos.ksh"
	"zfs-tests/tests/functional/delegate/zfs_unallow_007_neg.ksh"
	"zfs-tests/tests/functional/delegate/zfs_allow_004_pos.ksh"
	"zfs-tests/tests/functional/delegate/zfs_allow_008_pos.ksh"
	"zfs-tests/tests/functional/delegate/zfs_allow_005_pos.ksh"
	"zfs-tests/tests/functional/delegate/zfs_allow_003_pos.ksh"
	"zfs-tests/tests/functional/pool_checkpoint/checkpoint_sm_scale.ksh"
	"zfs-tests/tests/functional/removal/removal_with_create_fs.ksh"
	"zfs-tests/tests/functional/bootfs/bootfs_004_neg.ksh"
	"zfs-tests/tests/functional/bootfs/bootfs_006_pos.ksh"
	"zfs-tests/tests/functional/bootfs/bootfs_007_pos.ksh"
	"zfs-tests/tests/functional/bootfs/bootfs_005_neg.ksh"
	"zfs-tests/tests/functional/bootfs/bootfs_008_pos.ksh"
	"zfs-tests/tests/functional/bootfs/bootfs_003_pos.ksh"
	"zfs-tests/tests/functional/bootfs/bootfs_001_pos.ksh"
	"zfs-tests/tests/functional/refreserv/refreserv_003_pos.ksh"
	"zfs-tests/tests/functional/refreserv/refreserv_001_pos.ksh"
	"zfs-tests/tests/functional/refreserv/refreserv_002_pos.ksh"
	"zfs-tests/tests/functional/no_space/enospc_002_pos.ksh"
	"zfs-tests/tests/functional/channel_program/synctask_core/tst.get_count_and_limit.ksh"
	"zfs-tests/tests/functional/channel_program/synctask_core/tst.get_neg.ksh"
	"zfs-tests/tests/functional/channel_program/synctask_core/tst.snapshot_neg.ksh"
	"zfs-tests/tests/functional/channel_program/synctask_core/tst.snapshot_destroy.ksh"
	"zfs-tests/tests/functional/channel_program/synctask_core/tst.list_children.ksh"
	"zfs-tests/tests/functional/channel_program/synctask_core/tst.destroy_fs.ksh"
	"zfs-tests/tests/functional/channel_program/synctask_core/tst.snapshot_recursive.ksh"
	"zfs-tests/tests/functional/channel_program/synctask_core/tst.promote_multiple.ksh"
	"zfs-tests/tests/functional/channel_program/synctask_core/tst.get_string_props.ksh"
	"zfs-tests/tests/functional/channel_program/synctask_core/tst.get_mountpoint.ksh"
	"zfs-tests/tests/functional/channel_program/synctask_core/tst.snapshot_simple.ksh"
	"zfs-tests/tests/functional/channel_program/synctask_core/tst.promote_conflict.ksh"
	"zfs-tests/tests/functional/channel_program/synctask_core/tst.terminate_by_signal.ksh"
	"zfs-tests/tests/functional/channel_program/synctask_core/tst.get_written.ksh"
	"zfs-tests/tests/functional/channel_program/synctask_core/tst.promote_simple.ksh"
	"zfs-tests/tests/functional/channel_program/lua_core/tst.return_large.ksh"
	"zfs-tests/tests/functional/refquota/refquota_008_neg.ksh"
	"zfs-tests/tests/functional/refquota/refquota_005_pos.ksh"
	"zfs-tests/tests/functional/refquota/refquota_003_pos.ksh"
	"zfs-tests/tests/functional/refquota/refquota_001_pos.ksh"
	"zfs-tests/tests/functional/refquota/refquota_004_pos.ksh"
	"zfs-tests/tests/functional/refquota/refquota_007_neg.ksh"
	"zfs-tests/tests/functional/refquota/refquota_002_pos.ksh"
	"zfs-tests/tests/functional/grow/grow_replicas_001_pos.ksh"
	"zfs-tests/tests/functional/grow/grow_pool_001_pos.ksh"
	"zfs-tests/tests/functional/history/history_004_pos.ksh"
	"zfs-tests/tests/functional/history/history_003_pos.ksh"
	"zfs-tests/tests/functional/history/history_010_pos.ksh"
	"zfs-tests/tests/functional/history/history_008_pos.ksh"
	"zfs-tests/tests/functional/history/history_006_neg.ksh"
	"zfs-tests/tests/functional/procfs/procfs_list_basic.ksh"
	"zfs-tests/tests/functional/procfs/procfs_list_concurrent_readers.ksh"
	"zfs-tests/tests/functional/mount/setup.ksh"
	"zfs-tests/tests/functional/snapshot/clone_001_pos.ksh"
	"zfs-tests/tests/functional/snapshot/rollback_003_pos.ksh"
	"zfs-tests/tests/functional/snapshot/snapshot_016_pos.ksh"
	"zfs-tests/tests/functional/snapshot/snapshot_017_pos.ksh"
	"zfs-tests/tests/functional/slog/slog_replay_fs_001.ksh"
	"zfs-tests/tests/functional/slog/slog_replay_fs_002.ksh"
	"zfs-tests/tests/functional/inheritance/inherit_001_pos.ksh"
	"zfs-tests/tests/functional/fault/auto_spare_001_pos.ksh"
	"zfs-tests/tests/functional/upgrade/upgrade_userobj_001_pos.ksh"
	"zfs-tests/tests/functional/upgrade/upgrade_projectquota_001_pos.ksh"
)

# Check the number of arguments passed
if [ $# -eq 0 ]; then
    echo "No arguments provided."

    readarray -t statesArray < states.txt
    #readarray -t testsArray < testfiles.txt

    echo "Running full suite."

elif [ $# -eq 1 ]; then
    echo "One argument provided: $1"


    if [[ "$1" == *"ksh"* ]]; then
	readarray -t statesArray < states.txt
	testsArray=($1)
	echo "Running test over all states"
    else
	statesArray=("$1")
	#readarray -t testsArray < zfscreatefiles.txt
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

echo "49"

#COMMAND="./zfs-tests.sh -t ../zfs-tests/tests/functional/cli_root/zfs_create/zfs_create_001_pos.ksh"

for script in "${testsArray[@]}"; do

    echo "55"

    COMMAND="./zfs-tests.sh -t ../$script"

    # Default command to replace
    replace="zfs create"

    echo "62"

    for state in "${statesArray[@]}"; do

	echo "$script"

	#Replace the state in the current test
	sudo sed -i "s/$replace/$state/g" "$script"

	echo "71"

	#Print state being tested
	echo -e "\n\nNow testing: \n$state\n$script\n"

	#Execute the test
	$COMMAND

	#Set so the next test can read it
	replace="$state"

    done

done

#Reset test directory
./reset.sh

exit 0
