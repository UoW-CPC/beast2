### Dockerfile for building images for Beast and beagle
based on https://github.com/beast-dev/BeastDocker

### In DockerHub:

* uowcpc/beast:v2.6 (generic Beast2+beagle, `/usr/local/bin/reinstall_beagle --prefix=/usr/local` to optimise for your architecture)
* uowcpc/beast:v2-uow (Beast2+beagle optimised for UoW OpenStack instances)
* uowcpc/beast:seeded-ec2 (Beast2+beagle pre-seeded and prefixed)
* uowcpc/beast:v1.10.5 (Beast1)


### Usage
`docker run uowcpc/beast:seeded-ec2` runs beast2 with a pseudorandom seed and prefixes output logs and trees with that seed

Additional arguments to beast2 can be passed as arguments to the container, ie. `docker run uowcpc/beast:seeded-ec2 -beagle_sse`

Pass the filename to the environment variable FILE, ie. `docker run -e FILE=beast_data.xml uowcpc/beast:seeded-ec2`

You can mount current dir as the working dir for data input/output with `-v $(pwd):/tmp/data -w /tmp/data`


OPTIONAL. If you're using subdirectories for different experiments, pass the subdir to the env var DIR, ie. `docker run -e DIR=exp01 -e FILE=beast_data.xml uowcpc/beast:seeded-ec2`

so full basic usage with:

`docker run -d -e FILE=beast_data.xml -v $(pwd):/tmp/data -w /tmp/data uowcpc/beast -threads -1`
