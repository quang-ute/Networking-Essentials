# Inspecting http request & response

1. Open wireshark in browser `http://localhost:3000` then double-click active NIC to inspect. Usually it is `eth0`
2. In Windows Terminal, attaching to the console of the wireshark container: `docker exec -it web-server sh -l`

## For simple html request

At the wireshark container: `curl http://web-server:3000/index.html`


