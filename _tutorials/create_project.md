---
title: Iottly tutorials
---

# Create a new Iottly Project

A project in __Iottly__ is a set of devices with the same hardware architecture and the same python scripts running on them.

![Alt text](/images/create_project.png)

## Choose the DEVICE TYPE

Choose a suitable **DEVICE TYPE** for your board:
- by choosing **Raspberry Pi** you will be able to install on your RPi a specialized agent which can interact with the GPIOs and I2C
- for any other kind of board you should choose the DEVICE TYPE based on the hardware architecture of your board:
  - choose _ARMv5_ for ARM7EJ, ARM9E, ARM10E processors (this is also known as _armel_ without hardware floating point)
  - choose _ARMv6_ for any ARMv6+ processor, e.g. the ARM11 (this is also known as _armhf_ with support for hardware floating point)
  - choose _AMD64_ for intel/AMD based 64 bit processors
  - choose _i386_ for intel/AMD based 32 bit processors

Unclear what DEVICE TYPE you should choose?
  - [contact support](mailto:iottly-support@tomorrowdata.io) and we’ll help you sort it out!

## Add tags  

You can add one or more **Project tags**, for example to classify the project in a category

## That's it!

You can now proceed by [connecting boards to your new project]({{'tutorials/connect_board' | relative_url}}).
