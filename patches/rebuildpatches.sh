#!/bin/bash
basedir=$(dirname $(readlink -f $0))
basedir=$(dirname $basedir)
echo "Rebuilding patch files from current fork state..."
function cleanupPatches {
    cd $1
    for patch in *.patch; do
        gitver=$(tail -n 2 $patch | grep -ve "^$" | tail -n 1)
        diffs=$(git diff --staged $patch | grep -E "^(\+|\-)" | grep -Ev "(From [a-z0-9]{32,}|\-\-\- a|\+\+\+ b|.index)")

        testver=$(echo "$diffs" | tail -n 2 | grep -ve "^$" | tail -n 1 | grep "$gitver")
        if [ "x$testver" != "x" ]; then
            diffs=$(echo "$diffs" | head -n -2)
        fi


        if [ "x$diffs" == "x" ] ; then
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
    git format-patch --quiet -N -o $basedir/patches/$what upstream/upstream
    cd $basedir
    git add $basedir/patches/$what
    cleanupPatches $basedir/patches/$what/
    echo "  Patches saved for $what to patches/$what"
    
}

savePatches Bukkit
savePatches CraftBukkit
