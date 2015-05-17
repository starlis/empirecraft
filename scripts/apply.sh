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

spigotVer=$(cat current-spigot)
echo "Rebuilding Forked projects.... "
function applyPatch {
	what=$1

	cd $basedir
	if [ ! -d $what ]; then
		git clone git@bitbucket.org:starlis/$2 $what
	fi
	cd $basedir/$what
	echo "Synchronizing $what/master to $2/$spigotVer"
	git remote rm origin > /dev/null 2>&1
	git remote add origin git@bitbucket.org:starlis/$what >/dev/null 2>&1
	git remote rm upstream > /dev/null 2>&1
	git remote add upstream git@bitbucket.org:starlis/$2 >/dev/null 2>&1

	git checkout master >/dev/null 2>&1
	git fetch --all --tags
	git am --abort
	git clean -f

	git reset --hard "$spigotVer" >/dev/null
	git branch -D upstream 2>/dev/null
	git branch upstream
	echo "  Applying patches to $what..."
	git am -3 $basedir/patches/$3/*.patch
	if [ "$?" != "0" ]; then
		echo "  Something did not apply cleanly to $what. "
		echo "  Please review above details and finish the apply then"
		echo "  save the changes with rebuildpatches.sh"
	else
		echo "  Patches applied cleanly to $what"
	fi
}
applyPatch EmpireCraft-API Spigot-API bukkit
applyPatch EmpireCraft-Server Spigot-Server craftbukkit
basedir
scripts/generatesources