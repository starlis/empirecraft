#!/bin/bash
basedir=$(dirname $(readlink -f $0))
basedir=$(dirname $basedir)
echo "Rebuilding patch files from current fork state..."
function savePatches {
    what=$1
    cd $basedir/EMC-$what/
    rm $basedir/patches/$what/*.patch
    git co master
    git format-patch -o $basedir/patches/$what upstream/master
    cd $basedir
    git add $basedir/patches/$what
    echo "  Patches saved for $what to patches/$what"
}

savePatches Bukkit
savePatches CraftBukkit
