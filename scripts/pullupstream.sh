#!/bin/bash
# get base dir regardless of execution location
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
. $(dirname $SOURCE)/init.sh

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
	echo -e "Update B: $bdesc - CB: $cbdesc\n\nBukkit:\n$bdiff\n\nCraftBukkit:\n$cbdiff" | git commit Bukkit CraftBukkit -F -
fi
