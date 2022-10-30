#!/usr/bin/python3
from scapy.all import *
def process_packet(pkt):
	if pkt.haslayer(IP):
		ip = pkt[IP]
		print("IP: {} --> {}".format(ip.src, ip.dst),end="")
	if pkt.haslayer(TCP):
		tcp = pkt[TCP]
		print(" TCP port: {} --> {}, flag {}".format(tcp.sport,tcp.dport,tcp.flags))
	elif pkt.haslayer(UDP):
		udp = pkt[UDP]
		print(" UDP port: {} --> {}".format(udp.sport, udp.dport))
	elif pkt.haslayer(ICMP):
		icmp = pkt[ICMP]
		print(" ICMP type: {}".format(icmp.type))
	else:
		print("	Other protocol")
# replace iface with NIC name of your computer
sniff(iface='br-606ef6e97278', filter='ip', prn=process_packet)
