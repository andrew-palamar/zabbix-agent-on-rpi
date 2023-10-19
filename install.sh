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

# Create zabbix script location:
scriptZabbixpath="/etc/zabbix/scripts"
[ -d $scriptZabbixpath ] || sudo mkdir -p $scriptZabbixpath

# Fetch script
scriptzabbix="$scriptZabbixpath/raspberrypi.sh"
[ -f $scriptzabbix ] || sudo wget https://raw.githubusercontent.com/andrew-palamar/zabbix-agent-on-rpi/ds18b20/raspberrypi.sh -O $scriptzabbix
checkexit
# Change permissions for script:
sudo chmod 755 $scriptzabbix
checkexit

# Create poll script location:
scriptPollpath="/opt/poll_sensors"
[ -d $scriptPollpath ] || sudo mkdir -p $scriptPollpath

# Fetch poll script
scriptpoll="$scriptPollpath/poll_ds18b20.sh"
[ -f $scriptpoll ] || sudo wget https://raw.githubusercontent.com/andrew-palamar/zabbix-agent-on-rpi/ds18b20/poll_ds18b20.sh -O $scriptpoll
checkexit
# Change permissions for script:
sudo chmod 755 $script
checkexit

# Add Cron job for sensors polling each minute
str='*/1 * * * * root /opt/poll_sensors/poll_ds18b20.sh'
f='/etc/crontab'
if grep -qF "$str" "$f"; then
    echo "String already exists in the destination file."
else
    echo -e "\n$str" | sudo tee -a "$f"
fi

# Add zabbix user to video group to get required permissions.
sudo usermod -aG video zabbix
checkexit

# Run script as user zabbix:
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
    echo -e "\n$string" | sudo tee -a "$file"
fi

checkexit

# Restart the zabbix agent:
sudo systemctl restart zabbix-agent2
sudo systemctl status zabbix-agent2
checkexit
printf "Installation script completed!\n"
