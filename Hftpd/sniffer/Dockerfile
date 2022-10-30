FROM	alpine:edge
RUN apk add --update \
	git \
	ipython \
	scapy \
	tcpdump
WORKDIR /home
RUN git clone https://github.com/KimiNewt/pyshark.git
RUN cd /home/pyshark/src
RUN python /home/pyshark/src/setup.py install
