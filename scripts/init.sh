#!/bin/bash
cd $(dirname $SOURCE)/../
basedir=$(pwd)

emcb=$basedir/EMC-Bukkit
emccb=$basedir/EMC-CraftBukkit


function cleanupPatches {
    cd $1
    for patch in *.patch; do
        gitver=$(tail -n 2 $patch | grep -ve "^$" | tail -n 1)
        diffs=$(git diff --staged $patch | grep -E "^(\+|\-)" | grep -Ev "(From [a-z0-9]{32,}|\-\-\- a|\+\+\+ b|.index|Date\: )")

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
