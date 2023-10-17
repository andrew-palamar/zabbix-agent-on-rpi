# zabbix-agent-on-rpi

Script and template for zabbix-agent2 to run on raspberryPi.

Fetch install script from GitHub:
```
wget https://raw.githubusercontent.com/andrew-palamar/zabbix-agent-on-rpi/master/install.sh
```

Change permissions for script:
```
chmod +x install.sh
```

Run install script. 
```
./install.sh
```

Import the Template in your Zabbix Server frontend.
Assign it to the host.

# Thanks to 
Bernhard Linz for his Tutorial and Script on [http://znil.net/index.php/Zabbix:Template_Raspberry_Pi]
