# chw25
Activate pipenv on controller:
```
pipenv shell --three
pipenv install
```

## files
This is the Nextcloud Server.

## Node Setup:
#### Raspberry Pi OS
1. Flash Raspberry Pi OS to SD Card
2. touch a File SSH to `/boot/`
3. set static IP by configuring `/rootfs/etc/dhcpcd.conf`
4. boot the rpi
5. `scp scripts/rpi-init.sh pi@PI_IP_ADDRESS:/home/pi/`
6. `ssh pi@PI_IP_ADDRESS`
7. `sudo ./rpi-init.sh`
8. Go for a run
9. `sudo reboot`
10. Check ansible inventory
11. Check with `ansible node -m ping`
