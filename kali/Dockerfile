FROM  kalilinux/kali-linux-docker:latest

RUN apt -y update && apt -y upgrade

RUN apt -y --no-install-recommends install \
  metasploit-framework rsh-client apt-file \
  nfs-common rpcbind telnet hackrf gnuradio \
  python3-gi gobject-introspection gir1.2-gtk-3.0 \
  gnuradio-dev gr-osmosdr gqrx-sdr wireshark \
  git burpsuite openjdk-8-jre zaproxy exploitdb \
  strace gdb htop tcpdump dnsutils mtr john

WORKDIR /app

CMD [ "/bin/bash", "-i" ]
