FROM openjdk:9 

WORKDIR /tmp

RUN apt-get update && apt-get install -y \
	ant \
	build-essential \
	autoconf \
	automake \
	libtool \
	subversion \
	pkg-config \
	git \
        ocl-icd-opencl-dev \
        pocl-opencl-icd

RUN apt-get -y autoremove
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

RUN which gcc
RUN gcc --version

ENV JAVA_HOME /usr/lib/jvm/java-9-openjdk-amd64
ENV JAVA_TOOL_OPTIONS -Dfile.encoding=UTF8
ENV ROOT_HOME /root
ENV USER_HOME /home/ubuntu

# Install Beast2 from source
WORKDIR ${ROOT_HOME}
RUN git clone --depth=1 https://github.com/CompEvol/beast2.git
#COPY beast2 beast2
WORKDIR ${ROOT_HOME}/beast2
RUN ls
RUN ant linux
RUN mkdir -p /usr/local
RUN mv ${ROOT_HOME}/beast2/release/Linux/beast /usr/local

# Build beagle from source
WORKDIR ${ROOT_HOME}
RUN git clone --depth=1 https://github.com/beagle-dev/beagle-lib.git
#COPY beagle-lib beagle-lib
WORKDIR ${ROOT_HOME}/beagle-lib
RUN ./autogen.sh
RUN ./configure --prefix=/usr/local 
RUN make install 

# Create standard user
RUN echo 'export PATH=/usr/local/beast/bin:$PATH' >> ${ROOT_HOME}/.bashrc
RUN echo 'export PS1="[beast2-\u]:\W# "' >> ${ROOT_HOME}/.bashrc
RUN echo 'export LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}' >> ${ROOT_HOME}/.bashrc
WORKDIR /root

COPY reinstall_beagle /usr/local/bin
COPY docker-entrypoint.sh /docker-entrypoint.sh

ENV FILE beast_data.xml
ENV DIR .

ENTRYPOINT ["/docker-entrypoint.sh"]
