#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
. $(dirname $SOURCE)/init.sh

nms="net/minecraft/server"
export MODLOG=""
cd $basedir
decompile=$(ls -lat Spigot/work/ | grep decompile | head -n 1 | awk '{print $9}')

function import {
	file="${1}.java"
	target="$basedir/Spigot/Spigot/Spigot-Server/src/main/java/$nms/$file"
	base="$basedir/Spigot/work/$decompile/$nms/$file"

	if [[ ! -f "$target" ]]; then
		export MODLOG="$MODLOG  Imported $file from mc-dev\n";
		echo "Copying $base to $target"
		cp "$base" "$target"
	fi
}

import ServerStatisticManager
import RemoteControlListener
import NBTTagList
import EntityAnimal
import PathfinderGoalNearestAttackableTarget
import EnchantmentManager
import TileEntityEnderChest
import TileEntityLightDetector
#weird bug
#import EmptyClass
#import EnchantmentModifierProtection
#import EnchantmentModifierDamage
#import EnchantmentModifierThorns
#import EnchantmentModifierArthropods

import ItemSnowball

(
	cd Spigot/Spigot/Spigot-Server/
	git add src -A
	lastlog=$(git log -1 --oneline)
	amend=""
	if [[ "$lastlog" = *"EMC-Extra mc-dev Imports"* ]]; then
		amend="--amend"
		echo "Amending last commit"
	fi
	echo -e "EMC-Extra mc-dev Imports\n\n$MODLOG" | git commit src $amend -F -
)
