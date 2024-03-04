#!/bin/bash

echo "installing, enabling and starting vnstat (data usage monitoring tool)"
sudo eopkg install vnstat
sudo systemctl enable vnstat
sudo systemctl start vnstat

echo "Starting xremp (i.e: $GITHUB/xremap) for keyboard mapping "
cd $GITHUB/xremap
cp xremap.service /etc/systemd/system/xremap.service
sudo systemctl enable xremap.service
sudo systemctl start xremap.service
sudo systemctl status xremap.service
