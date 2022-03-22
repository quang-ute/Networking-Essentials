## This will create a LAN connecting 2 hosts:

<img width="350" src="https://user-images.githubusercontent.com/57078914/159425302-ea4ec683-084d-4da7-ba8b-acf1f4289f68.png">

### Steps:
1. Install Docker Desktop on your computer
2. Clone git to the local host, change working directory to OneLAN:
```
git clone https://github.com/quang-ute/Nees
cd Nees\OneLAN <br>
```
3. Building and starting the containers <br>
`docker-compose up -d`

<img width="954" src="https://user-images.githubusercontent.com/57078914/159435365-6dd4465d-82f1-4d32-a749-bf31202aed43.png">

4. Check the running containers with docker ps <br>
`docker ps`

<img width="954" src="https://user-images.githubusercontent.com/57078914/159427263-dd8c11bb-22de-484e-9ba6-3eaba0baaf50.png">

The STATUS column indicates the containers are working normally <br>
. Attaching to the console of hosts
for host-172.16.10.5:<br>
`docker exec -it host-172.16.10.5 sh -l`

<img width="954" src="https://user-images.githubusercontent.com/57078914/159432433-ad9ae47f-b84d-4d3e-9720-bdacffed6cc0.png">

for host-172.16.10.6:<br>
`docker exec -it host-172.16.10.6 sh -l`

<img width="954" src="https://user-images.githubusercontent.com/57078914/159433369-b2ba6d5a-d6eb-4327-859c-654819a3b5f9.png">

The network is now ready for the labs <br>
When finish doing the labs <br> 
`docker-compose down`

<img width="954" src="https://user-images.githubusercontent.com/57078914/159434148-32874d50-9944-49bb-8102-3a2e1de97c16.png">
