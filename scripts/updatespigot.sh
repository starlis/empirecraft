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
    git fetch upstream
    git reset --soft upstream/upstream
    git commit -a --author="md_5 <md_5@bigpond.com>" -m "Spigot"
    git format-patch --stdout HEAD^ > ../patches/$target/0001-Spigot.patch
    git co master
}

update Bukkit
update CraftBukkit
