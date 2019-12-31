---
title: Iottly tutorials
---

# Connect a generic device to Iottly

When your device is not a RaspberryPi or a device with a dedicated installer
you can install the __iottly agent__ using a generic Linux installer that comes
pre-packaged for various architectures:

- x86_64
- i386
- ARM (v5 and v6)

In this tutorial we are going to assume an `x86_64` architecture.

## Install the agent on your device

To add a device to your project, go to the __DEVICE CONFIGURATION__ panel and click
the __ADD DEVICE__ button. The first step of the installation is giving a name to
the new device.
![iottly pairing](/images/agent_installation/step-1.png)
After that you will see the installation steps needed to install the __iottly agent__
on your device (see the picture below).
![iottly pairing](/images/agent_installation/step-2.1.png)

You can follow these steps to set-up the __iottly agent__ or continue reading
this guide to complete the installation process.

We should now open a shell to the device where you want to install the __iottly agent__
and download the installer package. Once the download is finished we need to extract
the agent to a directory of your choice (we chose `/opt/iottly.com-agent` in this example).
![iottly pairing](/images/agent_installation/step-3.1.png)

The last step in the procedure is running the configuration script that will
perform the registration of the device to the __iottly cloud__.
![iottly pairing](/images/agent_installation/step-2.2.png)
![iottly pairing](/images/agent_installation/step-3.2.png)
The installation procedure will ask for confirmation to finalize the installation.
![iottly pairing](/images/agent_installation/step-3.3.png)
Once the installation is completed you can start the __iottly agent__ by running
`/opt/iottly.com-agent/sbin/iottly` executable (you should adapt the path to the
one chosen during the installation).
![iottly pairing](/images/agent_installation/step-3.4.png)

## Configure your system to start the iottly agent at boot
The manual installation procedure doesn't install the __iottly agent__ as a service
on your system. You should configure your system to auto-start the agent depending
on which system you are using:

### Debian-like systems (Debian, Ubuntu, ...)
Recent Ubuntu or Debian distribution use Systemd as init system. In order to
auto-start the __iottly agent__ on these systems you need to configure a systemd-unit.


Copy this configuration to `lib/systemd/system/iottly-device-agent.service`
```
Description=Iottly Agent
After=network.target multi-user.target

[Service]
Type=idle
Restart=always
ExecStart=/bin/sh /opt/iottly.com-agent/sbin/iottly

[Install]
WantedBy=multi-user.target
```

The enable the service with:
```
sudo chmod 644 /lib/systemd/system/iottly-device-agent.service
sudo systemctl daemon-reload
sudo systemctl enable iottly-device-agent.service
sudo systemctl start iottly-device-agent.service
```



