# Simple network setup for inspecting/snipping network packets
This is a containerized network that comprises a simple httpd server, a sniffer-host where one can sniff every network packet flowing on 172.16.10.0/24 docker network. One can sit at the client-host to access the web server or an optional ftp server (which can be attached to the network later).

![Capture](https://user-images.githubusercontent.com/57078914/198918685-16775255-67c4-4501-8bc6-b11b8506390b.PNG)

The network can be set up in windows terminal by:
1. Cloning the repository to the local machine<br>
`git clone https://github.com/quang-ute/Networking-Essentials.git`
2. Change to the Hftpd folder<br>
`cd Networking-Essentials\Hftpd` <br>

*(Updated on 05/03/2023)* <br>

3. Build images by `docker-compose build`
4. Start up the network by `docker-compose up -d`
<img width="527" src="https://user-images.githubusercontent.com/57078914/163668481-ddf6f6a8-3de1-41ff-968a-1dacb802b887.png">
Now you should be able to access the web server by visiting 

`http://localhost:5025` or `curl 172.16.10.100` within the client container <br>
Due to updates on 05/03/2023, the client host run VNC Server internally. You now can use the client host's GUI using VNC client
which makes web access more comfortable.

![image](https://user-images.githubusercontent.com/57078914/222957984-28a2d52d-f178-4f25-8c84-321f34f6c46e.png)

At first, you need to type localhost:5900 on search bar of VNC Viewer then enter to connect to the host.
After the first successful connection, there will be a thumbnail like in the above image. You just double-click it for connection later on. 

![image](https://user-images.githubusercontent.com/57078914/222958351-14fbb98e-db9e-466e-9e66-1f5296578d00.png)

## Starting wireshark in client host
1. Open terminal window.
2. Enter command `sudo wireshark` then input `alpine` for the password

![image](https://user-images.githubusercontent.com/57078914/222965914-959dd46a-bac5-4289-9542-e90c86b62442.png)

3. Double-click the operative NIC to start packet capture.

![image](https://user-images.githubusercontent.com/57078914/222966069-1ac988b4-a403-4fa4-9212-b5b260e404ae.png)

## Attach a ftp server to the network
In windows terminal<br>

`docker run -p 21:21 -p 21000-21010:21000-21010 \`<br>
            `-v C:\Users\quang\Downloads\:/ftp/student \` <br>
            `--network net-172.16.10.0 delfer/alpine-ftp-server`
            
Replace `C:\Users\quang\Downloads\` with the folder that map to the home folder of the ftp server.

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



