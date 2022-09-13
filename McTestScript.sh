#!/usr/bin/bash

#this script is just to interact with the server to extract online player info... 
#   run some tests on this and let me know the outcome
#   NOTE: you might have to change the port if u did some sus shit



# !/bin/bash
# email="user@domain.com"
# message="Someone has logged in to the Minecraft server"
if[ -s .players ]; then
lsof -iTCP:25565 -sTCP:ESTABLISHED > .players
else
lsof -iTCP:25565 -sTCP:ESTABLISHED > .players &&echo"$message"| /usr/sbin/ssmtp "$email"
fi