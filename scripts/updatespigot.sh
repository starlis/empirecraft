#!/bin/bash
# get base dir regardless of execution location
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
. $(dirname $SOURCE)/init.sh

mkdir -p Spigot
cd Spigot

if [[ "$@" == *--update* ]]; then
	wget -N https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
	java -jar BuildTools.jar --skip-compile --disable-certificate-check
fi

#get all 4 revisions
bukkitVer=$(gethead Bukkit)
crafftbukkitVer=$(gethead CraftBukkit)
apiVer=$(gethead Spigot/Spigot-API)
serverVer=$(gethead Spigot/Spigot-Server)
spigotVer=$(gethead Spigot)
cd Spigot/Spigot-Server
mcVer=$(mvn -o org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | sed -n -e '/^\[.*\]/ !{ /^[0-9]/ { p; q } }')

basedir
. scripts/importmcdev.sh


cd Spigot/Spigot

version=$(echo -e "Bukkit: $bukkitVer\nCraftBukkit: $crafftbukkitVer\nSpigot: $spigotVer\nmc-dev:$importedmcdev")
tag="$mcVer-$(echo -e $version | sha1sum | awk '{print $1}')"

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
if [ "$(cat $basedir/current-spigot)" != "$tag" ]; then
	forcetag=1
fi

tag Spigot-API $forcetag
tag Spigot-Server $forcetag

echo "$tag" > $basedir/current-spigot
pushRepo Spigot-API git@bitbucket.org:starlis/Spigot-API $tag
pushRepo Spigot-Server git@bitbucket.org:starlis/Spigot-Server $tag
