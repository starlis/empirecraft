#!/bin/bash
# get base dir regardless of execution location
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
. $(dirname $SOURCE)/init.sh

PS1="$"
echo "Rebuilding patch files from current fork state..."
spigotVer=$(cat current-spigot)
function savePatches {
    what=$1
    cd $basedir/$what/
    rm $basedir/patches/$2/*.patch
    git co master
    git format-patch --quiet -N -o $basedir/patches/$2 $spigotVer
    cd $basedir
    git add --ignore-removal $basedir/patches/$2
    cleanupPatches $basedir/patches/$2/
    echo "  Patches saved for $what to patches/$2"
}

savePatches EmpireCraft-API bukkit
savePatches EmpireCraft-Server craftbukkit
