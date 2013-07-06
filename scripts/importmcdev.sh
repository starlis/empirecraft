#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
. $(dirname $SOURCE)/init.sh

# restore mc-dev
nms="net/minecraft/server"

#restore backup files
mkdir backup
unzip -qo $basedir/mc-dev.zip backup/\* 2>/dev/null 1>&2
mkdir -p $basedir/backup/mc-dev-master/$nms
mv $basedir/backup/*.java $basedir/backup/mc-dev-master/$nms/ 2>/dev/null
cd backup/
zip -r $basedir/mc-dev.zip . 2>/dev/null 1>&2
zip -d $basedir/mc-dev.zip backup/\* 2>/dev/null 1>&2
cd $basedir
function import {
	file="${1}.java"
	target="$basedir/EMC-CraftBukkit/src/main/java/$nms/$file"
	if [[ ! -f "$target" ]]; then

		src=$(unzip -p $basedir/mc-dev.zip mc-dev-master/$nms/$file 2>/dev/null)
		backup="backup/$file"

		if [[ "$src" == "" ]]; then
			src=$(unzip -p $basedir/mc-dev.zip $backup)
		fi
		if [[ "$src" != "" ]]; then
			echo "Adding $target"
			echo "$src" | tee $target | tee $basedir/$backup >/dev/null
			zip $basedir/mc-dev.zip $backup 2>/dev/null 1>&2
			zip -d $basedir/mc-dev.zip mc-dev-master/$nms/$file 2>/dev/null 1>&2
		else
			echo "ERROR: Could not find source"
		fi
	fi
}

#import PathfinderGoalNearestAttackableTarget
#import PathfinderGoalHurtByTarget

rm -rf backup
