FROM app-bio/base


ENV ZIP=plink2_linux_x86_64_20230325.zip
ENV URL=https://s3.amazonaws.com/plink2-assets
#ENV FOLDER=Plink
ENV DST=/opt/plink
ENV ULOCAL=/usr/local/bin

RUN mkdir -p $DST


RUN wget $URL/$ZIP -O $DST/$ZIP && \
    unzip $DST/$ZIP -d $DST && \
    rm $DST/$ZIP && \
    chmod +x $DST/plink2 && \
    ln -s $DST/plink2 $ULOCAL/plink &&\
    ln -s $DST/plink2 $ULOCAL/plink2

WORKDIR /data/


