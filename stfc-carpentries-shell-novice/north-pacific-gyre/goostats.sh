#!/bin/bash
# goostats.sh: a research script by Jovyan Jetty
# Analyze "goo" input data and write "stats" to result file.

# check for the right number of input arguments
if [ $# -ne 2 ]
then
    echo "Usage: $0 input_file result_file" >&2
    exit 1
fi

# Check the input file exists
if [ ! -e "$1" ]
then
    echo "Error: $1 does not exist" >&2
    exit 2
fi

# Don't overwrite earlier results
if [ -e "$2" ]
then
    echo "Error: $2 already exists" >&2
    exit 2
fi

# run the numbers
sleep 0.2
head -n 3 "$1" | cut -d , -f 1 | sort | uniq > "$2"
