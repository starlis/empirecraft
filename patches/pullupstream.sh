#!/bin/bash
basedir=$(dirname $(readlink -f $0))
basedir=$(dirname $basedir)

cd $basedir/Bukkit
git co master
git pull
cd $basedir/CraftBukkit
git co master
git pull
