#! /bin/bash

## NO trailing slashes for sources, please!!!!!!.
SOURCES="/export/data"

TARGETDRIVE="/export/backup/"

MAILFOLKS="ress@mail.utexas.edu clint@mail.utexas.edu"

STATSFILE="/tmp/dobackLog"

if [ -f $STATSFILE ]; then
    mv $STATSFILE $STATSFILE".old"
fi
touch $STATSFILE

#### Does target exist?
if ! [ -d $TARGETDRIVE ]; then
  for recipient in $MAILFOLKS; do
    echo "WARNING: $TARGETDRIVE DOES NOT EXIST ON SANDSTONE" |  mail -s "SANDSTONE NO BACKUP DISK" $recipient
  done
  echo "Aborted: no backup drive"
  exit 3
fi
                                                                                                      
#### Is the target drive mounted?

if [ `df $TARGETDRIVE | tail -1 | awk '{print $5}'` = '/' ]; then
  for recipient in $MAILFOLKS; do
    echo "WARNING: $TARGETDRIVE DOES NOT APPEAR TO BE MOUNTED ON SANDSTONE" |  mail -s "SANDSTONE NO BACKUP DISK" $recipient
  done
  echo "Aborted: backup drive not mounted"
  exit 3
fi

##### Start off by checking disk usage
diskusage=`df $TARGETDRIVE | tail -1 | awk -F " " '{print $5}' | cut -d% -f1`
if [ $diskusage -ge 95 ]; then
  for recipient in $MAILFOLKS; do
    echo "WARNING: disk usage on $TARGETDRIVE exceeds 95%" | mail -s "SANDSTONE DISK USAGE WARNING" $recipient
  done
  echo "Aborted: insufficient disk space for backup"
  exit 4
fi

# The above checks could be shortened by making use of /proc/mounts, and 
# if using perl, the statfs call (statvfs on Solaris).

month=`date +%b%Y`
day=`date +%d`
starttime=`date`

# Check if directory exists for current month and create it if it doesn't
monthdir=$TARGETDRIVE$month
if [ ! -d $monthdir ]; then
  prevMonth=`ls -1t $TARGETDRIVE | head -n 1`
  prevMonthdir=$TARGETDRIVE$prevMonth
  echo "Creating directory: $monthdir"
  mkdir $monthdir
  chgrp ircusers $monthdir
  chmod 755 $monthdir
  if [ $? -ne 0 ]; then
    echo "Unable to create directory $monthdir"
    exit 2                #this should be a meaningful error code probably
  fi
fi

destdir=$monthdir/$day

### List of existing directories in current month's directory
backups=`find $monthdir -maxdepth 1 -type d ! -path $monthdir | sort -r`

### Number of existing backups
nbacks=`echo $backups | wc -w`

### Make new hard link to previous directory 
if [ $nbacks -ge 1 ]; then
  previousdir=`echo $backups | cut -f 1 -d " "`
else
  prevbackups=`find $prevMonthdir -maxdepth 1 -type d ! -path $prevMonthdir | sort -r`
  previousdir=`echo $prevbackups | cut -f 1 -d " "`
fi

cp -al $previousdir $destdir 

### Here is the actual copy ###
for source in $SOURCES; do
  chgrp -R ircusers $source
  chmod -R g+rw $source
  rsync -a --stats --numeric-ids --delete $source $destdir >> $STATSFILE
done
chgrp -R ircusers $destdir
chmod -R g+rx $destdir
chown -R vision $destdir
rsync -a --stats --numeric-ids --delete /etc $destdir >> $STATSFILE

### flush disk cache
sync; sync;  

endtime=`date`

echo "" >> $STATSFILE
echo "Backup started at $starttime " >> $STATSFILE
echo "Backup finished at $endtime " >> $STATSFILE


enddiskusage=`df $TARGETDRIVE | tail -1 | awk -F " " '{print $5}' | cut -d% -f1`
echo "Starting disk usage on $TARGETDRIVE = ${diskusage}%" >> $STATSFILE 
echo "Ending disk usage on $TARGETDRIVE =  ${enddiskusage}%" >> $STATSFILE


for recipient in $MAILFOLKS; do
   cat $STATSFILE | mail -s "SANDSTONE backup report" $recipient
done

