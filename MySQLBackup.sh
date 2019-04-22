#!/bin/bash
#Script to Backup MySQL Database
#Author: Juan de Yzaguirre - Oct/2014
#Revision: David Sanchez Alvarez - Abril/2019

#MySQL credentials
mysql_user=username
mysql_password=password

#Schemas to backup
declare -a "databases=( $( < schemas.txt ) )"

#Backup directory
#ATTENTION: With / at the end
backup_dir=/mnt/bckp_mysql_alta/

#Log file
logfile=./backup-mysql-alta.log

#Checking credentials
echo "Attepmting connection..."
mysql -u$mysql_user -p$mysql_password -e exit 2>/dev/null
dbstatus=`echo $?`
if [ $dbstatus -ne 0 ]; then
   echo "MySQL $mysql_user wrong credentials."
   echo "MySQL $mysql_user wrong credentials." >> $logfile
   exit
else
   echo "MySQL $mysql_user logged in. Connection established."
   echo "MySQL $mysql_user logged in. Connection established." >> $logfile
fi

#Volcamos y comprimimos las copias de seguridad de las bases de datos, una por una
for database in "${databases[@]}"
do
   echo "Iniciamos volcado de $database..."
   echo "Iniciamos volcado de $database..." >> $logfile
   mysqldump -u$mysql_user -p$mysql_password --hex-blob $database | gzip > "$backup_dir$database"_$(date +%Y-%m-%d).sql.gz
   backup=`echo $?`
   if [ "$backup" -ne 0 ]; then
      echo "[MYSQL ERROR]["$(date +%d-%m-%Y/%T)"] An error has ocurred while backing up $database" >> $logfile
      echo "An error has ocurred while backing up $database"
      exit
   else
      echo "[MYSQL INFO]["$(date +%d-%m-%Y/%T)"] Copia de seguridad realizada correctamente" de $database >> $logfile
      echo "Copia de seguridad realizada correctamente de $database"
   fi
      #Copiamos el backup a una segunda ubicacion
   #scp "$backup_dir"bd_$(date +%d-%m-%Y).sql.gz /dev/backups

   #Borramos los backups con mas de 15 dias
   #find  $backup_dir/*.gz -mtime +30 -exec rm {} \;
   #find  $backup_dir/*.sql -mtime +30 -exec rm {} \;
done
