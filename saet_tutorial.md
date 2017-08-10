---
title: Saet Tutorial
---

# Contents

Tutorial for using iottly with Saet Athena boards:

- [Move the board to another project](#move-the-board-to-another-project)

# iottly Agent

## Install iottly agent on Athena board

1. navigate to iottly: [https://staging.iottly.com](https://staging.iottly.com)
2. login
3. open the project in which you want to place your board
4. in the _Device Configuration_ tab click on _Add Device_
5. follow the instructions showed there
6. ...
7. after a bit of time you should see the green ligth on the board under _Device Configuration_

### Install with GPRS

**Before installing:**
1. **power off** the board
2. remove the SIM card
3. connect to the LAN
4. **power on** the board
5. continue from step 1 above

**After the installation is completed:** 
- the board **will not** connect
- the DNS are set to the TELCO operators and don't work over LAN

1. insert the SIM card
2. wait for the led to start blinking slowly
3. after a bit of time you should see the green ligth on the board under _Device Configuration_

### Notes

- the installer automatically sets iottly autostart in `/etc/inittab`
- the installer authomatically fixes the hwclock UTC problem, if found (script `/etc/rc.d/init.d/settime`)
- the installer authomatically tries to set the time with ntp
- the installer authomatically set the NAMESERVER to "8.8.8.8", if it is not already set in `/etc/network/network.conf`

## Agent specifications

- Logs:
  - `/var/iottly-agent/iottly.log`
  - rolling, 100Kb block, max 2 blocks
- pid file (to kill iottly):
  - `/var/iottly-agent/iottly.pid`
- installation path: 
  - `/mnt/flash/iottly`
  - or the link `/iottly -> /mnt/flash/iottly`
  - python: `/iottly/iottly/bin/python3.6`
- configuration file:
  - `/iottly/iottly-device-agent-py/iottly-device-agent-py/settings.json`

### Security and certificates

- MQTT certificates:
  - mutual authentication is implemented, with the following certs:
  - device authentication private certificate: `/iottly/iottly-device-agent-py/iottly-device-agent-py/certs/device.pem`
  - cloud server is authenticated with a public root certificate: `/iottly/iottly-device-agent-py/iottly-device-agent-py/certs/root_ca.pem`
- SSH certificates:
  - device authentication to iottly ssh server: `/root/.ssh/iottly_ssh_dropbear`
  - iottly private ssh box authentication to device: `/root/.ssh/authorized_keys`

## Reinstall iottly agent within Athena board

When installing iottly on a board with iottly already installed, the previous isntallation is automatically removed.

### Same project

In case you need to format the Athena board, or simply you uninstalled iottly and want it again, you can just repeat the installation procedure. 
- If the board preserves its MAC address, it will be binded to the same object on iottly. 
- In case the board gets a new MAC address, a new objec tin iottly will be generated.
  - in this case you can remove the old object from iottly.

### Move the board to another project

Simply repeat the installation procedure from the new project (downloading the installer from the new project).

## Uninstall the agent from Athena Board

`/iottly/iottly-device-agent-py/iottly-device-agent-py/uninstall`

# Web SSH from iottly

When the board is installed with the iottly agent and connected (green light), you can ssh into the board directly from the web page of the project:
- navigate to the _Terminal_ tab (the last one on the right)
- select the board you want to connect to
- click on __Connect to ... __


## Security
The ssh session is started **from the board** when it receives a specific command via MQTT; so it works from behind any type of firewall, provided the board has outbound connectivity to port 2200 of our server.
The board does not expose any port to the Internet.
The ssh server on the board is normally **off** and is started only when the MQTT message is received.

## Close the session

To close the ssh session:
- click on the red button _Close_ on top of the terminal
- please do not type `exit` on the terminal: it breaks something on our ssh service for now
  - in case you do it, write to support@iottly.com and just tell it, we'll restart our ssh service

## Reboot

In case you want to reboot the board from ssh, just remember to close the session with the red button after the reboot.

# Move files to and from the Athena board


