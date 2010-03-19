#!/bin/sh

FORCE_FRESH_INSTALL="yes"

NIMBUS_SRC_REL="`dirname $0`/.."
NIMBUS_SRC=`cd $NIMBUS_SRC_REL; pwd`

if [ "X$1" == "X" ]; then
    echo ""
    echo "Usage: $0 destination_dir"
    echo "    You must specify the destination directory.\n"
    exit 1
fi

NIMBUS_HOME=$1

if [ -d $NIMBUS_HOME ] && [ "$(ls -A $NIMBUS_HOME)" ]; then
    if [ $FORCE_FRESH_INSTALL == "yes" ]; then
        echo ""
        echo "The destination directory '$NIMBUS_HOME' exists and is not empty."
        echo "It is not recommended to reinstall Nimbus into an existing install."
        echo ""
        echo "If you are making changes to the services, you can build and install those directly:"
        echo "    export GLOBUS_LOCATION=$NIMBUS_HOME/services"
        echo "    scripts/all-build-and-install.sh"
        echo ""
        echo "If you know what you are doing and want to reinstall, edit this script:"
        echo "    $0"
        echo "and change FORCE_FRESH_INSTALL to \"no\""
        echo ""

        exit 1
    fi
fi

$NIMBUS_SRC/bin/create-nimbus-home.sh $NIMBUS_HOME

if [ $? -ne 0 ]; then
    echo "Nimbus home creation failed!"
    exit 1
fi

CONFIG_SCRIPT="$NIMBUS_HOME/bin/nimbus-configure"

if [ ! -f $CONFIG_SCRIPT ]; then
    echo "Configuration script could not be found: $CONFIG_SCRIPT"
    exit 1
fi

$CONFIG_SCRIPT

if [ $? -ne 0 ]; then
    echo "Nimbus configuration script failed! You may try running it manually:"
    echo "    $CONFIG_SCRIPT"
    exit 1
fi

echo ""
echo "Nimbus installation succeeded!"
echo "However, additional configuration may be necessary."
echo "Refer to the Administrator Guide for details."
echo ""
echo "You can now start/stop Nimbus services with the nimbusctl command. e.g:"
echo "    $NIMBUS_HOME/bin/nimbusctl start"
echo ""

exit 0