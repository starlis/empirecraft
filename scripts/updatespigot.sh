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

wget -N https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
java -jar ../BuildTools.jar --skip-compile --disable-certificate-check --dev
cd ../
scripts/importmcdev.sh

pushRepo Spigot/Spigot/Spigot-API git@git.starlis.com:starlis/Spigot-API master
pushRepo Spigot/Spigot/Spigot-Server git@git.starlis.com:starlis/Spigot-Server master
