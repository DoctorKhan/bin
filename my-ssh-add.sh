#!/bin/bash
#SSH_ASKPASS="/home/khan/bin/ssh-askpass-dsa.sh"      ssh-add /home/khan/.ssh/authorized_keys2 < /dev/null
SSH_ASKPASS="/home/khan/bin/ssh-askpass-dsa.sh"      ssh-add < /dev/null
ssh-askpass-dsa.sh
