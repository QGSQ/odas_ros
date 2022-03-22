#!/usr/bin/env bash

## Creates an echo cancelled source from source $1

# $1 is the sound source name from "pacmd list-sources | grep 'name:'"
# $2 is the sound sink name from "pacmd list-sinks | grep 'name:'"
# $3 is a name for the resulting names, and it should not contain spaces
#   -> Echo cancelled source name and description: $3_ec
#   -> Echo cancelled sink name and description: $3_ec_sink
# $4 is volume in percent to which the sink should be set, and is 100% by default

source_name="$3_ec"
sink_name="$3_ec_sink"
[[ -z "$4" ]] && volume="100" || volume="$4"

pactl unload-module module-echo-cancel 2> /dev/null
pactl load-module module-echo-cancel source_master="$1" sink_master="$2" aec_method=webrtc source_name=$source_name sink_name=$sink_name use_master_format=yes source_properties=device.description=$source_name sink_properties=device.description=$sink_name 1> /dev/null

rosrun odas_ros movesinks.sh $sink_name
rosrun odas_ros setvolume.sh $source_name $volume
