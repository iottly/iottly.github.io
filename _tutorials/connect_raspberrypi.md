---
title: Iottly tutorials
---

# Connect the Raspberry Pi to Iottly


What you **will learn** in this tutorial:


- How to [Setup your notebook](#setup-your-notebook) for Windows or Linux
- How to [Setup the Raspberry Pi from Windows](#setup-the-raspberry-pi-from-windows)
- How to [Setup the Raspberry Pi from Linux](#setup-the-raspberry-pi-from-linux)
- How to [Register the Raspberry Pi with Iottly](#register-the-raspberry-pi-with-iottly) for Windows or Linux
- how to [Remote programming with Iottly](#remote-programming-with-iottly)
- [Board Attributes](#board-attributes)
- [Deployment group](#deployment-groups)
- How to [Uninstall the agent](#uninstall-agent)


## Setup your notebook


Notebook setup:
- On **MS Windows**, install the following tools **only for first board setup**:
   - OSFMount: [download](http://www.osforensics.com/tools/mount-disk-images.html){:target="_blank"} 
   - Ext2Sfd: [download](https://sourceforge.net/projects/ext2fsd/files/Ext2fsd/0.66/Ext2Fsd-0.66.exe/download){:target="_blank"} 
   - Win32 Disk Imager: [download](https://sourceforge.net/projects/win32diskimager/){:target="_blank"} 
   - Putty: [download](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html){:target="_blank"}
   - Advanced IP scanner: [download](http://www.advanced-ip-scanner.com){:target="_blank"}
   
- On **Linux**:
   - Nothing to do 
   
- Connect the laptop to your local network


## Setup the Raspberry Pi from Windows

If your Raspberry Pi is already configured and connected in your local network either wifi or LAN, **skip to** number 6.

1. Download the [Raspbian Lite image](https://downloads.raspberrypi.org/raspbian_lite_latest){:target="_blank"} 
2. Configure the WiFi on the image before flashing:
   - Mount the image via OSFMount and Ext2Sfd
   - Open the file /etc/wpa_supplicant/wpa_supplicant.conf with notepad
   - Add this snippet at the end of the file: 
      ```
      network={
         ssid="<SSID OF YOUR WIFI>"
         psk="<PASSWORD OF YOUR WIFI>"
      }
      ```
3. **Enable ssh** by placing a file named `ssh`, without any extension, onto the boot partition of the image.
4. Flash the image onto the micro-sd card:
   - From Windows: Execute Win32 Disk Imager as Administrator
5. Insert the micro-sd into the Raspberry Pi and power it on
6. To detect the board IP: 
   - use Advanced IP scanner
   - or check into the Router web interface


## Setup the Raspberry Pi from Linux

If your Raspberry Pi is already configured and connect in your local network either wifi or LAN, **skip to** number 6.

1. Download the [Raspbian Lite image](https://downloads.raspberrypi.org/raspbian_lite_latest){:target="_blank"} 
2. Configure the WiFi on the image before flashing:
   - Use this [script to setup wifi](https://github.com/iottly/iottly-device-agent-py/blob/master/iottly-device-tools/configure-wifi-rpi.sh){:target="_blank"} 
   - `./configure-wifi-rpi.sh [image path] [wifi ssid] [wifi password]`
3. **Enable ssh**:
    - Use this [script to enable ssh](https://github.com/iottly/iottly-device-agent-py/blob/master/iottly-device-tools/enable-ssh.sh){:target="_blank"} 
   - `./enable-ssh.sh [image path]`
4. Flash the image onto the micro-sd card:
   - full tutorial [here](http://tomorrowdata.io/2015/10/24/sd-and-micro-sd-management-with-linux-dd/){:target="_blank"}: `sudo dd bs=4M if=[image file name].img of=/dev/sd[X]`
   - **CAUTION**: double check `of=/dev/sd[X]`to be sure `sd[X]` is the SD card.
5. Insert the micro-sd into the Raspberry Pi and power it on
6. To detect the board IP: 
   - `sudo arp-scan 192.168.1.0/24` or whatever is your class


## Register the Raspberry Pi with Iottly


Connect to the board via ssh:
- User: pi
- Password: raspberry
   - From **Linux**: `ssh pi@[detected IP]`
   - From **Windows**: run putty.exe

>**- This is the first and only time you need to connect via ssh on the board


From the Iottly project/ DEVICE-CONFIGURATION/ Add device/ Connect your RaspberryPi:
- Copy the registration command


![Alt text](/images/registration_command.png)


- Paste it into ssh or putty
   - in putty right-click to paste
- Execute the command which will **automatically** take care of:
   - downloading the agent installer customized from your IoT project
   - checking and install newly available firmware in /var/iottly-agent/userpackageuploads
   - registering the device
   - connecting the device to Iottly

**Pair the board** while installation is in progress.


Communication with the board is encrypted and authenticated. The **Iottly pairing procedure** guarantees the physical identification of the device.

- copy the token from the ssh console

![get token from ssh console](/images/ssh_pairing.png)


- and paste the token here
 
 
![Alt text](/images/pairing.png)


## Remote programming with Iottly


From now you can program and manage the board entirely **from the Internet (Over-the-Air)**.
Your computer doesn't need to be connected to the same network as the board anymore.

![Alt text](/images/slide12.png)



##  Board Attributes

- **Unique ID**: 
   - this is the unique identifier of the board within Iottly
   - it is the username for MQTT authentication
- **Board MAC address**: 
   - if the board is reset to factory after having been registered, Iottly will assign the same Unique ID it generated during the first registration, based on the MAC address.
- **click** on the board to edit the description (or remove)
   

## Deployment groups


New Deployment groups
- write Name of your group
- insert the Board to the deployment group
       
       
## Uninstall agent   


 Only if you want to unistall the agent, run this command from the home in ssh or putty:
`iottly-device-agent-py/iottly-device-agent-py/uninstall`


## Further instructions on the following tutorial:
- [Get started]({{'tutorials/get_started' | relative_url}})


