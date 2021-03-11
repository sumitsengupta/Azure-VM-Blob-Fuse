# This shows how you can map a azure storage container to a Linux VM - on Azure or anywhere. Run the following in a script

```
# /usr/bin/bash

# Make a blobffuse file - to map to azure blob from https://docs.microsoft.com/en-us/azure/storage/blobs/storage-how-to-mount-container-linux
# One time setup only.  Create a temporary directory for Blobfuse.  In Azure VM, the /mnt is on ephemeral disk so you have to do it on every reboot.

if ! [[ -d  /mnt/resource/blobfusetmp ]] ;
then
  sudo mkdir /mnt/resource/blobfusetmp -p
  sudo chown <unix-user>:<unix-group> /mnt/resource/blobfusetmp
fi

# Create the directory where you want the blob container to be mounted on your linux host

 if ! [[ -d /data/azure-blob-container ]] ; then sudo mkdir/data/azure-blob-container   ; fi

# Ensure that the fuse_connection.cfg has the right blob account, container, key. Alternately you can specify on mount option - https://github.com/Azure/azure-storage-fuse


# The storage account be specified here or use a seperate config file -  directory needs to be empty  or use additional option -o noempty

export AZURE_STORAGE_ACCOUNT=<storage-account-name>
export AZURE_STORAGE_ACCESS_KEY=<storage-account-key>

# export AZURE_STORAGE_SAS_TOKEN=<storage-sas-token>      -- if not using key

sudo blobfuse /data/azure-blob-container --tmp-path=/mnt/resource/blobfusetmp  --container-name=<container-name> -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120

```
