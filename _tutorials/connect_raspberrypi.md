---
title: Iottly tutorials
---

# Connect the Raspberry Pi to Iottly


What you **will learn** in this tutorial:


- How to [Register the Raspberry Pi with Iottly](#register-the-raspberry-pi-with-iottly) for Windows or Linux
- how to [Remote programming with Iottly](#remote-programming-with-iottly)
- [Board Attributes](#board-attributes)
- [Deployment group](#deployment-groups)
- How to [Uninstall the agent](#uninstall-agent)


## Register the Raspberry Pi with Iottly
##### If your PC is not correctly configurated [CLICK HERE]({{'tutorials/flash_and_ssh_pi' | relative_url}})

Connect to the board via ssh:
- User: pi
- Password: raspberry
   - From **Linux**: `ssh pi@[detected IP]`
   - From **Windows**: [run putty.exe](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html){:target="_blank"}

>**- This is the first and only time you need to connect via ssh on the board**


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


