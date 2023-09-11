# ServerInColour (SIC) - minimizing excess in your work environment

![ServerInColour Demonstration Screenshot](/screenshots/demo-banner.jpg)

*We offer **ServerInColour** as a more readable and informative server login homepage. **Compare ServerInColour and the standard Ubuntu Server login page.***

# What is it?

### ServerInColour is a convenient and more informative login page to the server
**There is nothing superfluous here, just the information you need about the system. It is painted in different colors depending on the load (>50% of the load is orange, >75% is red).**

# Getting started!

We want to present **SIC** as a cross-platform script that will work on all Linux systems.
However, we cannot guarantee performance on all Linux systems.
Therefore, we offer a list of tested systems where **SIC** will be guaranteed to work:

- Debian 12 (Tested ✅)
- Ubuntu 22.04 LTS (Tested ✅)

## Install
1. Log in as root:
```
su -
```
2. Download git:
```
git clone https://github.com/medowic/serverincolour.git
```
3. Start `install.sh` script
```
bash serverincolour/install.sh
```
or
```
chmod u+x ./serverincolour/install.sh
./serverincolour/install.sh
```
4. **Done!** Now ServerInColour will be launched every time the user logs in.

## Uninstall
1. Log in as root:
```
su -
```
2. Start `uninstall.sh` script
```
bash serverincolour/uninstall.sh
```
or
```
chmod u+x ./serverincolour/uninstall.sh
./serverincolour/uninstall.sh
```
3. **Done.** Now you will see the standard login page of the system.

# License
This is project is under the [MIT License](https://raw.githubusercontent.com/medowic/serverincolour/master/LICENSE).
