#!/bin/bash

# Converts to float and rounds to .1 precision
round() {
echo $(awk -v val=$1 'BEGIN { rounded = sprintf("%.1f", val/1000); print rounded }') > /tmp/$2
}

# get First DS18B20 Temperature
value=$(cat /sys/bus/w1/devices/28-3c25e381a90f/temperature)
round $value 28-3c25e381a90f

# get Second DS18B20 Temperature
value=$(cat /sys/bus/w1/devices/28-3c28e381bf9d/temperature)
round $value 28-3c28e381bf9d

# get Third DS18B20 Temperature
value=$(cat /sys/bus/w1/devices/28-3c52e381f9c9/temperature)
round $value 28-3c52e381f9c9

# get Fourth DS18B20 Temperature
value=$(cat /sys/bus/w1/devices/28-3c8ae3819f48/temperature)
round $value 28-3c8ae3819f48
