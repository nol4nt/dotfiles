#!/bin/bash

# Battery Status
battery() {
    capacity=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
    [ -n "$capacity" ] && echo "Battery: ${capacity}%" || echo "Battery: N/A"
}

# Wi-Fi Status
wifi() {
    #ssid=$(iwctl station wlan0 get-networks | awk 'NR>1 {print $2}' | head -n 1)
    ssid=$(iwctl station wlan0 show | grep "Connected network" | awk '{print $3}')
    if [ -n "$ssid" ]; then
        echo "Wi-Fi: ${ssid}"
    else
        echo "Wi-Fi: Disconnected"
    fi
}

# Bluetooth Status
bluetooth() {
    if bluetoothctl show | grep -q "Powered: yes"; then
        echo "Bluetooth: On"
    else
        echo "Bluetooth: Off"
    fi
}

# Audio Status (PulseAudio)
audio() {
    volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}')
    muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
    
    if [ "$muted" = "yes" ]; then
        echo "Audio: Muted"
    else
        echo "Audio: ${volume}"
    fi
}

# Print the combined status bar info
while :; do
    echo "$(battery) | $(wifi) | $(bluetooth) | $(audio)"
    sleep 1
done

