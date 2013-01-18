#!/bin/bash
basedir=$(dirname $(readlink -f $0))
basedir=$(dirname $basedir)

cd $basedir/Bukkit
git fetch origin
bdiff=$(git log --oneline origin/master...HEAD)
git reset --hard origin/master
git branch -f upstream
bdesc=$(git describe)
cd $basedir/CraftBukkit
git fetch origin
cbdiff=$(git log --oneline origin/master...HEAD)
git reset --hard origin/master
git branch -f upstream
cbdesc=$(git describe)

cd ..
if [ "x${bdiff}x${cbdiff}" != "xx" ]; then
	echo -e "Update Bukkit: $bdesc - CraftBukkit: $cbdesc\nBukkit:\n$bdiff\n\nCraftBukkit:\n$cbdiff" | git commit Bukkit CraftBukkit -F -
fi
