# work from latest LTS ubuntu release
FROM ubuntu:20.04

RUN rm /bin/sh && ln -s /bin/bash  /bin/sh 

# set the environment variables
ENV kallisto_version 0.46.2


ARG DEBIAN_FRONTEND=noninteractive

# run update and install necessary tools
RUN apt-get update -y && apt-get install -y \
    build-essential \
    cmake \
    zlib1g-dev \
    libhdf5-dev \
    libnss-sss \
    curl \
    autoconf \
    vim \
    less \
    wget

#RUN ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime
# install kallisto
WORKDIR /usr/local/bin/
RUN curl -SL https://github.com/pachterlab/kallisto/archive/v${kallisto_version}.tar.gz \
    | tar -zxvC  /usr/local/bin/ 

WORKDIR /usr/local/bin/kallisto-${kallisto_version}/ext/htslib
RUN autoheader
RUN autoconf
RUN mkdir -p /usr/bin/kallisto/kallisto-${kallisto_version}/build
WORKDIR /usr/local/bin/kallisto-${kallisto_version}/build
RUN cmake ..
RUN make
RUN make install

#install bustools 
WORKDIR /usr/local/bin/
RUN curl -SL https://github.com/BUStools/bustools/archive/v0.40.0/bustools_linux-v0.40.0.tar.gz \
    | tar -zxvC  /usr/local/bin/ 
RUN ls /usr/local/bin/bustools-0.40.0/
WORKDIR /usr/local/bin/bustools-0.40.0/
RUN mkdir -p /usr/local/bin/bustools-0.40.0/build
RUN pwd 
WORKDIR /usr/local/bin/bustools-0.40.0/build
RUN pwd  
RUN cmake .. && make && make install


WORKDIR /usr/local/bin/


#SHELL ["bin/sh", "-c"]
ENV PATH="kallisto:bustools:${PATH}"

# set default command
CMD ["bin/sh","-c","kallisto && bustools"]
#CMD ["bustools"]
#RUN ["/kallisto"]

#ENTRYPOINT /bin/bash
ADD hello.sh /usr/local/bin/hello.sh  
RUN chmod 777 /usr/local/bin/hello.sh 
RUN /usr/local/bin/hello.sh 

#CMD ["/usr/local/bin/hello.sh"]
#COPY . .
#ADD map_transcriptome.sh /usr/local/bin/map_transcriptome.sh
#RUN chmod 777 /usr/local/bin/map_transcriptome.sh 
#RUN /usr/local/bin/map_transcriptome.sh 

