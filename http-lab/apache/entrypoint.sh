#!/bin/bash

# Start Apache in the background
service apache2 start

# Keep the container running by tailing Apache logs (or another persistent process)
tail -f /var/log/apache2/access.log