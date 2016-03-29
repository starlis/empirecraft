#!/bin/bash
# get base dir regardless of execution location
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
	DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
	SOURCE="$(readlink "$SOURCE")"
	[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
. $(dirname $SOURCE)/init.sh

if [ "$1" == "update" ]; then

	(
		cd "$basedir/Paper/"
		git fetch && git reset --hard origin/master
		cd ../
		git add Paper
    )
fi

paperVer=$(gethead Paper)
cd "$basedir/Paper"

./build.sh

basedir
. scripts/importmcdev.sh


cd Paper/

version=$(echo -e "Paper: $paperVer\nmc-dev:$importedmcdev")
tag="upstream-$(echo -e $version | sha1sum | awk '{print $1}')"

function tag {
(
	cd $1
	if [ "$2" == "1" ]; then
		git tag -d "$tag" 2>/dev/null
	fi
	echo -e "$(date)\n\n$version" | git tag -a "$tag" -F - 2>/dev/null
)
}
echo "Tagging as $tag"
echo -e "$version"

forcetag=0
if [ "$(cat $basedir/current-paper)" != "$tag" ]; then
	forcetag=1
fi

tag Paper-API $forcetag
tag Paper-Server $forcetag

echo "$tag" > $basedir/current-paper
pushRepo Paper-API $API_REPO $tag
pushRepo Paper-Server $SERVER_REPO $tag

