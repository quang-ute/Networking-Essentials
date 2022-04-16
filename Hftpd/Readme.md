# Simple network for inspecting network packets with wireshark or tcpdump
This is a containerized network that comprises a simple httpd server, a client where wireshark packet analyzer is installed.
One can sit at the client to access the web server or a ftp server which can be attached to the network latter.
All the packet goes to and from this client can be captured and inspected in wireshark.
The network can be set up in windows terminal by:
1. Cloning the repository to the local machine<br>
`git clone https://github.com/quang-ute/Networking-Essentials.git`
2. Change to the Hftpd folder<br>
`cd Networking-Essentials\Hftpd`
3. Setting it up by `docker-compose up -d`
<img width="527" src="https://user-images.githubusercontent.com/57078914/163668481-ddf6f6a8-3de1-41ff-968a-1dacb802b887.png">
Now you should be able to access the wireshark interface by visiting http://localhost:3128, or the web server visiting http://localhost:5000 <br>
To watch the network traffic in wireshark, you must initiate requests from this container. To do this, you must attach to the wireshark container then install <b>curl</b> for web requests.  

`docker exec -it wireshark sh -l`

## install curl package
Inside the container:<br>
`apk update`
then
`apk add curl`<br>
<img width="734" src="https://user-images.githubusercontent.com/57078914/163668906-44c8d072-d7d9-45bb-87d4-083eea884331.png"><br>
To send http request to the web server:<br>
`curl http://172.16.10.100:3000`<br>
The html page from the web server will be displayed:<br>
<img width="425" src="https://user-images.githubusercontent.com/57078914/163669118-f0006d8a-555b-46db-b510-72c64805df7c.png"><br>
You can also simultaneously inspect tcp packets or tcp stream for this session.
