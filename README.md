***Map an azure storage blob container to a Linux VM. On prem, any cloud or from my favourite [WSL2!](https://docs.microsoft.com/en-us/windows/wsl/).***
-------------------------------------------------------------------------------------------------------------------------------------------------------


The first requirement is to have [blobfuse](https://github.com/Azure/azure-storage-fuse/wiki/1.-Installation)  installed on your Linux OS. 

Once it is installed, optional but recommended is to create a blobfuse temporary file for improved performance following [this](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-how-to-mount-container-linux) instruction. 

Remember in Azure VM, /mnt is on ephemeral disk so you have to run this on every reboot - manually or part of system start up. 
In the script below, fill up your unix user and group name.


```
/usr/bin/bash

if ! [[ -d  /mnt/resource/blobfusetmp ]] ;
then
  sudo mkdir /mnt/resource/blobfusetmp -p
  sudo chown <unix-user>:<unix-group> /mnt/resource/blobfusetmp
fi

# Create the directory where you want the blob container to be mounted on your linux host. 

 if ! [[ -d /data/azure-blob-container ]] ; then sudo mkdir/data/azure-blob-container   ; fi
```

Ensure that the [config file](./fuse_connection.cfg) has the right blob account, container, key. There is a boat load of additional [mount](https://github.com/Azure/azure-storage-fuse) options.

To mount the filesystem, notice you can mount in user mode using the config file. Another option is to put the config file here either in variables or parameters

```

blobfuse /data/azure-blob-container --tmp-path=/mnt/resource/blobfusetmp --config-file=./fuse_connection.cfg -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120 -o nonempty


#Alternately you could specify it all here

#export AZURE_STORAGE_ACCOUNT=sqlseries
#export AZURE_STORAGE_ACCESS_KEY=
#export AZURE_STORAGE_SAS_TOKEN=
#sudo blobfuse /data/azure-blob-container --tmp-path=/mnt/resource/blobfusetmp  --container-name=ocpdump-postgres -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120
```

Finally if you need to unmount the filesystem - regular way - either of these works

```

umount /data/azure-blob-container
# Alternately run --> sudo  umount blobfuse

```

In the next step, you can mount an AWS S3 bucket or Google cloud storage to your OS.
