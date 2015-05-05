if [ ! -d "EmpireCraft-API" ]; then
git clone git@bitbucket.org:starlis/EmpireCraft-API
fi

if [ ! -d "EmpireCraft-Server" ]; then
git clone git@bitbucket.org:starlis/EmpireCraft-Server
fi

cd EmpireCraft-API
git fetch origin
git reset --hard origin/master

cd ..

cd EmpireCraft-Server
git fetch origin
git reset --hard origin/master

cd ..

mvn clean install