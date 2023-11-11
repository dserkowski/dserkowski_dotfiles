#!/bin/bash

# Get the current date in the desired format (YYYY-MM-DD)
current_date=$(date +'%Y-%m-%d')

# Use xdotool to type the current date
xdotool type "$current_date"

