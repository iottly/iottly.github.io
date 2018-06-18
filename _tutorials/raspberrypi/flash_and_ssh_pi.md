---
title: Iottly tutorials
---

# How To flash and ssh to your Pi

What you **will learn** in this tutorial:

- How to [Setup the Raspberry Pi from Windows](#setup-the-raspberry-pi-from-windows)
- How to [Setup the Raspberry Pi from Linux](#setup-the-raspberry-pi-from-linux)


## Setup the Raspberry Pi from Windows

1. Download the [Raspbian Lite image](https://downloads.raspberrypi.org/raspbian_lite_latest){:target="_blank"} 
2. Configure the WiFi on the image before flashing:
- Mount the image via [OSFMount](http://www.osforensics.com/tools/mount-disk-images.html){:target="_blank"} and [Ext2Sfd](https://sourceforge.net/projects/ext2fsd/files/Ext2fsd/0.66/Ext2Fsd-0.66.exe/download){:target="_blank"} 
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
   - From Windows: Execute [Win32 Disk Imager](https://sourceforge.net/projects/win32diskimager/){:target="_blank"} as Administrator
5. Insert the micro-sd into the Raspberry Pi and power it on
6. To detect the board IP: 
   - use [Advanced IP scanner](http://www.advanced-ip-scanner.com){:target="_blank"}
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

