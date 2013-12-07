#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
. $(dirname $SOURCE)/init.sh


scripts/updatemcdev.sh
nms="net/minecraft/server"
export MODLOG=""
cd $basedir
function import {
	file="${1}.java"
	target="$basedir/EMC-CraftBukkit/src/main/java/$nms/$file"
	base="$basedir/mc-dev-master/$nms/$file"

	if [[ ! -f "$target" ]]; then
		export MODLOG="$MODLOG  Imported $file from mc-dev\n";
		echo "Copying $base to $target"
		mv "$base" "$target"
	elif [[ -f "$base" ]]; then
		export MODLOG="$MODLOG  Removed $file from mc-dev\n";
		rm -f "$base"
	fi
}

import EntityItemFrame
import ServerStatisticManager

cd $basedir
git add mc-dev-master --all
git commit mc-dev-master -m "Updating mc-dev\n\n$MODLOG"