# Simple network setup for inspecting network packets with tcpdump or sniffing in scapy
This docker container set is bit different from the Hftpd set:
1. The client-host is a slimmer version of that in Hftpd: There is no wireshark, no ssh, no vnc server which make build process much faster; the images size is also more tiny. You can only work in command-line interface for this host. 
2. The web server now run with APACHE and PHP to clearly demonstrate various aspect of http protocol. 
3. The Python script in sniffer-host can help you to capture ip packets and display them in a human readable way. It's much cleaner than capturing packets in wireshark. 

![Capture](https://user-images.githubusercontent.com/57078914/198918685-16775255-67c4-4501-8bc6-b11b8506390b.PNG)

The network can be set up in windows terminal by:
1. Cloning the repository to the local machine<br>
`git clone https://github.com/quang-ute/Networking-Essentials.git`
2. Change to the Hftpd-slim folder<br>
`cd Networking-Essentials\Hftpd-slim`
3. Setting it up by `docker-compose up -d`
<img width="527" src="https://user-images.githubusercontent.com/57078914/163668481-ddf6f6a8-3de1-41ff-968a-1dacb802b887.png">
Now you should be able to access the web server by visiting 

`http://localhost:5050` from the host machine or `curl 172.16.10.100` within the client-host container <br>

## Attach a ftp server to the network
In windows terminal<br>

`docker run -d --name ftp-server -p 21:21 -p 21000-21010:21000-21010 -v C:\Users\quang\ftp\:/ftp/student --network net-172.16.10.0 delfer/alpine-ftp-server`
            
Replace `C:\Users\quang\ftp\` with the folder that map to the home folder of the ftp server.

To get the ip address of the newly created ftp server, in windows terminal:

`docker network inspect net-172.16.10.0`
  
<img width="823" src="https://user-images.githubusercontent.com/57078914/163669891-1b389ea0-ebd1-4d90-bf44-9b211a878472.png">

## Establishing ftp connection 

`lftp 172.16.10.2` (prompt changed)

`user alpineftp`

then input password alpineftp

You are now in the ftp server

<img width="1091" src="https://user-images.githubusercontent.com/57078914/163670304-7d1b9826-5d16-4f19-b6a6-a8f28c47e617.png">

You can also simultaneously inspect tcp packets or tcp stream of this session.



