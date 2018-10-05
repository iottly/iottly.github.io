---
title: Iottly tutorials
---

# Pre-install the iottlyAgent on the devies

The iottlyAgent can be preinstalled on the image of the devices, to allow for preparing the devices in bulk in a production environment.
The procedure consists of two main steps:
1. add the iottly agent to the image of your device
2. register the device and connect it to iottlyCloud
  - this step is performed automatically via the __self register__ procedure

## Add the iottly agent to the image of your device

Follow these steps:
### 1. download the agent tarball

- from `https://cloud.iottly.com/getagent/iottlyagent_[version]_linux_[DEVICE TYPE].tar.gz`
- `version` is latest available version of the agent, for example 1.7.1
- `DEVICE TYPE` is the __DEVICE TYPE__ that you have choosen while [creating the project]({{'tutorials/create_project' | relative_url}})

### 2. extract the tarball

Extract the tarball in a suitable path within your image (let say in `/opt`)
- this will produce a dir tree in `/opt/iottly.com-agent`

### 3. Create the file `registersettings.json`

Create the file `/opt/iottly.com-agent/etc/iottly/registersettings.json` with the following content

```
{
    "REGISTRATION_HOST": "api.cloud.iottly.com",
    "PROJECT_ID": "<project id>",
    "API_KEY": "<api key>",
    "DEVICE_NAME_HOOK":"<dynamic device name hook>",
    "DEVICE_NAME": "<fixed device name>",
    "REGISTRATION_PROTOCOL": "https"
}
```

The meaning of the keys is the following:

- `PROJECT_ID`: the unique identifier of the project
  - you can find the project id as the long code at the end of the project url in the browser
- `API_KEY`: the API key to interact with iottlyCloud apis
  - how to obtain the API key from iottly cloud:
    - navigate to your project
    - click on 'open' on the top right corner
    - click twice on the right arrow to navigate to the API panel
    - create an API key with 'Create new API key'
- `DEVICE_NAME_HOOK`:
  - optional
  - this is useful when you want to customize the device name with local parameters like the CID of the SD card.
  - if present it must contain the path to a python script like the following:
```
def get_device_name():
    return "example device name"
```
  - when the self register procedure starts it will try to call the `get_device_name` function in the hook script to obtain the device name
    - the function must accept zero args and must return a string
  - if absent, the procedure tries to obtain the name from the following parameter
- `DEVICE_NAME`:
  - optional
  - if present this will be the (fixed) name of the device
  - if absent (and also the hook is absent) the procedure will fallback to "NEW DEVICE"

### 4. configure iottly to be started by the init system

Configure the init system of the image to run the following command:
`/opt/iottly.com-agent/sbin/iottly`

This script handles the respawn, so that you don't need to configure the init system to respawn the agent.

### 5. flash the image and turn on the device

The image built in this way has no dependencies on specific device attributes, so that you can use it as a master image to be flashed in bulk on new devices.

Once the device will be powered on the agent will start trying to register to iottlyCloud.
As soon as an internet connection will be available for the device, the registration will succeed, and you'll be able to see the device registered and connected in the __DEVICE CONFIGURATION__ panel.
