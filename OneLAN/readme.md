# This will create a LAN connecting 2 hosts as shown in the following figure:

<img width="350" src="https://user-images.githubusercontent.com/57078914/159425302-ea4ec683-084d-4da7-ba8b-acf1f4289f68.png">
Steps: <br>
1. Clone git to the local host, change working directory to OneLAN:<br>
```
git clone https://github.com/quang-ute/Nees <br>
cd Nees\OneLAN <br>
```
2. Building and starting the containers <br>
docker-compose up -d <br>
<img width="954" src="https://user-images.githubusercontent.com/57078914/159435365-6dd4465d-82f1-4d32-a749-bf31202aed43.png">
Check the containers with docker ps <br>
docker ps <br>
<img width="954" src="https://user-images.githubusercontent.com/57078914/159427263-dd8c11bb-22de-484e-9ba6-3eaba0baaf50.png">
The STATUS column indicates the containers are working normally<br>
3. Attaching to the console of hosts<br>
for host-172.16.10.5:<br>
docker exec -it host-172.16.10.5 sh -l<br>
<img width="954" src="https://user-images.githubusercontent.com/57078914/159432433-ad9ae47f-b84d-4d3e-9720-bdacffed6cc0.png">
for host-172.16.10.6:<br>
docker exec -it host-172.16.10.6 sh -l<br>
<img width="954" src="https://user-images.githubusercontent.com/57078914/159433369-b2ba6d5a-d6eb-4327-859c-654819a3b5f9.png">
When finish doing the labs <br>
docker-compose down <br>
<img width="954" src="https://user-images.githubusercontent.com/57078914/159434148-32874d50-9944-49bb-8102-3a2e1de97c16.png">
