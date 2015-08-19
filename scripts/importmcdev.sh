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
export importedmcdev=""
function import {
	export importedmcdev="$importedmcdev $1"
	file="${1}.java"
	target="$basedir/Spigot/Spigot/Spigot-Server/src/main/java/$nms/$file"
	base="$basedir/Spigot/work/$decompile/$nms/$file"

	if [[ ! -f "$target" ]]; then
		export MODLOG="$MODLOG  Imported $file from mc-dev\n";
		echo "Copying $base to $target"
		cp "$base" "$target"
	fi
}

(
	cd Spigot/Spigot/Spigot-Server/
	lastlog=$(git log -1 --oneline)
	if [[ "$lastlog" = *"EMC-Extra mc-dev Imports"* ]]; then
		git reset --hard HEAD^
	fi
)

import ServerStatisticManager
import RemoteControlListener
import NBTTagList
import EntityAnimal
import PathfinderGoalNearestAttackableTarget
import EnchantmentManager
import TileEntityEnderChest
import TileEntityLightDetector
import PathfinderGoalArrowAttack
import PathfinderGoalTarget
import ItemSnowball
import ItemBookAndQuill
import MerchantRecipe
import CommandStop
import WorldGenMonument
import BlockSponge
import EntityMinecartHopper
import PathfinderGoalInteractVillagers
import GameProfileSerializer
import FileIOThread

(
	cd Spigot/Spigot/Spigot-Server/
	git add src -A
	echo -e "EMC-Extra mc-dev Imports\n\n$MODLOG" | git commit src -F -
)
