FROM ubuntu:xenial

ENV FILEBEAT_VERSION 5.3.2

RUN \
  apt-get update && \
  apt-get -y install wget && \
  wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz && \
  echo "$(wget -qO - https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz.sha1) filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz" | sha1sum -c - && \
  tar xzf filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz && \
  mv filebeat-${FILEBEAT_VERSION}-linux-x86_64/filebeat /usr/local/bin && \
  rm -rf /filebeat* && \
  rm -rf /var/lib/apt/lists/*

COPY filebeat.yml /etc/filebeat/filebeat.yml

CMD ["/usr/local/bin/filebeat", "-e", "-c", "/etc/filebeat/filebeat.yml"]
