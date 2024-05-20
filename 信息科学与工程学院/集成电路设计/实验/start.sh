#!/bin/bash

qemu-system-x86_64 -hda SoCdesign.qcow2 -virtfs local,path=/tmp,mount_tag=host0,security_model=passthrough,id=host0
