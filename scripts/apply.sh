#!/bin/bash
# get base dir regardless of execution location
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
. $(dirname $SOURCE)/init.sh

echo "Rebuilding Forked projects.... "
function applyPatch {
    what=$1
    cd $basedir
    if [ ! -f "$basedir/Bukkit/pom.xml" ]; then
	cd ..
	git submodule init --update
	cd $basedir
    fi
    if [ ! -d "$basedir/EMC-$what" ]; then
        git clone github.com:aikar/EMC-$what EMC-$what
    fi
    cd $basedir/$what
    git branch -f upstream
    cd $basedir/EMC-$what
    echo "Synchronizing EMC-$what/master to $what/master"
    git remote rm upstream > /dev/null 2>&1
    git remote add upstream ../$what >/dev/null 2>&1
    git checkout master >/dev/null 2>&1
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
