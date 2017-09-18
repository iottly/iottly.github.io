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
- [Athena remote maintenance tools](#athena-remote-maintenance-tools)
  - [Killall](#killall)
  - [Reboot](#reboot)
  - [Ps](#ps)
  - [Ifconfig](#ifconfig)
  - [saet version](#saet-version)
  - [GSM signal power](#gsm-signal-power)
  - [start tcpdump](#start-tcpdump)
  - [stop tcpdump](#stop-tcpdump)
- [Example Code Snippets](#example-code-snippets)
  - [ps to dict](#ps-to-dict)
  - [reboot code](#reboot-code)
  - [get saet version](#get-saet-version)
  - [ifconfig](#ifconfig)
  - [killall](#killall)
  - [start tcp dump](#start-tcp-dump)
  - [stop tcp dump](#stop-tcp-dump)
  - [gsm signal power](#gsm-signal-power)


# iottly Agent

## Install iottly agent on Athena board

1. navigate to iottly: [https://staging.iottly.com](https://staging.iottly.com)
2. login
3. open the project in which you want to place your board
4. in the _Device Configuration_ tab click on _Add Device_
5. follow the instructions showed there
6. ...
7. after a bit of time you should see the green light on the board under _Device Configuration_
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
3. after a bit of time you should see the green light on the board under _Device Configuration_

### Notes

- the installer automatically sets iottly autostart in `/etc/inittab`
- the installer automatically fixes the hwclock UTC problem, if found (script `/etc/rc.d/init.d/settime`)
- the installer automatically tries to set the time with NTP
- the installer automatically set the NAMESERVER to "8.8.8.8", if it is not already set in `/etc/network/network.conf`

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

When installing iottly on a board with iottly already installed, the previous installation is automatically removed.

### Same project

In case you need to format the Athena board, or simply you uninstalled iottly and want it again, you can just repeat the installation procedure. 
- If the board preserves its MAC address, it will be binded to the same object on iottly. 
- In case the board gets a new MAC address, a new object in iottly will be generated.
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

## Close the ssh session

To close the ssh session you can:
1. click on the red button _Close_ on top of the terminal, or
2. type `exit` or `Ctrl D` in the console as usual

## Reboot

In case you want to reboot the board from ssh, just do it. The console will automatically close.

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

# Athena remote maintenance tools

## Killall
This command allows to kill the process "isi" or "saet" and you can choose the methods "9" or "15"

- go to iottly, in the project where the board is connected
- navigate to the _Console_ tab and expand the panel (with the double arrow on the top right corner of the panel)
- choose your board (from the list on top of the panel)
- on _killall_ click _send_
- for "processname" choose the process you would kill "isi" or "saet"
- for "signal" choose the method ("9" to have a killing force and "15" to have a killing clean out)
- click send
- message will show:
  ```
  {
    "timestamp": "2017-09-18T12:12:23",
    "devicetimestamp": "2017-09-18T12:12:23",
    "type": "userdefined",
    "payload": {
      "killall": {
        "returnstatus": "success"
      }
    }
  }
  ```
- In case of errors, the message will show some details.

# Reboot
This command allows to reboot the device with (optional) -f
- go to iottly, in the project where the board is connected
- navigate to the _Console_ tab and expand the panel (with the double arrow on the top right corner of the panel)
- choose your board (from the list on top of the panel)
- on _reboot_ click _send_
- if you would send the reboot without -f choose in the list "force" the parameter "no" 
- and click send
- else you would send the message with -f choose "Yes"
- click send

# Ps 
This command return a list of process running only on the device.
- go to iottly, in the project where the board is connected
- navigate to the _Console_ tab and expand the panel (with the double arrow on the top right corner of the panel)
- choose your board (from the list on top of the panel)
- on _ps_ click _send_
- now click send again
- message will show: 
  ```
    {
    "timestamp": "2017-09-18T12:29:03",
    "devicetimestamp": "2017-09-18T12:29:03",
    "type": "userdefined",
    "payload": {
      "processes": [
        "PID USER       VSZ STAT COMMAND",
        "    1 root      1900 S    init                ",
        "    2 root         0 SW<  [kthreadd]",
        "    3 root         0 SW<  [ksoftirqd/0]",
        "    4 root         0 SW<  [events/0]",
        "    5 root         0 SW<  [khelper]",
        "    8 root         0 SW<  [async/mgr]",
        "  116 root         0 SW<  [kblockd/0]",
        "  123 root         0 SW<  [mxc_spi.0]",
        "  127 root         0 SW<  [ksuspend_usbd]",
        "  131 root         0 SW<  [khubd]",
        "  150 root         0 SW<  [pmic_spi/0]",
        "  230 root         0 SW   [pdflush]",
        "  231 root         0 SW   [pdflush]",
        "  232 root         0 SW<  [kswapd0]",
        "  278 root         0 SW<  [aio/0]",
        "  913 root         0 SW<  [ubi_bgt0d]",
        "  916 root         0 SW<  [ubi_bgt1d]",
        "  933 root         0 SW<  [kconservative/0]",
        "  939 root         0 SW<  [hwevent]",
        "  957 root         0 SW<  [ubifs_bgt0_0]",
        "  967 root      1604 S <  udevd --daemon ",
        " 1859 root         0 SW<  [ubifs_bgt1_0]",
        " 1880 root      2076 S    /usr/sbin/dropbear ",
        " 1884 root      1332 S    /sbin/watchdog ",
        " 1890 root      1904 S    -/bin/sh ",
        " 2315 root      1904 S    /bin/sh /mnt/flash/iottly/iottly-device-agent-py/iott",
        " 2319 root     12880 S    /mnt/flash/iottly/iottly/bin/python3.6 /mnt/flash/iot",
        " 2326 root     13584 S    /mnt/flash/iottly/iottly/bin/python3.6 /mnt/flash/iot",
        " 2329 root     12880 S    /mnt/flash/iottly/iottly/bin/python3.6 /mnt/flash/iot",
        " 2330 root     12984 R    /mnt/flash/iottly/iottly/bin/python3.6 /mnt/flash/iot",
        " 2331 root     12788 S    /mnt/flash/iottly/iottly/bin/python3.6 /mnt/flash/iot",
        " 2348 root     12432 S    /isi/isi ",
        " 2352 root      1904 R    ps"
      ]
    }
  }
  ```

# Ifconfig
This command return a list of "interfaces"and "networkconf"
- go to iottly, in the project where the board is connected
- navigate to the _Console_ tab and expand the panel (with the double arrow on the top right corner of the panel)
- choose your board (from the list on top of the panel)
- on _ifconfig_ click _send_
- now click send again
- message will show: 
  ```
    {
    "timestamp": "2017-09-18T12:37:51",
    "devicetimestamp": "2017-09-18T12:37:51",
    "type": "userdefined",
    "payload": {
      "ifconfig": {
        "interfaces": [
          "eth0      Link encap:Ethernet  HWaddr 24:EB:65:00:10:E1  ",
          "          inet addr:192.168.72.161  Bcast:192.168.72.255  Mask:255.255.255.0",
          "          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1",
          "          RX packets:134228 errors:0 dropped:0 overruns:0 frame:0",
          "          TX packets:33064 errors:0 dropped:0 overruns:0 carrier:0",
          "          collisions:0 txqueuelen:1000 ",
          "          RX bytes:26453937 (25.2 MiB)  TX bytes:2848864 (2.7 MiB)",
          "          Base address:0x2000 ",
          "lo        Link encap:Local Loopback  ",
          "          inet addr:127.0.0.1  Mask:255.0.0.0",
          "          UP LOOPBACK RUNNING  MTU:16436  Metric:1",
          "          RX packets:341864 errors:0 dropped:0 overruns:0 frame:0",
          "          TX packets:341864 errors:0 dropped:0 overruns:0 carrier:0",
          "          collisions:0 txqueuelen:0 ",
          "          RX bytes:17122996 (16.3 MiB)  TX bytes:17122996 (16.3 MiB)"
        ],
        "networkconf": {
          "NETWORK": "192.168.72.0",
          "IP": "192.168.72.161",
          "HOSTNAME": "Athena",
          "# Configurazione DelphiTool ": " Tue Mar 15 13:59:41 2016",
          "BROADCAST": "192.168.72.255",
          "NETMASK": "255.255.255.0",
          "BOOTPROTO": "none",
          "NAMESERVER": "8.8.8.8",
          "GATEWAY": "192.168.72.1"
        }
      }
    }
  }
  ```
# saet_version
This command return a list of version isi and saet
- go to iottly, in the project where the board is connected
- navigate to the _Console_ tab and expand the panel (with the double arrow on the top right corner of the panel)
- choose your board (from the list on top of the panel)
- on _saet_version_ click _send_
- now click send again:
  ```
      {
    "timestamp": "2017-09-18T12:53:36",
    "devicetimestamp": "2017-09-18T12:53:36",
    "type": "userdefined",
    "payload": {
      "version": {
        "isi": [
          "Centrale ISI v.0603171740",
          "Plugin GSM SMS: Oct 22 2014 19:29:54",
          "Plugin Backup: Oct 22 2014 11:04:48",
          "Plugin BACnet: Mar 11 2016 10:53:22",
          "Plugin Hydra: Sep 15 2015 17:54:36",
          "Plugin MMASTER: Sep 14 2016 12:33:13",
          "Plugin MAYER: Apr 24 2015 17:47:32",
          "Plugin Modem (Gprs): Dec 10 2015 11:31:29",
          "Plugin IEC1107: Mar 11 2016 10:53:19",
          "Plugin TecnoAlarm: Dec 18 2015 11:50:53",
          "Plugin NOTIFIER: Mar  5 2015 14:35:57",
          "Plugin MODBUS: Feb 17 2017 18:55:27",
          "Plugin LARA: Oct 22 2014 11:04:49",
          "Plugin SYS: Nov 12 2015 09:54:51",
          "Plugin UDP: Mar 28 2017 15:21:59 (v2.1)",
          "Plugin CPU: Mar 28 2017 15:21:59",
          "Plugin KAITHRON: Oct 22 2014 11:04:48",
          "Plugin CEI(IMQ v1.3): Mar 11 2016 10:53:19",
          "Plugin SCAME: Oct 22 2014 11:04:51",
          "Plugin EiB: Oct 22 2014 11:04:49",
          "Plugin Debug: Oct 22 2014 11:04:48"
        ],
        "saet": [
          "Centrale SAET Delphi v.1102161130",
          "Printer plugin: Oct 27 2015 13:12:51",
          "ToolWeb plugin: Oct 26 2015 18:12:30",
          "UDP plugin: Oct 26 2015 18:01:33 (v2.0.5)",
          "DelphiTipo (plugin): Oct 27 2015 13:12:51",
          "ContactID (plugin): Oct 26 2015 18:01:34",
          "/saet/libuser.so: cannot open shared object file: No such file or directory"
        ]
      }
    }
  }
  ```
# GSM_signal_power 
This command return stauts of gsm signal
- go to iottly, in the project where the board is connected
- navigate to the _Console_ tab and expand the panel (with the double arrow on the top right corner of the panel)
- choose your board (from the list on top of the panel)
- on _GSM_signal_power_ click _send_
- now click send again:
  ```
    {
    "timestamp": "2017-09-18T13:01:08",
    "devicetimestamp": "2017-09-18T13:01:08",
    "type": "userdefined",
    "payload": {
      "CSQ": {
        "bit_error_rate": 0,
        "signal": 12
      },
      "last_reading": "Mon Sep 18 12:52:18 2017"
    }
  }
  ```
# start_tcpdump
This command allows to scan of the web interface, with determinate parameters
- go to iottly, in the project where the board is connected
- navigate to the _Console_ tab and expand the panel (with the double arrow on the top right corner of the panel)
- choose your board (from the list on top of the panel)
- on _start_tcpdump_ click _send_
- for "extra_options" you can choose the options (example "-v") to add to command (THIS COMMAND ISN'T OBBLIGATORY )
- for "interface" you can choose from "eth0" or "ppp0"
- for "hex" if you choose "yes" the command add to string "-x" if you choose "No" or don't choose anything, nothing happens
- for "Port" you need insert value of the port, the inserted port will be the one on which the scan will be made
- for "protocol" you can choose from "tcp" or "udp"
- the message returns the pid and the path when the file is saved 
  ```
    {
    "timestamp": "2017-09-18T15:50:18",
    "devicetimestamp": "2017-09-18T15:50:18",
    "type": "userdefined",
    "payload": {
      "PID": {
        "log_file": "/tmp/tcpdump_2017-09-18-15-50-18.log",
        "pid": 2357
      }
    }
  }
  ```

# stop_tcpdump
With this command you can kill the process started from start_tcpdump and if you want you can send to Amazon S3 the log_file with the result 
- go to iottly, in the project where the board is connected
- navigate to the _Console_ tab and expand the panel (with the double arrow on the top right corner of the panel)
- choose your board (from the list on top of the panel)
- on _stop_tcpdump_ click _send_
- if you would send the log_file to Amazon S3 click on the "dest_folder" and choose the destination folder
- when you click send the command kill the process spawned earlier and if you choose a destination the program sends the file to S3 and after deletes this file, otherwise if you don't choose the destination folder the program kills only the process but leaves the file in memory.



# Example Code Snippets

## ps to dict

```
py
from subprocess import check_output

ps_headers = {0: 'pid', 1: 'cmd', 2: 'cmdargs'}

def _ps_to_dict():

  def psraw_to_dict(psraw):
    items = list(map(lambda s: s.strip(), psraw.split('\|')))
    return {ps_headers[index]: item for index, item in enumerate(items) if index in ps_headers.keys()}

  return [psraw_to_dict(psraw) for psraw in check_output(["ps","-axo","%p\|%c\|%a"],shell=False).decode().split("\n")]
```

## reboot code

```py
from subprocess import check_output

def _reboot():
  return check_output(["reboot","-f"],shell=False)
```

## get saet version

```py
from subprocess import check_output

def _get_saet_version():
  return check_output(["/saet/saet","-v"],shell=False).decode().split("\n")
```

## ifconfig

```py
from subprocess import check_output

def _ifconfig():

  ifcfg = check_output(["ifconfig"],shell=False).decode().split("\n")

  netconf = []
  with open('/etc/network/network.conf', 'r') as f:
    netconf = list(map(lambda l: l.rstrip(), list(f)))

  return {'interfaces': ifcfg, 'networkconf': netconf}
```
# killall


```
def _killall(signal, processname):
  try:
    check_output(["killall", "-%s" % (signal), processname],shell=False)
    return "success"
  except Exception as e:
    raise e
```

# start tcpdump

```
def _start_dump(interface, protocol, port, hex_flag=None, extra_options=None):
  # formatting date, time according to ISO8601
  date_time = strftime("%Y-%m-%d-%H-%M-%S", localtime())

  file_name = "/tmp/tcpdump_{}.log".format(date_time)
  
  # generating options string
  pcap_expr =  "{} port {}".format(protocol, port)
  options =  "-i {}".format(interface) 
  if hex_flag is not None:
    options =  "{} {}".format(hex_flag, options)
  if extra_options is not None:
    options = "{} {}".format(options, extra_options)
     
  # check if iottly_tcpdump.pid exists or not
  if (os.path.exists('/var/run/iottly_tcpdump.pid')):
    return ({"FILE EXISTS": "before you can send a new command kill the old process"})
  
  # execute tcpdump and redirect stdout to file
  command = ["tcpdump", options, pcap_expr]
  with open(file_name, 'w') as log_file:
    p = Popen(command, shell=True, stdout=log_file)
  # save PID for killing the process later  
  with open( '/var/run/iottly_tcpdump.pid', 'w') as pid_file:      
    pid_file.write( "{}\n{}\n".format(p.pid, file_name))
    
  # return the output message  
  return {'pid' : p.pid , 'log_file' : file_name} 

```

# stop tcpdump

```
def stop_tcpdump(command):

  # generated on 2017-09-06 16:01:07.691024

  # function to handle the command stop_tcpdump
  # command description: kill process and send to desired folder on S3
  # format of command dict:
  # {"stop_tcpdump":{"dest_folder":"[<giancarlo|luigi|luca>]"}}

  # cmdpars stores the command parameters
  cmdpars = command["stop_tcpdump"]
  
  # open file and save the values on the variable
  with open( '/var/run/iottly_tcpdump.pid', 'r') as pid_file:    
    content = pid_file.read()
  pid, log_file_name = content.splitlines()
  
  #kill pid process
  
  kill(int(pid), children=True)
  send_msg({"kill": pid})
  
  # check if you would send the log_file_name on S3
  if "dest_folder" in cmdpars:
    upload_file({"upload_file":{"dest_folder": cmdpars["dest_folder"],
                              "source_path": log_file_name }})
    check_call(["rm", log_file_name])
    
  # remove the file, to permit a new process  
  check_call(["rm", '/var/run/iottly_tcpdump.pid'])
```

# gsm signal power


```
def find_last_CSQ_log():
    """
    find the last occurence of CSQ log
    :return the log line or None if no line is found
    """
    last_log = None

    # find the last line of CSQ in the log file
    with open('/tmp/isi.log.0', 'r') as f:
        for l in f.readlines():
          if "CSQ" in l:
            last_log = l
            
    if last_log == None:
      with open('/tmp/isi.log.1', 'r') as F:
        for L in F.readlines():
          if "CSQ" in L:
            last_log = L

    return last_log

def parse_gsm_connection_status():
    """
    extrat GSM connection status
    """
    if find_last_CSQ_log() == None:
      return "result not found"
    else:
      csq = ""
      log_s = find_last_CSQ_log()
      last_reading = log_s[0:24]
      s = find_last_CSQ_log()
      csq = s.split("+CSQ:")[1].strip().split(",")
      signal = int(csq[0])
      bit_error_rate = int(csq[1])
      
      result = {
        "last_reading": last_reading,
        "CSQ": {
          "signal": signal,
          "bit_error_rate": bit_error_rate
          }
        }
    return result
```
