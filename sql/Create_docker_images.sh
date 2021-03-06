# Mount Azure file
# sudo apt-get install cifs-utils
# mkdir /azurebackups
sudo mount -t cifs //sql2017builddemo.file.core.windows.net/backups /azurebackups -o vers=3.0,username=sql2017builddemo,password=XVjLIwjTTDRtNuK5mXRfuRz+R2oq+e9arnBBVEoMY38cV+WCF6gl415f5hY5n5NpKAFMpEOP7rjVnnoHHZzAsg==,dir_mode=0777,file_mode=0777
 
printf "\nPull and run microsoft/mssql-server-linux Docker image from Docker Hub\n"
docker pull microsoft/mssql-server-linux
docker run --name sanitation-station -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=//build2017' -p 1433:1433 -v /azurebackups:/azurebackups -d microsoft/mssql-server-linux 
docker ps
sleep 10

printf "\nRestoring production database into sanitation environment\n"
sqlcmd -Usa -P//build2017 -i sql/Restore_Production_Database_as_Development.sql

printf "\nSanitizing production data for development use\n"
sqlcmd -Usa -P//build2017 -i sql/Sanitize_Production_Database_for_Dev_use.sql
sqlcmd -Usa -P//build2017 -Q"SELECT TOP 10 Author FROM SQL2017BuildDemo_DevBig..Comments"

printf "\nDetaching, making copy of sanitized database to create small dev DB, and re-attaching again\n"
sqlcmd -Usa -P//build2017 -i sql/Detach_DevBig_Database.sql
docker exec -it sanitation-station "cp" "/var/opt/mssql/data/SQL2017BuildDemo.mdf" "/var/opt/mssql/data/SQL2017BuildDemoSmall.mdf"
docker exec -it sanitation-station "cp" "/var/opt/mssql/data/SQL2017BuildDemo.ldf" "/var/opt/mssql/data/SQL2017BuildDemoSmall.ldf"
sqlcmd -Usa -P//build2017 -i sql/Attach_Dev_Databases.sql

printf "\nShrinking small dev database\n"
sqlcmd -Usa -P//build2017 -i sql/Shrink_Development_Database_Small.sql

printf "\nDocker commit to create big dev image\n"
docker commit sanitation-station db-dev-big-tmp:latest

printf "\nDropping big dev database\n"
sqlcmd -Usa -P//build2017 -Q"DROP DATABASE SQL2017BuildDemo_DevBig;"

printf "\nDocker commit to create small dev image\n"
docker commit sanitation-station db-dev-small-tmp:latest
docker rm -f sanitation-station

printf "\nAllmost finished images\n"
docker images

printf "\nFlattening small image to reduce size\n"
docker run --name tmp-small -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=//build2017' -p 1433:1433 -v /azurebackups:/azurebackups -d db-dev-small-tmp
docker export tmp-small | docker import - db-dev-small:latest
docker rm -f tmp-small
docker rmi db-dev-small-tmp

printf "\nFlattening large image to reduce size\n"
docker run --name tmp-big -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=//build2017' -p 1433:1433 -v /azurebackups:/azurebackups -d db-dev-big-tmp
docker export tmp-big | docker import - db-dev-big:latest
docker rm -f tmp-big
docker rmi db-dev-big-tmp

printf "\nFinal list of images\n"
docker images

#docker run --name db-big -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=//build2017' -p 1433:1433 -d db-dev-big /opt/mssql/bin/sqlservr
#docker run --name db-small -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=//build2017' -p 1433:1433 -d db-dev-small /opt/mssql/bin/sqlservr















