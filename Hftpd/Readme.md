# Simple network setup for inspecting network packets with tcpdump or sniffing in scapy
This is a containerized network that comprises a simple httpd server, a sniffer-host where one can sniff every network packet flowing on 172.16.10.0/24 docker network One can sit at the client-host to access the web server or an optional ftp server which can be attached to the network later.

![Capture](https://user-images.githubusercontent.com/57078914/198918685-16775255-67c4-4501-8bc6-b11b8506390b.PNG)

The network can be set up in windows terminal by:
1. Cloning the repository to the local machine<br>
`git clone https://github.com/quang-ute/Networking-Essentials.git`
2. Change to the Hftpd folder<br>
`cd Networking-Essentials\Hftpd`
3. Setting it up by `docker-compose up -d`
<img width="527" src="https://user-images.githubusercontent.com/57078914/163668481-ddf6f6a8-3de1-41ff-968a-1dacb802b887.png">
Now you should be able to access the web server by visiting 

`http://localhost:5025` or `curl 172.16.10.100` within the client container <br>

## Attach a ftp server to the network
In windows terminal<br>

`docker run -p 21:21 -p 21000-21010:21000-21010 \`<br>
            `-e USERS="student|12345" \`<br>
            `-v C:\Users\quang\Downloads\:/ftp/student \` <br>
            `--network net-172.16.10.0 delfer/alpine-ftp-server`
            
Replace `C:\Users\quang\Downloads\` with the folder that map to the home folder of the ftp server.

To get the ip address of the newly created ftp server, in windows terminal:

`docker network inspect net-172.16.10.0`
  
<img width="823" src="https://user-images.githubusercontent.com/57078914/163669891-1b389ea0-ebd1-4d90-bf44-9b211a878472.png">

## Establishing ftp connection 

`lftp 172.16.10.2` (prompt changed)

`user student`

then input password 12345

You are now in the ftp server

<img width="1091" src="https://user-images.githubusercontent.com/57078914/163670304-7d1b9826-5d16-4f19-b6a6-a8f28c47e617.png">

You can also simultaneously inspect tcp packets or tcp stream of this session.



