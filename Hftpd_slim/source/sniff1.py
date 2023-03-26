#!/usr/bin/python3
from scapy.all import *
pkt=sniff(iface='br-e4de50b7fb8d',filter='icmp or udp or tcp',count=20)
pkt.summary()
