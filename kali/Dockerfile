FROM kalilinux/kali-rolling:latest

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && \
  apt-get -y upgrade && \
  apt-get -y dist-upgrade

RUN apt-get install -y kali-tools-top10

WORKDIR /app

CMD [ "/bin/bash", "-i" ]
