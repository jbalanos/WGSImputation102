FROM app-bio/base-java


ENV ZIP=fastqc_v0.11.9.zip
ENV URL=https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
ENV FOLDER=FastQC
ENV DST=/opt/fastqc
ENV ULOCAL=/usr/local/bin

RUN mkdir -p $DST


RUN wget $URL/$ZIP -O $DST/$ZIP && \
    unzip $DST/$ZIP -d $DST && \
    rm $DST/$ZIP && \
    mv $DST/$FOLDER/* $DST && \
    rmdir $DST/$FOLDER && chmod +x $DST/fastqc && \
    ln -s $DST/fastqc $ULOCAL/fastqc

WORKDIR /data/