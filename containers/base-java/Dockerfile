FROM app-bio/base:latest


RUN apt update && \
    apt install -y \
    default-jre \
    default-jdk && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*



