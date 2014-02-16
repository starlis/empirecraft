cd EMC-Bukkit
git fetch origin
git reset --hard origin/master
cd ..
cd EMC-CraftBukkit
git fetch origin
git reset --hard origin/master
cd ..
mvn clean install