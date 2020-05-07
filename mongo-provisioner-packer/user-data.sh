#!/bin/bash
#sudo rm -rf /var/lib/cloud
sudo systemctl daemon-reload
sudo systemctl start mongod	
systemctl enable mongod.service