# Inspecting http request & response

1. Open wireshark in browser `http://localhost:3000` then double-click active NIC to inspect. Usually it is `eth0`
2. In Windows Terminal, attaching to the console of the wireshark container: `docker exec -it web-server sh -l`

## For simple html request

  1. At the wireshark container: `curl http://web-server:3000/index.html`

  2. Filter out http packets in wireshark.

  3. Right-click one of related packet >> `Follow` >> `HTTP Stream`


  <img width="1173" src="https://user-images.githubusercontent.com/57078914/166148539-fa773b2d-dcc0-448b-a924-f5d70013a1f4.png">


  <img width="480" src="https://user-images.githubusercontent.com/57078914/166148825-449bc634-01bc-4b5e-b969-bd0c52dd21b7.png">

## for html page with POST request:

1. At the wireshark container: `curl -X POST -d 'fname=hoang&lname=huy' 'http://web-server:3000/index_post.html`. This equivalent to input firstname = hoang and lastname = huy in POST request form then submit

  <img width="480" src="https://user-images.githubusercontent.com/57078914/166149225-b81229e6-8fac-4242-8503-eb5e1c2846ae.png">

## For simple html request with cookies:

  1. At the wireshark container: `curl http://web-server:3000/index.html -b "session=eJwlzj0wMQG7eO4Q"

  2. Filter out http packets in wireshark.

  3. Right-click one of related packet >> `Follow` >> `HTTP Stream`

  <img width="480" src="https://user-images.githubusercontent.com/57078914/166149971-da7ae0fa-70dd-4502-9d35-6442ced263da.png">

