#!/bin/bash
# Get the current date and time in the desired format (YYYY-MM-DD HH:MM)
current_datetime=$(date +'%Y-%m-%d %H:%M')

# Use xdotool to type the current date and time
xdotool type "$current_datetime"