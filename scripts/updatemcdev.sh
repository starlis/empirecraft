#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
. $(dirname $SOURCE)/init.sh

wget -O mc-dev.zip https://github.com/Bukkit/mc-dev/archive/master.zip
cd EMC-CraftBukkit/src/main/java
find . -type f -name "*.java" | sed -e 's/\.\///g' | xargs -I{} zip -d $basedir/mc-dev.zip mc-dev-master/{} 2>/dev/null 1>&2

