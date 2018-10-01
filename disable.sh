#!/bin/bash

## Setup
[[ $# == 0 ]] && filename="disable-list.txt" || filename="${1}"
packages=($(awk 'BEGIN { FS = "[ \t]+" } ; { print $1 }' ${filename}))
devices=($(adb devices | tail -n +2 | cut -sf 1))

## Go through each device
for device in "${devices[@]}"
do
  echo -e "Device: \t ${device}"

  ## Go through each package
  for package in "${packages[@]}"
  do

    ## Try to disable
    adb -s ${device} shell "pm disable ${package}" &>/dev/null
    if [ $? == 0 ]; then
      echo -e "Disabled: \t ${package}"
    else
      echo -e "Failed to disable: \t ${package}"
    fi
  done
done
