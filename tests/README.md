
# ZFS Custom Test Suite README

### 1) Building and installing the Custom ZFS Test Suite

The ZFS Test Suite runs under the test-runner framework.  This framework
is built along side the standard ZFS utilities. The zfs-test package can
be built from source as follows:

    $ ./configure
    $ make pkg-utils

The resulting packages can be installed using the rpm or dpkg command as
appropriate for your distributions.

    - Installed from source
    $ rpm -ivh ./zfs-test*.rpm, or
    $ dpkg -i ./zfs-test*.deb

### 2) Running the Custom ZFS Test Suite

The pre-requisites for running the ZFS Test Suite are:

* Three scratch disks
    * Specify the disks you wish to use in the $DISKS variable in zfs-tests.sh
    * as a space delimited list like this: DISKS='vdb vdc vdd'.
    * By default the zfs-tests.sh script will construct three loopback devices
    * to be used for testing: DISKS='loop0 loop1 loop2'.
* A non-root user with a full set of basic privileges and the ability
  to sudo(8) to root without a password to run the test.
* Specify any pools you wish to preserve as a space delimited list in
  the $KEEP variable in zfs-tests.sh. All pools detected at the start of
* testing are added automatically.
* The original and custom ZFS Test Suite will add users and groups to
* test machine to verify functionality.  Therefore it is strongly advised that a
  dedicated test machine, which can be a VM, be used for testing. It is
* inadvisable to use this suite on a non-test machine
* On FreeBSD, mountd(8) must use `/etc/zfs/exports`
  as one of its export files – by default this can be done by setting
  `zfs_enable=yes` in `/etc/rc.conf`.

Once the pre-requisites are satisfied simply run the custom test script:

    $ ./suite.sh (from within the zfs/tests directory)

Running it this way will run the entire suite (which will take a long time).

To run a subset of the test suite, we can add one of the tests found in
testsArray in suite.sh as a parameter to test only from that test, as shown below:

    $ ./suite.sh zfs-tests/tests/functional/cli_root/zfs_create/zfs_create_001_pos.ksh (from within the zfs/tests directory)

We can also use one of the zfs configurations found in states.txt to test all
tests with just one state: (NOTE: the quotations are required!)

    $ ./suite.sh "zfs create" (from within the zfs/tests directory)

Finally, we can specify both a test and a state (order does not matter) to run
the test with that state (just one test run).

    $ ./suite.sh zfs-tests/tests/functional/cli_root/zfs_create/zfs_create_001_pos.ksh "zfs create" (from within the zfs/tests directory)

### 3) Test results

While the ZFS Test Suite is running, one informational line is printed at the
end of each test, and a results summary is printed at the end of the run. The
results summary includes the location of the complete logs, which is logged in
the form `/var/tmp/test_results/[ISO 8601 date]`.  A normal test run launched
with the `zfs-tests.sh` wrapper script will look something like this:

    $ /usr/share/zfs/zfs-tests.sh -v -d /tmp/test

    --- Configuration ---
    Runfile:         /usr/share/zfs/runfiles/linux.run
    STF_TOOLS:       /usr/share/zfs/test-runner
    STF_SUITE:       /usr/share/zfs/zfs-tests
    STF_PATH:        /var/tmp/constrained_path.G0Sf
    FILEDIR:         /tmp/test
    FILES:           /tmp/test/file-vdev0 /tmp/test/file-vdev1 /tmp/test/file-vdev2
    LOOPBACKS:       /dev/loop0 /dev/loop1 /dev/loop2
    DISKS:           loop0 loop1 loop2
    NUM_DISKS:       3
    FILESIZE:        4G
    ITERATIONS:      1
    TAGS:            functional
    Keep pool(s):    rpool


    /usr/share/zfs/test-runner/bin/test-runner.py  -c /usr/share/zfs/runfiles/linux.run \
        -T functional -i /usr/share/zfs/zfs-tests -I 1
    Test: /usr/share/zfs/zfs-tests/tests/functional/arc/setup (run as root) [00:00] [PASS]
    ...more than 1100 additional tests...
    Test: /usr/share/zfs/zfs-tests/tests/functional/zvol/zvol_swap/cleanup (run as root) [00:00] [PASS]

    Results Summary
    SKIP     52
    PASS    1129

    Running Time:  02:35:33
    Percent passed:    95.6%
    Log directory: /var/tmp/test_results/20180515T054509

### 4) Adding an existing test case to the custom suite

If adding an already-existing test case to the custom suite, we need to
add the file path relative to the zfs/tests directory to testfiles.txt.

This test case should have the "zfs create" command in it and instances of
the command should not have any options already on them (this is for the
custom suite to do).

The zfscreatefiles.txt file is also available for testing purposes.

### 5) Adding an entirely new test-case

NOTE: this probably will not be needed for the purposes of DSL

If adding a whole new test case, the below steps should be followed:

This broadly boils down to 5 steps
1. Create/Set password-less sudo for user running test case.
2. Edit configure.ac, Makefile.am appropriately
3. Create/Modify .run files
4. Create actual test-scripts
5. Run Test case

Will look at each of them in depth.

* Set password-less sudo for 'Test' user as test script cannot be run as root
* Edit file **configure.ac** and include line under AC_CONFIG_FILES section
  ~~~~
    tests/zfs-tests/tests/functional/cli_root/zpool_example/Makefile
  ~~~~
* Edit file **tests/runfiles/Makefile.am** and add line *zpool_example*.
  ~~~~
    pkgdatadir = $(datadir)/@PACKAGE@/runfiles
    dist_pkgdata_DATA = \
      zpool_example.run \
      common.run \
      freebsd.run \
      linux.run \
      longevity.run \
      perf-regression.run \
      sanity.run \
      sunos.run
  ~~~~
* Create file **tests/runfiles/zpool_example.run**. This defines the most
  common properties when run with test-runner.py or zfs-tests.sh.
  ~~~~
    [DEFAULT]
    timeout = 600
    outputdir = /var/tmp/test_results
    tags = ['functional']

    tests = ['zpool_example_001_pos']
  ~~~~
  If adding test-case to an already existing suite the runfile would
  already be present and it needs to be only updated. For example, adding
  **zpool_example_002_pos** to the above runfile only update the **"tests ="**
  section of the runfile as shown below
  ~~~~
    [DEFAULT]
    timeout = 600
    outputdir = /var/tmp/test_results
    tags = ['functional']

    tests = ['zpool_example_001_pos', 'zpool_example_002_pos']
  ~~~~

* Edit **tests/zfs-tests/tests/functional/cli_root/Makefile.am** and add line
  under SUBDIRS.
  ~~~~
    zpool_example \ (Make sure to escape the line end as there will be other folders names following)
  ~~~~
* Create new file **tests/zfs-tests/tests/functional/cli_root/zpool_example/Makefile.am**
  the contents of the file could be as below. What it says it that now we have
  a test case *zpool_example_001_pos.ksh*
  ~~~~
    pkgdatadir = $(datadir)/@PACKAGE@/zfs-tests/tests/functional/cli_root/zpool_example
    dist_pkgdata_SCRIPTS = \
      zpool_example_001_pos.ksh
  ~~~~
* We can now create our test-case zpool_example_001_pos.ksh under
  **tests/zfs-tests/tests/functional/cli_root/zpool_example/**.
  ~~~~
  # DESCRIPTION:
  #    zpool_example Test
  #
  # STRATEGY:
  #    1. Demo a very basic test case
  #

  DISKS_DEV1="/dev/loop0"
  DISKS_DEV2="/dev/loop1"
  TESTPOOL=EXAMPLE_POOL

  function cleanup
  {
      # Cleanup
      destroy_pool $TESTPOOL
      log_must rm -f $DISKS_DEV1
      log_must rm -f $DISKS_DEV2
  }

  log_assert "zpool_example"
  # Run function "cleanup" on exit
  log_onexit cleanup

  # Prep backend device
  log_must dd if=/dev/zero of=$DISKS_DEV1 bs=512 count=140000
  log_must dd if=/dev/zero of=$DISKS_DEV2 bs=512 count=140000

  # Create pool
  log_must zpool create $TESTPOOL $type $DISKS_DEV1 $DISKS_DEV2

  log_pass "zpool_example"
  ~~~~
* Run Test case, which can be done in two ways. Described in detail above in
  section 2.
    * test-runner.py (This takes run file as input. See *zpool_example.run*)
    * zfs-tests.sh. Can execute the run file or individual tests
