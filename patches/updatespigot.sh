#!/bin/bash
basedir=$(dirname $(readlink -f $0))
basedir=$(dirname $basedir)
cd $basedir/EMC-CraftBukkit
git co spigot
git fetch spigot
git reset --hard spigot/master
git reset --soft upstream/master
git commit -a --author="md_5 <md_5@bigpond.com>" -m "Spigot"
git format-patch --stdout HEAD^ > ../patches/CraftBukkit/0001*.patch