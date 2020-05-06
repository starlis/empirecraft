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

paperVer=$(cat current-paper)

gitcmd="git -c commit.gpgsign=false -c core.safecrlf=false"
echo "Rebuilding Forked projects.... "
function applyPatch {
	what=$1
	what_name=$(basename $what)
	target=$2
	branch=$3
	patch_folder=$4

	cd "$basedir/$what"
	git fetch --all
	git branch -f upstream "$branch" >/dev/null

	cd "$basedir"
	if [ ! -d  "$basedir/$target" ]; then
		mkdir "$basedir/$target"
		cd "$basedir/$target"
		git init
		git remote add origin $5
		cd "$basedir"
	fi
	cd "$basedir/$target"

	echo "Resetting $target to $what_name..."
	git remote rm upstream > /dev/null 2>&1
	git remote add upstream $basedir/$what >/dev/null 2>&1
	($gitcmd am --abort ; git rebase --abort) 1>&2 2>/dev/null || true
	git checkout master 2>/dev/null
	git fetch upstream >/dev/null 2>&1
	git reset --hard upstream/upstream
	echo "  Applying patches to $target..."
	statusfile=".git/patch-apply-failed"
	rm -f "$statusfile"
	$gitcmd am --abort >/dev/null 2>&1
	$gitcmd am --3way --ignore-whitespace "$basedir/patches/$patch_folder/"*.patch
	if [ "$?" != "0" ]; then
		echo 1 > "$statusfile"
		echo "  Something did not apply cleanly to $target."
		echo "  Please review above details and finish the apply then"
		echo "  save the changes with rebuildPatches.sh"
		exit 1
	else
		rm -f "$statusfile"
		echo "  Patches applied cleanly to $target"
	fi
}
(
	(applyPatch Paper/Paper-API ${FORK_NAME}-API HEAD api $API_REPO &&
	applyPatch Paper/Paper-Server ${FORK_NAME}-Server HEAD server $SERVER_REPO) || exit 1
) || (
	echo "Failed to apply patches"
	exit 1
) || exit 1
