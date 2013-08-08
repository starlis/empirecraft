#!/bin/bash
# get base dir regardless of execution location
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
. $(dirname $SOURCE)/init.sh

function update {
    target=$1
    cd $basedir/$target
    git branch -f upstream
    cd $basedir/EMC-$target
    git co spigot
    git fetch spigot
    git reset --hard spigot/master
    #git fetch origin
    #git reset --hard origin/spigot
    git fetch upstream
    git reset --soft upstream/upstream
    if [[ $1 == "CraftBukkit" ]]; then
        $basedir/scripts/importmcdev.sh
    fi
    git add .
    git commit -a --author="md_5 <md_5@bigpond.com>" -m "Spigot" > /dev/null
    git format-patch --stdout HEAD^ > ../patches/$target/0001-Spigot.patch
    git co master
    cd $basedir/patches/$target
    git add 0001-Spigot.patch
    cleanupPatches $basedir/patches/$target
}

update Bukkit
update CraftBukkit
