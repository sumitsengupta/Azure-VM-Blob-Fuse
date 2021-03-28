# /bin/bash
# Make a blobffuse file - to map to azure blob from https://docs.microsoft.com/en-us/azure/storage/blobs/storage-how-to-mount-container-linux
# one time setup only.  In Azure VM, the /mnt is on ephemeral disk so you have to do it on every reboot.
# Author:         Sumit Sengupta                        https://www.linkedin.com/in/sumit-sengupta/

echo -e "\n Checking if the temporary directory for blobfuse exists - if not, create it \n"
if ! [[ -d  /mnt/resource/blobfusetmp ]] ;
then
  sudo mkdir /mnt/resource/blobfusetmp -p
  sudo chown sumit:sumit /mnt/resource/blobfusetmp
fi

# Ensure that the fuse_connection.cfg has the right blob account, container, key.

echo -e "\n Now checking of the fuse_connection.cfg file exists containing storage account, key or sas token, container \n"

if ! [[ -f ./.fuse_connection.cfg ]] ; then echo "Please add the storage account info into a configuration file first ." ;  fi

blobfuse /data/azure-blob-container --tmp-path=/mnt/resource/blobfusetmp --config-file=./.fuse_connection.cfg -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120 -o nonempty

#Alternately you could specify it all here

#export AZURE_STORAGE_ACCOUNT=sqlseries
#export AZURE_STORAGE_ACCESS_KEY=
#export AZURE_STORAGE_SAS_TOKEN=
#sudo blobfuse /data/azure-blob-container --tmp-path=/mnt/resource/blobfusetmp  --container-name=ocpdump-postgres -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120

# To unmount the filesystem

read -p "Do you want to unmount the blobfuse filesystem [y|Y]" resp
typeset -u RESP=$resp
if [ $RESP = "Y" ] ; then
  umount /data/azure-blob-container
# Alternately run --> sudo  umount blobfuse
fi
