FROM ubuntu:latest

RUN apt-get update && apt-get install -y sudo curl jq vim bsdmainutils

COPY demo.sh /root

RUN chmod +x /root/demo.sh