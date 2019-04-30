#!/bin/bash
#Script to copy backups to an external location using SCP
#David Sanchez Alvarez April/2019

# Databases to copy
declare -a "databases=( $( < schemas.txt ) )"

#Backups folder
#ATTENTION: Including / at the end
backup_dir=/mnt/bckp_dir/
#Destiny folder
dir_destiny=/mnt/HD/HD_a2/MySQL/
#Destiny IP address
ip_destiny=172.23.255.208
#Destiny username
us_destiny=root

#Log file                                                                               │
logfile=./weekly-copy.log

#Check every defined schema
for database in "${databases[@]}"                                                                                     │
do
  #List most recent file of every schema
  fn=$(ls -t "$backup_dir$database"* | head -n1)
  # Continue if we obtained a result
  if  [ ! -z "$fn" ]
  then
    echo $(date +%d-%m-%Y/%T)" - Copying $fn to $dir_destino"
    echo "Copying $fn to $dir_destino" >> $logfile
    # File copy. We use sshpass to read credentiales a bit safely from the external file
    sshpass -f ".credencials" scp -r "$fn" "$us_destiny"@"$ip_destiny":"$dir_destiny"
  fi
done
