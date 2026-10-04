#!/bin/bash
# goostats-batch.sh: run goostats.sh on many input files.
# Written by Joyvan's LLM assistant, but reviewed carefully by Jovyan.

# Check we were given at least one input file
if [ $# -lt 1 ]
then
    echo "Usage: $0 input_file [input_file ...]" >&2
    exit 1
fi

# Repeat for every input file we were given
for input_file in "$@"
do
    echo "Processing $input_file"
    ./goostats.sh "$input_file" "stats-$input_file"
done
