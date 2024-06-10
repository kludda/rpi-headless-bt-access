#!/bin/bash -e

#Edit the display name of the RaspberryPi so you can distinguish
#your unit from others in the Bluetooth console
#(very useful in a class setting)

echo -n PRETTY_HOSTNAME=rpi > /etc/machine-info
# add mac adress to hostname to make it unique
cat /sys/class/net/wlan0/address >> /etc/machine-info
#remove : from hostname
sed -e s/://g -i /etc/machine-info

# Edit /lib/systemd/system/bluetooth.service to enable BT services
sudo sed -i: 's|^Exec.*toothd$| \
ExecStart=/usr/sbin/bluetoothd -C \
ExecStartPost=/usr/bin/sdptool add SP \
ExecStartPost=/usr/bin/hciconfig hci0 piscan \
|g' /lib/systemd/system/bluetooth.service

# create /etc/systemd/system/rfcomm.service to enable 
# the Bluetooth serial port from systemctl
sudo cat <<EOF | sudo tee /etc/systemd/system/rfcomm.service > /dev/null
[Unit]
Description=RFCOMM service
After=bluetooth.service
Requires=bluetooth.service

[Service]
ExecStart=/usr/bin/rfcomm watch hci0 1 getty rfcomm0 115200 vt100 -a admin

[Install]
WantedBy=multi-user.target
EOF

# enable the new rfcomm service
sudo systemctl enable rfcomm

# start the rfcomm service
sudo systemctl restart rfcomm