#!/bin/bash
####
# This script automatically mount S3 Bucket
#
# Author: Asuk Nath
# Date: 05/24/2018
#
# Exmaple:
# sudo ./s3_mount.sh <AWS Access Key ID> <AWS Secret Access Key>  <S3 Bucket Name>
#
###

## Create a folder to use for mount path 
sudo mkdir /mnt/$1 
sudo chmod -R 775 /mnt/$1

echo "Mounting Bucket"
echo "-------------------"

#sudo s3fs -o use_cache=/tmp/cache $3 /mnt/s3bucket 

# allow_other will give full access to mount folder
sudo s3fs -o use_cache=/tmp/cache -o allow_other $1 /mnt/$1

# S3 Bucket to be mounted automatically after each reboot.
sudo cat <<EOF >> /etc/fstab
s3fs#$1 /mnt/$1 fuse allow_other,use_cache=/tmp/cache 0 0
EOF

# Add SMB Config
sudo cat <<EOF >> /etc/samba/smb.conf
[$1]
path = /mnt/$1
browsable =yes
writable = yes
guest ok = yes
EOF

# Restart Samba Service
sudo systemctl restart smbd nmbd



