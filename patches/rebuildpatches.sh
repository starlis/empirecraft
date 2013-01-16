#!/bin/bash
basedir=$(dirname $(readlink -f $0))
basedir=$(dirname $basedir)
echo "Rebuilding patch files from current fork state..."
function cleanupPatches {
    cd $1
    for patch in *.patch; do
        lines=$(git diff --staged $patch | grep -E "^(\+|\-)" | grep -Ev "(From [a-z0-9]{32,}|--- a|+++ b)" | wc -l)
        if [ "$lines" == "0" ] ; then
            git reset HEAD $patch >/dev/null
            git checkout -- $patch >/dev/null
        fi
    done
}
function savePatches {
    what=$1
    cd $basedir/EMC-$what/
    rm $basedir/patches/$what/*.patch
    git co master
    git format-patch --quiet -N -o $basedir/patches/$what upstream/master
    cd $basedir
    git add $basedir/patches/$what
    cleanupPatches $basedir/patches/$what/
    echo "  Patches saved for $what to patches/$what"
    
}

savePatches Bukkit
savePatches CraftBukkit
