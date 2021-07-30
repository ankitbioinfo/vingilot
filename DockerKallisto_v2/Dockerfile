FROM jupyter/datascience-notebook:lab-3.0.14


#RaceID
RUN R -e 'install.packages("RaceID",dep=TRUE,repos="https://cran.rstudio.com/"); if (!library(RaceID, logical.return=T)) quit(status=10)'


##ssam 
RUN R -e 'install.packages("sctransform",dep=TRUE,repos="https://cran.rstudio.com/"); if (!library(sctransform, logical.return=T)) quit(status=10)'
RUN R -e 'install.packages("feather",dep=TRUE,repos="https://cran.rstudio.com/"); if (!library(feather, logical.return=T)) quit(status=10)'
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir pyarrow && \
    pip install --no-cache-dir ssam



##bwa 
RUN conda install -c bioconda bwa

#kallisto 
RUN conda install -c bioconda kallisto
RUN conda install -c bioconda bustools
