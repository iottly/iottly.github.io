---
title: Iottly tutorials
---

# IoT Actuator Hello World 

#### What you will learn in this tutorial:
- [Hardware setup](#hardware-setup) to remotely control the LED
- [Message Setup](#message-setup)
- [Iottly Code](#iottly-code)

## Preconditions

After connecting your Raspberry Pi:
- [Connect Raspberry Pi to Iottly]({{'tutorials/connect_raspberrypi' | relative_url}}){:target="_blank"}

you can follow this tutorial.


## Hardware setup

In this exercise we are going to use pin *#7* as an **output** (actuator) to control the green LED
- Create a circuit like the one in the sketch
- This time the green wire connect the LED anode to RPi Pin *#7* (through a 220Ohm resistor)
![Alt text](/images/hardware_set_up1.png)



[Raspberry Pi 2/3 Pinout reference here](http://www.jameco.com/Jameco/workshop/circuitnotes/raspberry_pi_circuit_note_fig2a.jpg){:target="_blank"} 

[Raspberry Pi zero w Pinout reference here](http://othermod.com/wp-content/uploads/Raspberry-Pi-Model-Zero-Mini-PC.jpg){:target="_blank"}   

Let’s use Iottly to configure  a command to remotely control the LED


## Message Setup 

Create the following message:
- Name: 
  - LED_control
- Description: 
  - IoT Actuator Hello World
- Keywords:
  - kay: “state”
    - Type: Multiple Value
  - Values:
    - on
    - off
    
![Alt text](/images/iottly_message_setup.png)


## Iottly Code
Edit the following snippets in CODING-FIRMWARE panel:
- ```init```:
  - Initialize Pin *#7* to be managed as **output**
  

```python
def init():
  #...

  #-----------------------------------------------------------------------------#

  # here your code!!
  
  pin = "7"
  GPIO.setup(int(pin), GPIO.OUT)
  
  #-----------------------------------------------------------------------------#

  ```
  
  
- ```LED_control``` :
  - Keep in mind the format of the incoming message:
      ```{"LED_control":{"state":"<on|off>"}}```
  - Set the state of Pin *#7* to ```True``` or ```False```, based on the value of the ```'state'``` keyword in the message

```python
def LED_control(command):
  #...
  cmdpars = command["LED_control"]
  #...
  #-----------------------------------------------------------------------------#

  # here your code!!
  state = {
    'on': True,
    'off': False
  }.get(cmdpars['state'], False)  
  GPIO.output(7,state)
  #-----------------------------------------------------------------------------#
  ```
  
  
- ![Alt text](/images/flash_botton.png)


- Test the “IoT Actuator Hello World” from the Console panel



