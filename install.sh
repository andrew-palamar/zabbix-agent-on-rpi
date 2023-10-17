#/bin/bash

checkexit() {
    # Check exitcode
    if [ $? != 0 ]; then
        printf "Installation failed! Process returned bad exitcode."
        exit 1
    fi
}

sudo apt update
sudo apt install zabbix-agent2 -y

# Create script location:
sudo mkdir -p /etc/zabbix/scripts

# Fetch script
sudo wget https://raw.githubusercontent.com/andrew-palamar/zabbix-agent-on-rpi/ds18b20/raspberrypi.sh -O /etc/zabbix/scripts/raspberrypi.sh
checkexit
# Change permissions for script:
sudo chmod 755 /etc/zabbix/scripts/raspberrypi.sh
checkexit

# Add zabbix user to video group to get required permissions.
sudo usermod -aG video zabbix
checkexit

# Test script as user zabbix:
printf "Test installed script as zabbix user."
sudo -u zabbix /etc/zabbix/scripts/raspberrypi.sh temperature
checkexit

# Add script to zabbix configuration file (append)
echo 'UserParameter=raspberrypi.sh[*],/etc/zabbix/scripts/raspberrypi.sh $1' | sudo tee -a /etc/zabbix/zabbix_agent2.conf
checkexit

# Restart the zabbix agent:
sudo systemctl zabbix-agent restart
sudo systemctl zabbix-agent status
checkexit
printf "Installation script completed!"
