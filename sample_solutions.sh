#!/bin/bash

JAR=paper-1.19.2-141.jar
MAXRAM=12G
MINRAM=12G
TIME=10

############################################
#   og sol                                 #
############################################

sudo shutdown +60
while [ true ]; do
    java -Xmx$MAXRAM -Xms$MINRAM -jar $JAR nogui
    if [[ ! -d "exit_codes" ]]; then
        mkdir "exit_codes";
    fi
    if [[ ! -f "exit_codes/server_exit_codes.log" ]]; then
        touch "exit_codes/server_exit_codes.log";
    fi
    echo "[$(date +"%d.%m.%Y %T")] ExitCode: $?" >> exit_codes/server_exit_codes.log
    echo "----- Press enter to prevent the server from restarting in $TIME seconds -----";
    read -t $TIME input;
    if [ $? == 0 ]; then
        break;
    else
        echo "------------------- SERVER RESTARTS -------------------";
    fi
done

############################################
#   solution 1                             #
############################################

sudo shutdown +120                      #shutdown after 2 hours
while [ true ]; do
    java -Xmx$MAXRAM -Xms$MINRAM -jar $JAR nogui
    if [[ ! -d "exit_codes" ]]; then
        mkdir "exit_codes";
    fi
    if [[ ! -f "exit_codes/server_exit_codes.log" ]]; then
        touch "exit_codes/server_exit_codes.log";
    fi
    echo "[$(date +"%d.%m.%Y %T")] ExitCode: $?" >> exit_codes/server_exit_codes.log

    ##left out the read input line since i doubt they were ever being used 
    lsof -iTCP:25565 -sTCP:ESTABLISHED > .players               #output connection to file ".player" 
    if [[ -s .players ]]; then      #if .players file exists and is non-empty 
        sudo shutdown -c        #cancels scheduled shutdown.. although this might be too late to cancel it...
        sudo shutdown +60 
            #my theory is that everything after the line "java -Xmx....." is ran when shutdown stops the java
            # program. in which case it might be too late to cancel it? test it out
    else
        break;
    fi
done



############################################
#   solution 2                             #
############################################
    
    #if the exit logs arent important to you... this might be a better alternative 


sudo shutdown +60                      #shutdown after 2 hours
java -Xmx$MAXRAM -Xms$MINRAM -jar $JAR nogui &
java_pid=$!                             #store the pid to check/kill later (just in case... the server should never be quit this way)
while [ true ]; do 
    sleep 59m                           #sleep for 60m while java is running in background (change this to interval of player checks)
    lsof -iTCP:25565 -sTCP:ESTABLISHED > .players               #output connection to file ".player"    
    if [[ -s .players ]]; then          #if .players file exists and is non-empty 
        sudo shutdown -c                #stop shutdown timer
        sudo shutdown +60.              #reset shutdown timer for another hour, then do it again     
    else
        break;                          #exits the loop and lets it shutdown.
    fi
done







