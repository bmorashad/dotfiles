#!/bin/bash

echo "installing, enabling and starting vnstat (data usage monitoring tool)"
sudo eopkg install vnstat;
sudo systemctl enable vnstat;
sudo systemctl start vnstat;
