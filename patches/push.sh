#!/bin/bash
basedir=$(dirname $(readlink -f $0))
basedir=$(dirname $basedir)

cd $basedir/EMC-Bukkit
git co master
git push origin -f
cd $basedir/EMC-CraftBukkit
git co master
git push origin -f