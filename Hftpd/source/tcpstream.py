from scapy.all import *

scapy_cap = rdpcap('file.pcap')
for packet in scapy_cap:
    print (hexdump(packet[IP].payload))