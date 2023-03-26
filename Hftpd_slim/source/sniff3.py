#!/usr/bin/python3
from scapy.all import *

def process_packet(pkt):
	if pkt.haslayer(IP):
		ip = pkt[IP]
		print("IP: {} --> {}".format(ip.src, ip.dst),end="")
	if pkt.haslayer(TCP):
		tcp = pkt[TCP]
		data = tcp.payload
		l = len(data)
		print(" TCP port: {} --> {}, flag {}, len {}".format(tcp.sport,tcp.dport,tcp.flags,l))
		if (l!=0):
			print(bytes(tcp.payload).decode('utf-8'))
	elif pkt.haslayer(UDP):
		udp = pkt[UDP]
		print(" UDP port: {} --> {}".format(udp.sport, udp.dport))
	elif pkt.haslayer(ICMP):
		icmp = pkt[ICMP]
		print(" ICMP type: {}".format(icmp.type))
	else:
		print("	Other protocol")
# replace iface with NIC name of your computer
sniff(iface='br-c5e2da28a63b', filter='ip', prn=process_packet)
