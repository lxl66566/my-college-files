#!/usr/bin/env bash

objcopy -I ihex -O binary Objects/main.hex Objects/main.bin
sudo poetry run stcgal -P stc89 -b 9600 Objects/main.bin
