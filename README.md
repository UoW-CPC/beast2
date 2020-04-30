### Dockerfile for building images for Beast and beagle
based on https://github.com/beast-dev/BeastDocker

### In DockerHub:

* uowcpc/beast:v2.6 (generic Beast2+beagle, `/usr/local/bin/reinstall_beagle --prefix=/usr/local` to optimise for your architecture)
* uowcpc/beast:v2-uow (Beast2+beagle optimised for UoW OpenStack instances)
* uowcpc/beast:v1.10.5 (Beast1)


### Usage
`docker run uowcpc/beast` runs beast2

You can mount current dir as the working dir for data input/output with `-v $(pwd):/tmp/data -w /tmp/data`

so basic usage with: `docker run -d -v $(pwd):/tmp/data -w /tmp/data uowcpc/beast -seed 777 -threads -1 input_data.xml`
