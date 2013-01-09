#!/bin/bash
basedir=$(dirname $(readlink -f $0))
basedir=$(dirname $basedir)
echo "Compiling EMC Bukkit and CraftBukkit"
cd $basedir/EMC-Bukkit
mvn clean install
cd $basedir/EMC-CraftBukkit
mvn clean install
