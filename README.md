# chw25
Activate pipenv on controller:
```
pipenv shell --three
pipenv install
```

## Setup secrets
To create encrypted passwords for the playbook use ansible-vault.
First add ansible vault password to `vautl_password_file`
Then create encrypted user passwords:
```
ansible-vault encrypt_string 'ANSIBLE_PASSWD' -n ansible_user_pass >> roles/base/vars/user.yml
ansible-vault encrypt_string 'ROOT_PASSWD' -n root_user_pass >> roles/base/vars/user.yml

```
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
