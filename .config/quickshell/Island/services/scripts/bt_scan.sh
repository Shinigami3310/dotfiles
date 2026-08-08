#!/bin/bash
# Сканирование Bluetooth-устройств: список + connected/paired статусы.
# Вызывается из BluetoothService.scanProc.
set -e

p=$(bluetoothctl devices Paired | awk '{print $2}')
devs=$(bluetoothctl devices | awk '{print $2}')
c=""
for mac in $devs; do
    info=$(bluetoothctl info "$mac" | sed 's/\x1b\[[0-9;]*m//g')
    if echo "$info" | grep -q "Connected: yes"; then
        if echo "$info" | grep -q "ServicesResolved: yes"; then
            c="$c $mac"
        fi
    fi
done

bluetoothctl devices | awk -v c_list="$c" -v p_list="$p" '
BEGIN {
    split(c_list, c_arr, " ");
    for (i in c_arr) if (c_arr[i] != "") connected_map[c_arr[i]] = 1;
    split(p_list, p_arr, " ");
    for (i in p_arr) if (p_arr[i] != "") paired_map[p_arr[i]] = 1;
}
NF>1 {
    mac = $2;
    $1 = ""; $2 = "";
    sub(/^[ \t]+/, "");
    name = $0;
    is_c = (mac in connected_map) ? "true" : "false";
    is_p = (mac in paired_map) ? "true" : "false";
    print mac "|" is_c "|" is_p "|" name
}'