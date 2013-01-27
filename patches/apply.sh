#!/bin/bash
basedir=$(dirname $(readlink -f $0))
basedir=$(dirname $basedir)
echo "Rebuilding Forked projects.... "
function applyPatch {
    what=$1
    cd $basedir
    if [ ! -d "$basedir/EMC-$what" ]; then
        git clone github.com:aikar/EMC-$what EMC-$what
    fi
    cd $basedir/$what
    git branch -f upstream
    cd $basedir/EMC-$what
    echo "Synchronizing EMC-$what/master to $what/master"
    git remote rm upstream > /dev/null 2>&1
    git remote add upstream ../$what >/dev/null 2>&1
    git co master >/dev/null 2>&1
    git fetch upstream >/dev/null 2>&1
    git reset --hard upstream/upstream >/dev/null
    echo "  Applying patches to EMC-$what..."
    git am -3 $basedir/patches/$what/*.patch
    if [ "$?" != "0" ]; then
        echo "  Something did not apply cleanly to EMC-$what. "
        echo "  Please review above details and finish the apply then"
        echo "  save the changes with rebuildpatches.sh"
    else
        echo "  Patches applied cleanly to EMC-$what"
    fi
}
applyPatch Bukkit
applyPatch CraftBukkit
