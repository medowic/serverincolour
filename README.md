# ServerInColour - minimizing excess in your work environment

![ServerInColour Demonstration Screenshot](/img/first-banner.jpg)

# What is it?

### ServerInColour is a minimalistic and colorful homepage that see every time when user log on
**There is nothing superfluous here, just the information you need about the system. It is painted in different colors depending on the load (>50% of the load is orange, >75% is red).**

# Getting started!

We want to present **SIC** as a cross-platform script that will work on all Linux systems.
However, we cannot guarantee support on all Linux systems.
There a list of tested systems where **SIC** will be guaranteed to work:

- Debian >= 11 (Tested ✅)
- Ubuntu >= 22.04 (Tested ✅)

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
