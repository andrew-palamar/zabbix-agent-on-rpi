#/bin/bash

checkexit() {
    # Check exitcode
    if [ $? != 0 ]; then
        printf "Installation failed! Process returned bad exitcode.\n"
        exit 1
    fi
}

sudo apt update
sudo apt install zabbix-agent2 -y

# Create script location:
scriptpath="/etc/zabbix/scripts"
[ -d $scriptpath ] || sudo mkdir -p $scriptpath

# Fetch script
script="/etc/zabbix/scripts/raspberrypi.sh"
[ -f $script ] || sudo wget https://raw.githubusercontent.com/andrew-palamar/zabbix-agent-on-rpi/ds18b20/raspberrypi.sh -O $script
checkexit
# Change permissions for script:
sudo chmod 755 $script
checkexit

# Add zabbix user to video group to get required permissions.
sudo usermod -aG video zabbix
checkexit

# Test script as user zabbix:
printf "Test installed script as zabbix user.\n"
sudo -u zabbix /etc/zabbix/scripts/raspberrypi.sh temperature
checkexit
printf "OK\n"

# Add script to zabbix configuration file (append)
string='UserParameter=raspberrypi.sh[*],/etc/zabbix/scripts/raspberrypi.sh $1'
file='/etc/zabbix/zabbix_agent2.conf'

if grep -qF "$string" "$file"; then
    echo "String already exists in the destination file."
else
    echo "$string" | sudo tee -a "$file"
fi

checkexit

# Restart the zabbix agent:
sudo systemctl restart zabbix-agent
sudo systemctl status zabbix-agent
checkexit
printf "Installation script completed!\n"
