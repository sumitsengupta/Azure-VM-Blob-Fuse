Map an azure storage blob container to a Linux VM 
Make a blobffuse temporary file for improved performance following [this](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-how-to-mount-container-linux)
In Azure VM, /mnt is on ephemeral disk so you have to run this on every reboot. Fill up your unux user and group below.


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

Ensure that the fuse_connection.cfg file has the right blob account, container, key. There is a boat load of [mount](https://github.com/Azure/azure-storage-fuse) options.

```
sudo blobfuse /data/azure-blob-container --tmp-path=/mnt/resource/blobfusetmp  --container-name=<container-name> -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120

#Alternately you could specify it all here

#export AZURE_STORAGE_ACCOUNT=sqlseries
#export AZURE_STORAGE_ACCESS_KEY=
#export AZURE_STORAGE_SAS_TOKEN=
#sudo blobfuse /data/azure-blob-container --tmp-path=/mnt/resource/blobfusetmp  --container-name=ocpdump-postgres -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120
```

