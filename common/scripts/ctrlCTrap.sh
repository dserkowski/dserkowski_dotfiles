#!/bin/bash
set -eu

commandToExecute="${1:?no command passed}"

# break `command1 ; command2 || command3` chains when Ctrl+C happens
trap "{ echo 'Terminated with Ctrl+C'; exit 1; }" SIGINT

eval "$commandToExecute"