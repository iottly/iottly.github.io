---
title: Iottly tutorials
published: false
---

# IoT Sensor Hello World


#### What you will learn in this tutorial:


- [Hardware setup](#hardware-setup) to capture the state of the push button
- [Setup button callback in Iottly](#setup-button-callback-in-iottly)
- [Edge computing in Iottly](#edge-computing-in-iottly)


## Preconditions

After connecting your Raspberry Pi:
- [Connect Raspberry Pi to Iottly]({{'tutorials/connect_raspberrypi' | relative_url}}){:target="_blank"}  

you can follow this tutorial.



## Hardware setup 


In this exercise we are going to use pin *#12* as an **input** (sensor) to capture the state of the push button
- Create a circuit like the one in the sketch
- This time the yellow wire connect Pin *#12* to 3.3V (through the push button)
![Alt text](/images/hardware_set_up2.png)


[Raspberry Pi 1 Rev 1 Pinout reference here](http://www.hobbytronics.co.uk/image/data/tutorial/raspberry-pi/gpio-pinout.jpg){:target="_blank"} 

[Raspberry Pi 1 Rev 2 Pinout reference here](http://www.hobbytronics.co.uk/image/data/tutorial/raspberry-pi/gpio-pinout-rev2.jpg){:target="_blank"} 

[Raspberry Pi 2/3 Pinout reference here](http://www.jameco.com/Jameco/workshop/circuitnotes/raspberry_pi_circuit_note_fig2a.jpg){:target="_blank"} 

[Raspberry Pi zero w Pinout reference here](http://othermod.com/wp-content/uploads/Raspberry-Pi-Model-Zero-Mini-PC.jpg){:target="_blank"}   



Let’s use Iottly to configure an event to be triggered when the button is pressed


## Setup button callback in Iottly


In CODING-FIRMWARE panel edit the following snippets:
- ```init``` :
  - Initialize Pin *#12* to be managed as **input**
    - The ```GPIO.PUD_DOWN``` flag allows to set a software version of a pull down resistor
  - ```add_event_detect``` allows to register a callback to be executed whenever the input changes its status
    - The ```GPIO.BOTH``` means the event must be triggered both on rising or on falling signal
    - The ```bouncetime``` avoids multiple events to be triggered due to physical bouncing of the switch
    
```python
def init():
  #...

  #-------------------------------
  # here your code!!
  pin = "7"
  GPIO.setup(int(pin), GPIO.OUT)
  pin = "12"
  GPIO.setup(int(pin), GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
  GPIO.add_event_detect(int(pin), GPIO.BOTH, callback=button_pressed, bouncetime=200)
  #---------------------------------
``` 
   
- ```global```:
  - Add the callback function ```button_pressed```
  
```python
# ...
def button_pressed(channel):
  status = GPIO.input(channel)
  send_msg({"button_pressed": {"GPIO": channel, "state": status}})
```

- It will send a message to Iottly evry time the button is pressed
-  ![Alt text](/images/flash_botton.png) 
- Test the “IoT Sensor Hello World” from the Console


## Edge computing in Iottly

 
Let's add an edge feedback so that when the button is pressed, the green LED is switched on.

> Once flashed over-the-air this feedback will be triggered by the Raspberry PI, even if it is **disconnected** from the Internet.

- ```global```:
  - modify the callback function ```button_pressed```
  - The green LED is controlled by pin *#7*
  
```python
# ...
def button_pressed(channel):
  status = GPIO.input(channel)
  
  # -------- edge feedback -------------
  GPIO.output(7,status)
  # -------- edge feedback -------------
  
  send_msg({"button_pressed": {"GPIO": channel, "state": status}})
```
- Notice that the feedback message is sent **after** the physical actuation has been executed: if the actuation raises an exception the  feedback message is not sent
-  ![Alt text](/images/flash_botton.png)
- Test the “IoT Sensor Hello World” from the Console




