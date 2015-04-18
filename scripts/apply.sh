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

echo "Rebuilding Forked projects.... "
function applyPatch {
	what=EMC-$1

	cd $basedir
	if [ ! -d Spigot/Spigot/$2 ]; then
		mkdir -p Spigot/Spigot/
		echo "Cloning $2"
		git clone git@bitbucket.org:starlis/$2 Spigot/Spigot/$2
	fi
	if [ ! -d $what ]; then
		git clone git@bitbucket.org:starlis/$what $what
	fi
	cd $basedir/$what
	echo "Synchronizing $what/master to $2/master"
	git remote rm upstream > /dev/null 2>&1
	git remote add upstream $basedir/Spigot/Spigot/$2 >/dev/null 2>&1
	git checkout master >/dev/null 2>&1
	git fetch upstream >/dev/null 2>&1
	git am --abort
	git clean -f
	git reset --hard upstream/master >/dev/null
	echo "  Applying patches to $what..."
	git am -3 $basedir/patches/$1/*.patch
	if [ "$?" != "0" ]; then
		echo "  Something did not apply cleanly to $what. "
		echo "  Please review above details and finish the apply then"
		echo "  save the changes with rebuildpatches.sh"
	else
		echo "  Patches applied cleanly to $what"
	fi
}
applyPatch Bukkit Spigot-API
applyPatch CraftBukkit Spigot-Server
