FROM ubuntu:xenial

ENV FILEBEAT_VERSION 6.1.1
ENV FILEBEAT_BASE_URL https://artifacts.elastic.co/downloads/beats/filebeat/

RUN \
  apt-get update && \
  apt-get -y install wget && \
  apt-get -y install bash && \
  wget -q ${FILEBEAT_BASE_URL}filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz && \
  wget -q ${FILEBEAT_BASE_URL}filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz.sha512 && \
  sha512sum -c filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz.sha512 && \
  tar xzf filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz && \
  mv filebeat-${FILEBEAT_VERSION}-linux-x86_64/filebeat /usr/local/bin && \
  mkdir -p /etc/filebeat/conf.d && \
  mkdir -p /etc/filebeat/modules.d && \
  mkdir -p /etc/filebeat/log && \
  rm -rf /filebeat* && \
  rm -rf /var/lib/apt/lists/*

COPY filebeat.yml /etc/filebeat/filebeat.yml
COPY docker_app.yml /etc/filebeat/conf.d/docker_app.yml

CMD ["/usr/local/bin/filebeat", "-e", "-c", "/etc/filebeat/filebeat.yml"]
