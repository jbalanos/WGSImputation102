FROM app-bio/base


RUN apt-get update -y && \
    apt-get install -y samtools && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*