# simple-pomodoro-timer
A simple Pomodoro timer for Darwin operating systems that runs in the shell.

This is a basic bash script that counts down from 25 minutes, alerts the user, and starts a timer for a five-minute break. After four work cycles are completed a longer break of 20 minutes is started. The script will continue to run until SIGINT is detected "Ctrl + C". To adjust work and break times just update the variables with the desired time lengths.
