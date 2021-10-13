FROM jupyter/datascience-notebook:lab-3.0.14


#RaceID
RUN R -e 'install.packages("RaceID",dep=TRUE,repos="https://cran.rstudio.com/"); if (!library(RaceID, logical.return=T)) quit(status=10)'


##ssam
RUN R -e 'install.packages("sctransform",dep=TRUE,repos="https://cran.rstudio.com/"); if (!library(sctransform, logical.return=T)) quit(status=10)'
RUN R -e 'install.packages("feather",dep=TRUE,repos="https://cran.rstudio.com/"); if (!library(feather, logical.return=T)) quit(status=10)'
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir pyarrow && \
    pip install --no-cache-dir ssam



#R biocpackage and dependcy
RUN R -e 'install.packages("shinythemes",dep=TRUE,repos="https://cran.rstudio.com/"); if (!library(shinythemes, logical.return=T)) quit(status=10)'
RUN R -e 'install.packages("shinyBS",dep=TRUE,repos="https://cran.rstudio.com/"); if (!library(shinyBS, logical.return=T)) quit(status=10)'
RUN R -e 'install.packages("cowplot",dep=TRUE,repos="https://cran.rstudio.com/"); if (!library(cowplot, logical.return=T)) quit(status=10)'
RUN R -e 'install.packages("BiocManager",dep=TRUE,repos="https://cran.rstudio.com/"); if (!library(BiocManager, logical.return=T)) quit(status=10)'
RUN R -e 'install.packages("stringdist",dep=TRUE,repos="https://cran.rstudio.com/"); if (!library(stringdist, logical.return=T)) quit(status=10)'

#RUN R bioc_pcks <- c("GenomicRanges","GenomicFeatures","GenomicAlignments","AnnotationDbi","Rsubread")
RUN R -e 'BiocManager::install("BiocDockerManager")'


##bwa
RUN conda install -c bioconda bwa

#kallisto
RUN conda install -c bioconda kallisto
#old bustools 
#RUN conda install -c bioconda bustools

##install cmake
USER root 
RUN apt-get update \
 && apt-get install --assume-yes --no-install-recommends --quiet \
    ca-certificates \
    cmake \
    git \
    g++ \
    make \
    libzip-dev \
 && apt-get clean all


USER ${user}
WORKDIR $HOME 
## bustools_dev
RUN git clone https://github.com/Yenaled/bustools.git && \ 
    mkdir -p $HOME/bustools/build && \
    cd $HOME/bustools/build \ 
    &&  cmake .. \ 
    &&  make \
    &&  make install  
 
#RUN cd src
#RUN mv bustools bustools_dev
#RUN ENV PATH=$HOME/bustools/build/src/:${PATH}




#Samtools
USER root

RUN apt-get update && apt-get install --no-install-recommends -y \
 libncurses5-dev \
 libbz2-dev \
 liblzma-dev \
 libcurl4-gnutls-dev \
 zlib1g-dev \
 libssl-dev \
 gnuplot \
 ca-certificates && \
 apt-get autoclean && rm -rf /var/lib/apt/lists/*

USER ${user}


WORKDIR $HOME
ARG SAMTOOLSVER=1.13
RUN wget https://github.com/samtools/samtools/releases/download/${SAMTOOLSVER}/samtools-${SAMTOOLSVER}.tar.bz2
RUN  tar -xjf samtools-${SAMTOOLSVER}.tar.bz2
RUN  rm samtools-${SAMTOOLSVER}.tar.bz2 && \
 cd samtools-${SAMTOOLSVER} && \
 ./configure --prefix $(pwd) && \
 make

ENV PATH=$HOME/samtools-${SAMTOOLSVER}:${PATH}


#update conda 
RUN conda update -n base conda 
RUN conda install -c anaconda networkx>=2.5


#install new version of RACEID 
WORKDIR newRaceID
COPY RaceID newRaceID/RaceID
RUN R -e 'install.packages("runner",dep=TRUE,repos="https://cran.rstudio.com/");'
RUN R -e 'install.packages("harmony",dep=TRUE,repos="https://cran.rstudio.com/");'
RUN R -e 'install.packages("leiden",dep=TRUE,repos="https://cran.rstudio.com/");'
RUN R -e 'install.packages("newRaceID/RaceID",dep=TRUE,repos=NULL,type="source");'
WORKDIR $HOME



#zUMI
WORKDIR $HOME
#RUN git clone https://github.com/sdparekh/zUMIs.git
#ENV PATH=$HOME


#cellranger

#WORKDIR $HOME
#ENV CELLRANGER_VER 6.0.2
#COPY cellranger-$CELLRANGER_VER.tar.gz cellranger-$CELLRANGER_VER.tar.gz

#RUN tar -xzvf cellranger-$CELLRANGER_VER.tar.gz && \
#    #echo $(ls)
#    #alias cellranger=$HOME/cellranger-$CELLRANGER_VER/cellranger
#    echo "#!/bin/bash\n$HOME/cellranger-$CELLRANGER_VER/cellranger" > /opt/conda/bin/cellranger && \
#    chmod +x /opt/conda/bin/cellranger

#ENV PATH=${PATH}:$HOME/cellranger-$CELLRANGER_VER

