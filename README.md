# PDJACKMAX

Welcome to the PD-JACK-MAX routing setup wizard.

This directory contains several helper scripts that can be run by double-clicking on the following programs:
- start.command : to begin the setup wizard
- stop.command : to terminate all audio programs the wizard opens (pd, max, and jack)
- reset.command : to reset the temporary values used for faster load (in .tmp/)

Please follow these instructions. See below for further settings.

# INSTRUCTIONS

## 0. INSTALL JACK
Before you start, please install Jack2 on OSX. Restart your computer after installation. Run this script again once you have jack installed.
Get jack at www.jackaudio.org (Required version: 1.9.11)

## 1. CONNECT AUDIO INTERFACE USB CABLE
## 2. CONNECT YOUR SYSTEM AUDIO TO THE INTERFACE
Set both INPUT and OUTPUT to your audio interface
Open up your Sound Preferences Panel or alt+click the sound icon and select your interface.
## 3. STARTING JACK SERVER
Ignore this step if Jack is already running.
## 4. OPEN MAX/MSP
Install Max if you dont have Max installed.
Install it and come back.
## 5. Wait 25 seconds for Max to load...
Make sure Max is connected to Jack: Open Max's Audio Status and select JackRouter
## 6. OPENING PURE DATA
Download AccadAoo.app and place it in your /Applications folder
From github.com/fdch/AccadAoo ...
## 7. ROUTING MAX AND PD
See bin/jack_route.sh for details
## 8. SETUP FINISHED
You can exit this terminal window now.
Remember to double-click on the 'stop.command' to stop all.


# SETTINGS

Edit the `settings` file located in this directory with a simple text editor (TextEdit). These settings are used by the wizard.
