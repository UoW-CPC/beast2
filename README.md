### MiCADO ADTs and Dockerfile for Beast
based on https://github.com/beast-dev/BeastDocker

### Available In DockerHub:

* uowcpc/beast:v2.6 (generic Beast2+beagle, `/usr/local/bin/reinstall_beagle --prefix=/usr/local` to optimise for your architecture)
* uowcpc/beast:v2-uow (Beast2+beagle optimised for UoW OpenStack instances)
* uowcpc/beast:seeded-ec2 (Beast2+beagle pre-seeded, prefixed, optimised for EC2 t2.instances)
* uowcpc/beast:v1.10.5 (Beast1)
### Usage with MiCADO

#### Prerequisites

* This repository
* Access to a supported cloud (EC2, OpenStack, OpenNebula, Azure, CloudSigma, CloudBroker)
* MiCADO Master (as per https://micado-scale.readthedocs.io/en/latest/deployment.html)
* NFS server

#### Step 1: Point to MiCADO Master

```console
cd micado
edit _settings
```

Specify an IP in `MICADO_MASTER` and enter SSL credentials in `SSL_USER` and `SSL_PASS`

#### Step 2: Point to NFS server

```console
cd micado
edit beast.yaml
```

Under *####NFS Server Details####* specify the `server` IP and the `path` defined in */etc/exports*.

#### Step 3: Configure MiCADO Workers

```console
cd micado
edit beast.yaml
```

Under *####MiCADO Worker Details####* define the worker nodes (as per https://micado-scale.readthedocs.io/en/latest/application_description.html#virtual-machine).

#### Step 4: Prepare the Experiment

*NFS Server*
```console
cd /home/ubuntu/nfs
mkdir exp001
```

*Local Machine*
```console
scp beast_data.xml <NFS_SERVER_IP>:/home/ubuntu/nfs/exp001/beast_data.xml
```

In the NFS share, create a subdirectory for the experiment output. Copy the XML data to it.

#### Step 5: Deploy with MiCADO


```console
cd micado
./1-submit-adt.sh
```

Run the script *1-submit_adt.sh* to submit Beast to MiCADO. It will prompt you for:
* `filename` (_beast_data.xml_ in the example above)
* `subdirectory` (_exp001_ in the exmaple above)
* `parallelisations` (number of unique seed computations to run).

#### Step 6: Monitor and End


```console
cd micado
./3-check-status.sh
```

Run the script *3-check-status.sh* to verify the deployment to MiCADO, or check the Dashboard at *https://<MICADO_MASTER_IP>*. Your experiment directory should begin to fill with output shortly after the deployment is successful.


```console
cd micado
./2-delete-beast.sh
```

When you are ready to end the experiment run the script *2-delete-beast.sh*. Beast will stop and the cloud worker nodes will be terminated. The output data will still be available on the NFS server.

### Usage with Docker
`docker run uowcpc/beast:seeded-ec2` runs beast2 with a pseudorandom seed and prefixes output logs and trees with that seed

Additional arguments to beast2 can be passed as arguments to the container, ie. `docker run uowcpc/beast:seeded-ec2 -beagle_sse`

Pass the filename to the environment variable FILE, ie. `docker run -e FILE=beast_data.xml uowcpc/beast:seeded-ec2`

You can mount current dir as the working dir for data input/output with `-v $(pwd):/tmp/data -w /tmp/data`


OPTIONAL. If you're using subdirectories for different experiments, pass the subdir to the env var DIR, ie. `docker run -e DIR=exp01 -e FILE=beast_data.xml uowcpc/beast:seeded-ec2`

so full basic usage with:

`docker run -d -e FILE=beast_data.xml -v $(pwd):/tmp/data -w /tmp/data uowcpc/beast -threads -1`
