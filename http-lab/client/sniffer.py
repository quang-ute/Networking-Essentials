#!/usr/bin/python3
from scapy.all import *

def process_packet(pkt):
    if pkt.haslayer(IP):
        ip = pkt[IP]
        print(f"IP: {ip.src} --> {ip.dst}", end="")
    if pkt.haslayer(TCP):
        tcp = pkt[TCP]
        print(f" TCP port: {tcp.sport} --> {tcp.dport}, flag {tcp.flags}")
        try:
            payload = bytes(tcp.payload).decode(errors='ignore')
            print(payload)
        except:
            print("(Binary or undecodable payload)")
    elif pkt.haslayer(UDP):
        udp = pkt[UDP]
        print(f" UDP port: {udp.sport} --> {udp.dport}")
    elif pkt.haslayer(ICMP):
        icmp = pkt[ICMP]
        print(f" ICMP type: {icmp.type}")
    else:
        print(" Other protocol")

# Sniff on the default network interface (eth0 in Docker)
sniff(iface="eth0", filter="ip", prn=process_packet)