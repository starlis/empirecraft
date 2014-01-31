#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
. $(dirname $SOURCE)/init.sh

rm -rf mc-dev-master
wget -NO ../../mc-dev.zip https://github.com/SpigotMC/mc-dev/archive/master.zip 1>/dev/null
unzip ../..//mc-dev.zip 1>/dev/null
rm -rf mc-dev-master/{achievement,font.txt,lang,META-INF,null,README.md} 1>/dev/null

cd EMC-CraftBukkit/src/main/java
find . -type f -name "*.java" | sed -e 's/\.\///g' | xargs -I{} rm $basedir/mc-dev-master/{} 2>/dev/null 1>&2
