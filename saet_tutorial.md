---
title: Saet Tutorial
---
# Support

For support:
- write to: support@iottly.com
- call: +39 0110121019

# Contents

Tutorial for using iottly with Saet Athena boards:

- [iottly Agent](#iottly-agent)
  - [Install iottly agent on Athena board](#install-iottly-agent-on-athena-board)
    - [Install with GPRS](#install-with-gprs)
    - [Notes](#notes)
  - [Agent specifications](#agent-specifications)
    - [Security and certificates](#security-and-certificates)
  - [Reinstall iottly agent on Athena board](#reinstall-iottly-agent-on-athena-board)
  - [Uninstall the agent from Athena Board](#uninstall-the-agent-from-athena-board)
- [Web SSH from iottly](#web-ssh-from-iottly)
  - [Security](#security)
  - [Close the session](#close-the-session)
  - [Reboot](#reboot)
- [Move files to and from the Athena board](#move-files-to-and-from-the-athena-board)
  - [Access to Amazon S3 bucket](#access-to-amazon-s3-bucket)
  - [Bucket folders](#bucket-folders)
  - [Move a file from your computer to the Athena board](#move-a-file-from-your-computer-to-the-athena-board)
  - [Move a file from the Athena board to your computer](#move-a-file-from-the-athena-board-to-your-computer)
- [Example Code Snippets](#Example-Code-Snippets)
  - [ps to dict](#_ps_to_dict():)
  - [reboot](#_reboot():)
  - [get saet version](#_get_saet_version():)
  - [ifconfig](#_ifconfig():)


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

## Reinstall iottly agent on Athena board

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
- click on _Connect to ..._


## Security
The ssh session is started **from the board** when it receives a specific command via MQTT; so it works from behind any type of firewall, provided the board has outbound connectivity to port 2200 of our server.

The board does not expose any port to the Internet.

The ssh server on the board is normally **off** and is started only when the MQTT message is received.

## Close the session

To close the ssh session:
- click on the red button _Close_ on top of the terminal
- **please do not type `exit` on the terminal**: it breaks something on our ssh service for now
  - in case you do it, write to support@iottly.com and just tell it, we'll restart our ssh service

## Reboot

In case you want to reboot the board from ssh, just remember to close the session with the red button after the reboot.

# Move files to and from the Athena board

You can easily move files to and from the Athena board, passing them through an Amazon S3 bucket.

This feature is provided by two macros available in Saet projects:
- `download_file`: download a **from S3** into the board
- `upload_file`: upload a file **from the board** to S3

## Access to Amazon S3 bucket

- bucket name: `saet-files-repo`
- login here: 
  - [https://258881803388.signin.aws.amazon.com/console/s3](https://258881803388.signin.aws.amazon.com/console/s3){:target="_blank"} 
  - you receive an _Access Denied_ error: **that's OK**
- after login, to access the bucket go here:
  - [https://s3.console.aws.amazon.com/s3/buckets/saet-files-repo/](https://s3.console.aws.amazon.com/s3/buckets/saet-files-repo/){:target="_blank"} 

## Bucket folders

There are three folders in the bucket, corresponding to the three position in which you can place or get the files.

## Move a file from your computer to the Athena board

- access the S3 bucket
- go to your folder
- upload the file from your computer to the folder (click upload, or simply drag the file)
- go to iottly, in the project where the board is connected
- navigate to the _Console_ tab and expand the panel (with the double arrow on the top right corner of the panel)
- choose your board (from the list on top of the panel)
- on _download_file_ click _send_
- choose the **source** folder on S3
- write the name of the file you have already uploaded to S3
- click send
- After the download is completed a message will show its status in the _Logs_:
> ```json
> {
>   "timestamp": "2017-08-10T12:10:01",
>   "devicetimestamp": "2017-08-10T12:10:03",
>   "type": "userdefined",
>   "payload": {
>     "download_file": {
>       "status": "successful",
>       "dest_file": "/tmp/isi"
>     }
>   }
> }
>```

- In case of errors, the message will show some details.
- The files are always placed in the Athena `/tmp` dir, with the same name they have on S3.

## Move a file from the Athena board to your computer

- go to iottly, in the project where the board is connected
- navigate to the _Console_ tab and expand the panel (with the double arrow on the top right corner of the panel)
- choose your board (from the list on top of the panel)
- on _upload_file_ click _send_
- choose the **destination** folder on S3
- write the **full path** (with file name) of the file you want to send to S3
- click send
-  After the upload is completed a message will show its status in the _Logs_:
> ```json
> {
>   "timestamp": "2017-08-10T12:16:32",
>   "devicetimestamp": "2017-08-10T12:16:34",
>   "type": "userdefined",
>   "payload": {
>     "upload_file": {
>       "status": "successful",
>       "dest_file": "/giancarlo/isi.log.0"
>     }
>   }
> }
>```

- In case of errors, the message will show some details.
- The files are always stored in S3 with the same name they have on the Athena.
- access the S3 bucket
- go to your folder
- locate and download the file you just uploaded from the board

# Example Code Snippets
## _ps_to_dict():
  ```
  def _ps_to_dict():
   
    def psraw_to_dict(psraw):
      items = list(map(lambda s: s.strip(), psraw.split('\|')))
      return {ps_headers[index]: item for index, item in enumerate(items) if index in ps_headers.keys()}
    
      return [psraw_to_dict(psraw) for psraw in check_output(["ps","-axo","%p\|%c\|%a"],shell=False).decode().split("\n")]
  ```
## _reboot():
  ```
  def _reboot():
    return check_output(["reboot","-f"],shell=False)
  ```
## _get_saet_version():
  ```
  def _get_saet_version():
    return check_output(["/saet/saet","-v"],shell=False).decode().split("\n")
  ```
## _ifconfig():
  ```
  def _ifconfig():
    
    ifcfg = check_output(["ifconfig"],shell=False).decode().split("\n")
    
    netconf = []
    with open('/etc/network/network.conf', 'r') as f:
      netconf = list(map(lambda l: l.rstrip(), list(f)))
      
    return {'interfaces': ifcfg, 'networkconf': netconf}
  ```
  
