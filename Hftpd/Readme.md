# Simple network for inspecting network packets with wireshark or tcpdump
This is a containerized network that comprises a simple httpd server, a client where wireshark packet analyzer is installed.
One can sit at the client to access the web server or a ftp server which can be attached to the network later.
All the packet goes to and from this client can be captured and inspected in wireshark.

<img width="274" src="https://user-images.githubusercontent.com/57078914/163670787-e809892f-ce96-472f-9046-115df43f2ab0.png">

The network can be set up in windows terminal by:
1. Cloning the repository to the local machine<br>
`git clone https://github.com/quang-ute/Networking-Essentials.git`
2. Change to the Hftpd folder<br>
`cd Networking-Essentials\Hftpd`
3. Setting it up by `docker-compose up -d`
<img width="527" src="https://user-images.githubusercontent.com/57078914/163668481-ddf6f6a8-3de1-41ff-968a-1dacb802b887.png">
Now you should be able to access the wireshark UI by visiting http://localhost:3128, or the web server by visiting http://localhost:5000 <br>
To watch the network traffic in wireshark, you must initiate requests from this container. To do this, you must attach to the wireshark container then install <b>curl</b> for web requests.  

`docker exec -it wireshark sh -l`

## install curl package (web client)
Inside the container:<br>

`apk update`

then

`apk add curl`

<img width="734" src="https://user-images.githubusercontent.com/57078914/163668906-44c8d072-d7d9-45bb-87d4-083eea884331.png"><br>

## Sending http request

To send http request to the web server:<br>

`curl http://172.16.10.100:3000`

The html page from the web server will be displayed:<br>
<img width="425" src="https://user-images.githubusercontent.com/57078914/163669118-f0006d8a-555b-46db-b510-72c64805df7c.png"><br>
You can also simultaneously inspect tcp packets or tcp stream for this session.
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

## install lftp package (ftp client)
Inside the wireshark container:

`apk add lftp`

## Establishing ftp connection 

`lftp 172.16.10.2` (prompt changed)

`user student`

then input password 12345

You are now in the ftp server

<img width="1091" src="https://user-images.githubusercontent.com/57078914/163670304-7d1b9826-5d16-4f19-b6a6-a8f28c47e617.png">

You can also simultaneously inspect tcp packets or tcp stream of this session.



