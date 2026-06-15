#!/bin/bash
ssh pi@192.168.1.50 '
  # Kill anything already on port 5000
  fuser -k 5000/udp 5000/tcp 2>/dev/null
  sleep 1
  source ~/akida_env/bin/activate && python3 ~/brainchip/src/app.py
'