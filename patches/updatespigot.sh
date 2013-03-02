#!/bin/bash
basedir=$(dirname $(readlink -f $0))
basedir=$(dirname $basedir)
function update {
    target=$1
    cd $basedir/$target
    git branch -f upstream
    cd $basedir/EMC-$target
    git co spigot
    git fetch spigot
    git reset --hard spigot/master
    git fetch upstream
    git reset --soft upstream/upstream
    git commit -a --author="md_5 <md_5@bigpond.com>" -m "Spigot"
    git format-patch --stdout HEAD^ > ../patches/$target/0001-Spigot.patch
    git co master
}

update Bukkit
update CraftBukkit
