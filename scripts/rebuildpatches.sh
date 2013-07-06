#!/bin/bash
# get base dir regardless of execution location
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
. $(dirname $SOURCE)/init.sh

echo "Rebuilding patch files from current fork state..."

function savePatches {
    what=$1
    cd $basedir/EMC-$what/
    rm $basedir/patches/$what/*.patch
    git co master
    git format-patch --quiet -N -o $basedir/patches/$what upstream/upstream
    cd $basedir
    git add --ignore-removal $basedir/patches/$what
    cleanupPatches $basedir/patches/$what/
    echo "  Patches saved for $what to patches/$what"
    
}

savePatches Bukkit
savePatches CraftBukkit
